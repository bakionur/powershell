$data = @()
$data+="subname, starttime,endtime,aspname,cpupercentage,memorypercentage"


$startTime = "2020-12-05T00:00"
$endTime = "2020-12-09T00:00"



$ASPs = Get-AzAppServicePlan

foreach($asp in $ASPs){
$ID = $asp.ID
$aspName = $asp.name

$CPUPercentage = (Get-AzMetric -ResourceId "$ID" -TimeGrain 00:01:00 -StartTime $startTime -EndTime $endTime -MetricName "CPUPercentage" -DetailedOutput | select -ExpandProperty data | measure average -Average).AVERAGE

$MemoryPercentage = (Get-AzMetric -ResourceId "$ID" -TimeGrain 00:01:00 -StartTime $startTime -EndTime $endTime -MetricName "MemoryPercentage" -DetailedOutput | select -ExpandProperty data | measure average -Average).AVERAGE

$data +=  "$subname, $starttime, $endtime, $aspname, $cpupercentage, $memorypercentage"

}

$data | convertfrom-csv
$data | ft


$outputstarttime = $startTime.replace(":","_")
$outputendtime = $endTime.replace(":","_")
$outputsubname = $subname.replace(" ", "_")

$outputfilename = ".\"+$outputsubname+"_"+$outputstarttime+"_"+$outputendtime+".csv"

$data | out-file $outputfilename
