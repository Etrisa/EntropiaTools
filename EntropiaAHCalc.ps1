#AH Fee is calculated with this math:
#0.5 + ($markupPED * 99.5) / (1990 + $markupPED)

#$nItems = 2095
#$totalTT = 20.95
#$markupLP = 102
#$markupHP = 105

$nItems = Read-Host -Prompt 'Total number of items'
$totalTT = Read-Host -Prompt 'Total TT Value'
$markupLP = Read-Host -Prompt 'Lowest Markup %'
$markupHP = Read-Host -Prompt 'Highest Markup %'

$TTitem = $TotalTT / $nItems

$data = New-Object System.Collections.Generic.List[System.Object]

for ($i = 1; $i -le $nItems; $i++) {
    $stackValue = $i * $TTitem
    $sellPrice = [math]::ceiling($stackValue)

    while ($true) {
        if ($sellPrice / $stackValue * 100 -ge $markupLP -and $sellPrice / $stackValue * 100 -le $markupHP) {
            $markupP = ($sellPrice / $stackValue).ToString("P")
            $markupPED = $sellPrice - $stackValue
            $AHFee = 0.5 + ($markupPED * 99.5) / (1990 + $markupPED)
            $AHFee = [Math]::Truncate($AHFee * 100) / 100
            $PEDProfit = $markupPED - $AHFee

            if ($PEDProfit -gt 0) {
                $data.add([PSCustomObject]@{
                        nItems     = $i
                        SellAmount = $sellPrice
                        Markup     = $markupP
                        PEDProfit  = [Math]::Truncate($PEDProfit * 100) / 100
                    })
            }
        }
        if ($sellPrice / $stackValue * 100 -gt $markupHP) {
            break
        }
        $sellPrice++
    }
}

Write-Host "------------------------------------"
$data = $data | Sort-Object -Property PEDProfit -Desc | Select -First 10  | Out-String
Write-Host $data

write-host "Done, press any key to close the script.";
cmd /c pause | out-null;