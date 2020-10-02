$data = @()
$Data += "subscription, resourceName, resourceID, rgName, resourceType, location, DiagSettingsEnabled"
$subscription = (Get-AzContext).Subscription.Name
$allresources = Get-AzResource -ErrorAction SilentlyContinue | select *

$allresources | foreach{
    $resourceID = $psitem.ResourceId
    $resourceName = $psitem.ResourceName
    $rgname = $psitem.ResourceGroupName
    $resourceType = $psitem.ResourceType
    #$kind = $psitem.Kind
    $location = $psitem.Location



    $DiagSettings = Get-AzDiagnosticSetting -ResourceId $resourceID -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
    if($DiagSettings){
        $DiagSettingsEnabled = $true
        $Data += "$subscription, $resourceName, $resourceID, $rgName, $resourceType, $location, $DiagSettingsEnabled"


    }else{
        $DiagSettingsEnabled = $false

        $Data += "$subscription, $resourceName, $resourceID, $rgName, $resourceType, $location, $DiagSettingsEnabled"


    }



}

$data | out-file "file.csv"
