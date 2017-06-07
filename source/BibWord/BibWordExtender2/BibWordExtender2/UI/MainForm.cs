using System;
using System.IO;
using System.Windows.Forms;
using System.ComponentModel;
using System.Collections.Generic;

namespace BibWord.Extender.UI
{
  /// <summary>
  /// Main form for the BibWord Extender program.
  /// </summary>
  public partial class MainForm : Form
  {
    #region Variables

    /// <summary>
    /// String containing the directory where the Word bibliography styles 
    /// are stored.
    /// </summary>
    private string styleDir = "";

    /// <summary>
    /// Mapping of style names (keys) and style paths (values).
    /// </summary>
    private Dictionary<string, string> map;

    /// <summary>
    /// Background worker thread for creating the mapping between style names 
    /// and style paths.
    /// </summary>
    private BackgroundWorker worker;

    /// <summary>
    /// Progress dialog.
    /// </summary>
    private ProgressDialog progress;

    #endregion Variables
    
    #region Constructors

    /// <summary>
    /// Initializes a new instance of an Extender object.
    /// </summary>
    public MainForm()
    {
      InitializeComponent();
      
      // Set the caption of the form.
      this.Text = "BibWord Extender v." + System.Diagnostics.FileVersionInfo.GetVersionInfo(Application.ExecutablePath).FileMajorPart + "." + System.Diagnostics.FileVersionInfo.GetVersionInfo(Application.ExecutablePath).FileMinorPart;
      
      // Try to retrieve a first version for the directory containing the 
      // Word bibliography styles.
      this.styleDir = ExtensionTools.GetBibliographyStylesPath();
      
      // Initialize the style map.
      this.map = new Dictionary<string, string>();

      this.Show();
      GetStyleInformation();
    }

    #endregion Constructors
    
    #region Methods

    /// <summary>
    /// Ensures the loading of all style information through a background worker thread.
    /// </summary>
    private void GetStyleInformation()
    {
      // Create a new progress dialog.
      this.progress = new ProgressDialog();
      
      // Allow the user to browse for the style folder.
      FolderBrowserDialog fbd = new FolderBrowserDialog();
      fbd.Description = "Please select the directory containing the Word bibliography styles.";
      fbd.SelectedPath = this.styleDir;
      fbd.ShowDialog();

      // Only continue if a path was selected.
      if (String.IsNullOrEmpty(fbd.SelectedPath) == false && fbd.DialogResult == DialogResult.OK)
      {
        // Change the cursor to busy.
        Cursor.Current = Cursors.WaitCursor;

        // Store the selected folder for later use.
        this.styleDir = fbd.SelectedPath;

        // Initialize the background worker.
        this.worker = new BackgroundWorker();
        this.worker.DoWork += new DoWorkEventHandler(Worker_DoWork);
        this.worker.ProgressChanged += new ProgressChangedEventHandler(Worker_ProgressChanged);
        this.worker.RunWorkerCompleted += new RunWorkerCompletedEventHandler(Worker_RunWorkerCompleted);
        this.worker.WorkerReportsProgress = true;

        // Start running the background worker.
        this.worker.RunWorkerAsync();

        // Display the progress dialog.
        this.progress.ShowDialog();
      }
      else if (fbd.DialogResult == DialogResult.Cancel && this.map.Count == 0)
      {
        MessageBox.Show("Please select the directory containing the bibliography styles." +
          Environment.NewLine + "Use the 'Reload Styles' button.",
          "Invalid style directory", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
      }
    }

    #endregion Methods

    #region Event Handling

    /// <summary>
    /// Background worker thread.
    /// </summary>
    private void Worker_DoWork(object sender, DoWorkEventArgs e)
    {
      // Load information about all the bibliography styles.
      e.Result = ExtensionTools.LoadBibliographyStylesInformation(this.styleDir, this.worker);
    }

    /// <summary>
    /// Handle the ProgressChanged event raised by the background worker.
    /// </summary>
    private void Worker_ProgressChanged(object sender, ProgressChangedEventArgs e)
    {
      // Update status information on the progress dialog.
      this.progress.Invoke((MethodInvoker)delegate()
      {
        this.progress.ProgressText = e.UserState.ToString();
        this.progress.ProgressPercentage = e.ProgressPercentage;
      });
    }

    /// <summary>
    /// Handle the RunWorkerCompleted event raised by the background worker.
    /// </summary>
    private void Worker_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
    {
      // Assign the result to the map.
      this.map = (Dictionary<string, string>)e.Result;

      // Close the splash screen.
      this.progress.Invoke((MethodInvoker)delegate()
      {
        this.progress.AllowClosing = true;
        this.progress.Close();
      });

      // Validate the result.
      if (this.map.Count > 0)
      {
        // Bind the result to the combobox.
        this.cmbStyles.Invoke((MethodInvoker)delegate()
        {
          this.cmbStyles.DataSource = new BindingSource(this.map, null);
          this.cmbStyles.DisplayMember = "Key";
        });
      }
      else
      {
        MessageBox.Show("No Word bibliography styles were found in " +
          this.styleDir + ".", "No styles found!", MessageBoxButtons.OK,
          MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button1, 
          MessageBoxOptions.DefaultDesktopOnly);
      }

      // Set the cursor back to default.
      Cursor.Current = Cursors.Default;
    }
    
    /// <summary>
    /// Handle the clicking of the button to select a file.
    /// </summary>
    private void btnWordDocSelection_Click(object sender, EventArgs e)
    {
      // Let the user pick a Word docx file.
      OpenFileDialog ofd = new OpenFileDialog();
      ofd.ShowDialog();

      // If a file was selected.
      if (String.IsNullOrEmpty(ofd.FileName) == false)
      {
        // Display the path of selected file.
        txtWordDoc.Text = ofd.FileName;

        // Set the cursor to busy.
        Cursor.Current = Cursors.WaitCursor;

        // Sets the bibliography style currently used by the document.
        string styleName = String.Empty;
        string selectedStyle = String.Empty;
        try
        {
          ExtensionTools.GetBibliographyStyle(ofd.FileName, ref selectedStyle, ref styleName);
                    
          // Verify if there is a match with a style name.
          if (this.map.ContainsKey(styleName))
          {
            this.cmbStyles.Text = styleName;
          }
          else
          {
            // Verify if there is a match with a style file.
            string path = Path.Combine(styleDir, Path.GetFileName(selectedStyle));

            foreach (KeyValuePair<string, string> kvp in this.map)
            {
              if (kvp.Value == path)
              {
                this.cmbStyles.Text = kvp.Key;
                break;
              }
            }
          }
        }
        catch (Exception ex)
        {
          MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK, 
            MessageBoxIcon.Error);
        }

        // Set the cursor back to default.
        Cursor.Current = Cursors.Default;
      }
    }

    /// <summary>
    /// Handle the clicking of the extend button.
    /// </summary>
    private void btnExtend_Click(object sender, EventArgs e)
    {
      // Set the cursor to indicate the program is busy.
      Cursor.Current = Cursors.WaitCursor;

      // Verify that the file actually exists.
      if (File.Exists(this.txtWordDoc.Text) == true && String.IsNullOrEmpty(this.cmbStyles.Text) == false)
      {
        // Check if a backup needs to be made.
        if (chkBackup.Checked == true)
        {
          // Find a file name that is not in use yet for the backup.
          FileInfo fi = new FileInfo(this.txtWordDoc.Text);

          string dir = fi.DirectoryName;
          string file = Path.GetFileNameWithoutExtension(fi.FullName) + "_orig";
          string ext = Path.GetExtension(fi.FullName);

          int cnt = 1;

          string backup = Path.Combine(dir, file + ext);

          while (File.Exists(backup) == true)
          {
            backup = Path.Combine(dir, file + "_" + cnt++ + ext);
          }

          File.Copy(this.txtWordDoc.Text, backup);
        }

        // Do the extension.
        try
        {
          bool success = ExtensionTools.ExtendBibliography(this.txtWordDoc.Text, this.map[this.cmbStyles.Text]);

          // Give the user a hint to the result of the extension attempt.
          if (success == true)
          {
            MessageBox.Show("Bibliography extension successful.", "Extension result",
              MessageBoxButtons.OK, MessageBoxIcon.Information);
          }
          else
          {
            MessageBox.Show("Bibliography extension failed. Either there was no" +
              "bibliography or it was not a BibWord bibliography.", 
              "Extension result", MessageBoxButtons.OK, MessageBoxIcon.Error);
          }
        }
        catch (FileFormatException)
        {
          MessageBox.Show("Not a valid Word 2007 file.", "Error", 
            MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
        }
        catch (Exception ex)
        {
          MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK,
            MessageBoxIcon.Exclamation);
        }
      }
      else
      {
        if (File.Exists(this.txtWordDoc.Text) == false)
        {
          MessageBox.Show("File does not exist.", "Invalid file",
            MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
        }
        else
        {
          MessageBox.Show("No style selected.", "Invalid style selection",
            MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
        }
      }
      
      // Set the cursor back to default.
      Cursor.Current = Cursors.Default;
    }

    /// <summary>
    /// Handle the clicking of the clean button.
    /// </summary>
    private void btnClean_Click(object sender, EventArgs e)
    {
      // Set the cursor to indicate the program is busy.
      Cursor.Current = Cursors.WaitCursor;

      // Verify that the file actually exists.
      if (File.Exists(this.txtWordDoc.Text) == true)
      {
        // Check if a backup needs to be made.
        if (chkBackup.Checked == true)
        {
          // Find a file name that is not in use yet for the backup.
          FileInfo fi = new FileInfo(this.txtWordDoc.Text);

          string dir = fi.DirectoryName;
          string file = Path.GetFileNameWithoutExtension(fi.FullName) + "_orig";
          string ext = Path.GetExtension(fi.FullName);

          int cnt = 1;

          string backup = Path.Combine(dir, file + ext);

          while (File.Exists(backup) == true)
          {
            backup = Path.Combine(dir, file + "_" + cnt++ + ext);
          }

          File.Copy(this.txtWordDoc.Text, backup);
        }

        // Cleaning up the bibliography.
        try
        {
          ExtensionTools.CleanBibliography(this.txtWordDoc.Text);

          // Give the user a hint to the success.
          MessageBox.Show("Bibliography was successfully cleaned.",
            "Bibliography cleaned", MessageBoxButtons.OK, MessageBoxIcon.Information);
        }
        catch (FileFormatException)
        {
          MessageBox.Show("Not a valid Word 2007 file.", "Error",
            MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
        }
        catch (Exception ex)
        {
          MessageBox.Show(ex.Message, "Error", MessageBoxButtons.OK,
            MessageBoxIcon.Exclamation);
        }
      }

      // Set the cursor back to default.
      Cursor.Current = Cursors.Default;
    }
    
    /// <summary>
    /// Handle the clicking of the reload button.
    /// </summary>
    private void btnReload_Click(object sender, EventArgs e)
    {
      this.GetStyleInformation();
    }

    /// <summary>
    /// Handle the clicking of the info button.
    /// </summary>
    private void btnInfo_Click(object sender, EventArgs e)
    {
      AboutDialog ad = new AboutDialog();
      ad.ShowDialog();
    }

    /// <summary>
    /// Handle the clicking of the exit button.
    /// </summary>
    private void btnExit_Click(object sender, EventArgs e)
    {
      this.Close();
    }

    #endregion Event Handling
  }
}
