using System.Windows.Forms;

namespace BibWord.Extender.UI
{
  /// <summary>
  /// Dialog reporting the progress on background tasks.
  /// </summary>
  public partial class ProgressDialog : Form
  {
    #region Variables

    /// <summary>
    /// Boolean indicating if the dialog can be closed.
    /// </summary>
    private bool allowClosing = false;

    #endregion Variables

    #region Constructors

    /// <summary>
    /// Initializes a new instance of a ProgressDialog object.
    /// </summary>
    /// <remarks>
    /// To be able to close the dialog, the AllowClosing property 
    /// has to be set to true.
    /// </remarks>
    public ProgressDialog()
    {
      InitializeComponent();
    }

    #endregion Constructors

    #region Properties

    /// <summary>
    /// Indicates if the form can be closed or not.
    /// </summary>
    public bool AllowClosing
    {
      get { return this.allowClosing; }
      set { this.allowClosing = value; }
    }

    /// <summary>
    /// Gets or sets the text indicating the progress.
    /// </summary>
    public string ProgressText
    {
      get { return this.lblStatus.Text; }
      set { this.lblStatus.Text = value; }
    }

    /// <summary>
    /// Gets or sets the value of the progress bar used to display
    /// progress.
    /// </summary>
    public int ProgressPercentage
    {
      get 
      { 
        return this.pbLoad.Value; 
      }
      set
      { 
        this.pbLoad.Value = value;
        this.pbLoad.PerformStep();
      }
    }

    #endregion Properties

    #region Events

    /// <summary>
    /// Handles the closing event.
    /// </summary>
    private void ProgressDialog_FormClosing(object sender, FormClosingEventArgs e)
    {
      // As long as the allowClosing flag is not set, cancel any closing event.
      e.Cancel = !this.allowClosing;
    }

    #endregion Events
  }
}
