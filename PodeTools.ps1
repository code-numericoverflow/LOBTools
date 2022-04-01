function Get-PodeCommandProxy {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [String]  $CommandName,
        [String]  $Endpoint      = "`$(`$env:PodeEndpoint)",
        [String]  $Session       = "`$env:PodeSession"
    )
    process {
        $cmd = Get-Command $CommandName
        $cmdMetadata = [System.Management.Automation.CommandMetadata]::new($cmd)

        #$help     = [System.Management.Automation.ProxyCommand]::GetHelpComments($cmdMetadata) # TODO
        $binding  = [System.Management.Automation.ProxyCommand]::GetCmdletBindingAttribute($cmdMetadata)
        $param    = [System.Management.Automation.ProxyCommand]::GetParamBlock($cmdMetadata)
        $dyna     = [System.Management.Automation.ProxyCommand]::GetDynamicParam($cmdMetadata) # TODO
        $begin    = [System.Management.Automation.ProxyCommand]::GetBegin($cmdMetadata)
        $process  = [System.Management.Automation.ProxyCommand]::GetProcess($cmdMetadata)
        $end      = [System.Management.Automation.ProxyCommand]::GetEnd($cmdMetadata)

        $verb = ($CommandName -split '-')[0]
        $method = Convert-PodeFunctionVerbToHttpMethod -Verb $verb

$customBegin = "
    try {
        `$wrappedCmd = `$ExecutionContext.InvokeCommand.GetCommand('Invoke-RestMethod', [System.Management.Automation.CommandTypes]::Cmdlet)
        `$params = @{}
        `$params.Add('Method', '$method')
        `$params.Add('Uri'   , ""$Endpoint/$CommandName"")
        `$params.Add('Body'  , `$PSBoundParameters)
        `$scriptCmd = {& `$wrappedCmd @params }
        `$steppablePipeline = `$scriptCmd.GetSteppablePipeline()
        `$steppablePipeline.Begin(`$myInvocation.ExpectingInput, `$ExecutionContext)
    } catch {
        throw
    }
"
$customProcess = "
    try {
        `$body = `$PSBoundParameters
        `$result = Invoke-RestMethod -Method $method -Uri ""$Endpoint/$CommandName"" -Body @{ Body = (ConvertTo-Json `$body) } -WebSession $Session
        `$result
    } catch {
        throw
    }
"
    
"function $CommandName {
$binding
param (
$param
)
process {
$customProcess
}
}"
    }
}

function Get-PodeADSessionScript {
'
function New-PodeADSession {
    [CmdletBinding()]
    param (
        [String]   $Url = "$($env:PodeEndpoint)",
        [Parameter(Mandatory=$true)]
        [String]   $Username = $env:PodeUsername,
        [Parameter(Mandatory=$true)]
        [String]   $Password = $env:PodePassword
    )
    Invoke-RestMethod -Method Get  -Uri $Url         -SessionVariable session | Out-Null
    Invoke-RestMethod -Method Post -Uri "$Url/login" -Body @{ username = $Username; password = $Password } -WebSession $session | Out-Null
    $session
}
'
}

function Convert-PodeFunctionVerbToHttpMethod {
    param (
        [Parameter()]
        [string]
        $Verb
    )

    # if empty, just return default
    switch ($Verb) {
        { $_ -iin @('Find', 'Format', 'Get', 'Join', 'Search', 'Select', 'Split', 'Measure', 'Ping', 'Test', 'Trace') } { 'GET' }
        { $_ -iin @('Set') } { 'PUT' }
        { $_ -iin @('Rename', 'Edit', 'Update') } { 'PATCH' }
        { $_ -iin @('Clear', 'Close', 'Exit', 'Hide', 'Remove', 'Undo', 'Dismount', 'Unpublish', 'Disable', 'Uninstall', 'Unregister') } { 'DELETE' }
        Default { 'POST' }
    }
}

function Convert-PodeFunctionVerbToHttpRules {
    param (
        [Parameter()]
        [string]
        $CommandName
    )
    # Add    => Post   /Plural
    # Get    => Get    /Plural
    #        => Get    /Plural  /:id
    #        => Get    /Plural  /:id/Plural2
    # Set    => Put    /Plural  /:id
    # Remove => Delete /Plural  /:Id
    # Test   => Get    /Singular/:id


    # if empty, just return default
    switch ($Verb) {
        { $_ -iin @('Find', 'Format', 'Get', 'Join', 'Search', 'Select', 'Split', 'Measure', 'Ping', 'Test', 'Trace') } { 'GET' }
        { $_ -iin @('Set') } { 'PUT' }
        { $_ -iin @('Rename', 'Edit', 'Update') } { 'PATCH' }
        { $_ -iin @('Clear', 'Close', 'Exit', 'Hide', 'Remove', 'Undo', 'Dismount', 'Unpublish', 'Disable', 'Uninstall', 'Unregister') } { 'DELETE' }
        Default { 'POST' }
    }
}

# BODY AS JSON

#            $parameters["Body"] | Out-PodeHost
#            $body = ConvertFrom-Json $parameters["Body"]
#            $bodyParameters = ConvertTo-Hashtable $body
#            $newParameters = @{}
#            $bodyParameters.GetEnumerator() | ForEach-Object {
#                $isPresent = $_.Value.IsPresent
#                if ($isPresent -ne $null -and $_.Value.IsPresent) {
#                    $newParameters += @{ "$($_.Name)" = $true }
#                } elseif ($isPresent -ne $null -and -not $_.Value.IsPresent) {
#                    $newParameters += @{ "$($_.Name)" = $false }
#                } else {
#                    $newParameters += @{ "$($_.Name)" = $_.Value }
#                }
#            }
