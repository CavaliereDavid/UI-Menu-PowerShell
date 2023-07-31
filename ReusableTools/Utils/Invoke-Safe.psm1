Import-Module -Name ".\ReusableTools\Utils\Validation-Utils.psm1" -Force

# Define a common try-catch block to handle exceptions
function Invoke-Safe {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory, Position = 0)]
        [scriptblock]
        $ScriptBlock
    )
    # The -ErrorAction Stop parameter within the try block ensures that any errors that occur within the script block are treated as terminating errors
    try {
        & $ScriptBlock -ErrorAction Stop
    }
    <#Do this if a terminating exception happens, $_ variable represents the current object in the pipeline#>  
    catch {
        Write-Error "An error occurred: $_"
    }
}



# Export all functions for the module
Export-ModuleMember -Function * 