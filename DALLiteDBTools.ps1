using namespace System.Management.Automation.Language

function Get-DALLiteDBCreationScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [String]   $ModelClassesPath
    )
    process {
        $ast = [Parser]::ParseInput((Get-Content $ModelClassesPath), [ref]$null, [ref]$null)
        $astClasses         = $ast.FindAll({ $args[0].IsClass }, $true) | Where-Object { $_.nAME -ne "EntityBase" }
        $references         = Get-ModelReference -ClassAsts $astClasses

        $collectionScripts  = $astClasses         | Get-DALLiteDBCollectionScript
        $collectionScript   = $collectionScripts  -join "`n"
        $indexScripts       = $references         | Get-DALLiteDBIndexScript
        $indexScript        = $indexScripts       -join "`n"
        $addScripts         = $astClasses         | Get-DALLiteDBAddScript
        $addScript          = $addScripts         -join "`n"
        $getScripts         = $astClasses         | Get-DALLiteDBGetScript
        $getScript          = $getScripts        -join "`n"
        $testScripts        = $astClasses         | Get-DALLiteDBTestScript
        $testScript         = $testScripts        -join "`n"
        $updateScripts      = $astClasses         | Get-DALLiteDBUpdateScript
        $updateScript       = $updateScripts      -join "`n"
        $upsertScripts      = $astClasses         | Get-DALLiteDBUSetScript
        $upsertScript       = $upsertScripts      -join "`n"
        $removeScripts      = $astClasses         | Get-DALLiteDBRemoveScript
        $removeScript       = $removeScripts      -join "`n"
        $referenceScripts   = $references         | Get-DALLiteDBReferenceGetScript
        $referenceScript    = $referenceScripts   -join "`n"

        Get-DALLiteDBBase
        $collectionScript
        $indexScript
        $addScript
        $getScript
        $testScript
        $referenceScript
        $updateScript
        $upsertScript
        $removeScript
    }
}

function Get-DALLiteDBBase {
'
Import-Module PSLiteDB

$Script:DB = $null

function Open-Connection {
    param (
        [String] $Database
    )
    $Script:DB = Open-LiteDBConnection -Database $Database -Mode Shared
}   
'
}

function Get-DALLiteDBCollectionScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    begin {
        $collections = @()
    }
    process {
        $collections += $classAst.Name | Get-Plural
    }
    end {
        $collections = $collections -join """, """
        $script  = "
function New-Collections {
    ""$collections"" | New-LiteDBCollection -Connection `$Script:DB 
}"
        $script
    }
}

function Get-DALLiteDBIndexScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [Object]   $Reference
    )
    begin {
        $indexes = @()
    }
    process {
        $source          = $Reference.Source
        $target          = $Reference.Target
        $sourceId        = $source + "Id"
        $collection      = $target | Get-Plural
        $indexes += "`tNew-LiteDBIndex -Connection `$Script:DB -Collection $collection -Field $sourceId"
    }
    end {
        $indexes = $indexes -join "`n"
        $script  = "
function New-Indexes {
$indexes
}
"
        $script
    }
}

function Get-DALLiteDBNewScript {
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

function Get-DALLiteDBAddScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    process {
        $className          = $classAst.Name
        $CollectionName     = $className | Get-Plural
        $script  = "
function Add-$className {
    param (
        [Parameter(mandatory=`$true, ValueFromPipeline=`$true)]
      <#[$className]#>`$$className
    )
    process {
        if (`$$className.Id -ne `$null) {
            `$$className | ConvertTo-LiteDbBSON | Add-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -Id `$$($className).Id
        } else {
            Write-Error ""Empty Id"" -TargetObject `$$className
        }
    }
}"
        $script
    }
}

function Get-DALLiteDBGetScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    process {
        $className          = $classAst.Name
        $CollectionName     = $className | Get-Plural
        $parameterName      = $className + "Id"
        $parameterPlural    = $parameterName | Get-Plural
        $script  = "
function Get-$className {
    #[OutputType([$className])]
    param (
        [Parameter(ValueFromPipeline=`$true, ParameterSetName = 'Id')]
        [Object]  `$InputObject, 
        [Parameter(ValueFromPipelineByPropertyName=`$true, ParameterSetName = 'Id')][Alias(""Id"")]
        [String]  `$$parameterName,
        [Parameter(ParameterSetName = 'Id')]
        [Switch]  `$Merge,
        [Parameter(ParameterSetName = 'Text', Mandatory = `$true)]
        [Object]  `$Text
    )
    process {
        if (`$Text) {
            Find-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -As PSObject | New-$className | Where-Object { `$_.GetFullText().Contains(`$Text) }
        } else {
            if (`$$parameterName) {
                `$result = Find-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -ID `$$parameterName -As PSObject | New-$className
                if (`$Merge -and `$InputObject -ne `$null) {
                    Add-Member -InputObject `$InputObject -MemberType NoteProperty -Name $className -Value `$result
                    `$InputObject
                } else {
                    `$result
                }
            } else {
                Find-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -As PSObject | New-$className
            }
        }
    }
}"
        $script
    }
}

function Get-DALLiteDBTestScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    process {
        $className          = $classAst.Name
        $CollectionName     = $className | Get-Plural
        $parameterName      = $className + "Id"
        $parameterPlural    = $parameterName | Get-Plural
        $script  = "
function Test-$className {
    #[OutputType([Boolean])]
    param (
        [Parameter(ValueFromPipeline=`$true)]
        [Object]  `$InputObject, 
        [Parameter(ValueFromPipelineByPropertyName=`$true, Mandatory = `$true)][Alias(""Id"")]
        [String]  `$$parameterName
    )
    process {
        `$doc = Find-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -ID `$$parameterName
        if (`$doc -ne `$null) {
            `$true
        } else {
            `$false
        }
    }
}"
        $script
    }
}

function Get-DALLiteDBUpdateScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    process {
        $className          = $classAst.Name
        $CollectionName     = $className  | Get-Plural
        $parameterName      = $className
        $script  = "
function Update-$className {
    param (
        [Parameter(Mandatory=`$true, ValueFromPipeline=`$true)]
      <#[$className]#>`$$parameterName
    )
    process {
        `$$parameterName | ConvertTo-LiteDbBSON | Update-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -Id `$$($className).Id
    }
}"
        $script
    }
}

function Get-DALLiteDBUSetScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    process {
        $className          = $classAst.Name
        $CollectionName     = $className  | Get-Plural
        $parameterName      = $className
        $script  = "
function Set-$className {
    param (
        [Parameter(Mandatory=`$true, ValueFromPipeline=`$true)]
      <#[$className]#>`$$parameterName
    )
    process {
        `$$parameterName | ConvertTo-LiteDbBSON | Upsert-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -Id `$$($className).Id
    }
}"
        $script
    }
}

function Get-DALLiteDBRemoveScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [TypeDefinitionAst]   $classAst
    )
    process {
        $className          = $classAst.Name
        $CollectionName     = $className | Get-Plural
        $parameterName      = $className + "Id"
        $parameterPlural    = $parameterName | Get-Plural
        $script  = "
function Remove-$className {
    param (
        [Parameter(Mandatory=`$true, ValueFromPipelineByPropertyName=`$true)][Alias(""Id"")]
        [String]  `$$parameterName
    )
    Remove-LiteDBDocument -Connection `$Script:DB -Collection $CollectionName -ID `$$parameterName
}"
        $script
    }
}

function Get-DALLiteDBReferenceGetScript {
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [Object]   $Reference
    )
    process {
        $source          = $Reference.Source
        $target          = $Reference.Target
        $sourceId        = $source + "Id"
        $collection      = $target | Get-Plural
        $script  = "
function Get-$source$collection {
    #[OutputType([$target])]
    param (
        [Parameter(ValueFromPipeline=`$true)]
        [Object]  `$InputObject, 
        [Parameter(ValueFromPipelineByPropertyName=`$true, Mandatory=`$true)][Alias(""Id"")]
        [String]  `$$sourceId,
        [Switch]  `$Merge
    )
    process {
        `$result = Find-LiteDBDocument -Connection `$Script:DB -Collection $collection -Select '$' -Where ""$sourceId = '`$$sourceId' "" -As PSObject | New-$target
        if (`$Merge -and `$InputObject -ne `$null) {
            Add-Member -InputObject `$InputObject -MemberType NoteProperty -Name $collection -Value `$result
            `$InputObject
        } else {
            `$result
        }
    }
}"
        $script
    }
}
