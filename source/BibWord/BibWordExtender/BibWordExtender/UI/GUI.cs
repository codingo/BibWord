using System;
using System.IO;
using System.Windows.Forms;
using System.ComponentModel;
using System.Collections.Generic;

using BibWordExtender.Data;

namespace BibWordExtender.UI
{
  public partial class GUI : Form
  {
    #region Variables

    /// <summary>
    /// Mapping of style names (keys) and style paths (values).
    /// </summary>
    private Dictionary<string, string> map;

    /// <summary>
    /// Background worker thread for creating the mapping between style names and style paths.
    /// </summary>
    private BackgroundWorker worker;

    /// <summary>
    /// Splash form.
    /// </summary>
    private Splash splash;
    
    #endregion Variables

    #region Constructors

    public GUI()
    {
      InitializeComponent();

      LoadStyleInformation();

      toolTip.SetToolTip(this.cmdClean, "Remove all BibWord extensions from the bibliographic sources.");
      toolTip.SetToolTip(this.cmdExit, "Exit the application.");
      toolTip.SetToolTip(this.cmdInfo, "Display information about the application.");
      toolTip.SetToolTip(this.cmdWordDocSelection, "Select a Word document.");
      toolTip.SetToolTip(this.cmdReload, "Reload all style information.");
      toolTip.SetToolTip(this.cmdExtend, "Extend the bibliographic sources.");
    }

    #endregion Constructors

    #region Methods

    /// <summary>
    /// Ensures the loading of all style information through a background worker thread.
    /// </summary>
    private void LoadStyleInformation()
    {
      // Initialize the background worker.
      this.worker = new BackgroundWorker();
      this.worker.DoWork += new DoWorkEventHandler(Worker_DoWork);
      this.worker.ProgressChanged += new ProgressChangedEventHandler(Worker_ProgressChanged);
      this.worker.RunWorkerCompleted += new RunWorkerCompletedEventHandler(Worker_RunWorkerCompleted);
      this.worker.WorkerReportsProgress = true;

      // Start running the background worker.
      this.worker.RunWorkerAsync();

      // Display the splash form.
      this.splash = new Splash();
      this.splash.ShowDialog();
    }
    
    #endregion Methods
    
    #region Event Handling

    /// <summary>
    /// Background worker thread.
    /// </summary>
    private void Worker_DoWork(object sender, DoWorkEventArgs e)
    {
      // Load information about all the bibliography styles.
      e.Result = BibWord.LoadBibliographyStylesInformation(this.worker);
    }

    /// <summary>
    /// Handle the ProgressChanged event raised by the background worker.
    /// </summary>
    private void Worker_ProgressChanged(object sender, ProgressChangedEventArgs e)
    {
      // Update status label on the splash screen.
      this.splash.StatusText = "Processed " + e.UserState.ToString() + " ... (" + e.ProgressPercentage + "%)";
    }

    /// <summary>
    /// Handle the RunWorkerCompleted event raised by the background worker.
    /// </summary>
    private void Worker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
    {
      // Assign the result to the map.
      this.map = (Dictionary<string, string>)e.Result;

      // Bind the result to the combobox.
      this.cmbStyles.DataSource = new BindingSource(this.map, null);
      this.cmbStyles.DisplayMember = "Key";

      // Close the splash screen.
      this.splash.AllowClosing = true;
      this.splash.Close();
    }

    /// <summary>
    /// Handle the clicking of the reload button.
    /// </summary>
    private void cmdReload_Click(object sender, EventArgs e)
    {
      // Reload the style information.
      this.LoadStyleInformation();
    }

    /// <summary>
    /// Handle the clicking of the info button.
    /// </summary>
    private void cmdInfo_Click(object sender, EventArgs e)
    {
      this.splash = new Splash(true);
      this.splash.ShowDialog();
    }

    /// <summary>
    /// Handle the clicking of the exit button.
    /// </summary>
    private void cmdExit_Click(object sender, EventArgs e)
    {
      this.Close();
    }

    /// <summary>
    /// Handle the clicking of the extend button.
    /// </summary>
    private void cmdExtend_Click(object sender, EventArgs e)
    {
      try
      {
        bool success = BibWord.ExtendBibliography(this.txtWordDoc.Text, this.map[this.cmbStyles.Text]);

        // Give the user a hint to the result of the extension attempt.
        if (success == true)
        {
          MessageBox.Show("Bibliography extension successful.", "Extension result", 
            MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        else
        {
          MessageBox.Show("Bibliography extension failed. Either there was no" +
            "bibliography or it was not a BibWord bibliography.", "Extension result",
            MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
      }
      catch (FileFormatException)
      {
        MessageBox.Show("Not a valid Word 2007 file.");
      }
      catch (Exception ex)
      {
        MessageBox.Show(ex.Message);
      }
    }

    /// <summary>
    /// Handle the clicking of the button to select a file.
    /// </summary>
    private void cmdWordDocSelection_Click(object sender, EventArgs e)
    {
      // Let the user pick a Word docx file.
      openFileDialog.ShowDialog();

      // Display the selected file.
      if (openFileDialog.FileName != "")
      {
        txtWordDoc.Text = openFileDialog.FileName;

        // Sets the bibliography style currently used by the document.
        try
        {
          this.cmbStyles.Text = BibWord.GetBibliographyStyle(openFileDialog.FileName, this.map);
        }
        catch (Exception ex)
        {
          MessageBox.Show(ex.Message);
        }
      }
    }

    /// <summary>
    /// Handle the clicking of the clean button.
    /// </summary>
    private void cmdClean_Click(object sender, EventArgs e)
    {
      try
      {
        BibWord.CleanBibliography(this.txtWordDoc.Text);

        // Give the user.
        MessageBox.Show("Bibliography was successfully cleaned.", 
          "Bibliography cleaned", MessageBoxButtons.OK, MessageBoxIcon.Information);
      }
      catch (FileFormatException)
      {
        MessageBox.Show("Not a valid Word 2007 file.");
      }
      catch (Exception ex)
      {
        MessageBox.Show(ex.Message);
      }
    }

    #endregion Event Handling
  }
}
