# For simplicity We haven't created a controller.ps1 and main.ps1 but instead decided to use this file as both.

# -Force : ensures that the latest version of the module is loaded into the session

Import-Module ".\Module\Utils\Permission.psm1" -Force
Import-Module ".\Module\Folder-Management\Folder-Utils.psm1" -Force
Import-Module ".\Module\File-Management\File-Utils.psm1" -Force




function Show-Menu {
    [CmdletBinding()]
    param (
    )

    Clear-Host
    Write-Host "Press 1 to create a new folder"
    Write-Host "Press 2 to create a new text file"
    Write-Host "Press 3 to copy a folder"
    Write-Host "Press 4 to copy a file"
    Write-Host "Press 5 to delete a folder"
    Write-Host "Press 6 to delete a file"
    Write-Host "Press 7 to move a folder"
    Write-Host "Press 8 to move a file"
    Write-Host "Press 9 to rename a folder"
    Write-Host "Press 10 to rename a file"
    Write-Host "Press 11 to compress a folder"
    Write-Host "Press 12 to extract a folder"
    Write-Host "Press Q to exit"

    do {
        $Choice = Read-Host "Make a choice: "

        # Binding parameters
        switch ($Choice) {
            "1" {
                $ParentPath = Read-Host "Enter the parent folder path: "
                $FolderName = Read-Host "Enter the new folder name: "
                New-Folder -ParentFolderPath $ParentPath -NewFolderName $FolderName
            }
            "2" {
                $FilePath = Read-Host "Enter the file path "
                $FileName = Read-Host "Enter the file name "
                $FileExtension = Read-Host "Enter the file extension (txt, xml, csv, html) "
                $Content = Read-Host "Enter the content of the file (optional) "
                New-File -FilePath $FilePath -FileName $FileName -FileExtension $FileExtension -Content $Content
                
            }
            "3" {
                $SourcePath = Read-Host "Enter the source folder path "
                $DestinationPath = Read-Host "Enter the destination path of the folder "
                Copy-Folder -SourceFolderPath $SourcePath -DestinationParentFolderPath $DestinationPath
            }
            "4" {
                $SourceFile = Read-Host "Enter the source file path with the file name and extension "
                $DestinationFile = Read-Host "Enter the destination file path "
                Copy-File -SourceFilePath $SourceFile -DestinationFilePath $DestinationFile
            }
            "5" {
                $FolderToDelete = Read-Host "Enter the folder path to delete "
                Remove-Folder -FolderPath $FolderToDelete
            }
            "6" {
                $FileToDelete = Read-Host "Enter the file path to delete with the file name and extension "
                Remove-File -FilePath $FileToDelete
            }
            "7" {
                $SourcePath = Read-Host "Enter the source folder path "
                $DestinationParentPath = Read-Host "Enter the destination path of the folder "
                Move-Folder -SourceFolderPath $SourcePath -DestinationParentFolderPath $DestinationParentPath
            }
            "8" {
                $SourceFile = Read-Host "Enter the source file path with the file name and extension "
                $DestinationParentPath = Read-Host "Enter the destination path of the folder "
                Move-File -SourceFilePath $SourceFile -DestinationParentFolderPath $DestinationParentPath
            }
            "9" {
                $FolderPath = Read-Host "Enter the folder path to rename "
                $NewFolderName = Read-Host "Enter the new name for the folder "
                Rename-Folder -FolderPath $FolderPath -NewName $NewFolderName
            }
            "10" {
                $FilePath = Read-Host "Enter the file path to rename with the file name and extension "
                $NewFileName = Read-Host "Enter the new name for the file "
                Rename-File -FilePath $FilePath -NewName $NewFileName
            }
            "11" {
                $FolderToCompress = Read-Host "Enter the folder path to compress and the file name without the extension "
                $CompressionType = Read-Host "Enter the compression type (Zip, 7z, etc.): "
                $DestinationPath = Read-Host "Enter the destination path of the folder (Main disk is not allowed) "
                Compress-Folder -FolderPath $FolderToCompress -CompressionType $CompressionType -DestinationPath $DestinationPath
            }
            "12" {
                $ArchivePath = Read-Host "Enter the archive path "
                $DestinationPath = Read-Host "Enter the destination path for extraction "
                Resize-Folder -ArchivePath $ArchivePath -DestinationPath $DestinationPath
            }
            default {
                Write-Host "Invalid choice. Please select a valid option."
            }
        }
        Pause
    } until ($Choice -eq 'Q')
}

# Check if the current session has administrative privileges
if (-not (Test-Administrator)) {
    Write-Warning "This script requires administrative privileges. Please run the script as an administrator."
    # Pause the script to allow the user to read the warning
    Pause
    # Relaunch the script with elevated permissions
    Restart-ScriptWithElevatedPermissions
    # Call function
    Show-Menu   
}



