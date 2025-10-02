# **Counterwatch Backup & Restore Tool**

A simple and easy-to-use PowerShell script for Windows that helps you back up and restore your data for the [Counterwatch](https://counterwatch.gg) Overwolf addon.

This tool is perfect for users who want to save their addon settings and data before reformatting a computer, moving to a new PC, or just want a safe backup.

---

## **Features**

* **Simple Menu:** An easy-to-navigate menu lets you choose to back up, restore, or exit.
* **Automatic Process Handling:** The script automatically detects if Overwolf is running and closes it to prevent file corruption during the backup/restore process.
* **Dated Backups:** Backup files are automatically named with the current date and time (e.g., `Counterwatch_Backup_2023-10-27_15-30-00.zip`) and saved directly to your Desktop for easy access.
* **Safe Restore:** The script safely removes the old data folder before restoring your backup to ensure a clean transfer.

---

## **How to Use**

### **1. Download the Script**

* Download the script from [here](https://github.com/LunRos/cwbackuptool/releases/download/Main/cwbackuptool.ps1) or the [releases](https://github.com/LunRos/cwbackuptool/releases/tag/Main).
  
**OR**
  
* Click on the `overwolf_backup.ps1` file in this GitHub repository.
* Click the "Download raw file" button (or "Raw" then right-click and "Save as...").
* Save the file somewhere you can easily find it, like your Desktop.

### **2. Run the Script**

* Right-click on the `overwolf_backup.ps1` file.
* Select **"Run with PowerShell"** from the context menu.

> **First-Time User? Getting an Error?**
> If you see a red error message mentioning "script execution", your system is blocking the script for security reasons. To fix this, you only need to do this once:
>
> 1.  Click the Start Menu and type `PowerShell`.
> 2.  Right-click on "Windows PowerShell" and select **"Run as administrator"**.
> 3.  In the blue window that appears, copy and paste the following command, then press Enter:
>     ```powershell
>     Set-ExecutionPolicy RemoteSigned
>     ```
> 4.  It will ask for confirmation. Type `Y` and press Enter.
> 5.  You can now close the administrator PowerShell window and run the script normally by right-clicking it.

### **3. Using the Menu**

Once the script is running, you will see a simple menu:

* **To create a backup:**
    1.  Type `1` and press Enter.
    2.  The script will close Overwolf, find your Counterwatch data, and compress it into a `.zip` file on your Desktop.
* **To restore from a backup:**
    1.  Type `2` and press Enter.
    2.  The script will ask for the path to your backup `.zip` file. The easiest way to do this is to **drag and drop the `.zip` file directly into the PowerShell window** and then press Enter.
    3.  The script will close Overwolf, delete the current data, and restore your backup.

---

## **Important: Restoring Data After a Fresh Install**

If you have reformatted your PC or are moving to a new one, you must follow these steps in order **exactly** to ensure the restore works correctly.

1.  **Install Overwolf and the Counterwatch addon** as you normally would.
2.  **Run Overwolf and Counterwatch at least once.** This is critical because it creates the necessary folders that the script needs to find.
3.  **Completely exit Overwolf.** You can do this by right-clicking its icon in the system tray (bottom-right of your screen) and selecting "Quit".
4.  **Run the `overwolf_backup.ps1` script** and choose the **Restore** option.
5.  Once the restore is complete, you can start Overwolf again, and your data should be back.

---

## **Disclaimer**

This script is provided as-is. It is not officially affiliated with Overwolf or the creators of the Counterwatch addon. Always be careful when managing application files, and use this tool at your own risk.
