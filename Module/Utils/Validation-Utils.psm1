function Test-PathExists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
        [string]
        $Path,

        [Parameter(Position = 1)]
        [Switch]
        $DirectoryOnly,

        [Parameter(Position = 2)]
        [Switch]
        $FileOnly,

        [Parameter(Position = 3)]
        [Switch]
        $ZipFileOnly
    )

    process {
        if (-not (Test-Path $Path)) {
            return $false
        }

        if ($DirectoryOnly -and -not (Test-Path $Path -PathType Container)) {
            return $false
        }

        if ($FileOnly -and -not (Test-Path $Path -PathType Leaf)) {
            return $false
        }

        if ($ZipFileOnly -and (-not (Test-Path $Path -PathType Leaf) -or -not ($Path -like "*.zip"))) {
            return $false
        }

        return $true
    }
}


function Confirm-Overwrite {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $DestinationPath,

        # Parameter help description
        [Parameter(Position = 1)]
        [string]
        $Message = "Destination already exists. Do you want to overwrite it? Y/N"
    )

    process {
        if (Test-Path $DestinationPath) {
            $confirmation = Read-Host $Message
            if($confirmation -ne "Y") {
                Write-Host "Operation canceled. Destination was not overwritten."
                return $false
            }
            else {
                return $true
            }
        }
        else {
            return $true
        }
    }
}

# Export all functions for the module
Export-ModuleMember -Function * 