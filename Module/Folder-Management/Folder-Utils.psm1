Import-Module -Name ".\Module\Utils\Invoke-Safe.psm1" -Force
Import-Module -Name ".\Module\Utils\Validation-Utils.psm1" -Force

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
                $Confirmation = Read-Host "Folder does not exist. Do you want to create it? (Y/N)"
                if ($Confirmation -ne "Y") {
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

function Copy-Folder {
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

            $DestinationFolderName = (Split-Path -Leaf $SourceFolderPath)
            $DestinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath $DestinationFolderName

            if (Test-PathExists -Path $DestinationPath -DirectoryOnly) {
                if (-not (Confirm-Overwrite -DestinationPath $DestinationPath)) {
                    Write-Host "Operation canceled. Destination folder was not overwritten."
                    return
                }
                else {
                    Remove-Item $DestinationPath -Recurse -Force
                }
            }

            Copy-Item $SourceFolderPath -Destination $DestinationPath -Recurse
            Write-Host "Folder moved to: $DestinationPath"
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
    
            $DestinationFolderName = (Split-Path -Leaf $SourceFolderPath)
            $DestinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath $DestinationFolderName
    
            if (Test-PathExists -Path $DestinationPath -DirectoryOnly) {
                if (-not (Confirm-Overwrite -DestinationPath $DestinationPath)) {
                    return
                }
                else {
                    Remove-Item $DestinationPath -Recurse -Force
                }
            }
            Move-Item $SourceFolderPath -Destination $DestinationPath
            Write-Host "Folder moved to: $DestinationPath"
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
            $NewPath = Join-Path -Path (Split-Path -Parent $FolderPath) -ChildPath $NewName
            Rename-Item $FolderPath -NewName $NewName
            Write-Host "Folder renamed to: $NewPath"
        }
        Invoke-Safe -ScriptBlock $ScriptBlock
    }

    
}

function Compress-Folder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $FolderPath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $CompressionType,

        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $DestinationPath
    )

    Process {
        $ScriptBlock = {
            if (-not (Test-PathExists -Path $FolderPath -DirectoryOnly)) {
                Write-Host "Folder not found: $FolderPath"
                return
            }

            if (-not (Test-PathExists -Path $DestinationPath -DirectoryOnly)) {
                Write-Host "Destination folder does not exist: $DestinationPath"
                return
            }

            $ArchiveName = [System.IO.Path]::GetFileNameWithoutExtension($FolderPath)
            $Extension = $null

            switch ($CompressionType.ToLower()) {
                "zip" { $Extension = ".zip" }
                "7z" { $Extension = ".7z" }
                # Add more cases for other supported compression types as needed
                default {
                    Write-Host "Unsupported compression type: $CompressionType"
                    return
                }
            }

            $ArchivePath = Join-Path -Path $DestinationPath -ChildPath "$ArchiveName$Extension"

            Compress-Archive -Path $FolderPath -DestinationPath $ArchivePath -CompressionLevel Optimal -Force
            Write-Host "Folder compressed to: $ArchivePath"
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

            $ArchiveFileName = Split-Path -Leaf $ArchivePath
            $FolderName = $ArchiveFileName -replace '\.zip$'  
            $DestinationFolder = Join-Path -Path $DestinationPath -ChildPath $FolderName
            if (Test-PathExists -Path $DestinationFolder -DirectoryOnly) {
                if (-not (Confirm-Overwrite -DestinationPath $DestinationFolder)) {
                    Write-Host "Operation canceled. Folder was not extracted or overwritten."
                    return
                }
                else {
                    Remove-Item $DestinationFolder -Recurse -Force
                }
            }

            Expand-Archive -LiteralPath $ArchivePath -DestinationPath $DestinationPath
            Write-Host "Folder extracted to: $DestinationFolder"
        }

        Invoke-Safe -ScriptBlock $ScriptBlock
    }    
}

# Export all functions for the module
Export-ModuleMember -Function *
