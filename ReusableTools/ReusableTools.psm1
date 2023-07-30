function New-Folder {
     [CmdletBinding()]
     param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0)]
        [string]
        $ParentFolderPath,

        # Parameter help description
        [Parameter(Mandatory, Position = 1)]
        [string]
        $NewFolderName
     )

     try {

        $NewFolderPath = Join-Path - Path $ParentFolderPath - ChildPath $NewFolderName
        
        # checking whether the filePath does not exists, returns false if it does not exists and then We negate It by using -not
        if (-not (Test-Path $NewFolderPath -PathType Container)) {
            # We use Out-Null to suppress the output
            New-Item -Path $NewFolderPath -ItemType Directory | Out-Null
            Write-Output $NewFolderPath
        }
        else {
            Write-Output "Folder already exists: $NewFolderPath"
        }
     }
     catch {
        <#Do this if a terminating exception happens#>
        <#
        $_ variable represents the current object in the pipeline
        #>
        Write-Error "Error creating folder: $_"
     }
}


function New-TextFile {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0)]
        [string]
        $FilePath,

        # Parameter help description
        [Parameter(Mandatory, Position = 1)]
        [string]
        $Content
    )

    try {

        if (-not (Test-Path $FilePath)) {
            $Content | Set-Content $FilePath
            Write-Output $FilePath
        }
        else {
            Write-Output "File already exists: $FilePath"
        }
    }
    catch {
        <#Do this if a terminating exception happens#>
        Write-Error "Error creating text file: $_"
    }  
}

function Copy-Folder {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0)]
        [string]
        $SourceFolderPath,

        # Parameter help description
        [Parameter(Mandatory, Position = 1)]
        [string]
        $DestinationFolderPath
    )

    try {

        if(Test-Path $SourceFolderPath -PathType Container) {
            # We use recurse to bring all the files from the folder
            Copy-Item $SourceFolderPath -Destination $DestinationFolderPath -Recurse
            Write-Host "Folder copied from $SourceFolderPath to $DestinationFolderPath"
        }
        else {
            Write-Host "Source folder does not exists: $SourceFolderPath"
        }
    }
    catch {
        <#Do this if a terminating exception happens#>
        Write-Error "Error copying folder: $_"
    }  
}

# Export all functions for the module
Export-ModuleMember -Function * 