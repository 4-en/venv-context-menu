# venv-context-menu

`venv-context-menu` is a PowerShell script that adds a context menu option to Windows Explorer, enabling users to quickly activate a Python virtual environment (`venv`) from the right-click menu.

## Features

- Adds a "Activate VEnv" option to the right-click context menu for directories.
- Automatically runs the associated virtual environment's activation script.
- Ensures the script is run with administrative privileges.

## Prerequisites

- Windows operating system
- PowerShell
- Administrator privileges

## Installation

1. Clone or download this repository to your local machine.
2. Place the following files in the same directory:
   - `add_to_context_menu.ps1` (main script for adding the context menu entry)
   - `activate_venv.ps1` (script for activating the virtual environment)
   - `venv_folder_python.ico` (icon for the context menu entry)
3. Open PowerShell as an administrator.
4. Run the `add_to_context_menu.ps1` script:

   ```powershell
   .\add_to_context_menu.ps1
   ```

5. You should see a success message: `Context menu option 'Activate VEnv' added successfully!`

## Usage

1. Right-click on any folder in Windows Explorer.
2. Select the "Activate VEnv" option from the context menu.
3. The script will:
   - Check if the folder contains a `.venv` directory.
   - Activate the virtual environment in a new PowerShell window.

## How It Works

1. **Administrator Check:** Ensures the script is run with elevated privileges to modify the Windows Registry.
2. **File Setup:** Copies required files (`activate_venv.ps1` and `venv_folder_python.ico`) to the `%APPDATA%\.activate_venv_menu` directory.
3. **Registry Modification:** Adds entries to the Windows Registry to define the context menu option and its associated commands.
4. **Activation Script:** Executes the activation script for the specified virtual environment in a new PowerShell session.

## Customization

You can customize the following variables in `add_to_context_menu.ps1` to suit your needs:

- `$contextMenuName`: The name of the context menu option (default: `Activate VEnv`).
- `$iconName`: The icon file used for the context menu option.

## Notes

- The script expects the virtual environment activation script to be located at `.venv\Scripts\Activate.ps1` within the selected folder.
- The feature requires administrative privileges to modify the Windows Registry.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to open issues or submit pull requests to improve the functionality of `venv-context-menu`!

---

Happy coding! 🎉
