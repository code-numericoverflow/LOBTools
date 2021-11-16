#
# Manifiesto del módulo 'LOBTools'
#
# Generado por Code
#
# Generado el 16/11/2021
#

@{

# Módulo de script o archivo de módulo binario asociado con este manifiesto.
RootModule = '.\LOBTools.psm1'

# Número de versión de este módulo.
ModuleVersion = '0.0.1'

# PSEditions compatibles
# CompatiblePSEditions = @()

# Id. usado para identificar de forma única este módulo.
GUID = 'cc2b4f15-448b-4f48-9f1e-768fab346730'

# Autor de este módulo.
Author = 'Code'

# Compañía o proveedor de este módulo.
CompanyName = 'NumericOverflow'

# Instrucción de copyright de este módulo.
Copyright = '(c) 2021 Code. Todos los derechos reservados.'

# Descripción de la funcionalidad proporcionada por este módulo.
Description = 'Line of busines tools'

# Versión mínima del motor de Windows PowerShell requerida por este módulo.
PowerShellVersion = '5.1'

# El nombre del host de Windows PowerShell requerido por este módulo.
# PowerShellHostName = ''

# Versión mínima del host de Windows PowerShell requerida por este módulo.
# PowerShellHostVersion = ''

# Versión mínima de Microsoft .NET Framework requerida por este módulo. Este requisito previo únicamente es válido para la edición de escritorio de PowerShell.
# DotNetFrameworkVersion = ''

# Versión mínima de Common Language Runtime (CLR) requerida por este módulo. Este requisito previo únicamente es válido para la edición de escritorio de PowerShell.
# CLRVersion = ''

# Arquitectura de procesador (None, X86, Amd64) que requiere este módulo
# ProcessorArchitecture = ''

# Módulos que se deben importar en el entorno global antes de importar este módulo.
# RequiredModules = @()

# Ensamblados que se deben cargar antes de importar este módulo.
# RequiredAssemblies = @()

# Archivos de script (.ps1) que se ejecutan en el entorno del llamador antes de importar este módulo.
# ScriptsToProcess = @()

# Archivos de tipo (.ps1xml) que se van a cargar al importar este módulo.
# TypesToProcess = @()

# Archivos de formato (.ps1xml) que se van a cargar al importar este módulo.
# FormatsToProcess = @()

# Módulos para importar como módulos anidados del módulo especificado en RootModule/ModuleToProcess
# NestedModules = @()

# Funciones para exportar desde este módulo; para conseguir el mejor rendimiento, no uses caracteres comodines ni elimines la entrada; usa una matriz vacía si no hay funciones que exportar.
FunctionsToExport = 'Get-ModelBaseCreationScript', 'Get-ModelNewScript', 
               'Get-ModelReference', 'Get-DALLiteDBAddScript', 'Get-DALLiteDBBase', 
               'Get-DALLiteDBCollectionScript', 'Get-DALLiteDBCreationScript', 
               'Get-DALLiteDBFindScript', 'Get-DALLiteDBIndexScript', 
               'Get-DALLiteDBNewScript', 'Get-DALLiteDBReferenceFindScript', 
               'Get-DALLiteDBRemoveScript', 'Get-DALLiteDBTestScript', 
               'Get-DALLiteDBUpdateScript', 'Get-DALLiteDBUpsertScript'

# Cmdlets para exportar desde este módulo; para conseguir el mejor rendimiento, no uses caracteres comodines ni elimines la entrada; usa una matriz vacía si no hay cmdlets que exportar.
CmdletsToExport = '*'

# Variables para exportar desde este módulo.
VariablesToExport = '*'

# Alias para exportar desde este módulo; para conseguir el mejor rendimiento, no uses caracteres comodines ni elimines la entrada; usa una matriz vacía si no hay alias que exportar.
AliasesToExport = '*'

# Recursos de DSC que se exportarán de este módulo
# DscResourcesToExport = @()

# Lista de todos los módulos empaquetados con este módulo
# ModuleList = @()

# Lista de todos los paquetes con este módulo.
# FileList = @()

# Datos privados que se pasan al módulo especificado en RootModule/ModuleToProcess. Pueden contener también una tabla hash PSData con metadatos del módulo adicionales usados por PowerShell.
PrivateData = @{

    PSData = @{
        Tags          = 'LOB','Line Of Business', 'LiteDB'
        LicenseUri    = 'https://raw.githubusercontent.com/code-numericoverflow/LOBTools/master/LOBTools/LICENSE.txt'
        ProjectUri    = 'https://github.com/code-numericoverflow/LOBTools'
        IconUri       = 'https://raw.githubusercontent.com/code-numericoverflow/LOBTools/master/icon.png'
#  = @{

        # Etiquetas aplicadas a este módulo. Ayudan a encontrar el módulo en las galerías en línea.
        # Tags = @()

        # Dirección URL a la licencia de este módulo.
        # LicenseUri = ''

        # Una dirección URL al sitio web principal de este proyecto.
        # ProjectUri = ''

        # Una dirección URL a un icono que representa este módulo.
        # IconUri = ''

        # ReleaseNotes de este módulo
        # ReleaseNotes = ''

    } # Fin de la tabla hash PSData

} # Fin de la tabla hash PrivateData

# URI de HelpInfo de este módulo
# HelpInfoURI = ''

# Prefijo predeterminado para los comandos exportados desde este módulo. Invalide el prefijo predeterminado mediante Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

