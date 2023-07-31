Import-Module -Name ".\ReusableTools\Utils\Invoke-Safe.psm1" -Force

function New-TextFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $FilePath,

        [Parameter(Mandatory, Position = 1)]
        [string]
        $Content
    )

    $ScriptBlock = {
        if (-not (Test-Path $FilePath)) {
            $Content | Set-Content $FilePath
            Write-Output $FilePath
        }
        else {
            $confirmation = Read-Host "File already exists. Do you want to overwrite it? (Y/N)"
            if ($confirmation -eq "Y") {
                $Content | Set-Content $FilePath
                Write-Output "File overwritten: $FilePath"
            }
            else {
                Write-Host "Operation canceled. File was not overwritten."
                return
            }
        }
    }

    Invoke-Safe -ScriptBlock $ScriptBlock
}

function Copy-File {
    param (
        [string]$SourceFilePath,
        [string]$DestinationFolderPath
    )

    $ScriptBlock = {
        param (
            [string]$SourcePath,
            [string]$DestinationPath
        )

        if (Test-Path $SourcePath -PathType Leaf) {
            if (-not (Test-Path $DestinationPath -PathType Container)) {
                Write-Host "Destination folder does not exist: $DestinationPath"
                return
            }

            $destinationFileName = (Split-Path -Leaf $SourcePath)
            $destinationPath = Join-Path -Path $DestinationPath -ChildPath $destinationFileName

            if (Test-Path $destinationPath -PathType Leaf) {
                $confirmation = Read-Host "Destination file already exists. Do you want to overwrite it? (Y/N)"
                if ($confirmation -ne "Y") {
                    Write-Host "Operation canceled. Destination file was not overwritten."
                    return
                }
                else {
                    Remove-Item $destinationPath -Force
                }
            }

            Copy-Item $SourcePath -Destination $destinationPath
            Write-Host "File copied from $SourcePath to $destinationPath"
        }
        else {
            Write-Host "Source file does not exist: $SourcePath"
        }
    }

    Invoke-Safe -ScriptBlock $ScriptBlock -ArgumentList $SourceFilePath, $DestinationFolderPath
}



function Remove-File {
    param (
        [string]$FilePath
    )

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

function Move-File {
    param (
        [string]$SourceFilePath,
        [string]$DestinationParentFolderPath
    )

    $ScriptBlock = {
        if (Test-Path $SourceFilePath -PathType Leaf) {
            $destinationPath = Join-Path -Path $DestinationParentFolderPath -ChildPath (Split-Path -Leaf $SourceFilePath)

            if (Test-Path $destinationPath -PathType Leaf) {
                $confirmation = Read-Host "Destination file already exists. Do you want to overwrite it? (Y/N)"
                if ($confirmation -ne "Y") {
                    Write-Host "Operation canceled. Destination file was not overwritten."
                    return
                }
            }

            Move-Item $SourceFilePath -Destination $destinationPath
            Write-Host "File moved to: $destinationPath"
        }
        else {
            Write-Host "Source file not found: $SourceFilePath"
        }
    }

    Invoke-Safe -ScriptBlock $ScriptBlock
}


function Rename-File {
    param (
        [string]$FilePath,
        [string]$NewName
    )

    $ScriptBlock = {
        if (Test-Path $FilePath -PathType Leaf) {
            $newPath = Join-Path -Path (Split-Path -Parent $FilePath) -ChildPath $NewName
            Rename-Item $FilePath -NewName $NewName
            Write-Host "File renamed to: $newPath"
        }
        else {
            Write-Host "File not found: $FilePath"
        }
    }

    Invoke-Safe -ScriptBlock $ScriptBlock
}

# Export all functions for the module
Export-ModuleMember -Function * 