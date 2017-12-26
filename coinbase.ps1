Param([string]$file="", [string]$out="", [string]$fromTicker="")

# Export report type "Buys, sells and merchant payouts". Remove header in file manually.
$history = Import-Csv ($file +".csv")
$export = @()

$history | ForEach { 
    $obj = New-Object System.Object
    $obj | Add-Member -Name 'Exchange' -Type NoteProperty -Value "Coinbase"
    $obj | Add-Member -Name 'Type' -Type NoteProperty -Value $_.Type.ToLower()
    $obj | Add-Member -Name 'Timestamp' -Type NoteProperty -Value  ([datetime]($_.Timestamp))
    $obj | Add-Member -Name 'Amount' -Type NoteProperty -Value $_.BTC
    $obj | Add-Member -Name 'Currency' -Type NoteProperty -Value $fromTicker
    $obj | Add-Member -Name 'Price' -Type NoteProperty -Value $_."Price Per Coin"
    $obj | Add-Member -Name 'Price Currency' -Type NoteProperty -Value $_.Currency
    $obj | Add-Member -Name 'Fees' -Type NoteProperty -Value $_.Fees
    $obj | Add-Member -Name 'Fees Currency' -Type NoteProperty -Value $_.Currency
    $export += $obj
}

$export | Export-CSV ($out +".csv") -NoTypeInformation
