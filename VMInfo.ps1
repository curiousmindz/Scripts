#Created log file

$erroraction = $ErrorActionPreference

$ErrorActionPreference = "silentlyContinue"

New-Item -Path c:\ -ItemType File -Name GetSystemInfoLog.txt >> $null

$LOG = "c:\GetSystemInfoLog.txt"

write-output "#############################  START  #####################################" >> $LOG
Function Get-SystemInfo 

{
 
# Dell Program istalled ? 
write-output "############################## DELL PRogram ChecK ############################################" >> $LOG
$GetDellProg = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | ? {$_.Publisher -eq "Dell"} | Select Displayname, Displayversion

if ($GetDellProg){

#there is a software on the system that is dell Log it
$GetDellProg  >> $Log
}

write-output "########################### ISCSI Information ###################################### " >> $LOG
$GetIscsiTargets = iscsicli ListPersistentTargets

if ($?){
# Iscsi service is running

if ($GetIscsiTargets){
#the variable has the list of targets

$GetIscsiTargets >> $log

}

}

write-output "########################## Network Provide Order ################################### " >> $LOG

#GetNetworkProviderorder :
$NetworkProvider = Get-ItemProperty -path HKLM:\SYSTEM\CurrentControlSet\Control\NetworkProvider\Order -name providerorder | select -ExpandProperty providerorder

if ($NetworkProvider){
# Network provider information is recorded
	$NetworkProvider >> $LOG
}

write-output "############################### IfConfig Info ##################################" >> $LOG
#Network ipconfig /all 
$ipconfigall = ipconfig /all

if ($ipconfigall){

$ipconfigall >> $LOG

}

write-output "################################## Services and Status ############################ "  >> $LOG
#List of Running services 
$listofallservices = Get-Service
$listofallservices >> $LOG


write-output "################################### Nic Binding Order ###########################"  >> $LOG
#Get nic Binding order 
#Get the nics and their GUID and Decription  
$NicDecGUID = CMD /C "wmic nicconfig get Description,SettingID" 
$NicDecGUID >> $LOG
#Get the matching EXPORT,ROUTE and BIND Registry settings

$NicBind =  Get-ItemProperty -path HKLM:\System\CurrentControlSet\Services\Tcpip\Linkage\ | select -ExpandProperty Bind
$NicExport = Get-ItemProperty -path HKLM:\System\CurrentControlSet\Services\Tcpip\Linkage\ | select -ExpandProperty Export
$NicRoute = Get-ItemProperty -path HKLM:\System\CurrentControlSet\Services\Tcpip\Linkage\ | select -ExpandProperty Route
    
$NicBind >> $LOG
$NicExport >> $LOG
$NicRoute >> $LOG


write-output "################################# Drive Info ################################ "  >> $LOG
#Get Disk Information 

$strComputer = "." 
$colItems = get-wmiobject -class "Win32_DiskDrive" -namespace "root\CIMV2" -computername $strComputer 
 
foreach ($objItem in $colItems) { 
      Write-Output "Bytes Per Sector:  $($objItem.BytesPerSector)  " >> $LOG
      Write-Output "Capabilities:  $($objItem.Capabilities)  ">> $LOG
      write-output "Caption: $($objItem.Caption)  ">> $LOG
      Write-Output "Capability Descriptions:  $($objItem.CapabilityDescriptions )  ">> $LOG
      Write-Output "Compression Method:  $($objItem.CompressionMethod )  ">> $LOG
      Write-Output "Configuration Manager Error Code: $( $objItem.ConfigManagerErrorCode)  " >> $LOG
      Write-Output "Configuration Manager User Configuration:  $($objItem.ConfigManagerUserConfig)  " >> $LOG
      Write-Output "Creation Class Name:  $($objItem.CreationClassName )  ">> $LOG
      Write-Output "Description:  $($objItem.Description )  ">> $LOG
      Write-Output "Device ID:  $($objItem.DeviceID )  ">> $LOG
      Write-Output "Interface Type:  $($objItem.InterfaceType)  " >> $LOG
      Write-Output "Manufacturer:  $($objItem.Manufacturer )  ">> $LOG
      Write-Output "Media Loaded: $($objItem.MediaLoaded )  ">> $LOG
      Write-Output "Media Type:  $($objItem.MediaType )  ">> $LOG
      Write-Output "Model:  $($objItem.Model )  ">> $LOG
      Write-Output "Name:  $($objItem.Name )  ">> $LOG
      Write-Output "Partitions:  $($objItem.Partitions)  " >> $LOG
      Write-Output "PNP Device ID:  $($objItem.PNPDeviceID )  ">> $LOG
      Write-Output "SCSI Bus:  $($objItem.SCSIBus )  ">> $LOG
      Write-Output "SCSI Logical Unit:  $($objItem.SCSILogicalUnit)" >> $LOG
      Write-Output "SCSI Port:  $($objItem.SCSIPort )">> $LOG
      Write-Output "SCSI Target ID:  $($objItem.SCSITargetId)" >> $LOG
      Write-Output "Sectors Per Track:  $($objItem.SectorsPerTrack)" >> $LOG
      Write-Output "Signature:  $($objItem.Signature )">> $LOG
      Write-Output "Size:  $($objItem.Size )">> $LOG
      Write-Output "Status:  $($objItem.Status)" >> $LOG
      Write-Output "Status Information:  $($objItem.StatusInfo)" >> $LOG
      Write-Output "System Creation Class Name: $($objItem.SystemCreationClassName)" >> $LOG
      Write-Output "System Name:  $($objItem.SystemName )">> $LOG
      Write-Output "Total Cylinders: $($objItem.TotalCylinders)" >> $LOG
      Write-Output "Total Heads:  $($objItem.TotalHeads )">> $LOG
      Write-Output "Total Sectors:  $($objItem.TotalSectors)" >> $LOG
      Write-Output "Total Tracks:  $($objItem.TotalTracks )">> $LOG
      Write-Output "Tracks Per Cylinder:  $($objItem.TracksPerCylinder)">> $LOG

}

write-output "#################################### Advance Network Card Config #############################"  >> $LOG

#get the advance configurations of the nics on system
$advancenetconfig = Get-ChildItem -Recurse -Path "HKLM:System\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" 
$advancenetconfig >> $LOG


Write-Output "################################ END of Function ###################################" >> $LOG

#Main Fundtions end
}

#call the function

Get-SystemInfo



$ErrorActionPreference = $($erroraction)
