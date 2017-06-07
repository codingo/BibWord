using System;
using System.IO;
using System.Xml;
using System.Text;
using System.Xml.Xsl;
using System.IO.Packaging;
using System.Globalization;
using System.ComponentModel;
using System.Collections.Generic;

namespace BibWord.Extender
{
  /// <summary>
  /// A set of tools facilitating the extension possibilities of BibWord.
  /// </summary>
  public static class ExtensionTools
  {
    #region Constants

    /// <summary>
    /// Document relationship type.
    /// </summary> 
    private const string DocumentRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";

    /// <summary>
    /// Custom XML relationship type.
    /// </summary>
    private const string CustomXmlRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/customXml";

    /// <summary>
    /// Bibliography namespace.
    /// </summary>
    private const string BibliographyNS = @"http://schemas.openxmlformats.org/officeDocument/2006/bibliography";

    #endregion Constants

    #region Methods

    /// <summary>
    /// Attempts to retrieve the path to the directory where Word stores 
    /// the bibliography styles.
    /// </summary>
    /// <returns>A string containing a path.</returns>
    /// <remarks>
    /// This function is platform dependent. Currently, Windows and MacOS,
    /// the only platforms on which Word is released, are supported.
    /// </remarks>
    public static string GetBibliographyStylesPath()
    {
      if (Environment.OSVersion.Platform == PlatformID.Win32NT)
      {
        // Handle Word on Windows systems.
        return GetWindowsBibliographyStylePath();
      }
      else // PlatformID.MacOSX is not correctly defined by Mono on MacOSX.
      {
        // Handle Word on Mac OS systems (it is the only alternative system to Windows).
        return GetMacOSBibliographyStylePath();
      }
    }

    /// <summary>
    /// Retrieves the Word bibliography style directory on a Windows system.
    /// </summary>
    /// <returns>The location of the bibliography style path.</returns>
    public static string GetWindowsBibliographyStylePath()
    {
      string path = "";

      try
      {
        Microsoft.Win32.RegistryKey hklm = Microsoft.Win32.Registry.LocalMachine;
        hklm = hklm.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\Winword.exe");
        path = (string)hklm.GetValue("Path") + "Bibliography\\Style";
      }
      catch
      {
        // Something went wrong, as an alternative, retrieve the root
        // directory of the first fixed drive on the machine.
        foreach (DriveInfo di in DriveInfo.GetDrives())
        {
          if (di.DriveType == DriveType.Fixed)
          {
            path = di.RootDirectory.FullName;
            break;
          }
        }
      }

      return path;
    }

    /// <summary>
    /// Retrieves the Word bibliography style directory on a MacOS system.
    /// </summary>
    /// <returns>The location of the bibliography style path.</returns>
    public static string GetMacOSBibliographyStylePath()
    {
      // Use a hard coded path.
      string path = "/Applications/Microsoft Office 2008/Microsoft Word.app/Contents/Resources/Style";

      // If the path does not exist, try an alternative.
      if (Directory.Exists(path) == false)
      {
        // Alternative hard coded path.
        path = "/Applications";

        // If the path does not exist, try retrieve the root directory
        // of the first fixed drive.
        if (Directory.Exists(path) == false)
        {
          foreach (DriveInfo di in DriveInfo.GetDrives())
          {
            if (di.DriveType == DriveType.Fixed)
            {
              path = di.RootDirectory.FullName;
              break;
            }
          }
        }
      }

      return path;
    }


    /// <summary>
    /// Loads information about all the bibliography styles.
    /// </summary>
    /// <param name="styleDir">
    /// Directory containing the Word bibliography styles.
    /// </param>
    /// <param name="worker">
    /// Background worker thread on which this function is run. This parameter
    /// is required if progress should be reported.
    /// </param>
    public static Dictionary<string, string> LoadBibliographyStylesInformation(string styleDir, BackgroundWorker worker)
    {
      // Place to store the mapping between retrieved style names and style paths.
      Dictionary<string, string> result = new Dictionary<string, string>();

      // Collection of OfficeStyleKeys. Those are predefined styles of which the
      // name can be localized by Microsoft.
      Dictionary<string, string> OfficeStyleKeys = new Dictionary<string, string>(10);
      OfficeStyleKeys.Add("APA", "APA");
      OfficeStyleKeys.Add("CHICAGO", "Chicago");
      OfficeStyleKeys.Add("GB7714", "GB7714");
      OfficeStyleKeys.Add("GOSTNS", "Gost - Name Sort");
      OfficeStyleKeys.Add("GOSTTS", "Gost - Title Sort");
      OfficeStyleKeys.Add("ISO690", "ISO 690 - First Element and Date");
      OfficeStyleKeys.Add("ISO690NR", "ISO 690 - Numerical Reference");
      OfficeStyleKeys.Add("MLA", "MLA");
      OfficeStyleKeys.Add("SIST02", "SIST02");
      OfficeStyleKeys.Add("TURABIAN", "Turabian");

      // Variable for XSL transformations. Although deprecated, this is a lot 
      // faster than XslCompiledTransform.
      XslTransform xslt = new XslTransform();

      // Variable for storing the xml fragment that needs transformation.
      XmlDocument doc = new XmlDocument();

      // Report progress.
      if (worker != null)
      {
        worker.ReportProgress(0, "Building list of *.xsl files...");
      }

      // Retrieve a list of all possible styles in the directory.
      //   Note: Directory.GetFiles(styleDir, "*.xsl") might give
      //         unwanted results on a case sensitive OS!
      List<string> styles = new List<string>();

      // Get all the files in the directory.
      string[] files = Directory.GetFiles(styleDir, "*");

      for (int i = 0; i < files.Length; i++)
      {
        FileInfo fi = new FileInfo(files[i]);

        // Add the file to the list if the lower case variant
        // of its extension is '.xsl'.
        if (fi.Extension.ToLowerInvariant() == ".xsl")
        {
          styles.Add(files[i]);
        }
      }

      // Variable containing the maximum number of styles.
      int styleMax = styles.Count;

      // Variable containing the number of styles processed so far.
      int styleCnt = 0;

      // Handle all styles in the directory.
      foreach (string stylePath in styles)
      {
        // Used for storing the result of a transformation.
        StringBuilder sb = new StringBuilder();
        TextWriter tw = new StringWriter(sb, CultureInfo.InvariantCulture);

        try
        {
          // Load the style.
          xslt.Load(stylePath);

          // Load document for the transformation.
          doc.LoadXml("<b:StyleName xmlns:b=\"" + BibliographyNS + "\"/>");

          // Transform the document.
          xslt.Transform(doc, null, tw);

          // Get the result of the transformation.
          string styleName = sb.ToString();

          // If the result is empty, try going for the OfficeStyleKey instead of the StyleName.
          if (String.IsNullOrEmpty(styleName) == true)
          {
            // Load document for the transformation.
            doc.LoadXml("<b:OfficeStyleKey xmlns:b=\"" + BibliographyNS + "\"/>");

            // Transform the document.
            xslt.Transform(doc, null, tw);

            // Get the actual name based on the transformation result.
            if (OfficeStyleKeys.ContainsKey(sb.ToString().ToUpperInvariant()) == true)
            {
              styleName = OfficeStyleKeys[sb.ToString().ToUpperInvariant()];
            }
          }

          // If the result is not empty, add to the map.
          if (String.IsNullOrEmpty(styleName) == false)
          {
            // Check if the name is not yet in the result map.
            if (result.ContainsKey(styleName) == false)
            {
              result.Add(styleName, stylePath);
            }
            else
            {
              // If the style name is already in the map, add the first possible
              // indexer after it between brackets.
              int cnt = 2;

              while (result.ContainsKey(styleName + " (" + cnt + ")") == true)
              {
                cnt++;
              }

              styleName += " (" + cnt + ")";
              result.Add(styleName, stylePath);
            }
          }
        }
        catch 
        {
          // Ignore all exceptions, move to the next one.
        }
        finally
        {
          // One more style was processed (not necessarily correct).
          styleCnt += 1;

          // Report progress if required.
          if (worker != null)
          {
            FileInfo fi = new FileInfo(stylePath);
            worker.ReportProgress((100 * styleCnt / styleMax), "Processed " + fi.Name + "...");
          }
        }
      }

      return result;
    }

    /// <summary>
    /// Retrieves the bibliography style used by a given Word document. 
    /// </summary>
    /// <param name="docx">
    /// Path to a Word document containing the bibliography.
    /// </param>
    /// <param name="selectedStyle">
    /// Contains the filename of the style used by the bibliography on return.
    /// (e.g. \APA.xsl or \Chicago.XSL)
    /// </param>
    /// <param name="styleName">
    /// Contains the name of the style used by the bibliography on return.
    /// (e.g. APA or Chicago)
    /// </param>
    /// <remarks>
    /// <paramref name="selectedStyle"/> is the SelectedStyle</b> attribute 
    /// of the bibliography and <paramref name="styleName"/> is the 
    /// <b>StyleName</b> attribute of the bibliography.
    /// </remarks>
    public static void GetBibliographyStyle(string docx, ref string selectedStyle, ref string styleName)
    {
      // Open the docx package.
      //   Note: FileAccess.Read would be better here, but Mono does not
      //         accept that yet. It throws a read-only exception.
      Package package = Package.Open(docx, FileMode.Open, FileAccess.ReadWrite);

      try
      {
        // Go over every document in the package.
        foreach (PackageRelationship rel in package.GetRelationshipsByType(DocumentRelationshipType))
        {
          // Get the uri indicating the document's location.
          Uri documentUri = PackUriHelper.ResolvePartUri(new Uri("/", UriKind.Relative), rel.TargetUri);

          // Get the document.
          PackagePart document = package.GetPart(documentUri);

          // Go over every customXml file related to the document.
          foreach (PackageRelationship docRel in document.GetRelationshipsByType(CustomXmlRelationshipType))
          {
            // Create the uri for a custom xml part of the document.
            Uri customXmlUri = PackUriHelper.ResolvePartUri(document.Uri, docRel.TargetUri);

            // Get the custom xml.
            PackagePart customXml = package.GetPart(customXmlUri);

            // Load the custom xml into an xml document.
            XmlDocument sources = new XmlDocument();
            sources.Load(customXml.GetStream());

            // Check if this is a custom xml describing a bibliography, i.e., check if it is a sources document.
            if (sources.DocumentElement.LocalName.ToLowerInvariant() == "sources" &&
              sources.DocumentElement.NamespaceURI.ToLowerInvariant() == BibliographyNS.ToLowerInvariant())
            {
              XmlNamespaceManager nsm = new XmlNamespaceManager(sources.NameTable);
              nsm.AddNamespace("b", BibliographyNS);

              // Retrieve the currently selected style and style name.
              XmlNode node = sources.SelectSingleNode("//b:Sources", nsm);
              selectedStyle = node.Attributes["SelectedStyle"].Value;
              styleName = node.Attributes["StyleName"].Value;
            }
          }
        }
      }
      finally
      {
        // Close the docx package whatever happened.
        package.Close();
      }
    }
    
    /// <summary>
    /// Extends source elements in an open xml bibliography inside a Word document.
    /// </summary>
    /// <param name="docx">
    /// Path to a Word document containing the bibliography.
    /// </param>
    /// <param name="stylesheet">
    /// Path to the style used to generate the bibliography.
    /// </param>
    /// <returns>
    /// True if an extension took place, false otherwise.
    /// </returns>
    public static bool ExtendBibliography(string docx, string stylesheet)
    {
      // Counts the number of bibliographies in the current document which were transformed.
      int bibCnt = 0;

      // Open the docx package.
      Package package = Package.Open(docx, FileMode.Open, FileAccess.ReadWrite);

      try
      {
        // Go over every document in the package.
        foreach (PackageRelationship rel in package.GetRelationshipsByType(DocumentRelationshipType))
        {
          // Get the uri indicating the document's location.
          Uri documentUri = PackUriHelper.ResolvePartUri(new Uri("/", UriKind.Relative), rel.TargetUri);

          // Get the document.
          PackagePart document = package.GetPart(documentUri);

          // Go over every customXml file related to the document.
          foreach (PackageRelationship docRel in document.GetRelationshipsByType(CustomXmlRelationshipType))
          {
            // Create the uri for a custom xml part of the document.
            Uri customXmlUri = PackUriHelper.ResolvePartUri(document.Uri, docRel.TargetUri);

            // Get the custom xml.
            PackagePart customXml = package.GetPart(customXmlUri);

            // Load the custom xml into an xml document.
            XmlDocument sources = new XmlDocument();
            sources.Load(customXml.GetStream());

            // Check if this is a custom xml describing a bibliography, i.e., check if it is a sources document.
            if (sources.DocumentElement.LocalName.ToLowerInvariant() == "sources" &&
              sources.DocumentElement.NamespaceURI.ToLowerInvariant() == BibliographyNS.ToLowerInvariant())
            {
              // Create an XML document to give to the XSL transformation.
              XmlDocument BibWordInput = new XmlDocument();
              BibWordInput.AppendChild(BibWordInput.CreateXmlDeclaration("1.0", null, null));

              // Give the XML document a b:BibOrder element as root.
              XmlElement rootElement = BibWordInput.CreateElement("b", "BibWord", BibliographyNS);
              BibWordInput.AppendChild(rootElement);

              // Attach all the b:Source elements from the sources document to the BibOrderInput document.
              XmlNamespaceManager nsm = new XmlNamespaceManager(sources.NameTable);
              nsm.AddNamespace("b", BibliographyNS);

              // A collection of source nodes before the transformation.
              XmlNodeList beforeTransform = sources.SelectNodes("//b:Sources/b:Source", nsm);

              foreach (XmlNode node in beforeTransform)
              {
                // Add the b:Source element to the XML document to transform.
                rootElement.AppendChild(BibWordInput.ImportNode(node, true));
              }

              try
              {
                // Do the transformation.            
                XmlDocument BibWordOutput = new XmlDocument();
                XslCompiledTransform xslt = new XslCompiledTransform();
                xslt.Load(stylesheet);

                using (XmlWriter writer = BibWordOutput.CreateNavigator().AppendChild())
                {
                  xslt.Transform(BibWordInput, (XsltArgumentList)null, writer);
                }

                // A collection of source nodes after the transformation.
                XmlNodeList afterTransform = BibWordOutput.SelectNodes("//b:BibWord/b:Source", nsm);

                // Only continu if no sources were lost.
                if (beforeTransform.Count == afterTransform.Count)
                {
                  // Remove all nodes from the original document.
                  foreach (XmlNode node in beforeTransform)
                  {
                    sources.DocumentElement.RemoveChild(node);
                  }

                  // Add the newly obtained b:Source elements back to the orignal document.
                  foreach (XmlNode node in afterTransform)
                  {
                    sources.DocumentElement.AppendChild(sources.ImportNode(node, true));
                  }

                  // Write the XML document back to the docx.
                  StreamWriter sw = new StreamWriter(customXml.GetStream(FileMode.Create, FileAccess.ReadWrite));
                  sw.BaseStream.SetLength(0); // Fix for Mono.
                  sw.Write(sources.OuterXml);
                  sw.Flush();
                  sw.Close();

                  // Indicate that one more bibliography was transformed.
                  bibCnt++;
                }
                else
                {
                  throw new ArgumentException("Not a BibWord style.", stylesheet);
                }
              }
              catch (Exception)
              {
                // Close the docx package.
                package.Close();
                // Rethrow the exception rather than returning failure.
                throw;
              }
            }
          }
        }
      }
      finally
      {
        // Close the docx package whatever happened.
        package.Close();
      }

      // Give the user a hint that the extension was successful.
      return (bibCnt > 0);
    }

    /// <summary>
    /// Cleans all source elements in an open xml bibliography.
    /// </summary>
    /// <param name="docx">
    /// Path to a Word document containing one or more bibliography elements.
    /// </param>
    public static void CleanBibliography(string docx)
    {
      // Open the docx package.
      Package package = Package.Open(docx, FileMode.Open, FileAccess.ReadWrite);

      // Go over every document.
      foreach (PackageRelationship rel in package.GetRelationshipsByType(DocumentRelationshipType))
      {
        // Create the uri for a document.
        Uri documentUri = PackUriHelper.ResolvePartUri(new Uri("/", UriKind.Relative), rel.TargetUri);

        // Get the document.
        PackagePart document = package.GetPart(documentUri);

        // Go over every customXml file related to the document.
        foreach (PackageRelationship docRel in document.GetRelationshipsByType(CustomXmlRelationshipType))
        {
          // Create the uri for a custom xml part of the document.
          Uri customXmlUri = PackUriHelper.ResolvePartUri(documentUri, docRel.TargetUri);

          // Get the custom xml.
          PackagePart customXml = package.GetPart(customXmlUri);

          // Load the custom xml into an xml document.
          XmlDocument sources = new XmlDocument();
          sources.Load(customXml.GetStream());

          // Check if this is a custom xml describing a bibliography, i.e., check if it is a sources document.
          if (sources.DocumentElement.LocalName.ToLowerInvariant() == "sources" &&
              sources.DocumentElement.NamespaceURI.ToLowerInvariant() == BibliographyNS.ToLowerInvariant())
          {
            // Attach all the b:Source elements from the sources document to the BibOrderInput document.
            XmlNamespaceManager nsm = new XmlNamespaceManager(sources.NameTable);
            nsm.AddNamespace("b", BibliographyNS);

            // Get all the BibOrder elements.
            XmlNodeList biborder = sources.SelectNodes("//b:Sources/b:Source/b:BibOrder", nsm);

            // Remove the BibOrder elements.
            foreach (XmlNode node in biborder)
            {
              node.ParentNode.RemoveChild(node);
            }

            // Get all the YearSuffix elements.
            XmlNodeList yearsuffix = sources.SelectNodes("//b:Sources/b:Source/b:YearSuffix", nsm);

            // Remove the YearSuffix elements.
            foreach (XmlNode node in yearsuffix)
            {
              node.ParentNode.RemoveChild(node);
            }

            // Write the XML document back to the docx.
            StreamWriter sw = new StreamWriter(customXml.GetStream(FileMode.Create, FileAccess.ReadWrite));
            sw.BaseStream.SetLength(0); // Fix for Mono.
            sw.Write(sources.OuterXml);
            sw.Flush();
            sw.Close();
          }
        }
      }

      // Close the docx package.
      package.Close();
    }

    #endregion Methods
  }
}
