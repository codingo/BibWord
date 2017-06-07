using System;
using System.Xml;
using System.Collections.Generic;

namespace BibWord
{
  public class TagCollection
  {
    #region Private members

    /// <summary>
    /// String dictionary mapping tags onto elements.
    /// </summary>
    private Dictionary<string, string> _dict;

    /// <summary>
    /// Namespace for bibliography.
    /// </summary>
    private const string bibliographyNS = @"http://schemas.openxmlformats.org/officeDocument/2006/bibliography";

    #endregion Private members

    #region Constructors

    /// <summary>
    /// Initializes a new instance of a TagCollection.
    /// </summary>
    public TagCollection()
    {
      // Initialize variables.
      this._dict = new Dictionary<string, string>(67);

      // Initially, the collection gets loaded with English (United States) information.
      InitCollection();
    }

    #endregion Constructors

    #region Properties

    /// <summary>
    /// Retrieves the xml fragment belonging to a tag.
    /// </summary>
    /// <param name="tag">The tag to retrieve the xml for.</param>
    /// <returns>An xml fragment as a string.</returns>
    public string this[string tag]
    {
      get { return this._dict[tag]; }
    }

    #endregion Properties

    #region Methods

    /// <summary>
    /// Initializes the tag collection with localized data for English (United States) (LCID = 1033).
    /// </summary>
    private void InitCollection()
    {
      this._dict.Add("b:AbbreviatedCaseNumber", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Abbreviated Case Number</Label><DataTag>b:AbbreviatedCaseNumber</DataTag><Sample>Example: Bibliographies</Sample></Tag>");
      this._dict.Add("b:AlbumTitle", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Album Title</Label><DataTag>b:AlbumTitle</DataTag><TitlePriority>3</TitlePriority><Sample>Example: How to Write Bibliographies</Sample></Tag>");
      this._dict.Add("b:Author/b:Artist/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Artist</Label><DataTag>b:Author/b:Artist/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Author/b:Author/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Author</Label><DataTag>b:Author/b:Author/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author><OrgAuthor>Yes</OrgAuthor></Tag>");
      this._dict.Add("b:Author/b:BookAuthor/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Book Author</Label><DataTag>b:Author/b:BookAuthor/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:BookTitle", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Book Title</Label><DataTag>b:BookTitle</DataTag><TitlePriority>3</TitlePriority><Sample>Example: How to Write Bibliographies</Sample></Tag>");
      this._dict.Add("b:Broadcaster", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Broadcaster</Label><DataTag>b:Broadcaster</DataTag><Sample>Example: NBC</Sample></Tag>");
      this._dict.Add("b:BroadcastTitle", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Broadcast Title</Label><DataTag>b:BroadcastTitle</DataTag><TitlePriority>4</TitlePriority><Sample>Example: The Bibliography Program</Sample></Tag>");
      this._dict.Add("b:CaseNumber", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Case Number</Label><DataTag>b:CaseNumber</DataTag><Sample>Example: 1,234a</Sample></Tag>");
      this._dict.Add("b:ChapterNumber", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Chapter Number</Label><DataTag>b:ChapterNumber</DataTag><Sample>Example: 2</Sample></Tag>");
      this._dict.Add("b:City", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>City</Label><DataTag>b:City</DataTag><Sample>Example: Chicago</Sample></Tag>");
      this._dict.Add("b:Comments", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Comments</Label><DataTag>b:Comments</DataTag><Sample>Enter comments about this source.</Sample></Tag>");
      this._dict.Add("b:Author/b:Compiler/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Compiler</Label><DataTag>b:Author/b:Compiler/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Author/b:Composer/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Composer</Label><DataTag>b:Author/b:Composer/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Author/b:Conductor/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Conductor</Label><DataTag>b:Author/b:Conductor/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:ConferenceName", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Conference Publication Name</Label><DataTag>b:ConferenceName</DataTag><Sample>Example: Adventure Works Conference</Sample></Tag>");
      this._dict.Add("b:Author/b:Counsel/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Counsel</Label><DataTag>b:Author/b:Counsel/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:CountryRegion", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Country/Region</Label><DataTag>b:CountryRegion</DataTag><Sample>Example: United States of America</Sample></Tag>");
      this._dict.Add("b:Court", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Court</Label><DataTag>b:Court</DataTag><Sample>Example: The Supreme Court</Sample></Tag>");
      this._dict.Add("b:Day", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Day</Label><DataTag>b:Day</DataTag><Sample>Example: 1</Sample></Tag>");
      this._dict.Add("b:DayAccessed", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Day Accessed</Label><DataTag>b:DayAccessed</DataTag><Sample>Example: 1</Sample></Tag>");
      this._dict.Add("b:Department", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Department</Label><DataTag>b:Department</DataTag><Sample>Example: Department of Mathematics</Sample></Tag>");
      this._dict.Add("b:Author/b:Director/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Director</Label><DataTag>b:Author/b:Director/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Distributor", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Distributor</Label><DataTag>b:Distributor</DataTag><Sample>Example: Adventure Works</Sample></Tag>");
      this._dict.Add("b:Edition", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Edition</Label><DataTag>b:Edition</DataTag><Sample>Example: 2nd Edition</Sample></Tag>");
      this._dict.Add("b:Author/b:Editor/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Editor</Label><DataTag>b:Author/b:Editor/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Institution", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Institution</Label><DataTag>b:Institution</DataTag><Sample>Example: Maple University</Sample></Tag>");
      this._dict.Add("b:InternetSiteTitle", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Name of Web Site</Label><DataTag>b:InternetSiteTitle</DataTag><TitlePriority>3</TitlePriority><Sample>Example: A. Datum Corporation Web site</Sample></Tag>");
      this._dict.Add("b:Author/b:Interviewee/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Interviewee</Label><DataTag>b:Author/b:Interviewee/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author><TitlePriority>3</TitlePriority></Tag>");
      this._dict.Add("b:Author/b:Interviewer/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Interviewer</Label><DataTag>b:Author/b:Interviewer/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author><TitlePriority>5</TitlePriority></Tag>");
      this._dict.Add("b:Author/b:Inventor/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Inventor</Label><DataTag>b:Author/b:Inventor/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Issue", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Issue</Label><DataTag>b:Issue</DataTag><Sample>Example: 12</Sample></Tag>");
      this._dict.Add("b:JournalName", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Journal Name</Label><DataTag>b:JournalName</DataTag><Sample>Example: Adventure Works Monthly</Sample></Tag>");
      this._dict.Add("b:Medium", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Medium</Label><DataTag>b:Medium</DataTag><Sample>Example: Document</Sample></Tag>");
      this._dict.Add("b:Month", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Month</Label><DataTag>b:Month</DataTag><Sample>Example: January</Sample></Tag>");
      this._dict.Add("b:MonthAccessed", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Month Accessed</Label><DataTag>b:MonthAccessed</DataTag><Sample>Example: January</Sample></Tag>");
      this._dict.Add("b:NumberVolumes", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Number of Volumes</Label><DataTag>b:NumberVolumes</DataTag><Sample>Example: IV</Sample></Tag>");
      this._dict.Add("b:Pages", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Pages</Label><DataTag>b:Pages</DataTag><Sample>Example: 50-62</Sample></Tag>");
      this._dict.Add("b:PatentNumber", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Patent Number</Label><DataTag>b:PatentNumber</DataTag><Sample>Example: 123,456</Sample></Tag>");
      this._dict.Add("b:Author/b:Performer/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Performer</Label><DataTag>b:Author/b:Performer/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author><OrgAuthor>Yes</OrgAuthor></Tag>");
      this._dict.Add("b:PeriodicalTitle", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Periodical Title</Label><DataTag>b:PeriodicalTitle</DataTag><TitlePriority>3</TitlePriority><Sample>Example: Adventure Works Daily</Sample></Tag>");
      this._dict.Add("b:Author/b:ProducerName/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Producer Name</Label><DataTag>b:Author/b:ProducerName/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:ProductionCompany", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Production Company</Label><DataTag>b:ProductionCompany</DataTag><Sample>Example: Adventure Works Productions</Sample></Tag>");
      this._dict.Add("b:PublicationTitle", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Publication Title</Label><DataTag>b:PublicationTitle</DataTag><TitlePriority>3</TitlePriority><Sample>Example: The Bibliography Publication</Sample></Tag>");
      this._dict.Add("b:Publisher", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Publisher</Label><DataTag>b:Publisher</DataTag><Sample>Example: Adventure Works Press</Sample></Tag>");
      this._dict.Add("b:RecordingNumber", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Recording Number</Label><DataTag>b:RecordingNumber</DataTag><Sample>Example: 123456</Sample></Tag>");
      this._dict.Add("b:Reporter", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Reporter</Label><DataTag>b:Reporter</DataTag><Sample>Example: Supreme Court Reporter</Sample></Tag>");
      this._dict.Add("b:ShortTitle", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Short Title</Label><DataTag>b:ShortTitle</DataTag><TitlePriority>2</TitlePriority><Sample>Example: Bibliographies</Sample></Tag>");
      this._dict.Add("b:StandardNumber", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Standard Number</Label><DataTag>b:StandardNumber</DataTag><Sample>Example: ISBN/ISSN</Sample></Tag>");
      this._dict.Add("b:StateProvince", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>State/Province</Label><DataTag>b:StateProvince</DataTag><Sample>Example: Washington</Sample></Tag>");
      this._dict.Add("b:Station", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Station</Label><DataTag>b:Station</DataTag><Sample>Example: WABC</Sample></Tag>");
      this._dict.Add("b:Theater", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Theater</Label><DataTag>b:Theater</DataTag><Sample>Example: Adventure Works Theater</Sample></Tag>");
      this._dict.Add("b:ThesisType", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Report Type</Label><DataTag>b:ThesisType</DataTag><Sample>Example: PhD Thesis</Sample></Tag>");
      this._dict.Add("b:Title", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Title</Label><DataTag>b:Title</DataTag><TitlePriority>1</TitlePriority><Sample>Example: How to Write Bibliographies</Sample></Tag>");
      this._dict.Add("b:Author/b:Translator/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Translator</Label><DataTag>b:Author/b:Translator/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Type", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Type</Label><DataTag>b:Type</DataTag><Sample>Example: Software</Sample></Tag>");
      this._dict.Add("b:URL", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>URL</Label><DataTag>b:URL</DataTag><Sample>Example: http://www.adatum.com</Sample></Tag>");
      this._dict.Add("b:Version", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Version</Label><DataTag>b:Version</DataTag><Sample>Example: 1.5</Sample></Tag>");
      this._dict.Add("b:Volume", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Volume</Label><DataTag>b:Volume</DataTag><Sample>Example: III</Sample></Tag>");
      this._dict.Add("b:Author/b:Writer/b:NameList", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Writer</Label><DataTag>b:Author/b:Writer/b:NameList</DataTag><Sample>Example: Kramer, James D; Chen, Jacky</Sample><ToString>Author2String.XSL</ToString><ToXML>Author2XML.XSL</ToXML><Author>Yes</Author></Tag>");
      this._dict.Add("b:Year", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Year</Label><DataTag>b:Year</DataTag><Sample>Example: 2006</Sample></Tag>");
      this._dict.Add("b:YearAccessed", "<Tag xmlns=\"http://schemas.openxmlformats.org/officeDocument/2006/bibliography\"><Label>Year Accessed</Label><DataTag>b:YearAccessed</DataTag><Sample>Example: 2006</Sample></Tag>");

      // Unused fields:
      this._dict.Add("b:Guid", "");
      this._dict.Add("b:LCID", "");
      this._dict.Add("b:RefOrder", "");
      this._dict.Add("b:SourceType", "");
      this._dict.Add("b:Tag", "");
    }

    /// <summary>
    /// Overwrite tag collection information with localized information from a bibform xml document.
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

        // For every datatag, see if you can find localized content.
        foreach (string tag in keys)
        {
          XmlNode node = bibform.SelectSingleNode("b:Forms/b:Source/b:Tag[b:DataTag = '" + tag + "']", nsm);
          if (node != null)
          {
            this._dict[tag] = node.OuterXml;
          }
        }
      }
    }

    #endregion Methods
  }
}
