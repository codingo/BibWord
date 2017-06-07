using System;
using System.Windows.Forms;

namespace BibWord.Extender.UI
{
  /// <summary>
  /// About dialog for the BibWord Extender tool.
  /// </summary>
  public partial class AboutDialog : Form
  {
    #region Constructors

    public AboutDialog()
    {
      InitializeComponent();

      // Set the version information in Major.Minor format.
      this.lblVersion.Text = System.Diagnostics.FileVersionInfo.GetVersionInfo(Application.ExecutablePath).FileMajorPart + "." + System.Diagnostics.FileVersionInfo.GetVersionInfo(Application.ExecutablePath).FileMinorPart;
      
      // Set the title.
      this.Text = "BibWord Extender v." + this.lblVersion.Text;
    }

    #endregion Constructors

    #region Event handling

    /// <summary>
    /// Handle the clicking of the link.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void lnkTarget_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
    {
      System.Diagnostics.Process.Start("http://www.codeplex.com/bibliography");
      e.Link.Visited = true;
    }

    /// <summary>
    /// Event handling of   the clicking of the ok button.
    /// </summary>
    private void btnOk_Click(object sender, EventArgs e)
    {
      this.Close();
    }

    #endregion Event handling
  }
}
