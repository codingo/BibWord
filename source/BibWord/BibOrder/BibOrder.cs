using System;
using System.IO;
using System.Xml;
using System.Xml.Xsl;
using System.IO.Packaging; // Part of WindowsBase
using System.Collections.Specialized;

using Microsoft.Win32; // Registry access for default style folder.

namespace BibWord
{
  class BibOrder
  {
    static void Main(string[] args)
    {
      // Declare variables.
      string docx = "";
      string styledir = "";
      string stylesheet = "";
      
      // Parse arguments and retrieve variables.
      ParseArguments(args, ref docx, ref styledir, ref stylesheet);
            
      // Actual processing.
      TransformDocument(docx, styledir, stylesheet);      
    }
    
    /// <summary>
    /// Retrieves the arguments.
    /// </summary>
    /// <param name="args">An array with command line arguments.</param>
    /// <param name="docx">The path of the file to transform.</param>
    /// <param name="styledir">The directory of the styless.</param>
    /// <param name="stylesheet">The name of the stylesheet.</param>
    static void ParseArguments(string[] args, ref string docx, ref string styledir, ref string stylesheet)
    {
      // Add all parameters to a string dictionary with the switch as key.
      StringDictionary dict = new StringDictionary();

      for (int i = 0; i < args.Length; i++)
      {
        dict.Add(args[i].Substring(1, 1), args[i].Substring(3));
      }
      
      // Initialize variables.
      docx = "";
      styledir = "";
      stylesheet = "";

      // Indicates if the parameters are valid or not.
      bool valid = true;

      // Verify the document parameter.
      if (dict.ContainsKey("d") == true)
      {
        if (File.Exists(dict["d"]) == true)
        {
          docx = dict["d"];
        }
        else
        {
          Console.WriteLine("Specified document does not exist (/d switch).");
          valid = false;
        }
      }
      else
      {
        Console.WriteLine("No document specified (/d switch).");
        valid = false;
      }

      // Verify the stylesheet and styledir parameters.
      if (dict.ContainsKey("s") == true)
      {
        // If a stylesheet is given, verify that it exists.
        if (File.Exists(dict["s"]) == true)
        {
          styledir = Path.GetDirectoryName(dict["s"]);
          stylesheet = Path.GetFileName(dict["s"]);
        }
        else
        {
          Console.WriteLine("Specified stylesheet does not exist.");
          valid = false;
        }
      }
      else
      {
        // If there is no /s switch, check if there is a /l.
        if (dict.ContainsKey("l") == true)
        {
          // If a style directory is given, verify that it exists.
          if (Directory.Exists(dict["l"]) == true)
          {
            styledir = dict["l"];
          }
          else
          {
            Console.WriteLine("Specified style folder does not exist.");
            valid = false;
          }
        }
      }

      // If there is an error in the parameters, show help functionality and quit.
      if (valid == false)
      {
        Console.WriteLine();
        Console.WriteLine("Usage: BibOrder /d:doc [/s:stylesheet] [/l:styleloc]");
        Console.WriteLine();
        Console.WriteLine("    /d:doc       Path to the document to adapt. If no other parameters are");
        Console.WriteLine("                 specified, the program uses the stylesheet specified by the");
        Console.WriteLine("                 the document and looks for it in the default directory.");
        Console.WriteLine("    /s:style     Optional. Overwrites the stylesheet to use.");
        Console.WriteLine("    /l:styleloc  Optional. Overwrites the directory to look for the stylesheet.");
        Console.WriteLine("                 Ignored if /s is used.");
        Environment.Exit(0);
      }

      // If the styledir is empty, try to retrieve the default one.
      if (styledir == "")
      {
        // Get the Word version used to process documents with the docx extension.
        string type = (string)Registry.ClassesRoot.OpenSubKey(".docx").GetValue("");

        // Get the string executed if docx elements are opened.
        string winword = (string)Registry.ClassesRoot.OpenSubKey(type + "\\shell\\Open\\command").GetValue("");

        // Get the location of the version of Word used to process docx documents.
        string[] parts = winword.Split(new char[] { '"' }, StringSplitOptions.RemoveEmptyEntries);

        styledir = Path.Combine(Path.GetDirectoryName(parts[0]), "Bibliography\\Style");      
      }

    }

    /// <summary>
    /// Transforms the sources custom xml in a given document.
    /// </summary>
    /// <param name="docx">The path of the file to transform.</param>
    /// <param name="styledir">The directory of the style.</param>
    /// <param name="stylesheet">The name of the stylesheet.</param>
    static void TransformDocument(string docx, string styledir, string stylesheet)
    {
      #region Constants

      // Document relationship type.
      const string documentRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument";
      // Custom XML relationship type.
      const string customXmlRelationshipType = @"http://schemas.openxmlformats.org/officeDocument/2006/relationships/customXml";
      // Bibliography namespace.
      const string bibliographyNS = @"http://schemas.openxmlformats.org/officeDocument/2006/bibliography";

      #endregion Constants

      // Open the docx package.
      Package package = Package.Open(docx, FileMode.Open, FileAccess.ReadWrite);

      // Go over every document.
      foreach (PackageRelationship rel in package.GetRelationshipsByType(documentRelationshipType))
      {
        // Create the uri for a document.
        Uri documentUri = PackUriHelper.ResolvePartUri(new Uri("/", UriKind.Relative), rel.TargetUri);

        // Get the document.
        PackagePart document = package.GetPart(documentUri);

        // Go over every customXml file related to the document.
        foreach (PackageRelationship docRel in document.GetRelationshipsByType(customXmlRelationshipType))
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
            sources.DocumentElement.NamespaceURI.ToLower() == bibliographyNS.ToLower())
          {
            // Create an XML document to give to the XSL transformation.
            XmlDocument BibOrderInput = new XmlDocument();
            BibOrderInput.AppendChild(BibOrderInput.CreateXmlDeclaration("1.0", null, null));

            // Give the XML document a b:BibOrder element as root.
            XmlElement rootElement = BibOrderInput.CreateElement("b", "BibWord", bibliographyNS);
            BibOrderInput.AppendChild(rootElement);

            // Attach all the b:Source elements from the sources document to the BibOrderInput document.
            XmlNamespaceManager nsm = new XmlNamespaceManager(sources.NameTable);
            nsm.AddNamespace("b", bibliographyNS);

            foreach (XmlNode node in sources.SelectNodes("//b:Sources/b:Source", nsm))
            {
              // Add the b:Source element to the XML document to transform.
              rootElement.AppendChild(BibOrderInput.ImportNode(node, true));
              // Remove the b:Source element from the original input.
              sources.DocumentElement.RemoveChild(node);
            }

            // Get the stylesheet from the XML if not specified otherwise.
            if (stylesheet == "")
            {
              stylesheet = Path.GetFileName(sources.SelectSingleNode("//b:Sources", nsm).Attributes["SelectedStyle"].Value);
            }

            // Do the transformation.            
            string transformation = Path.Combine(styledir, stylesheet);
            MemoryStream ms = new MemoryStream();
            XslCompiledTransform xslt = new XslCompiledTransform();
            xslt.Load(transformation);
            xslt.Transform(BibOrderInput, null, ms);

            // Load the result back into an XML document.
            XmlDocument BibOrderOutput = new XmlDocument();
            BibOrderOutput.LoadXml(System.Text.Encoding.GetEncoding("iso-8859-1").GetString(ms.ToArray()));

            // Add the newly obtained b:Source elements back to the orignal document.
            foreach (XmlNode node in BibOrderOutput.SelectNodes("//b:BibWord/b:Source", nsm))
            {
              sources.DocumentElement.AppendChild(sources.ImportNode(node, true));
            }

            // Write the XML document back to the docx.
            StreamWriter sw = new StreamWriter(customXml.GetStream(FileMode.Create, FileAccess.ReadWrite));
            sw.Write(sources.OuterXml);
            sw.Flush();
            sw.Close();
          }
        }
      }

      // Close the docx package.
      package.Close();
    }
  }
}
