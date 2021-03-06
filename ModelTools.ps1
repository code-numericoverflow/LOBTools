using namespace System.Management.Automation.Language

function Get-ModelPlural {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [String]  $Noum
    )
    process {
        if ($Noum.EndsWith("y")) {
            $Noum.Substring(0, $Noum.Length - 1) + "ies"
        } elseif ($Noum.EndsWith("s")) {
            $Noum + "es"
        } else {
            $Noum + "s"
        }
    }
}

function Add-ObjectProperty {
    param (
        $Object,
        $AddedObject
    )
    $result = $Object
    Add-Member -InputObject $result -MemberType NoteProperty -Name $AddedObject.GetType().Name -Value $AddedObject
}

function Get-ModelReference {
    param (
        [Parameter(Mandatory=$true)]
        [TypeDefinitionAst[]]   $ClassAsts
    )
    $ReferenceNames = $ClassAsts | ForEach-Object { $_.Name + "Id" }
    $ClassAsts | ForEach-Object {
        $classAst  = $_
        $className = $classAst.Name
        $classAst.Members | Where-Object { $_.GetType() -eq [PropertyMemberAst] -and $ReferenceNames.Contains($_.Name) } | ForEach-Object {
            [PSCustomObject] @{ 
                Source = $_.Name.Substring(0, $_.Name.Length - 2)
                Target = $className
            }
        }
    }
}

function Get-ModelBaseCreationScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [String]   $ModelClassesPath
    )
    process {
        $ast = [Parser]::ParseInput((Get-Content $ModelClassesPath), [ref]$null, [ref]$null)
        $astClasses         = $ast.FindAll({ $args[0].IsClass }, $true) | Where-Object { $_.nAME -ne "EntityBase" }
        $references         = Get-ModelReference -ClassAsts $astClasses

        $newScripts         = $astClasses         | Get-ModelNewScript
        $newScript          = $newScripts         -join "`n"

        $newScript
    }
}

function Get-ModelNewScript {
    param (
        [TypeDefinitionAst]   $BaseTypeAst,
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    process {
        $className = $classAst.Name
        $script  = ""
        $script += "function New-$className {`n`t#[OutputType([$className])]`n`tparam (`n"
        $parameters = @()
        $baseParameters =@(
            "`t`t[Parameter(ValueFromPipelineByPropertyName=`$true)]`n`t`t[String]  `$Id"        ,
            "`t`t[Parameter(ValueFromPipelineByPropertyName=`$true)]`n`t`t[String]  `$Name"      ,
            "`t`t[Parameter(ValueFromPipelineByPropertyName=`$true)]`n`t`t[String]  `$Comment"
        )
        $parameters += $baseParameters
        $typeParameters = $classAst.Members | Where-Object { $_.GetType() -eq [PropertyMemberAst] } | ForEach-Object {
            "`t`t[Parameter(ValueFromPipelineByPropertyName=`$true)]`n" +
            "`t`t$($_.PropertyType)  `$$($_.Name)"
        }
        $parameters += $typeParameters
        $script +=  $parameters -join ",`n"
        $script += "`n`t)`n`tprocess {`n"
        $script += "`t`t[$className] `$PSBoundParameters`n"
        $script += "`t}`n"
        $script += "}`n"
        $script
    }
}

function Register-ModelAutocompleter {
    param (
        [Parameter(ValueFromPipeline=$true)]
        [String]   $Module   = "*.DAL.*"
    )
    process {
        Get-Command -Module $Module -CommandType Function | ForEach-Object {
            $function     = $_
            $functionName = $_.Name
            $parameters   = $_.Parameters
            $parameters.Keys | ForEach-Object {
                $parameterName  = $_
                $parameterValue = $parameters[$_]
                if ($parameterName.EndsWith("Id") -and $parameterName.Length -gt 2) {
                    Register-ArgumentCompleter -CommandName $functionName -ParameterName $parameterName -ScriptBlock {
                        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
                        $modelName = $parameterName.Substring(0, $parameterName.Length - 2)
                        $script = [ScriptBlock]::Create("Get-$modelName -Text ""$wordToComplete""")
                        $options = Invoke-Command -ScriptBlock $script
                        $options | ForEach-Object {
                            $descriptionValue  = $_.Name
                            $codeValue         = $_.Id
                            $extendedValue     = "'$codeValue' <# $descriptionValue #>"
                            [System.Management.Automation.CompletionResult]::new($extendedValue, $descriptionValue, "ParameterValue", $codeValue)
                        }
                    }
                }
            }
        }
    }
}
