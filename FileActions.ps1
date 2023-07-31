# For simplicity We haven't created a controller.ps1 and main.ps1 but instead decided to use this file as both.

# -Force : ensures that the latest version of the module is loaded into the session
Import-Module ".\ReusableTools\Folder-Management\Folder-Utils.psm1" -Force
Import-Module ".\ReusableTools\File-Management\File-Utils.psm1" -Force

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
        $choice = Read-Host "Make a choice: "

        switch ($choice) {
            "1" {
                $parentPath = Read-Host "Enter the parent folder path: "
                $folderName = Read-Host "Enter the new folder name: "
                New-Folder -ParentFolderPath $parentPath -NewFolderName $folderName
            }
            "2" {
                $filePath = Read-Host "Enter the file path: "
                $content = Read-Host "Enter the file content: "
                New-TextFile -FilePath $filePath -Content $content
            }
            "3" {
                $sourcePath = Read-Host "Enter the source folder path: "
                $destinationPath = Read-Host "Enter the destination folder path: "
                Copy-Folder -SourceFolderPath $sourcePath -DestinationFolderPath $destinationPath
            }
            "4" {
                $sourceFile = Read-Host "Enter the source file path: "
                $destinationFile = Read-Host "Enter the destination file path: "
                Copy-File -SourceFilePath $sourceFile -DestinationFilePath $destinationFile
            }
            "5" {
                $folderToDelete = Read-Host "Enter the folder path to delete: "
                Remove-Folder -FolderPath $folderToDelete
            }
            "6" {
                $fileToDelete = Read-Host "Enter the file path to delete: "
                Remove-File -FilePath $fileToDelete
            }
            "7" {
                $sourcePath = Read-Host "Enter the source folder path: "
                $destinationParentPath = Read-Host "Enter the destination parent folder path: "
                Move-Folder -SourceFolderPath $sourcePath -DestinationParentFolderPath $destinationParentPath
            }
            "8" {
                $sourceFile = Read-Host "Enter the source file path: "
                $destinationParentPath = Read-Host "Enter the destination parent folder path: "
                Move-File -SourceFilePath $sourceFile -DestinationParentFolderPath $destinationParentPath
            }
            "9" {
                $folderPath = Read-Host "Enter the folder path to rename: "
                $newName = Read-Host "Enter the new name for the folder: "
                Rename-Folder -FolderPath $folderPath -NewName $newName
            }
            "10" {
                $filePath = Read-Host "Enter the file path to rename: "
                $newName = Read-Host "Enter the new name for the file: "
                Rename-File -FilePath $filePath -NewName $newName
            }
            "11" {
                $folderToCompress = Read-Host "Enter the folder path to compress: "
                Compress-Folder -FolderPath $folderToCompress
            }
            "12" {
                $archivePath = Read-Host "Enter the archive path: "
                $destinationPath = Read-Host "Enter the destination path for extraction: "
                Resize-Folder -ArchivePath $archivePath -DestinationPath $destinationPath
            }
            default {
                Write-Host "Invalid choice. Please select a valid option."
            }
        }
        Pause
    } until ($choice -eq 'Q')
}

# Call function
Show-Menu
