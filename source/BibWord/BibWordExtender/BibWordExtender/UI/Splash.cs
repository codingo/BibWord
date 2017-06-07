using System;
using System.Windows.Forms;
using System.ComponentModel;

namespace BibWordExtender.UI
{
  public partial class Splash : Form
  {
    #region Variables 

    /// <summary>
    /// Boolean indicating if the form can be closed.
    /// </summary>
    private bool allowClosing = false;

    #endregion Variables

    #region Constructors

    /// <summary>
    /// Initializes a new instance of a Splash object.
    /// </summary>
    /// <remarks>
    /// The form will have no control box and will not be
    /// closable until the AllowClosing flag is set to true.
    /// </remarks>
    public Splash() : this(false)
    {       
    }

    /// <summary>
    /// Initializes a new instance of a Splash object.
    /// </summary>
    /// <param name="displayTitle">
    /// Bool indicating if the form should be displaying a title and close
    /// button or not.
    /// </param>
    /// <remarks>
    /// Note that if the title is displayed, it becomes possible to close
    /// the form.
    /// </remarks>
    public Splash(bool displayTitle)
    {
      InitializeComponent();

      // Set the version information in Major.Minor format.
      this.lblVersion.Text = System.Diagnostics.FileVersionInfo.GetVersionInfo(Application.ExecutablePath).FileMajorPart + "." + System.Diagnostics.FileVersionInfo.GetVersionInfo(Application.ExecutablePath).FileMinorPart;
      
      // Indicate if the close button should be shown.
      this.ControlBox = displayTitle;

      // Indicate if the form can be closed.
      this.allowClosing = displayTitle;
      
      // Display the title if required.
      if (displayTitle == true)
      {
        // Display the title.
        this.Text = "BibWord Extender v." + this.lblVersion.Text;
      }
    }

    #endregion Constructors

    #region Properties

    /// <summary>
    /// Gets or sets the boolean indicating if this form can be closed.
    /// </summary>
    /// <remarks>
    /// If this boolean is not set to true, this form can not be closed.
    /// </remarks>
    public bool AllowClosing
    {
      get { return this.allowClosing; }
      set { this.allowClosing = value; }
    }

    /// <summary>
    /// Gets or sets the text on the status label.
    /// </summary>
    public string StatusText
    {
      get { return this.lblStatus.Text; }
      set { this.lblStatus.Text = value; }
    }

    #endregion Properties

    #region Events

    /// <summary>
    /// Handles the closing event.
    /// </summary>
    private void Splash_FormClosing(object sender, FormClosingEventArgs e)
    {
      // As long as the allowClosing flag is not set, cancel any closing event.
      e.Cancel = !this.allowClosing;
    }

    /// <summary>
    /// Handles the clicking event.
    /// </summary>
    /// <remarks>
    /// Note that this will not close the form if the AllowClosing flag is not set.
    /// </remarks>
    private void Splash_Click(object sender, EventArgs e)
    {
      this.Close();
    }
    
    /// <summary>
    /// Handles the clicking of the web page link.
    /// </summary>
    private void lnkTarget_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
    {
      System.Diagnostics.Process.Start("http://www.codeplex.com/bibliography");
      e.Link.Visited = true;
    }

    #endregion Events
  }
}
