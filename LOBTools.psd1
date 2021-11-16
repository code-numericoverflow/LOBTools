#
# Manifiesto del m�dulo 'LOBTools'
#
# Generado por Code
#
# Generado el 16/11/2021
#

@{

# M�dulo de script o archivo de m�dulo binario asociado con este manifiesto.
RootModule = '.\LOBTools.psm1'

# N�mero de versi�n de este m�dulo.
ModuleVersion = '0.0.1'

# PSEditions compatibles
# CompatiblePSEditions = @()

# Id. usado para identificar de forma �nica este m�dulo.
GUID = 'cc2b4f15-448b-4f48-9f1e-768fab346730'

# Autor de este m�dulo.
Author = 'Code'

# Compa��a o proveedor de este m�dulo.
CompanyName = 'NumericOverflow'

# Instrucci�n de copyright de este m�dulo.
Copyright = '(c) 2021 Code. Todos los derechos reservados.'

# Descripci�n de la funcionalidad proporcionada por este m�dulo.
Description = 'Line of busines tools'

# Versi�n m�nima del motor de Windows PowerShell requerida por este m�dulo.
PowerShellVersion = '5.1'

# El nombre del host de Windows PowerShell requerido por este m�dulo.
# PowerShellHostName = ''

# Versi�n m�nima del host de Windows PowerShell requerida por este m�dulo.
# PowerShellHostVersion = ''

# Versi�n m�nima de Microsoft .NET Framework requerida por este m�dulo. Este requisito previo �nicamente es v�lido para la edici�n de escritorio de PowerShell.
# DotNetFrameworkVersion = ''

# Versi�n m�nima de Common Language Runtime (CLR) requerida por este m�dulo. Este requisito previo �nicamente es v�lido para la edici�n de escritorio de PowerShell.
# CLRVersion = ''

# Arquitectura de procesador (None, X86, Amd64) que requiere este m�dulo
# ProcessorArchitecture = ''

# M�dulos que se deben importar en el entorno global antes de importar este m�dulo.
# RequiredModules = @()

# Ensamblados que se deben cargar antes de importar este m�dulo.
# RequiredAssemblies = @()

# Archivos de script (.ps1) que se ejecutan en el entorno del llamador antes de importar este m�dulo.
# ScriptsToProcess = @()

# Archivos de tipo (.ps1xml) que se van a cargar al importar este m�dulo.
# TypesToProcess = @()

# Archivos de formato (.ps1xml) que se van a cargar al importar este m�dulo.
# FormatsToProcess = @()

# M�dulos para importar como m�dulos anidados del m�dulo especificado en RootModule/ModuleToProcess
# NestedModules = @()

# Funciones para exportar desde este m�dulo; para conseguir el mejor rendimiento, no uses caracteres comodines ni elimines la entrada; usa una matriz vac�a si no hay funciones que exportar.
FunctionsToExport = 'Get-ModelBaseCreationScript', 'Get-ModelNewScript', 
               'Get-ModelReference', 'Get-DALLiteDBAddScript', 'Get-DALLiteDBBase', 
               'Get-DALLiteDBCollectionScript', 'Get-DALLiteDBCreationScript', 
               'Get-DALLiteDBFindScript', 'Get-DALLiteDBIndexScript', 
               'Get-DALLiteDBNewScript', 'Get-DALLiteDBReferenceFindScript', 
               'Get-DALLiteDBRemoveScript', 'Get-DALLiteDBTestScript', 
               'Get-DALLiteDBUpdateScript', 'Get-DALLiteDBUpsertScript'

# Cmdlets para exportar desde este m�dulo; para conseguir el mejor rendimiento, no uses caracteres comodines ni elimines la entrada; usa una matriz vac�a si no hay cmdlets que exportar.
CmdletsToExport = '*'

# Variables para exportar desde este m�dulo.
VariablesToExport = '*'

# Alias para exportar desde este m�dulo; para conseguir el mejor rendimiento, no uses caracteres comodines ni elimines la entrada; usa una matriz vac�a si no hay alias que exportar.
AliasesToExport = '*'

# Recursos de DSC que se exportar�n de este m�dulo
# DscResourcesToExport = @()

# Lista de todos los m�dulos empaquetados con este m�dulo
# ModuleList = @()

# Lista de todos los paquetes con este m�dulo.
# FileList = @()

# Datos privados que se pasan al m�dulo especificado en RootModule/ModuleToProcess. Pueden contener tambi�n una tabla hash PSData con metadatos del m�dulo adicionales usados por PowerShell.
PrivateData = @{

    PSData = @{
        Tags          = 'LOB','Line Of Business', 'LiteDB'
        LicenseUri    = 'https://raw.githubusercontent.com/code-numericoverflow/LOBTools/master/LOBTools/LICENSE.txt'
        ProjectUri    = 'https://github.com/code-numericoverflow/LOBTools'
        IconUri       = 'https://raw.githubusercontent.com/code-numericoverflow/LOBTools/master/icon.png'
#  = @{

        # Etiquetas aplicadas a este m�dulo. Ayudan a encontrar el m�dulo en las galer�as en l�nea.
        # Tags = @()

        # Direcci�n URL a la licencia de este m�dulo.
        # LicenseUri = ''

        # Una direcci�n URL al sitio web principal de este proyecto.
        # ProjectUri = ''

        # Una direcci�n URL a un icono que representa este m�dulo.
        # IconUri = ''

        # ReleaseNotes de este m�dulo
        # ReleaseNotes = ''

    } # Fin de la tabla hash PSData

} # Fin de la tabla hash PrivateData

# URI de HelpInfo de este m�dulo
# HelpInfoURI = ''

# Prefijo predeterminado para los comandos exportados desde este m�dulo. Invalide el prefijo predeterminado mediante Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

