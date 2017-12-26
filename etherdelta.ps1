Param([string]$file="", [string]$out="")

$history = Import-Csv ($file +".csv")

$export = @()

$history | ForEach { 
    $obj = New-Object System.Object
    $obj | Add-Member -Name 'Exchange' -Type NoteProperty -Value "Etherdelta"
    $obj | Add-Member -Name 'Type' -Type NoteProperty -Value $_.Trade.ToLower()
    $obj | Add-Member -Name 'Timestamp' -Type NoteProperty -Value ([datetime]($_.Date))
    $obj | Add-Member -Name 'Amount' -Type NoteProperty -Value $_.Amount
    $obj | Add-Member -Name 'Currency' -Type NoteProperty -Value $_.Token
    $obj | Add-Member -Name 'Price' -Type NoteProperty -Value $_."Price (ETH)"
    $obj | Add-Member -Name 'Price Currency' -Type NoteProperty -Value "ETH"
    $obj | Add-Member -Name 'Fees' -Type NoteProperty -Value $_.Fee
    $obj | Add-Member -Name 'Fees Currency' -Type NoteProperty -Value $_.FeeToken
    $export += $obj
}

$export | Export-CSV ($out +".csv") -NoTypeInformation