namespace BibWord.Extender.UI
{
  partial class ProgressDialog
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
      this.pbLoad = new System.Windows.Forms.ProgressBar();
      this.SuspendLayout();
      // 
      // lblStatus
      // 
      this.lblStatus.AutoSize = true;
      this.lblStatus.Location = new System.Drawing.Point(10, 39);
      this.lblStatus.Name = "lblStatus";
      this.lblStatus.Size = new System.Drawing.Size(57, 13);
      this.lblStatus.TabIndex = 0;
      this.lblStatus.Text = "Loading ...";
      // 
      // pbLoad
      // 
      this.pbLoad.Location = new System.Drawing.Point(13, 12);
      this.pbLoad.Maximum = 101;
      this.pbLoad.Name = "pbLoad";
      this.pbLoad.Size = new System.Drawing.Size(353, 13);
      this.pbLoad.Step = 5;
      this.pbLoad.TabIndex = 1;
      // 
      // ProgressDialog
      // 
      this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
      this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
      this.ClientSize = new System.Drawing.Size(378, 57);
      this.ControlBox = false;
      this.Controls.Add(this.pbLoad);
      this.Controls.Add(this.lblStatus);
      this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
      this.MaximizeBox = false;
      this.MinimizeBox = false;
      this.Name = "ProgressDialog";
      this.ShowIcon = false;
      this.ShowInTaskbar = false;
      this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
      this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
      this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.ProgressDialog_FormClosing);
      this.ResumeLayout(false);
      this.PerformLayout();

    }

    #endregion

    private System.Windows.Forms.Label lblStatus;
    private System.Windows.Forms.ProgressBar pbLoad;
  }
}