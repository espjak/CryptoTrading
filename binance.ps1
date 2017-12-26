Param([string]$file="", [string]$out="")

#Save the XLSX as CSV using Google Sheets or some other tool.
$fromTicker = "ETH";
$history = Import-Csv ($file +".csv")

$export = @()

$history | ForEach { 
    $obj = New-Object System.Object
    $obj | Add-Member -Name 'Exchange' -Type NoteProperty -Value "Binance"
    $obj | Add-Member -Name 'Type' -Type NoteProperty -Value $_.Type.ToLower()
    $obj | Add-Member -Name 'Timestamp' -Type NoteProperty -Value ([datetime]($_.Date))
    $obj | Add-Member -Name 'Amount' -Type NoteProperty -Value $_.Amount
    $obj | Add-Member -Name 'Currency' -Type NoteProperty -Value ($_.Market -split $fromTicker)[0]
    $obj | Add-Member -Name 'Price' -Type NoteProperty -Value $_.Price
    $obj | Add-Member -Name 'Price Currency' -Type NoteProperty -Value ($_.Market -split $obj.Currency)[1]
    $obj | Add-Member -Name 'Fees' -Type NoteProperty -Value $_.Fee
    $obj | Add-Member -Name 'Fees Currency' -Type NoteProperty -Value $_."Fee Coin"
    $export += $obj
}

$export | Export-CSV ($out +".csv") -NoTypeInformation
