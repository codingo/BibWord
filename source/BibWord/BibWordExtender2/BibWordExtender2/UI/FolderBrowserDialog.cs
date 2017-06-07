using System;
using System.IO;
using System.Windows.Forms;
using System.Collections.Generic;

namespace BibWord.Extender.UI
{
  /// <summary>
  /// An alternative to the FolderBrowserDialog in System.Windows.Forms.
  /// </summary>
  /// <remarks>
  /// This alternative allows for easier navigation in other operating system
  /// than Windows.
  /// </remarks>
  public partial class FolderBrowserDialog : Form
  {
    #region Fields

    /// <summary>
    /// Path which was selected.
    /// </summary>
    private string selectedPath;

    #endregion Fields

    #region Constructors

    /// <summary>
    /// Initializes a new instance of a FolderBrowserDialog object.
    /// </summary>
    public FolderBrowserDialog()
      : this(String.Empty, String.Empty)
    {
    }

    /// <summary>
    /// Initializes a new instance of a FolderBrowserDialog object.
    /// </summary>
    /// <param name="description">
    /// Sets the descriptive text displayed above the tree view control
    /// in the dialog box.
    /// </param>
    public FolderBrowserDialog(string description)
      : this(description, String.Empty)
    {
    }

    /// <summary>
    /// Initializes a new instance of a FolderBrowserDialog object.
    /// </summary>
    /// <param name="description">
    /// Sets the descriptive text displayed above the tree view control
    /// in the dialog box.
    /// </param>
    /// <param name="path">
    /// Sets the path selected by the user.
    /// </param>
    public FolderBrowserDialog(string description, string path)
    {
      InitializeComponent();

      // Assign parameters.
      this.lblDescription.Text = description;
      this.selectedPath = path;
    }

    #endregion Constructors

    #region Properties

    /// <summary>
    /// Sets the caption for the dialog.
    /// </summary>
    public string Caption
    {
      get { return this.Text; }
      set { this.Text = value; }
    }

    /// <summary>
    /// Gets or sets the descriptive text displayed above the tree 
    /// view control in the dialog box.
    /// </summary>
    public string Description
    {
      get { return this.lblDescription.Text; }
      set { this.lblDescription.Text = value; }
    }

    /// <summary>
    /// Gets or sets the path selected by the user.
    /// </summary>
    public string SelectedPath
    {
      get { return this.selectedPath; }
      set { this.selectedPath = value; }
    }

    #endregion Properties

    #region Methods

    /// <summary>
    /// Populates the tree view control with the selected path.
    /// </summary>
    private void PopulateTreeview()
    {
      PopulateTreeview(this.selectedPath);
    }

    /// <summary>
    /// Populates the tree view control based on a given folder.
    /// </summary>
    /// <param name="folder">Path to the folder.</param>
    private void PopulateTreeview(string folder)
    {
      // Make sure the tree view control is empty.
      this.tvFolders.Nodes.Clear();

      // Add the root drives.
      foreach (DriveInfo driveinfo in DriveInfo.GetDrives())
      {
        try
        {
          TreeNode node = this.tvFolders.Nodes.Add(driveinfo.Name, driveinfo.Name, 1);
          node.Tag = driveinfo.RootDirectory.FullName;
        }
        catch (Exception)
        {
          // Catches all exceptions. Exceptions mean the drive can not
          // be accessed, but that is not important to us.
        }
      }

      // Add the first level children. Note that this code could be optimized
      // by putting it in the previous loop.
      foreach (TreeNode node in this.tvFolders.Nodes)
      {
        DirectoryInfo parent = new DirectoryInfo((string)node.Tag);

        try
        {
          foreach (DirectoryInfo di in parent.GetDirectories())
          {
            TreeNode child = node.Nodes.Add(di.Name, di.Name);
            child.Tag = di.FullName;
          }
        }
        catch
        {
          // Catches all exceptions. Exceptions mean the directory can not
          // be accessed, but that is not important to us.
        }
      }

      // Only do something if the requested folder exists.
      if (Directory.Exists(folder) == true)
      {
        // Create a stack with the full path in.
        //    For example C:\Users\Max\Desktop would become:
        //       C:\\
        //       Users
        //       Max
        //       Desktop
        Stack<string> folders = new Stack<string>();

        DirectoryInfo di = new DirectoryInfo(folder);
        folders.Push(di.Name);

        while (di.Parent != null)
        {
          di = di.Parent;
          folders.Push(di.Name);
        }

        // Pop the elements from the stack one by one.
        TreeNode node = tvFolders.Nodes[folders.Pop()];
        AddLevel(node);
        while (folders.Count > 1)
        {
          node = node.Nodes[folders.Pop()];
          node.Expand();
        }
        // Select the node and expand the treeview.
        node.TreeView.SelectedNode = node.Nodes[folders.Pop()];
        node.TreeView.Select();
      }
      else
      {
        // Select the root.
        this.tvFolders.SelectedNode = this.tvFolders.Nodes[0];
        this.tvFolders.Select();
      }
    }

    /// <summary>
    /// Add the children of the child directories to a given node.
    /// </summary>
    /// <param name="node">
    /// Node to add the children of the child directories to.
    /// </param>
    /// <remarks>
    /// This allows for lazy querying as only visited directories will be loaded.
    /// </remarks>
    private static void AddLevel(TreeNode node)
    {
      // Handle all the child nodes of the current node one by one.
      foreach (TreeNode child in node.Nodes)
      {
        DirectoryInfo parent = new DirectoryInfo((string)child.Tag);

        try
        {
          foreach (DirectoryInfo di in parent.GetDirectories())
          {
            TreeNode grandchild = child.Nodes.Add(di.Name, di.Name);
            grandchild.Tag = di.FullName;
          }
        }
        catch
        {
          // Catches all exceptions. Exceptions mean the directory can not
          // be accessed, but that is not important to us.
        }
      }
    }

    /// <summary>
    /// Remove the children of collapsed child directories.
    /// </summary>
    /// <param name="node">
    /// Node to remove the children of the children from.
    /// </param>
    /// <remarks>
    /// This is merely a memory preservation trick.
    /// </remarks>
    private static void RemoveLevel(TreeNode node)
    {
      // Handle all the child nodes of the current node one by one.
      foreach (TreeNode child in node.Nodes)
      {
        child.Nodes.Clear();
      }
    }

    /// <summary>
    /// Overrides the ShowDialog function to load the selected path first.
    /// </summary>
    /// <returns>The result of the dialog.</returns>
    public new DialogResult ShowDialog()
    {
      // Show the form as a dialog.
      return base.ShowDialog();
    }

    /// <summary>
    /// Overrides the Show function to load the selected path first.
    /// </summary>
    public new void Show()
    {
      // Show the form.
      base.Show();
    }

    #endregion Methods

    #region Events

    /// <summary>
    /// Event ensuring that the treeview gets populated.
    /// </summary>
    private void FolderBrowserDialog_Load(object sender, EventArgs e)
    {
      // Populate the tree view.
      PopulateTreeview();
    }

    /// <summary>
    /// Handle the collapsing of a node.
    /// </summary>
    private void tvFolders_AfterCollapse(object sender, TreeViewEventArgs e)
    {
      // This is used to ensure that subitems are collapsed as well.
      e.Node.Collapse(false);
      RemoveLevel(e.Node);
    }

    /// <summary>
    /// Handle the expansion of a node.
    /// </summary>
    private void tvFolders_BeforeExpand(object sender, TreeViewCancelEventArgs e)
    {
      AddLevel(e.Node);
    }

    /// <summary>
    /// Handle the clicking of the cancel button.
    /// </summary>
    private void btnCancel_Click(object sender, EventArgs e)
    {
      this.DialogResult = DialogResult.Cancel;
      this.Close();
    }

    /// <summary>
    /// Handle the clicking of the ok button.
    /// </summary>
    private void btnOk_Click(object sender, EventArgs e)
    {
      this.DialogResult = DialogResult.OK;
      this.selectedPath = (string)this.tvFolders.SelectedNode.Tag;
      this.Close();
    }

    #endregion Events
  }
}