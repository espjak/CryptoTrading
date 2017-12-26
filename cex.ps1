Param([string]$file="", [string]$out="")

$history = Import-Csv ($file +".csv") | where-object { $_.Comment -like "Bought *" -or $_.Comment -like "Sold *" }

$fromTicker = "ETH"
$export = @()

$history = $history | Where-Object { $_.Comment -match "([0-9.]* $fromTicker at)"}

$history | ForEach {
    $obj = New-Object System.Object
    $obj | Add-Member -Name 'Exchange' -Type NoteProperty -Value "CEX.IO"
    $obj | Add-Member -Name 'Type' -Type NoteProperty -Value $_.Type.ToLower()
    $obj | Add-Member -Name 'Timestamp' -Type NoteProperty -Value  ([datetime]($_.DateUTC))
    $obj | Add-Member -Name 'Amount' -Type NoteProperty -Value ($_.Comment -split ("([0-9.]*) " + $fromTicker))[1]
    $obj | Add-Member -Name 'Currency' -Type NoteProperty -Value $fromTicker
    $priceCurrency = ($_.Comment -split " ")[-1]
    $obj | Add-Member -Name 'Price' -Type NoteProperty -Value ($_.Comment -split ("([0-9.]*) " + $priceCurrency))[1]
    $obj | Add-Member -Name 'Price Currency' -Type NoteProperty -Value $priceCurrency
    $obj | Add-Member -Name 'Fees' -Type NoteProperty -Value $_.FeeAmount
    $obj | Add-Member -Name 'Fees Currency' -Type NoteProperty -Value $_.FeeSymbol
    $export += $obj
}

$export | Export-CSV ($out +".csv") -NoTypeInformation
