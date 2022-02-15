﻿<#
.DESCRIPTION
	This script performs network drive mappings with PowerShell and is auto generated by the intune-drive-mapping-generator (https://intunedrivemapping.azurewebsites.net).
	When executed under SYSTEM authority a scheduled task is created to ensure recurring script execution on each user logon.

.NOTES
	Author: Nicola Suter, nicolonsky tech: https://tech.nicolonsky.ch
#>

[CmdletBinding()]
Param()

###########################################################################################
# Start transcript for logging
###########################################################################################

Start-Transcript -Path $(Join-Path $env:temp "DriveMapping.log")

###########################################################################################
# Input values from generator
###########################################################################################

$driveMappingJson = '[
   {
      "Path":"\\\\sigvaris-group.com\\Data\\SGB\\Management",
      "DriveLetter":"U",
      "Label":"Management",
      "Id":1,
      "GroupFilter":"DL-FS-SIUKANFS01-Management-M,DL-FS-SIUKANFS01-Management-R"
   },
   {
      "Path":"\\\\sigvaris-group.com\\Data\\SGB\\Shared",
      "DriveLetter":"S",
      "Label":"Shared",
      "Id":2,
      "GroupFilter":"DL-UK-Andover-Users-All"
   },
   {
      "Path":"\\\\sigvaris-group.com\\Data\\SGB\\Applications",
      "DriveLetter":"T",
      "Label":"Applications",
      "Id":3,
      "GroupFilter":"DL-FS-SIUKANFS01-Applications-M,DL-FS-SIUKANFS01-Applications-R"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\appl",
      "DriveLetter":"M",
      "Label":"APPL",
      "Id":4,
      "GroupFilter":"G-SFR"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\appl\\SAP BO FC",
      "DriveLetter":"R",
      "Label":"SAPBoFc",
      "Id":5,
      "GroupFilter":"DL-SIGVARIS-SAP-BOFC-Users"
   },
   {
      "Path":"\\\\sc001745\\sigvaris\\filecenter",
      "DriveLetter":"Z",
      "Label":"FCVDOC",
      "Id":6,
      "GroupFilter":"DL_PF00-SIGVARIS-Filecenter_Vdoc_Users"
   },
   {
      "Path":"\\\\SYNO_SJ\\Stockage\\Autocad",
      "DriveLetter":"P",
      "Label":"AC",
      "Id":7,
      "GroupFilter":"DL_PF00-SIGVARIS-Plans_Autocad_Users"
   },
   {
      "Path":"\\\\SYNO_SJ\\Stockage\\Communication Medias",
      "DriveLetter":"V",
      "Label":"CM",
      "Id":8,
      "GroupFilter":"DL_PF00-SIGVARIS-Communication_Medias_Users"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\data",
      "DriveLetter":"K",
      "Label":"Data",
      "Id":9,
      "GroupFilter":"G-SFR"
   },
   {
      "Path":"\\\\sc001703.sigvaris-corp.com\\HVBDaten",
      "DriveLetter":"Q",
      "Label":"HVB",
      "Id":1,
      "GroupFilter":"RG_PF00-SIGVARIS-HVB_Users"
   },
   {
      "Path":"\\\\sigvaris-group.com\\templates",
      "DriveLetter":"T",
      "Label":"TEMPLATES",
      "Id":2,
      "GroupFilter":"DL-AMNOSV-FS-CA-Templates-W,DL-GLGR-EMEA-Templates-Administrators,DL-AMNOSV-FS-GA-Templates-W,DL-AMNOSV-FS-MI-Templates-W"
   },


   {
      "Path":"https://sigvarisgroup.sharepoint.com/sites/app-corp-ecne-ssg-data/SSG",
      "DriveLetter":"S",
      "Label":"SSG",
      "Id":3,
      "GroupFilter":"DL-EMCE-SSG-Users"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\DMS-SSG",
      "DriveLetter":"N",
      "Label":"DMS-SSG",
      "Id":4,
      "GroupFilter":"DL-EMCE-SSG-Users"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\data",
      "DriveLetter":"K",
      "Label":"Data",
      "Id":5,
      "GroupFilter":"G-SAT,G-SSG,G-SMG,G-SIT,G-SDE"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\appl",
      "DriveLetter":"M",
      "Label":"APPL",
      "Id":6,
      "GroupFilter":"G-SAT,G-SSG,G-SMG,G-SIT,G-SDE"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\appl\\SAP BO FC",
      "DriveLetter":"R",
      "Label":"SAPBoFc",
      "Id":7,
      "GroupFilter":"DL-SIGVARIS-SAP-BOFC-Users"
   },
   {
      "Path":"\\\\weu-pr-avm-0008.sigvaris-group.com\\DATA-SSG",
      "DriveLetter":"L",
      "Label":"DATA-SSG",
      "Id":8,
      "GroupFilter":"DL-EMCE-SSG-Users,G-SAT"
   },
   {
      "Path":"\\\\simxmcfs01\\Shared",
      "DriveLetter":"M",
      "Label":"Shared Data",
      "Id":8,
      "GroupFilter":"G-SMX"
   },


   
   {
      "Path":"\\\\siusgafs01.sigvaris-group.com\\data",
      "DriveLetter":"F",
      "Label":"PTC Data",
      "Id":1,
      "GroupFilter":"DL-AMNOSV-FS-GA-All US Users"
   },
   {
      "Path":"\\\\sicamofs01.sigvaris-group.com\\data",
      "DriveLetter":"S",
      "Label":"CA Data",
      "Id":2,
      "GroupFilter":"DL-AMNOSV-FS-CA-All Users"
   },
   {
      "Path":"\\\\siusgafs01.sigvaris-group.com\\data",
      "DriveLetter":"P",
      "Label":"PTC Data",
      "Id":3,
      "GroupFilter":"DL-AMNOSV-FS-CA-Senior Management"
   },
   {
      "Path":"\\\\siusgafs01.sigvaris-group.com\\data\\HR_Canada",
      "DriveLetter":"H",
      "Label":"HR (Canada)",
      "Id":4,
      "GroupFilter":"DL-AMNOSV-FS-CA-HR"
   },
   {
      "Path":"\\\\siusmifs01.sigvaris-group.com\\Shared",
      "DriveLetter":"P",
      "Label":"SharedData",
      "Id":5,
      "GroupFilter":"DL-AMNOSV-FS-MI-All Holland Users"
   },
   {
      "Path":"\\\\siusganas01.sigvaris-group.com\\marketing",
      "DriveLetter":"M",
      "Label":"Marketing",
      "Id":7,
      "GroupFilter":"DL-AMNOSV-FS-GA-Marketing Dept-W"
   },
   {
      "Path":"\\\\siusganeo1.sigvaris-group.com\\OMS500",
      "DriveLetter":"O",
      "Label":"OMS500 by Quadient",
      "Id":9,
      "GroupFilter":"DL-AMNOSV-FS-GA-OMS500-W,DL-AMNOSV-FS-GA-OMS500-R"
   }

   ,
   {
      "Path":"\\\\sibrspfs02.sigvaris-group.com\\Dados",
      "DriveLetter":"W",
      "Label":"DADOS",
      "Id":1,
      "GroupFilter":"G-SBR"
   },
   {
      "Path":"\\\\sibrspfs02.sigvaris-group.com\\Install",
      "DriveLetter":"Y",
      "Label":"INSTALL",
      "Id":2,
      "GroupFilter":"G-SBR"
   },
   {
      "Path":"\\\\sibrspfs02.sigvaris-group.com\\Dados\\ADM VENDAS\\NFe",
      "DriveLetter":"N",
      "Label":"NFe",
      "Id":3,
      "GroupFilter":"RG-AMERICAS-SOUTH-ADMV"
   },
   {
      "Path":"\\\\sibrspfs02.sigvaris-group.com\\Sistemas",
      "DriveLetter":"Z",
      "Label":"SISTEMAS",
      "Id":4,
      "GroupFilter":"G-SBR"
   },
   {
      "Path":"\\\\sibrspsv010.sigvaris-group.com\\RH1",
      "DriveLetter":"P",
      "Label":"RH1",
      "Id":5,
      "GroupFilter":"DL-AMERICAS-SOUTH-PROTHEUS-RH"
   },
   {
      "Path":"\\\\sibrspfs02.sigvaris-group.com\\Dados\\BI",
      "DriveLetter":"B",
      "Label":"BI",
      "Id":6,
      "GroupFilter":"RG-AMERICAS-SOUTH-BI"
   },
   {
      "Path":"https://sigvarisgroup.sharepoint.com/sites/ws-ssg-Data-Exchange-Custom-Made/Shared%20Documents",
      "DriveLetter":"Q",
      "Label":"",
      "Id":7,
      "GroupFilter":"DL-AMSOCL-MapCustomMade"
   }
   

]'

$driveMappingConfig = $driveMappingJson | ConvertFrom-Json -ErrorAction Stop

# Override with your Active Directory Domain Name e.g. 'ds.nicolonsky.ch' if you haven't configured the domain name as DHCP option
$searchRoot = ""

# If enabled all mounted PSdrives from filesystem except os drives get disconnected if not specified in drivemapping config
$removeStaleDrives = $false

###########################################################################################
# Helper function to determine a users group membership
###########################################################################################

# Kudos for Tobias Renström who showed me this!
function Get-ADGroupMembership {
	param(
		[parameter(Mandatory = $true)]
		[string]$UserPrincipalName
	)

	process {

		try {

			if ([string]::IsNullOrEmpty($env:USERDNSDOMAIN) -and [string]::IsNullOrEmpty($searchRoot)) {
				Write-Error "Security group filtering won't work because `$env:USERDNSDOMAIN is not available!"
				Write-Warning "You can override your AD Domain in the `$overrideUserDnsDomain variable"
			}
			else {

				# if no domain specified fallback to PowerShell environment variable
				if ([string]::IsNullOrEmpty($searchRoot)) {
					$searchRoot = $env:USERDNSDOMAIN
				}

				$searcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher
				$searcher.Filter = "(&(userprincipalname=$UserPrincipalName))"
				$searcher.SearchRoot = "LDAP://$searchRoot"
				$distinguishedName = $searcher.FindOne().Properties.distinguishedname
				$searcher.Filter = "(member:1.2.840.113556.1.4.1941:=$distinguishedName)"

				[void]$searcher.PropertiesToLoad.Add("name")

				$list = [System.Collections.Generic.List[String]]@()

				$results = $searcher.FindAll()

				foreach ($result in $results) {
					$resultItem = $result.Properties
					[void]$List.add($resultItem.name)
				}

				$list
			}
		}
		catch {
			#Nothing we can do
			Write-Warning $_.Exception.Message
		}
	}
}

#check if running as system
function Test-RunningAsSystem {
	[CmdletBinding()]
	param()
	process {
		return [bool]($(whoami -user) -match "S-1-5-18")
	}
}

###########################################################################################
# Get current group membership for the group filter capabilities
###########################################################################################

Write-Output "Running as SYSTEM: $(Test-RunningAsSystem)"

if ($driveMappingConfig.GroupFilter) {
	try {
		#check if running as user and not system
		if (-not (Test-RunningAsSystem)) {

			$groupMemberships = Get-ADGroupMembership -UserPrincipalName $(whoami -upn)
		}
	}
	catch {
		#nothing we can do
	}
}
###########################################################################################
# Mapping network drives
###########################################################################################
#Get PowerShell drives and rename properties

if (-not (Test-RunningAsSystem)) {

	$psDrives = Get-PSDrive | Where-Object { $_.Provider.Name -eq "FileSystem" -and $_.Root -notin @("$env:SystemDrive\", "D:\") } `
	| Select-Object @{N = "DriveLetter"; E = { $_.Name } }, @{N = "Path"; E = { $_.DisplayRoot } }

	# only map drives where group membership applicable
	#$driveMappingConfig = $driveMappingConfig | Where-Object { ($groupMemberships -contains $_.GroupFilter -or $_.GroupFilter -eq $null) -and ($groupMemberships -notcontains $_.NotGroupFilter -or $_.NotGroupFilter -eq $null) }

    $driveMappingConfigCleaned = @() 
    foreach ($mapping in $driveMappingConfig) { 
        if($mapping.GroupFilter -ne $null -and $mapping.GroupFilter.Contains(",")) { 
            $Agroups = $mapping.GroupFilter.Split(",") 
            foreach ($Agroup in $Agroups) { 
                if ($groupMemberships -contains $Agroup) { 
                    $mapping.GroupFilter = $Agroup 
                    $driveMappingConfigCleaned += $mapping 
                    break 
                } 
            } 
        } else { 
            if ($groupMemberships -contains $mapping.GroupFilter -or [String]::IsNullOrWhiteSpace($mapping.GroupFilter)) { 
                $driveMappingConfigCleaned += $mapping 
            } 
        }
    } 
    $driveMappingConfig = $driveMappingConfigCleaned

	#iterate through all network drive configuration entries
	foreach ($drive in $driveMappingConfig) {

		try {
			#check if variable in unc path exists, e.g. for $env:USERNAME -> resolving
			if ($drive.Path -match '\$env:') {
				$drive.Path = $ExecutionContext.InvokeCommand.ExpandString($drive.Path)
			}

			#if label is null we need to set it to empty in order to avoid error
			if ($null -eq $drive.Label) {
				$drive.Label = ""
			}

			$exists = $psDrives | Where-Object { $_.Path -eq $drive.Path -or $_.DriveLetter -eq $drive.DriveLetter }
			$process = $true

			if ($null -ne $exists -and $($exists.Path -eq $drive.Path -and $exists.DriveLetter -eq $drive.DriveLetter )) {
				Write-Output "Drive '$($drive.DriveLetter):\' '$($drive.Path)' already exists with correct Drive Letter and Path"
				$process = $false

			}
			else {
				# Mapped with wrong config -> Delete it
				Get-PSDrive | Where-Object { $_.DisplayRoot -eq $drive.Path -or $_.Name -eq $drive.DriveLetter } | Remove-PSDrive -EA SilentlyContinue
			}

			if ($process) {
				Write-Output "Mapping network drive $($drive.Path)"
				$null = New-PSDrive -PSProvider FileSystem -Name $drive.DriveLetter -Root $drive.Path -Description $drive.Label -Persist -Scope global -EA Stop
				(New-Object -ComObject Shell.Application).NameSpace("$($drive.DriveLetter):").Self.Name = $drive.Label
			}
		}
		catch {
			$available = Test-Path $($drive.Path)
			if (-not $available) {
				Write-Error "Unable to access path '$($drive.Path)' verify permissions and authentication!"
			}
			else {
				Write-Error $_.Exception.Message
			}
		}
	}

	# Remove unassigned drives
	if ($removeStaleDrives -and $null -ne $psDrives) {
		$diff = Compare-Object -ReferenceObject $driveMappingConfig -DifferenceObject $psDrives -Property "DriveLetter" -PassThru | Where-Object { $_.SideIndicator -eq "=>" }
		foreach ($unassignedDrive in $diff) {
			Write-Warning "Drive '$($unassignedDrive.DriveLetter)' has not been assigned - removing it..."
			Remove-SmbMapping -LocalPath "$($unassignedDrive.DriveLetter):" -Force -UpdateProfile
		}
	}

	# Fix to ensure drives are mapped as persistent!
	$null = Get-ChildItem -Path HKCU:\Network -ErrorAction SilentlyContinue | ForEach-Object { New-ItemProperty -Name ConnectionType -Value 1 -Path $_.PSPath -Force -ErrorAction SilentlyContinue }
}

###########################################################################################
# End & finish transcript
###########################################################################################

Stop-transcript

###########################################################################################
# Done
###########################################################################################

#!SCHTASKCOMESHERE!#

###########################################################################################
# If this script is running under system (IME) scheduled task is created  (recurring)
###########################################################################################

if (Test-RunningAsSystem) {

	Start-Transcript -Path $(Join-Path -Path $env:temp -ChildPath "IntuneDriveMappingScheduledTask.log")
	Write-Output "Running as System --> creating scheduled task which will run on user logon"

	###########################################################################################
	# Get the current script path and content and save it to the client
	###########################################################################################

	$currentScript = Get-Content -Path $($PSCommandPath)

	$schtaskScript = $currentScript[(0) .. ($currentScript.IndexOf("#!SCHTASKCOMESHERE!#") - 1)]

	$scriptSavePath = $(Join-Path -Path $env:ProgramData -ChildPath "intune-drive-mapping-generator")

	if (-not (Test-Path $scriptSavePath)) {

		New-Item -ItemType Directory -Path $scriptSavePath -Force
	}

	$scriptSavePathName = "DriveMapping.ps1"

	$scriptPath = $(Join-Path -Path $scriptSavePath -ChildPath $scriptSavePathName)

	$schtaskScript | Out-File -FilePath $scriptPath -Force

	###########################################################################################
	# Create dummy vbscript to hide PowerShell Window popping up at logon
	###########################################################################################

	$vbsDummyScript = "
	Dim shell,fso,file

	Set shell=CreateObject(`"WScript.Shell`")
	Set fso=CreateObject(`"Scripting.FileSystemObject`")

	strPath=WScript.Arguments.Item(0)

	If fso.FileExists(strPath) Then
		set file=fso.GetFile(strPath)
		strCMD=`"powershell -nologo -executionpolicy ByPass -command `" & Chr(34) & `"&{`" &_
		file.ShortPath & `"}`" & Chr(34)
		shell.Run strCMD,0
	End If
	"

	$scriptSavePathName = "IntuneDriveMapping-VBSHelper.vbs"

	$dummyScriptPath = $(Join-Path -Path $scriptSavePath -ChildPath $scriptSavePathName)

	$vbsDummyScript | Out-File -FilePath $dummyScriptPath -Force

	$wscriptPath = Join-Path $env:SystemRoot -ChildPath "System32\wscript.exe"

	###########################################################################################
	# Register a scheduled task to run for all users and execute the script on logon
	###########################################################################################

	$schtaskName = "IntuneDriveMapping"
	$schtaskDescription = "Map network drives from intune-drive-mapping-generator."

	$trigger = New-ScheduledTaskTrigger -AtLogOn
	#Execute task in users context
	$principal = New-ScheduledTaskPrincipal -GroupId "S-1-5-32-545" -Id "Author"
	#call the vbscript helper and pass the PosH script as argument
	$action = New-ScheduledTaskAction -Execute $wscriptPath -Argument "`"$dummyScriptPath`" `"$scriptPath`""
	$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

	$null = Register-ScheduledTask -TaskName $schtaskName -Trigger $trigger -Action $action  -Principal $principal -Settings $settings -Description $schtaskDescription -Force

	Start-ScheduledTask -TaskName $schtaskName

	Stop-Transcript
}

###########################################################################################
# Done
###########################################################################################