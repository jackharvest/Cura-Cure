![Cura Cure](RawImages/CuraCureBanner.png "Cura Cure Banner")

# Cura-Cure
- Cura-Cure removes the "Machine Disallowed Areas" Restriction from All Printer Profiles in Cura. Especially helpful in instances where your bed size has changed from the original printer size, such as the use of an Ender Extender, or similar.

# Usage
- You'll need to run this powershell script as admin. 

- To do so, follow these instructions:

1. Right-click on the Windows Start menu and select "Windows PowerShell (Admin)" (or Windows Terminal (Admin)).
2. In the PowerShell window, navigate to the directory where your .ps1 file is located by using the `cd` command followed by the path to the directory. For example, if your .ps1 file is located in `C:\Users\YourName\Documents`, you would type `cd C:\Users\YourName\Documents` and press Enter.
3. Type `.\your_script_name.ps1` and press Enter to run the script.

4. If this is the first time you are running a script, you may see a warning message about the execution policy. If you trust the source of the script and want to allow it to run, you can temporarily change the execution policy by typing `Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process` and pressing Enter.

# Notes
- As of Cura 5.3.0, the Ultimaker team has once again moved the json files that this script modifies.
- They are located in C:\Program Files\UltiMaker Cura 5.X.0\share\cura\resources\definitions

They've been in appdata and other locations in the past. Taking bets on where they move it to next.

# Version
1.0.0 - 4/5/2023 - Initial Release
