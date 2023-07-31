Import-Module -Name ".\ReusableTools\Utils\Invoke-Safe.psm1" -Force
Import-Module -Name ".\ReusableTools\Utils\Validation-Utils.psm1" -Force

function New-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $ParentFolderPath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $NewFolderName
    )

    Process {
        $ScriptBlock = {
            $NewFolderPath = Join-Path -Path $ParentFolderPath -ChildPath $NewFolderName

            if (Test-PathExists $NewFolderPath -DirectoryOnly) {
                if (-not (Confirm-Overwrite -DestinationPath $NewFolderPath)) {
                    return
                }
                else {
                    Remove-Item $NewFolderPath -Recurse -Force
                }
            }
            else {
                $confirmation = Read-Host "Folder does not exist. Do you want to create it? (Y/N)"
                if ($confirmation -ne "Y") {
                    Write-Host "Operation canceled. Folder was not created."
                    return
                }
            }

            New-Item -Path $NewFolderPath -ItemType Directory | Out-Null
            Write-Output $NewFolderPath
        }

        Invoke-Safe -ScriptBlock $ScriptBlock
    }
}

function Move-Folder {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $SourceFolderPath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $DestinationParentFolderPath
    )

    Process {
        $ScriptBlock = {
            if (-not (Test-PathExists -Path $SourceFolderPath -DirectoryOnly)) {
                Write-Host "Source folder not found: $SourceFolderPath"
                return
            }

            if (-not (Test-PathExists -Path $DestinationParentFolderPath -DirectoryOnly)) {
                Write-Host "Destination parent folder does not exist: $DestinationParentFolderPath"
                return
            }

            $destinationFolderName = (Split-Path -Leaf $SourceFolderPath)
            $destinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath $destinationFolderName

            if (Test-PathExists -Path $destinationPath -DirectoryOnly) {
                if (-not (Confirm-Overwrite -DestinationPath $destinationPath)) {
                    Write-Host "Operation canceled. Destination folder was not overwritten."
                    return
                }
                else {
                    Remove-Item $destinationPath -Recurse -Force
                }
            }

            Move-Item $SourceFolderPath -Destination $destinationPath
            Write-Host "Folder moved to: $destinationPath"
        }

        Invoke-Safe -ScriptBlock $ScriptBlock      
    } 
}

function Remove-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $FolderPath
    )

    Process {
        $ScriptBlock = {
            if (Test-Path $FolderPath -PathType Container) {
                Remove-Item $FolderPath -Recurse -Force
                Write-Host "Folder deleted: $FolderPath"
            }
            else {
                Write-Host "Folder not found: $FolderPath"
            }     
        }
        Invoke-Safe -ScriptBlock $ScriptBlock     
    }

    
}

function Move-Folder {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $SourceFolderPath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $DestinationParentFolderPath
    )

    Process {
        $ScriptBlock = {
            if (-not (Test-PathExists -Path $SourceFolderPath -DirectoryOnly)) {
                Write-Host "Source folder not found: $SourceFolderPath"
                return
            }

            if (-not (Test-PathExists -Path $DestinationParentFolderPath -DirectoryOnly)) {
                Write-Host "Destination parent folder does not exist: $DestinationParentFolderPath"
                return
            }
    
            $destinationFolderName = (Split-Path -Leaf $SourceFolderPath)
            $destinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath $destinationFolderName
    
            if (Test-PathExists -Path $destinationPath -DirectoryOnly) {
                if (-not (Confirm-Overwrite -DestinationPath $destinationPath)) {
                    return
                }
                else {
                    Remove-Item $destinationPath -Recurse -Force
                }
            }
            Move-Item $SourceFolderPath -Destination $destinationPath
            Write-Host "Folder moved to: $destinationPath"
        }
        Invoke-Safe -ScriptBlock $ScriptBlock      
    } 
}

function Rename-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $FolderPath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $NewName
    )

    Process {
        $ScriptBlock = {
            if (-not (Test-PathExists -Path $FolderPath -DirectoryOnly)) {
                Write-Host "Folder not found: $FolderPath"
                return
            }
            $newPath = Join-Path -Path (Split-Path -Parent $FolderPath) -ChildPath $NewName
            Rename-Item $FolderPath -NewName $NewName
            Write-Host "Folder renamed to: $newPath"
        }
        Invoke-Safe -ScriptBlock $ScriptBlock
    }

    
}

function Compress-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $FolderPath
    )

    Process {
        $ScriptBlock = {
            if (-not (Test-PathExists -Path $FolderPath -DirectoryOnly)) {
                Write-Host "Folder not found: $FolderPath"
                return
            }
            $archivePath = Join-Path -Path (Split-Path -Parent $FolderPath) -ChildPath "$([System.IO.Path]::GetFileNameWithoutExtension($FolderPath)).zip"
            Compress-Archive -Path $FolderPath -DestinationPath $archivePath
            Write-Host "Folder compressed to: $archivePath"
        }
        Invoke-Safe -ScriptBlock $ScriptBlock
    }   
}

function Resize-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $ArchivePath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $DestinationPath
    )

    Process {
        $ScriptBlock = {
            if (-not (Test-PathExists -Path $ArchivePath -ZipFileOnly)) {
                Write-Host "Archive not found or not a .zip file: $ArchivePath"
                return
            }

            if (-not (Test-PathExists -Path $DestinationPath -DirectoryOnly)) {
                Write-Host "Destination folder does not exist: $DestinationPath"
                return
            }

            $archiveFileName = Split-Path -Leaf $ArchivePath
            $folderName = $archiveFileName -replace '\.zip$'  
            $destinationFolder = Join-Path -Path $DestinationPath -ChildPath $folderName
            if (Test-PathExists -Path $destinationFolder -DirectoryOnly) {
                if (-not (Confirm-Overwrite -DestinationPath $destinationFolder)) {
                    Write-Host "Operation canceled. Folder was not extracted or overwritten."
                    return
                }
                else {
                    Remove-Item $destinationFolder -Recurse -Force
                }
            }

            Expand-Archive -LiteralPath $ArchivePath -DestinationPath $DestinationPath
            Write-Host "Folder extracted to: $destinationFolder"
        }

        Invoke-Safe -ScriptBlock $ScriptBlock
    }    
}

# Export all functions for the module
Export-ModuleMember -Function *
