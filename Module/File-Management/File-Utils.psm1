Import-Module -Name ".\Module\Utils\Invoke-Safe.psm1" -Force
Import-Module -Name ".\Module\Utils\Validation-Utils.psm1" -Force

function New-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $FilePath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $FileName,

        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateSet("txt", "xml", "html", "csv")]
        [string]
        $FileExtension,

        # Not Mandatory because a user could decide to create an empty file
        [Parameter(Mandatory = $false, Position = 3)]
        [string]
        $Content
    )

    Process {
        $ScriptBlock = {
            $FullPath = "$FilePath\$FileName.$FileExtension"
            if (-not (Test-PathExists -Path $FullPath -FileOnly)) {
                $Content | Set-Content $FullPath
                Write-Output $FullPath
            }
            else {
                if (Confirm-Overwrite -DestinationPath $FullPath) {
                    $Content | Set-Content $FullPath
                    Write-Output "File overwritten: $FullPath"
                }
                else {
                    Write-Host "Operation canceled. File was not overwritten."
                }
            }
        }
        Invoke-Safe -ScriptBlock $ScriptBlock    
    }
}

function Copy-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $SourceFilePath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $DestinationFilePath
    )

    Process {
        $ScriptBlock = {
            if (Test-Path $SourceFilePath -PathType Leaf) {
                if (-not (Test-Path $DestinationFilePath -PathType Container)) {
                    Write-Host "Destination folder does not exist: $DestinationFilePath"
                    return
                }
    
                $DestinationFileName = (Split-Path -Leaf $SourceFilePath)
                $FullDestinationFilePath = Join-Path -Path $DestinationFilePath -ChildPath $DestinationFileName
    
                if (Test-Path $FullDestinationFilePath -PathType Leaf) {
                    $confirmation = Read-Host "Destination file already exists. Do you want to overwrite it? (Y/N)"
                    if ($confirmation -ne "Y") {
                        Write-Host "Operation canceled. Destination file was not overwritten."
                        return
                    }
                    else {
                        Remove-Item $FullDestinationFilePath -Force
                    }
                }
    
                Copy-Item $SourceFilePath -Destination $FullDestinationFilePath
                Write-Host "File copied from $SourceFilePath to $FullDestinationFilePath"
            }
            else {
                Write-Host "Source file does not exist: $SourceFilePath"
            }
        }
        Invoke-Safe -ScriptBlock $ScriptBlock      
    }
}

function Remove-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $FilePath
    )

    Process {
        $ScriptBlock = {
            if (Test-Path $FilePath -PathType Leaf) {
                Remove-Item $FilePath -Force
                Write-Host "File deleted: $FilePath"
            }
            else {
                Write-Host "File not found: $FilePath"
            }
        }
        Invoke-Safe -ScriptBlock $ScriptBlock     
    }
}

function Move-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $SourceFilePath,

        [Parameter(Mandatory, Position = 1)]
        [string]
        $DestinationParentFolderPath
    )

    Process {
        $ScriptBlock = {
            if (Test-Path $SourceFilePath -PathType Leaf) {
                $DestinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath (Split-Path -Leaf $SourceFilePath)
    
                if (Test-Path $DestinationPath -PathType Leaf) {
                    $confirmation = Read-Host "Destination file already exists. Do you want to overwrite it? (Y/N)"
                    if ($confirmation -ne "Y") {
                        Write-Host "Operation canceled. Destination file was not overwritten."
                        return
                    }
                }
    
                Move-Item $SourceFilePath -Destination $DestinationPath
                Write-Host "File moved to: $DestinationPath"
            }
            else {
                Write-Host "Source file not found: $SourceFilePath"
            }
        }
        Invoke-Safe -ScriptBlock $ScriptBlock
    }
}

function Rename-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $FilePath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $NewName
    )

    Process {
        $ScriptBlock = {
            if (Test-Path $FilePath -PathType Leaf) {
                $NewPath = Join-Path -Path (Split-Path -Parent $FilePath) -ChildPath $NewName
                Rename-Item $FilePath -NewName $NewName
                Write-Host "File renamed to: $NewPath"
            }
            else {
                Write-Host "File not found: $FilePath"
            }
        }
        Invoke-Safe -ScriptBlock $ScriptBlock
    }
}

# Export all functions for the module
Export-ModuleMember -Function *
