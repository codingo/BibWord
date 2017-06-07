namespace BibWord.Extender.UI
{
  partial class MainForm
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
      this.components = new System.ComponentModel.Container();
      System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
      this.btnClean = new System.Windows.Forms.Button();
      this.btnReload = new System.Windows.Forms.Button();
      this.btnWordDocSelection = new System.Windows.Forms.Button();
      this.btnExit = new System.Windows.Forms.Button();
      this.cmbStyles = new System.Windows.Forms.ComboBox();
      this.toolTip = new System.Windows.Forms.ToolTip(this.components);
      this.btnInfo = new System.Windows.Forms.Button();
      this.btnExtend = new System.Windows.Forms.Button();
      this.txtWordDoc = new System.Windows.Forms.TextBox();
      this.label1 = new System.Windows.Forms.Label();
      this.lblWordDoc = new System.Windows.Forms.Label();
      this.chkBackup = new System.Windows.Forms.CheckBox();
      this.SuspendLayout();
      // 
      // btnClean
      // 
      this.btnClean.Location = new System.Drawing.Point(107, 93);
      this.btnClean.Name = "btnClean";
      this.btnClean.Size = new System.Drawing.Size(88, 23);
      this.btnClean.TabIndex = 5;
      this.btnClean.Text = "&Clean";
      this.toolTip.SetToolTip(this.btnClean, "Remove all BibWord extensions from the bibliographic sources.");
      this.btnClean.UseVisualStyleBackColor = true;
      this.btnClean.Click += new System.EventHandler(this.btnClean_Click);
      // 
      // btnReload
      // 
      this.btnReload.Location = new System.Drawing.Point(209, 93);
      this.btnReload.Name = "btnReload";
      this.btnReload.Size = new System.Drawing.Size(88, 23);
      this.btnReload.TabIndex = 6;
      this.btnReload.Text = "&Reload Styles";
      this.toolTip.SetToolTip(this.btnReload, "Reload all style information.");
      this.btnReload.UseVisualStyleBackColor = true;
      this.btnReload.Click += new System.EventHandler(this.btnReload_Click);
      // 
      // btnWordDocSelection
      // 
      this.btnWordDocSelection.Location = new System.Drawing.Point(469, 7);
      this.btnWordDocSelection.Name = "btnWordDocSelection";
      this.btnWordDocSelection.Size = new System.Drawing.Size(31, 23);
      this.btnWordDocSelection.TabIndex = 2;
      this.btnWordDocSelection.Text = "...";
      this.toolTip.SetToolTip(this.btnWordDocSelection, "Select a Word document.");
      this.btnWordDocSelection.UseVisualStyleBackColor = true;
      this.btnWordDocSelection.Click += new System.EventHandler(this.btnWordDocSelection_Click);
      // 
      // btnExit
      // 
      this.btnExit.Location = new System.Drawing.Point(413, 93);
      this.btnExit.Name = "btnExit";
      this.btnExit.Size = new System.Drawing.Size(88, 23);
      this.btnExit.TabIndex = 8;
      this.btnExit.Text = "E&xit";
      this.toolTip.SetToolTip(this.btnExit, "Exit the application.");
      this.btnExit.UseVisualStyleBackColor = true;
      this.btnExit.Click += new System.EventHandler(this.btnExit_Click);
      // 
      // cmbStyles
      // 
      this.cmbStyles.FormattingEnabled = true;
      this.cmbStyles.Location = new System.Drawing.Point(92, 61);
      this.cmbStyles.Name = "cmbStyles";
      this.cmbStyles.Size = new System.Drawing.Size(408, 21);
      this.cmbStyles.TabIndex = 3;
      // 
      // btnInfo
      // 
      this.btnInfo.Location = new System.Drawing.Point(311, 93);
      this.btnInfo.Name = "btnInfo";
      this.btnInfo.Size = new System.Drawing.Size(88, 23);
      this.btnInfo.TabIndex = 7;
      this.btnInfo.Text = "&About";
      this.toolTip.SetToolTip(this.btnInfo, "Display information about the application.");
      this.btnInfo.UseVisualStyleBackColor = true;
      this.btnInfo.Click += new System.EventHandler(this.btnInfo_Click);
      // 
      // btnExtend
      // 
      this.btnExtend.Location = new System.Drawing.Point(5, 93);
      this.btnExtend.Name = "btnExtend";
      this.btnExtend.Size = new System.Drawing.Size(88, 23);
      this.btnExtend.TabIndex = 4;
      this.btnExtend.Text = "&Extend";
      this.toolTip.SetToolTip(this.btnExtend, "Extend the bibliographic sources.");
      this.btnExtend.UseVisualStyleBackColor = true;
      this.btnExtend.Click += new System.EventHandler(this.btnExtend_Click);
      // 
      // txtWordDoc
      // 
      this.txtWordDoc.Location = new System.Drawing.Point(92, 9);
      this.txtWordDoc.Name = "txtWordDoc";
      this.txtWordDoc.Size = new System.Drawing.Size(376, 20);
      this.txtWordDoc.TabIndex = 1;
      // 
      // label1
      // 
      this.label1.AutoSize = true;
      this.label1.Location = new System.Drawing.Point(2, 61);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(91, 13);
      this.label1.TabIndex = 19;
      this.label1.Text = "Bibliography style:";
      // 
      // lblWordDoc
      // 
      this.lblWordDoc.AutoSize = true;
      this.lblWordDoc.Location = new System.Drawing.Point(2, 9);
      this.lblWordDoc.Name = "lblWordDoc";
      this.lblWordDoc.Size = new System.Drawing.Size(88, 13);
      this.lblWordDoc.TabIndex = 18;
      this.lblWordDoc.Text = "Word Document:";
      // 
      // chkBackup
      // 
      this.chkBackup.AutoSize = true;
      this.chkBackup.Checked = true;
      this.chkBackup.CheckState = System.Windows.Forms.CheckState.Checked;
      this.chkBackup.Location = new System.Drawing.Point(92, 35);
      this.chkBackup.Name = "chkBackup";
      this.chkBackup.Size = new System.Drawing.Size(96, 17);
      this.chkBackup.TabIndex = 20;
      this.chkBackup.Text = "Create &backup";
      this.toolTip.SetToolTip(this.chkBackup, "As there always is a small chance of something going wrong, taking a backup is a " +
              "good idea.");
      this.chkBackup.UseVisualStyleBackColor = true;
      // 
      // MainForm
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(506, 130);
      this.Controls.Add(this.chkBackup);
      this.Controls.Add(this.btnClean);
      this.Controls.Add(this.btnReload);
      this.Controls.Add(this.btnWordDocSelection);
      this.Controls.Add(this.btnExit);
      this.Controls.Add(this.cmbStyles);
      this.Controls.Add(this.btnInfo);
      this.Controls.Add(this.btnExtend);
      this.Controls.Add(this.txtWordDoc);
      this.Controls.Add(this.label1);
      this.Controls.Add(this.lblWordDoc);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
      this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
      this.MaximizeBox = false;
      this.Name = "MainForm";
      this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
      this.Text = "Extender";
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.Button btnClean;
    private System.Windows.Forms.Button btnReload;
    private System.Windows.Forms.Button btnWordDocSelection;
    private System.Windows.Forms.Button btnExit;
    private System.Windows.Forms.ComboBox cmbStyles;
    private System.Windows.Forms.ToolTip toolTip;
    private System.Windows.Forms.Button btnInfo;
    private System.Windows.Forms.Button btnExtend;
    private System.Windows.Forms.TextBox txtWordDoc;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.Label lblWordDoc;
    private System.Windows.Forms.CheckBox chkBackup;
  }
}