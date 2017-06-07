using System;
using System.IO;
using System.Xml;
using System.Collections.Specialized;

namespace BibWord
{
  class Program
  {
    static void Main(string[] args)
    {
      string bibformIn = null;
      string bibformOut = null;
      string typedefs = null;

      bibformIn = @"C:\Program Files\Microsoft Office\Office12\1033\Bibliography\BIBFORM.XML";
      bibformOut = @"e:\bibform2.xml";
      typedefs = @"E:\Software\Word 2007 Bibliography\Bibliography\BibWord\BibType\types.xml";

      ParseArguments(args, ref bibformIn, ref typedefs, ref bibformOut);

      Create(bibformIn, typedefs, bibformOut);
    }

    /// <summary>
    /// Retrieves the arguments.
    /// </summary>
    /// <param name="args">An array with command line arguments.</param>
    /// <param name="bibformIn">Path to the localized bibform.</param>
    /// <param name="bibformOut">Path to the bibform output.</param>
    /// <param name="typedefs">Path to the xml file containing the definition for the different types.</param>
    static void ParseArguments(string[] args, ref string bibformIn, ref string typedefs, ref string bibformOut)
    {
      // Add all parameters to a string dictionary with the switch as key.
      StringDictionary dict = new StringDictionary();

      for (int i = 0; i < args.Length; i++)
      {
        dict.Add(args[i].Substring(1, 1), args[i].Substring(3));
      }

      // Initialize variables.
      bibformIn = "";
      typedefs = "";
      bibformOut = "";

      // Indicates if the parameters are valid or not.
      bool valid = true;

      // Verify the type definitions parameter.
      if (dict.ContainsKey("t") == true)
      {
        if (File.Exists(dict["t"]) == true)
        {
          typedefs = dict["t"];
        }
        else
        {
          Console.WriteLine("File with source type definitions does not exist (/t switch).");
          valid = false;
        }
      }
      else
      {
        Console.WriteLine("No file with source type definitions specified (/t switch).");
        valid = false;
      }

      // Verify the output parameter.
      if (dict.ContainsKey("o") == true)
      {
        if (File.Exists(dict["o"]) == false)
        {
          bibformOut = dict["o"];
        }
        else
        {
          Console.WriteLine("Output file already exists (/o switch).");
          valid = false;
        }
      }
      else
      {
        Console.WriteLine("No output file was specified (/o switch).");
        valid = false;
      }

      // Verify the bibform parameter.
      if (dict.ContainsKey("l") == true)
      {
        if (File.Exists(dict["l"]) == true)
        {
          bibformIn = dict["l"];
        }
        else
        {
          Console.WriteLine("Localized bibform file does not exist (/l switch).");
          valid = false;
        }
      }
     

      // If there is an error in the parameters, show help functionality and quit.
      if (valid == false)
      {
        Console.WriteLine();
        Console.WriteLine("Usage: BibType /t:typedefs /o:output [/l:bibform]");
        Console.WriteLine();
        Console.WriteLine("    /t:typedefs  Path to the xml document containing the definition for the");
        Console.WriteLine("                 different source types.");
        Console.WriteLine("                 the document and looks for it in the default directory.");
        Console.WriteLine("    /o:output    Path to the output document that will be created.");
        Console.WriteLine("    /l:bibform   Optional. Path to a localized bibform.xml which will be used");
        Console.WriteLine("                 to localize the output.");
        Environment.Exit(0);
      }
    }

    /// <summary>
    /// Creates a new bibform xml document.
    /// </summary>
    /// <param name="bibformIn">Path to the localized bibform which is used to create the new bibform. Can be null, in which case English (United States) information is used.</param>
    /// <param name="typedefs">Path to the xml file containing the definition for the different types.</param>
    /// <param name="bibformOut">Path to the bibform output.</param>
    static void Create(string bibformIn, string typedefs, string bibformOut)
    {
      const string bibliographyNS = @"http://schemas.openxmlformats.org/officeDocument/2006/bibliography";
      const string typesNS = @"http://BibWord.org/BibType";

      // Load all (localized) information.
      TagCollection tags = new TagCollection();
      TypeCollection types = new TypeCollection();

      if (bibformIn != null && bibformIn != "")
      {
        XmlDocument doc = new XmlDocument();
        doc.Load(bibformIn);

        tags.Update(doc);
        types.Update(doc);
      }

      // Create skeleton output document.
      XmlDocument output = new XmlDocument();
      output.AppendChild(output.CreateXmlDeclaration("1.0", null, null));

      // Give the XML document a Forms element as root.
      XmlElement rootElement = output.CreateElement("Forms", bibliographyNS);
      output.AppendChild(rootElement);
      
      // Load definitions.
      XmlDocument defs = new XmlDocument();
      defs.Load(typedefs);

      XmlNamespaceManager nsm = new XmlNamespaceManager(defs.NameTable);
      nsm.AddNamespace("t", typesNS);

      // Grab all type nodes.
      XmlNodeList list = defs.SelectNodes("/t:Types/t:Type", nsm);

      // Process each type.
      foreach (XmlNode node in list)
      {
        string typeAttr = node.Attributes["Name"].InnerText;
        string displayAttr = types[typeAttr];

        // If another display
        XmlNode display = node.Attributes["Display"];
        if (display != null)
        {
          displayAttr = display.InnerText;
        }
        if (displayAttr == "")
        {
          displayAttr = typeAttr;
        }

        XmlElement Source = output.CreateElement("Source", bibliographyNS);
        Source.SetAttribute("type", typeAttr);
        Source.SetAttribute("display", displayAttr);

        // Get all DataTag elements in the current Type.
        XmlNodeList datatags = node.SelectNodes("/t:Types/t:Type[@Name ='" + typeAttr + "']/t:DataTag", nsm);

        // Combine data in.
        foreach (XmlNode datatag in datatags)
        {
          Source.InnerXml += tags[datatag.InnerText];
        }

        // Add the entire source.
        output.DocumentElement.AppendChild(Source);
      }

      output.Save(bibformOut);
    }
  }
}
