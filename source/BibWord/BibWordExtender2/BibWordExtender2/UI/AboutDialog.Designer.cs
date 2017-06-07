namespace BibWord.Extender.UI
{
  partial class AboutDialog
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
      this.lblVersion = new System.Windows.Forms.Label();
      this.lblVersionTag = new System.Windows.Forms.Label();
      this.lblCreatedBy = new System.Windows.Forms.Label();
      this.lblCreatedByTag = new System.Windows.Forms.Label();
      this.lnkTarget = new System.Windows.Forms.LinkLabel();
      this.lblHomepageTag = new System.Windows.Forms.Label();
      this.btnOk = new System.Windows.Forms.Button();
      this.lblTitle = new System.Windows.Forms.Label();
      this.SuspendLayout();
      // 
      // lblVersion
      // 
      this.lblVersion.AutoSize = true;
      this.lblVersion.Location = new System.Drawing.Point(79, 100);
      this.lblVersion.Name = "lblVersion";
      this.lblVersion.Size = new System.Drawing.Size(22, 13);
      this.lblVersion.TabIndex = 0;
      this.lblVersion.Text = "2.0";
      // 
      // lblVersionTag
      // 
      this.lblVersionTag.AutoSize = true;
      this.lblVersionTag.Location = new System.Drawing.Point(12, 100);
      this.lblVersionTag.Name = "lblVersionTag";
      this.lblVersionTag.Size = new System.Drawing.Size(45, 13);
      this.lblVersionTag.TabIndex = 0;
      this.lblVersionTag.Text = "Version:";
      // 
      // lblCreatedBy
      // 
      this.lblCreatedBy.AutoSize = true;
      this.lblCreatedBy.Location = new System.Drawing.Point(79, 76);
      this.lblCreatedBy.Name = "lblCreatedBy";
      this.lblCreatedBy.Size = new System.Drawing.Size(69, 13);
      this.lblCreatedBy.TabIndex = 0;
      this.lblCreatedBy.Text = "Yves Dhondt";
      // 
      // lblCreatedByTag
      // 
      this.lblCreatedByTag.AutoSize = true;
      this.lblCreatedByTag.Location = new System.Drawing.Point(12, 76);
      this.lblCreatedByTag.Name = "lblCreatedByTag";
      this.lblCreatedByTag.Size = new System.Drawing.Size(61, 13);
      this.lblCreatedByTag.TabIndex = 0;
      this.lblCreatedByTag.Text = "Created by:";
      // 
      // lnkTarget
      // 
      this.lnkTarget.AutoSize = true;
      this.lnkTarget.Location = new System.Drawing.Point(79, 125);
      this.lnkTarget.Name = "lnkTarget";
      this.lnkTarget.Size = new System.Drawing.Size(205, 13);
      this.lnkTarget.TabIndex = 0;
      this.lnkTarget.TabStop = true;
      this.lnkTarget.Text = "http://www.codeproject.com/bibliography";
      this.lnkTarget.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkTarget_LinkClicked);
      // 
      // lblHomepageTag
      // 
      this.lblHomepageTag.AutoSize = true;
      this.lblHomepageTag.Location = new System.Drawing.Point(12, 125);
      this.lblHomepageTag.Name = "lblHomepageTag";
      this.lblHomepageTag.Size = new System.Drawing.Size(62, 13);
      this.lblHomepageTag.TabIndex = 0;
      this.lblHomepageTag.Text = "Homepage:";
      // 
      // btnOk
      // 
      this.btnOk.Location = new System.Drawing.Point(360, 119);
      this.btnOk.Name = "btnOk";
      this.btnOk.Size = new System.Drawing.Size(52, 25);
      this.btnOk.TabIndex = 1;
      this.btnOk.Text = "&Ok";
      this.btnOk.UseVisualStyleBackColor = true;
      this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
      // 
      // lblTitle
      // 
      this.lblTitle.AutoSize = true;
      this.lblTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.lblTitle.ForeColor = System.Drawing.Color.OliveDrab;
      this.lblTitle.Location = new System.Drawing.Point(5, 9);
      this.lblTitle.Name = "lblTitle";
      this.lblTitle.Size = new System.Drawing.Size(414, 55);
      this.lblTitle.TabIndex = 0;
      this.lblTitle.Text = "BibWord Extender";
      // 
      // AboutDialog
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.BackColor = System.Drawing.Color.White;
      this.ClientSize = new System.Drawing.Size(424, 151);
      this.Controls.Add(this.lblTitle);
      this.Controls.Add(this.btnOk);
      this.Controls.Add(this.lblVersion);
      this.Controls.Add(this.lblVersionTag);
      this.Controls.Add(this.lblCreatedBy);
      this.Controls.Add(this.lblCreatedByTag);
      this.Controls.Add(this.lnkTarget);
      this.Controls.Add(this.lblHomepageTag);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
      this.MaximizeBox = false;
      this.MinimizeBox = false;
      this.Name = "AboutDialog";
      this.ShowIcon = false;
      this.ShowInTaskbar = false;
      this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.Label lblVersion;
    private System.Windows.Forms.Label lblVersionTag;
    private System.Windows.Forms.Label lblCreatedBy;
    private System.Windows.Forms.Label lblCreatedByTag;
    private System.Windows.Forms.LinkLabel lnkTarget;
    private System.Windows.Forms.Label lblHomepageTag;
    private System.Windows.Forms.Button btnOk;
    private System.Windows.Forms.Label lblTitle;
  }
}