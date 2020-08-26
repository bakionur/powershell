####

[securestring]$password = ConvertTo-SecureString $pass -AsPlainText -Force

[pscredential]$cred1 = New-Object System.Management.Automation.PSCredential ($user, $Password)


[securestring]$SPpassword = ConvertTo-SecureString $SPpass -AsPlainText -Force
[pscredential]$SPcred = New-Object System.Management.Automation.PSCredential ($SPuser, $SPpassword)

Connect-PnPOnline -Url $spsite -Credentials $SPcred


function Get-FtpDir ($url, $credentials) {
    $url = $url1
    $credentials = $cred1

    $webclient = New-Object System.Net.WebClient 
    $webclient.Credentials = $credentials 

	$request = [Net.WebRequest]::Create($url)
	$request.Method = [System.Net.WebRequestMethods+FTP]::ListDirectory

	if ($credentials) { $request.Credentials = $credentials }
	
	$response = $request.GetResponse()
	$reader = New-Object IO.StreamReader $response.GetResponseStream() 

	
	while(-not $reader.EndOfStream) {
		$reader.ReadLine()
	}
	
	$reader.Close()
	$response.Close()
}



$files=Get-FTPDir


if($files.count -gt 0){



foreach($file in $files){
$FTPtargetfolder = "$psscriptroot"
$FTPfilename = $file


$source = "$url1/$FTPfilename"
$dest = "archive/$file"


$client = New-Object System.Net.WebClient
$client.Credentials = $cred1

$client.DownloadFile("$source", "$FTPtargetfolder\$FTPfilename")

Add-PnPFile -Folder "Shared Documents" -Path "$FTPtargetfolder\$FTPfilename"


# Move the file

$ftp = [System.Net.FtpWebRequest]::Create($source)
$ftp.Credentials = $cred1
$ftp.KeepAlive = $true
$ftp.UsePassive = $true
$ftp.Method = "Rename"
$ftp.RenameTo = $dest
$ftp.UseBinary = $true
$response = [System.Net.FtpWebResponse] $ftp.GetResponse()


}


}


