Param([string]$exportFolder="", [string]$out="")
$export = @()
$exportFiles = Get-ChildItem $exportFolder -Filter *.csv | ForEach {
    Import-Csv $_.FullName | ForEach { $export += $_ }
}

function ConvertToNok {
    Param($value, $currency, $timestamp)

    # To avoid requesting cryptocurrencies.

    If(@("NOK", "USD", "EUR", "GBP") -contains $currency) {
        $uri = "https://api.fixer.io/" + ($timestamp -split " ")[0] + "?base=" + $currency + "&symbols=NOK"

        $response = Invoke-RestMethod -Uri $uri
        Start-Sleep -m 1000

        return $response.rates.NOK
    } else {
        return 0;
    }
}

$export | ForEach { 
    Write-Host $_
    $_.Timestamp = get-date $_.Timestamp -f 'yyyy-MM-dd hh:mm:ss'
    $inNok = ConvertToNok $_.Price $_."Price Currency" $_.Timestamp
    $_ | Add-Member -Name 'Price in NOK' -Type NoteProperty -Value $inNok
}

$export | Sort-Object Timestamp -descending | Export-CSV ($out + ".csv") -NoTypeInformation