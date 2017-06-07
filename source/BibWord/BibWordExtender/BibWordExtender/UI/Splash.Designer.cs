namespace BibWordExtender.UI
{
  partial class Splash
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
      this.lblStatus = new System.Windows.Forms.Label();
      this.lblTitle = new System.Windows.Forms.Label();
      this.lblCreatedBy = new System.Windows.Forms.Label();
      this.lblCreatedByTag = new System.Windows.Forms.Label();
      this.lnkTarget = new System.Windows.Forms.LinkLabel();
      this.lblHomepageTag = new System.Windows.Forms.Label();
      this.lblVersion = new System.Windows.Forms.Label();
      this.lblVersionTag = new System.Windows.Forms.Label();
      this.SuspendLayout();
      // 
      // lblStatus
      // 
      this.lblStatus.AutoSize = true;
      this.lblStatus.Location = new System.Drawing.Point(12, 128);
      this.lblStatus.Name = "lblStatus";
      this.lblStatus.Size = new System.Drawing.Size(0, 13);
      this.lblStatus.TabIndex = 0;
      // 
      // lblTitle
      // 
      this.lblTitle.AutoSize = true;
      this.lblTitle.Font = new System.Drawing.Font("Microsoft Sans Serif", 36F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
      this.lblTitle.ForeColor = System.Drawing.Color.OliveDrab;
      this.lblTitle.Location = new System.Drawing.Point(-2, 0);
      this.lblTitle.Name = "lblTitle";
      this.lblTitle.Size = new System.Drawing.Size(414, 55);
      this.lblTitle.TabIndex = 1;
      this.lblTitle.Text = "BibWord Extender";
      this.lblTitle.Click += new System.EventHandler(this.Splash_Click);
      // 
      // lblCreatedBy
      // 
      this.lblCreatedBy.AutoSize = true;
      this.lblCreatedBy.Location = new System.Drawing.Point(79, 55);
      this.lblCreatedBy.Name = "lblCreatedBy";
      this.lblCreatedBy.Size = new System.Drawing.Size(69, 13);
      this.lblCreatedBy.TabIndex = 8;
      this.lblCreatedBy.Text = "Yves Dhondt";
      this.lblCreatedBy.Click += new System.EventHandler(this.Splash_Click);
      // 
      // lblCreatedByTag
      // 
      this.lblCreatedByTag.AutoSize = true;
      this.lblCreatedByTag.Location = new System.Drawing.Point(12, 55);
      this.lblCreatedByTag.Name = "lblCreatedByTag";
      this.lblCreatedByTag.Size = new System.Drawing.Size(61, 13);
      this.lblCreatedByTag.TabIndex = 7;
      this.lblCreatedByTag.Text = "Created by:";
      this.lblCreatedByTag.Click += new System.EventHandler(this.Splash_Click);
      // 
      // lnkTarget
      // 
      this.lnkTarget.AutoSize = true;
      this.lnkTarget.Location = new System.Drawing.Point(79, 104);
      this.lnkTarget.Name = "lnkTarget";
      this.lnkTarget.Size = new System.Drawing.Size(205, 13);
      this.lnkTarget.TabIndex = 6;
      this.lnkTarget.TabStop = true;
      this.lnkTarget.Text = "http://www.codeproject.com/bibliography";
      this.lnkTarget.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lnkTarget_LinkClicked);
      // 
      // lblHomepageTag
      // 
      this.lblHomepageTag.AutoSize = true;
      this.lblHomepageTag.Location = new System.Drawing.Point(12, 104);
      this.lblHomepageTag.Name = "lblHomepageTag";
      this.lblHomepageTag.Size = new System.Drawing.Size(62, 13);
      this.lblHomepageTag.TabIndex = 5;
      this.lblHomepageTag.Text = "Homepage:";
      this.lblHomepageTag.Click += new System.EventHandler(this.Splash_Click);
      // 
      // lblVersion
      // 
      this.lblVersion.AutoSize = true;
      this.lblVersion.Location = new System.Drawing.Point(79, 79);
      this.lblVersion.Name = "lblVersion";
      this.lblVersion.Size = new System.Drawing.Size(22, 13);
      this.lblVersion.TabIndex = 10;
      this.lblVersion.Text = "1.0";
      this.lblVersion.Click += new System.EventHandler(this.Splash_Click);
      // 
      // lblVersionTag
      // 
      this.lblVersionTag.AutoSize = true;
      this.lblVersionTag.Location = new System.Drawing.Point(12, 79);
      this.lblVersionTag.Name = "lblVersionTag";
      this.lblVersionTag.Size = new System.Drawing.Size(45, 13);
      this.lblVersionTag.TabIndex = 9;
      this.lblVersionTag.Text = "Version:";
      this.lblVersionTag.Click += new System.EventHandler(this.Splash_Click);
      // 
      // Splash
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.BackColor = System.Drawing.Color.White;
      this.ClientSize = new System.Drawing.Size(410, 150);
      this.ControlBox = false;
      this.Controls.Add(this.lblVersion);
      this.Controls.Add(this.lblVersionTag);
      this.Controls.Add(this.lblCreatedBy);
      this.Controls.Add(this.lblCreatedByTag);
      this.Controls.Add(this.lnkTarget);
      this.Controls.Add(this.lblHomepageTag);
      this.Controls.Add(this.lblTitle);
      this.Controls.Add(this.lblStatus);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
      this.MaximizeBox = false;
      this.MinimizeBox = false;
      this.Name = "Splash";
      this.ShowIcon = false;
      this.ShowInTaskbar = false;
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
      this.Click += new System.EventHandler(this.Splash_Click);
      this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Splash_FormClosing);
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.Label lblStatus;
    private System.Windows.Forms.Label lblTitle;
    private System.Windows.Forms.Label lblCreatedBy;
    private System.Windows.Forms.Label lblCreatedByTag;
    private System.Windows.Forms.LinkLabel lnkTarget;
    private System.Windows.Forms.Label lblHomepageTag;
    private System.Windows.Forms.Label lblVersion;
    private System.Windows.Forms.Label lblVersionTag;
  }
}