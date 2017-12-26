Param([string]$file="", [string]$out="")

# Remember to change encoding to UTF-8 before importing.
$history = Import-Csv -LiteralPath ($file +".csv") -Encoding ASCII

$export = @()

$history | ForEach { 
    $obj = New-Object System.Object
    $obj | Add-Member -Name 'Exchange' -Type NoteProperty -Value "Bittrex"
    $type = ($_.Type -split "_")[-1].ToLower()
    $currency = ($_.Exchange -split "-")[-1]
    $priceCurrency = ($_.Exchange -split "-")[0]
    $obj | Add-Member -Name 'Type' -Type NoteProperty -Value $type
    $obj | Add-Member -Name 'Timestamp' -Type NoteProperty -Value ([datetime]($_.Closed))
    $obj | Add-Member -Name 'Amount' -Type NoteProperty -Value $_.Quantity
    $obj | Add-Member -Name 'Currency' -Type NoteProperty -Value $currency
    $obj | Add-Member -Name 'Price' -Type NoteProperty -Value $_.Limit
    $obj | Add-Member -Name 'Price Currency' -Type NoteProperty -Value $priceCurrency
    $obj | Add-Member -Name 'Fees' -Type NoteProperty -Value $_.CommissionPaid
    $obj | Add-Member -Name 'Fees Currency' -Type NoteProperty -Value $priceCurrency
    $export += $obj
}

$export | Export-CSV ($out + ".csv") -NoTypeInformation