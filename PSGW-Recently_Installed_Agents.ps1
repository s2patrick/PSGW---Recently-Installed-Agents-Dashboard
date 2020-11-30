# This script shows all recently installed Agents from a SCOM Management Group.
# Script can be used in SCOM 2012 R2 UR2 (or newer) Dashboards using PowerShell Grid Widget.
#
# Author:  Patrick Seidl
# Company: Syliance IT Services
# Website: www.syliance.com
# Blog:    www.SystemCenterRocks.com
#
# Please rate if you like it:
# https://gallery.technet.microsoft.com/systemcenter/PSGW-Recently-Installed-309f8d8b

$LastDays = "-7"

$allAgents = Get-SCOMAgent

foreach ($Agent in $allAgents) {
    $dataObject = $ScriptContext.CreateInstance("xsd://foo!bar/baz")
    if ($Agent.InstallTime -ge [DateTime]::Now.AddDays($LastDays)) {
		$foundData = $true
        $dataObject["Id"] = [String]($Agent.PrincipalName)
        $dataObject["Principal Name"] = [String]($Agent.PrincipalName)
        $dataObject["Install Time"] = [String]($Agent.InstallTime)
        $dataObject["Installed By"] = [String]($Agent.InstalledBy)
    }
	if ($error) {
		$dataObject["Error"] = [String]($error)
		$error.clear()
	}
    $ScriptContext.ReturnCollection.Add($dataObject)
}

if (!($foundData)) {
	$dataObject = $ScriptContext.CreateInstance("xsd://foo!bar/baz")
    $dataObject["Id"] = [String]("NoData")
    $dataObject["Agent Name"] = [String]("No Data within $LastDays days")
    $dataObject["Last Modified"] = [String]("")
    $dataObject["Pending Type"] = [String]("")
	$ScriptContext.ReturnCollection.Add($dataObject)
}
