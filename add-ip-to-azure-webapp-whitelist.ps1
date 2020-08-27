$date = ([string](get-date).day) + "-" + ([string](get-date).Month) + "-" + ([string](get-date).Year)
$priority = 9876
$rulename = "ADOBuildAgentPublicIP-$date"
$IPAddress = irm http://ipinfo.io/json | select -exp ip

$existingRules = Get-AzWebAppAccessRestrictionConfig -ResourceGroupName "" -Name "" | select -ExpandProperty MainSiteAccessRestrictions

Add-AzWebAppAccessRestrictionRule -ResourceGroupName "" -WebAppName "" -Name $rulename  -Priority $priority -Action Allow -IpAddress "$IPAddress/32"

######

$finalconfig = Get-AzWebAppAccessRestrictionConfig -ResourceGroupName "" -Name ""

if($finalconfig.MainSiteAccessRestrictions.rulename -contains $rulename){

Remove-AzWebAppAccessRestrictionRule -ResourceGroupName "" -WebAppName "" -Name $rulename

}
