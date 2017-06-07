namespace BibWord.Extender.UI
{
  partial class FolderBrowserDialog
  {
    /// <summary>
    /// Required designer variable.
    /// </summary>
    private System.ComponentModel.IContainer components = null;

    /// <summary>
    /// Clean up any resources being used.
    /// </summary>
    /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
    protected override void Dispose(bool disposing)
    {
      if (disposing && (components != null))
      {
        components.Dispose();
      }
      base.Dispose(disposing);
    }

    #region Windows Form Designer generated code

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
      this.btnOk = new System.Windows.Forms.Button();
      this.btnCancel = new System.Windows.Forms.Button();
      this.tvFolders = new System.Windows.Forms.TreeView();
      this.lblDescription = new System.Windows.Forms.Label();
      this.SuspendLayout();
      // 
      // btnOk
      // 
      this.btnOk.DialogResult = System.Windows.Forms.DialogResult.OK;
      this.btnOk.Location = new System.Drawing.Point(129, 371);
      this.btnOk.Name = "btnOk";
      this.btnOk.Size = new System.Drawing.Size(63, 23);
      this.btnOk.TabIndex = 0;
      this.btnOk.Text = "&Ok";
      this.btnOk.UseVisualStyleBackColor = true;
      this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
      // 
      // btnCancel
      // 
      this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
      this.btnCancel.Location = new System.Drawing.Point(198, 371);
      this.btnCancel.Name = "btnCancel";
      this.btnCancel.Size = new System.Drawing.Size(63, 23);
      this.btnCancel.TabIndex = 1;
      this.btnCancel.Text = "&Cancel";
      this.btnCancel.UseVisualStyleBackColor = true;
      this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
      // 
      // tvFolders
      // 
      this.tvFolders.Location = new System.Drawing.Point(0, 65);
      this.tvFolders.Name = "tvFolders";
      this.tvFolders.Size = new System.Drawing.Size(273, 300);
      this.tvFolders.TabIndex = 2;
      this.tvFolders.AfterCollapse += new System.Windows.Forms.TreeViewEventHandler(this.tvFolders_AfterCollapse);
      this.tvFolders.BeforeExpand += new System.Windows.Forms.TreeViewCancelEventHandler(this.tvFolders_BeforeExpand);
      // 
      // lblDescription
      // 
      this.lblDescription.Location = new System.Drawing.Point(0, 2);
      this.lblDescription.Margin = new System.Windows.Forms.Padding(3);
      this.lblDescription.Name = "lblDescription";
      this.lblDescription.Size = new System.Drawing.Size(273, 63);
      this.lblDescription.TabIndex = 3;
      this.lblDescription.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
      // 
      // FolderBrowserDialog
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(273, 397);
      this.Controls.Add(this.lblDescription);
      this.Controls.Add(this.tvFolders);
      this.Controls.Add(this.btnCancel);
      this.Controls.Add(this.btnOk);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
      this.MaximizeBox = false;
      this.MinimizeBox = false;
      this.Name = "FolderBrowserDialog";
      this.ShowIcon = false;
      this.ShowInTaskbar = false;
      this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
      this.Text = "Browse for Folder";
      this.Load += new System.EventHandler(this.FolderBrowserDialog_Load);
      this.ResumeLayout(false);

    }

    #endregion

    private System.Windows.Forms.Button btnOk;
    private System.Windows.Forms.Button btnCancel;
    private System.Windows.Forms.TreeView tvFolders;
    private System.Windows.Forms.Label lblDescription;
  }
}