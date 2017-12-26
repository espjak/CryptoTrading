Param([string]$file="", [string]$out="")

$history = Get-Content -Raw -Path $file | ConvertFrom-Json

$export = @()

$history.PSObject.Properties | ForEach { 
    $val = $_.value;
    $obj = New-Object System.Object
    $obj | Add-Member -Name 'Exchange' -Type NoteProperty -Value "Liqui"
    $currency = ($val.pair -split "_")[0].ToUpper()
    $priceCurrency = ($val.pair -split "_")[-1].ToUpper()
    $obj | Add-Member -Name 'Type' -Type NoteProperty -Value $val.type
    $obj | Add-Member -Name 'Timestamp' -Type NoteProperty -Value ([datetime]'1/1/1970').AddMilliseconds($val.timestamp * 1000)
    $obj | Add-Member -Name 'Amount' -Type NoteProperty -Value $val.amount
    $obj | Add-Member -Name 'Currency' -Type NoteProperty -Value $currency
    $obj | Add-Member -Name 'Price' -Type NoteProperty -Value $val.rate
    $obj | Add-Member -Name 'Price Currency' -Type NoteProperty -Value $priceCurrency
    $obj | Add-Member -Name 'Fees' -Type NoteProperty -Value 0
    $obj | Add-Member -Name 'Fees Currency' -Type NoteProperty -Value $priceCurrency
    $export += $obj
}

$export | Export-CSV ($out + ".csv") -NoTypeInformation