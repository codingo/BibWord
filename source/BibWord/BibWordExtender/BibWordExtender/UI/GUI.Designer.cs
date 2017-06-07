namespace BibWordExtender.UI
{
  partial class GUI
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
      this.cmdWordDocSelection = new System.Windows.Forms.Button();
      this.cmdExit = new System.Windows.Forms.Button();
      this.cmdInfo = new System.Windows.Forms.Button();
      this.cmdExtend = new System.Windows.Forms.Button();
      this.cmbStyles = new System.Windows.Forms.ComboBox();
      this.txtWordDoc = new System.Windows.Forms.TextBox();
      this.label1 = new System.Windows.Forms.Label();
      this.lblWordDoc = new System.Windows.Forms.Label();
      this.cmdReload = new System.Windows.Forms.Button();
      this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
      this.cmdClean = new System.Windows.Forms.Button();
      this.toolTip = new System.Windows.Forms.ToolTip(this.components);
      this.SuspendLayout();
      // 
      // cmdWordDocSelection
      // 
      this.cmdWordDocSelection.Location = new System.Drawing.Point(474, 10);
      this.cmdWordDocSelection.Name = "cmdWordDocSelection";
      this.cmdWordDocSelection.Size = new System.Drawing.Size(31, 23);
      this.cmdWordDocSelection.TabIndex = 15;
      this.cmdWordDocSelection.Text = "...";
      this.cmdWordDocSelection.UseVisualStyleBackColor = true;
      this.cmdWordDocSelection.Click += new System.EventHandler(this.cmdWordDocSelection_Click);
      // 
      // cmdExit
      // 
      this.cmdExit.Location = new System.Drawing.Point(418, 76);
      this.cmdExit.Name = "cmdExit";
      this.cmdExit.Size = new System.Drawing.Size(88, 23);
      this.cmdExit.TabIndex = 14;
      this.cmdExit.Text = "E&xit";
      this.cmdExit.UseVisualStyleBackColor = true;
      this.cmdExit.Click += new System.EventHandler(this.cmdExit_Click);
      // 
      // cmdInfo
      // 
      this.cmdInfo.Location = new System.Drawing.Point(316, 76);
      this.cmdInfo.Name = "cmdInfo";
      this.cmdInfo.Size = new System.Drawing.Size(88, 23);
      this.cmdInfo.TabIndex = 13;
      this.cmdInfo.Text = "&Info";
      this.cmdInfo.UseVisualStyleBackColor = true;
      this.cmdInfo.Click += new System.EventHandler(this.cmdInfo_Click);
      // 
      // cmdExtend
      // 
      this.cmdExtend.Location = new System.Drawing.Point(10, 76);
      this.cmdExtend.Name = "cmdExtend";
      this.cmdExtend.Size = new System.Drawing.Size(88, 23);
      this.cmdExtend.TabIndex = 12;
      this.cmdExtend.Text = "&Extend";
      this.cmdExtend.UseVisualStyleBackColor = true;
      this.cmdExtend.Click += new System.EventHandler(this.cmdExtend_Click);
      // 
      // cmbStyles
      // 
      this.cmbStyles.FormattingEnabled = true;
      this.cmbStyles.Location = new System.Drawing.Point(97, 44);
      this.cmbStyles.Name = "cmbStyles";
      this.cmbStyles.Size = new System.Drawing.Size(408, 21);
      this.cmbStyles.TabIndex = 11;
      // 
      // txtWordDoc
      // 
      this.txtWordDoc.Location = new System.Drawing.Point(97, 12);
      this.txtWordDoc.Name = "txtWordDoc";
      this.txtWordDoc.Size = new System.Drawing.Size(376, 20);
      this.txtWordDoc.TabIndex = 10;
      // 
      // label1
      // 
      this.label1.AutoSize = true;
      this.label1.Location = new System.Drawing.Point(7, 44);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(91, 13);
      this.label1.TabIndex = 9;
      this.label1.Text = "Bibliography style:";
      // 
      // lblWordDoc
      // 
      this.lblWordDoc.AutoSize = true;
      this.lblWordDoc.Location = new System.Drawing.Point(7, 12);
      this.lblWordDoc.Name = "lblWordDoc";
      this.lblWordDoc.Size = new System.Drawing.Size(88, 13);
      this.lblWordDoc.TabIndex = 8;
      this.lblWordDoc.Text = "Word Document:";
      // 
      // cmdReload
      // 
      this.cmdReload.Location = new System.Drawing.Point(214, 76);
      this.cmdReload.Name = "cmdReload";
      this.cmdReload.Size = new System.Drawing.Size(88, 23);
      this.cmdReload.TabIndex = 16;
      this.cmdReload.Text = "&Reload Styles";
      this.cmdReload.UseVisualStyleBackColor = true;
      this.cmdReload.Click += new System.EventHandler(this.cmdReload_Click);
      // 
      // openFileDialog
      // 
      this.openFileDialog.Filter = "docx files|*.docx|All files|*.*";
      // 
      // cmdClean
      // 
      this.cmdClean.Location = new System.Drawing.Point(112, 76);
      this.cmdClean.Name = "cmdClean";
      this.cmdClean.Size = new System.Drawing.Size(88, 23);
      this.cmdClean.TabIndex = 17;
      this.cmdClean.Text = "&Clean";
      this.cmdClean.UseVisualStyleBackColor = true;
      this.cmdClean.Click += new System.EventHandler(this.cmdClean_Click);
      // 
      // GUI
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(513, 113);
      this.Controls.Add(this.cmdClean);
      this.Controls.Add(this.cmdReload);
      this.Controls.Add(this.cmdWordDocSelection);
      this.Controls.Add(this.cmdExit);
      this.Controls.Add(this.cmdInfo);
      this.Controls.Add(this.cmdExtend);
      this.Controls.Add(this.cmbStyles);
      this.Controls.Add(this.txtWordDoc);
      this.Controls.Add(this.label1);
      this.Controls.Add(this.lblWordDoc);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
      this.MaximizeBox = false;
      this.Name = "GUI";
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
      this.Text = "BibWord Extender";
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.Button cmdWordDocSelection;
    private System.Windows.Forms.Button cmdExit;
    private System.Windows.Forms.Button cmdInfo;
    private System.Windows.Forms.Button cmdExtend;
    private System.Windows.Forms.ComboBox cmbStyles;
    private System.Windows.Forms.TextBox txtWordDoc;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.Label lblWordDoc;
    private System.Windows.Forms.Button cmdReload;
    private System.Windows.Forms.OpenFileDialog openFileDialog;
    private System.Windows.Forms.Button cmdClean;
    private System.Windows.Forms.ToolTip toolTip;
  }
}

