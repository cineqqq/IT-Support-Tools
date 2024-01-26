#Created by Marcin Zelezny
#Requirements - .csv file named "assets.csv" in location C:\tmp
#Requirements - Row with assets named "Asset_Name"

$hosts=Import-Csv -Path "C:\tmp\assets.csv" -Delimiter ";"
$quantity=$hosts.Count -1
$x=0
$hosts_restarted=""
$hosts_not_restarted=""
$detailed_logs=""
$ErrorActionPreference = 'Stop'

while ($x -le $quantity)
{
    $hostname=$hosts.Asset_Name[$x]
    $test = ""
    try
    {
        shutdown -f -g -t 60 /m \\$hostname /c "The computer will be restarted within 1 minute. Please save your work otherwise it will be lost."
        Write-Host $hostname " restarted"
        $hosts_restarted=$hosts_restarted + $hostname + ", "
    }
    catch
    {
        Write-Host "Error: $_"
        $hosts_not_restarted=$hosts_not_restarted +$hostname +", "
        $detailed_logs= $detailed_logs + $_ + "`n"
    }
             
    $x++
}

$result="Hosts restarted:`n" + $hosts_restarted + "`n`n" + "Hosts not restarted:`n" + $hosts_not_restarted  + "`n`n`n" + "Detailed logs: `n" + $detailed_logs | Out-File -FilePath "C:\tmp\restart_output.txt"