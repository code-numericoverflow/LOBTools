. .\DALLiteDBTools.ps1
. .\ModelTools.ps1

$GUID            = 'cc2b4f15-448b-4f48-9f1e-768fab346730'
$ModuleVersion   = "0.0.1"

$functions       = Get-Command *-Model* -CommandType Function | Select-Object -ExpandProperty Name
$functions      += Get-Command *-DAL*   -CommandType Function | Select-Object -ExpandProperty Name
$moduleParams    = @{
    Path                 = ".\LOBTools.psd1"
    RootModule           = ".\LOBTools.psm1"
    Author               = "Code"
    CompanyName          = "NumericOverflow"
    ModuleVersion        = "0.0.1"
    Guid                 = $GUID 
    Description          = "Line of busines tools" 
    PowerShellVersion    = "5.1"
    FunctionsToExport    = $functions 
}

$PSData = "@{
        Tags          = 'LOB','Line Of Business', 'LiteDB'
        LicenseUri    = 'https://raw.githubusercontent.com/code-numericoverflow/LOBTools/master/LOBTools/LICENSE.txt'
        ProjectUri    = 'https://github.com/code-numericoverflow/LOBTools'
        IconUri       = 'https://raw.githubusercontent.com/code-numericoverflow/LOBTools/master/icon.png'
# "

New-ModuleManifest @moduleParams
$newContent = Get-Content $moduleParams.Path | ForEach-Object { $_ -replace  '  PSData', "  PSData = $PSData" }
$newContent | Set-Content $moduleParams.Path -Force