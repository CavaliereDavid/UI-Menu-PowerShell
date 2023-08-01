# Function to check if the current session has administrative privileges
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    return $isAdmin
}

# Function to relaunch the script with elevated permissions
function Restart-ScriptWithElevatedPermissions {
    # Launch a new elevated PowerShell session and pass the current script as an argument
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
}

# Export all functions for the module
Export-ModuleMember -Function * 