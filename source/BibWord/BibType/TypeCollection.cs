using System;
using System.Xml;
using System.Collections.Generic;

namespace BibWord
{
  public class TypeCollection
  {
    #region Private members

    /// <summary>
    /// String dictionary mapping types onto strings.
    /// </summary>
    private Dictionary<string, string> _dict;

    /// <summary>
    /// Namespace for bibliography.
    /// </summary>
    private const string bibliographyNS = @"http://schemas.openxmlformats.org/officeDocument/2006/bibliography";

    #endregion Private members

    #region Constructors

    /// <summary>
    /// Initializes a new instance of a TypeCollection.
    /// </summary>
    public TypeCollection()
    {
      // Initialize variables.
      this._dict = new Dictionary<string, string>(67);

      // Initially, the collection gets loaded with English (United States) information.
      InitCollection();
    }

    #endregion Constructors

    #region Properties

    /// <summary>
    /// Retrieves the display string for a source type.
    /// </summary>
    /// <param name="type">A type name.</param>
    /// <returns>A string containing the display name.</returns>
    public string this[string type]
    {
      get
      {
        if (this._dict.ContainsKey(type))
        {
          return this._dict[type];
        }
        else
        {
          return "";
        }
      }
    }

    #endregion Properties

    #region Methods

    /// <summary>
    /// Initializes the type collection with localized data for English (United States) (LCID = 1033).
    /// </summary>
    private void InitCollection()
    {
      this._dict.Add("Book", "Book");
      this._dict.Add("BookSection", "Book Section");
      this._dict.Add("JournalArticle", "Journal Article");
      this._dict.Add("ArticleInAPeriodical", "Article in a Periodical");
      this._dict.Add("ConferenceProceedings", "Conference Proceedings");
      this._dict.Add("Report", "Report");
      this._dict.Add("InternetSite", "Web site");
      this._dict.Add("DocumentFromInternetSite", "Document From Web site");
      this._dict.Add("ElectronicSource", "Electronic Source");
      this._dict.Add("Art", "Art");
      this._dict.Add("SoundRecording", "Sound Recording");
      this._dict.Add("Performance", "Performance");
      this._dict.Add("Film", "Film");
      this._dict.Add("Interview", "Interview");
      this._dict.Add("Patent", "Patent");
      this._dict.Add("Case", "Case");
      this._dict.Add("Misc", "Miscellaneous");      
    }

    /// <summary>
    /// Overwrite type collection information with localized information from a bibform xml document.
    /// </summary>
    /// <param name="bibform">A bibform xml document.</param>
    public void Update(XmlDocument bibform)
    {
      if (bibform != null)
      {
        XmlNamespaceManager nsm = new XmlNamespaceManager(bibform.NameTable);
        nsm.AddNamespace("b", bibliographyNS);

        // Get the keys separate from the collection.
        //   Enumeration over a collection you are changing is not possible!!!
        string[] keys = new string[this._dict.Keys.Count];
        this._dict.Keys.CopyTo(keys, 0);

        // For every type, see if you can find localized content.
        foreach (string type in keys)
        {
          XmlNode node = bibform.SelectSingleNode("b:Forms/b:Source[@type = '" + type + "']", nsm);
          if (node != null)
          {
            this._dict[type] = node.Attributes["display"].InnerText;
          }
        }
      }
    }

    #endregion Methods
  }
}
