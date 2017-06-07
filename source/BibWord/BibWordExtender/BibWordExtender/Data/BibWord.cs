using System;
using System.IO;
using System.Xml;
using System.Text;
using System.Xml.Xsl;
using System.IO.Packaging;
using System.ComponentModel;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace BibWordExtender.Data
{
  /// <summary>
  /// BibWord data control and manipulation class.
  /// </summary>
  public class BibWord
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

    #region Constructors

    /// <summary>
    /// Initializes a new instance of a BibWord class.
    /// </summary>
    /// <remarks>
    /// Not used as the class consists of static methods only.
    /// </remarks>
    private BibWord()
    {
    }

    #endregion Constructors

    #region Methods

    /// <summary>
    /// Gets the path to the directory where Word stores its bibliography styles.
    /// </summary>
    /// <returns>A string containing a path.</returns>
    /// <remarks>
    /// This function is platform dependent. Currently, only Windows is supported.
    /// </remarks>
    public static string GetBibliographyStylesPath()
    {
      if (Environment.OSVersion.Platform == PlatformID.Unix)
      {
        throw new NotSupportedException("Currently this application only runs " +
          "on a Windows OS. If you have information on retrieving the directory" +
          " containing the bibliography styles on a different OS, feel free to " + 
          "contact me.");
      }
      else
      {
        Microsoft.Win32.RegistryKey hklm = Microsoft.Win32.Registry.LocalMachine;
        hklm = hklm.OpenSubKey("SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\Winword.exe");
        return ((string)hklm.GetValue("Path") + "Bibliography\\Style");
      }
    }

    /// <summary>
    /// Loads information about all the bibliography styles.
    /// </summary>
    /// <param name="worker">
    /// Background worker thread on which this function is run. This parameter
    /// is required if progress should be reported.
    /// </param>
    public static Dictionary<string,string> LoadBibliographyStylesInformation(BackgroundWorker worker)
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

      // Get the path to the directory containing the bibliography styles.
      string styleDir = GetBibliographyStylesPath();

      // Report progress if required.
      if (worker != null)
      {
        // Report that the style directory was found (0% completed).
        worker.ReportProgress(0, "Found style directory at " + styleDir);
      }

      // Variable containing the number of styles.
      int styleMax = Directory.GetFiles(styleDir, "*.xsl").Length;

      // Variable containing the number of styles processed so far.
      int styleCnt = 0;

      // Handle all styles in the directory.
      foreach (string stylePath in Directory.GetFiles(styleDir, "*.xsl"))
      {
        // Used for storing the result of a transformation.
        StringBuilder sb = new StringBuilder();
        TextWriter tw = new StringWriter(sb);

        try
        {
          // Load the style.
          xslt.Load(stylePath);

          // Load document for the transformation.
          doc.LoadXml("<b:StyleName xmlns:b=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"/>");

          // Transform the document.
          xslt.Transform(doc, null, tw);

          // Get the result of the transformation.
          string styleName = sb.ToString();

          // If the result is empty, try going for the OfficeStyleKey instead of the StyleName.
          if (styleName == "")
          {
            // Load document for the transformation.
            doc.LoadXml("<b:OfficeStyleKey xmlns:b=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"/>");

            // Transform the document.
            xslt.Transform(doc, null, tw);

            // Get the actual name based on the transformation result.
            styleName = OfficeStyleKeys[sb.ToString()];
          }

          // If the result is not empty, add to the map.
          if (styleName != "")
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
        catch (Exception)
        {

        }
        finally
        {
          // One more style was processed (not necessarily correct).
          styleCnt += 1;

          // Report progress if required.
          if (worker != null)
          {
            FileInfo fi = new FileInfo(stylePath);
            worker.ReportProgress((100 * styleCnt / styleMax), fi.Name);
          }
        }
      }

      return result;
    }

    /// <summary>
    /// Gets the name of the bibliography style used in a given Word document.
    /// </summary>
    /// <param name="docx">Path to the Word document.</param>
    /// <param name="styleMap">
    /// A mapping between style names (keys) and style paths (values).
    /// </param>
    /// <returns>A string containing the name of a style.</returns>
    public static string GetBibliographyStyle(string docx, Dictionary<string,string> styleMap)
    {
      // Variable containing the result.
      string result = "";

      try
      {
        // Open the docx package.
        Package package = Package.Open(docx, FileMode.Open, FileAccess.Read);

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
            if (sources.DocumentElement.LocalName.ToLower() == "sources" &&
              sources.DocumentElement.NamespaceURI.ToLower() == BibliographyNS.ToLower())
            {
              XmlNamespaceManager nsm = new XmlNamespaceManager(sources.NameTable);
              nsm.AddNamespace("b", BibliographyNS);

              // Retrieve the currently selected style.
              string selectedStyle = sources.SelectSingleNode("//b:Sources", nsm).Attributes["SelectedStyle"].Value;

              // If the selected style is not empty, use it to retrieve the style name.
              if (selectedStyle != "")
              {
                string stylePath = Path.Combine(GetBibliographyStylesPath(), Path.GetFileName(selectedStyle));
                // Find the style name through the style path.
                foreach (KeyValuePair<string, string> element in styleMap)
                {
                  if (element.Value == stylePath)
                  {
                    result = element.Key;
                    break;
                  }
                }
              }
              else
              {
                // If the selected style is empty, try using the StyleName attribute instead.
                result = sources.SelectSingleNode("//b:Sources", nsm).Attributes["StyleName"].Value;
              }
            }
          }
        }

        // Close the docx package.
        package.Close();
      }
      catch (FileFormatException)
      {
        throw new Exception("Not a valid Word 2007 file.");
      }

      return result;
    }

    /// <summary>
    /// Extends source elements in an open xml bibliography.
    /// </summary>
    /// <param name="docx">
    /// Path to a Word document containing a bibliography.
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
          if (sources.DocumentElement.LocalName.ToLower() == "sources" &&
            sources.DocumentElement.NamespaceURI.ToLower() == BibliographyNS.ToLower())
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

            foreach (XmlNode node in sources.SelectNodes("//b:Sources/b:Source", nsm))
            {
              // Add the b:Source element to the XML document to transform.
              rootElement.AppendChild(BibWordInput.ImportNode(node, true));
              // Remove the b:Source element from the original input.
              sources.DocumentElement.RemoveChild(node);
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
              
              // Add the newly obtained b:Source elements back to the orignal document.
              foreach (XmlNode node in BibWordOutput.SelectNodes("//b:BibWord/b:Source", nsm))
              {
                sources.DocumentElement.AppendChild(sources.ImportNode(node, true));
              }

              // Write the XML document back to the docx.
              StreamWriter sw = new StreamWriter(customXml.GetStream(FileMode.Create, FileAccess.ReadWrite));
              sw.Write(sources.OuterXml);
              sw.Flush();
              sw.Close();

              // Indicate that one more bibliography was transformed.
              bibCnt++;
     
            }
            catch (Exception e)
            {
              // Close the docx package.
              package.Close();
              // Rethrow the exception rather than returning failure.
              throw e;
            }
          }
        }
      }

      // Close the docx package.
      package.Close();

      // Give the user a hint that the extension was successful.
      return (bibCnt > 0);
    }

    /// <summary>
    /// Cleans all source elements in an open xml bibliography.
    /// </summary>
    /// <param name="docx">
    /// Path to a Word document containing a bibliography.
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
          if (sources.DocumentElement.LocalName.ToLower() == "sources" &&
            sources.DocumentElement.NamespaceURI.ToLower() == BibliographyNS.ToLower())
          {
            // Convert the entire document to a string.
            string bibliography = sources.OuterXml;

            // Remove BibOrder element.
            Regex regex = new Regex("<[a-zA-Z0-9]*:BibOrder>[a-zA-Z0-9]*</[a-zA-Z0-9]*:BibOrder>");
            bibliography = regex.Replace(bibliography, "");
            
            // Remove YearSuffix element.
            regex = new Regex("<[a-zA-Z0-9]*:YearSuffix>[a-zA-Z0-9]*</[a-zA-Z0-9]*:YearSuffix>");
            bibliography = regex.Replace(bibliography, "");

            // Write the XML document back to the docx.
            StreamWriter sw = new StreamWriter(customXml.GetStream(FileMode.Create, FileAccess.ReadWrite));
            sw.Write(bibliography);
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
