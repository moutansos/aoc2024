$inputFile = "$PSScriptRoot/day1-input.txt"
$input = Get-Content $inputFile -Raw

[string[]] $inputLines = $input.Split("`n") | ForEach-Object { $_.Trim() }

[int[]]$leftNumbersUnsorted = @()
[int[]]$rightNumbersUnsorted = @()

[hashtable]$rightFrequency = @{ }
    
foreach ($line in $inputLines) {
    [string[]] $numbers = $line.Split(" ") | Where-Object { $_.Trim() -ne "" }
    if ($numbers.Length -ne 2) {
        continue
    }

    [int]$leftNum = $numbers[0]
    [int]$rightNum = $numbers[1]
    
    $leftNumbersUnsorted += $leftNum
    $rightNumbersUnsorted += $rightNum

    if($rightFrequency.ContainsKey($rightNum)) {
        $rightFrequency[$rightNum] = $rightFrequency[$rightNum] + 1
    } else {
        $rightFrequency[$rightNum] = 1
    }
}

$leftNumbersSorted = $leftNumbersUnsorted | Sort-Object
$rightNumbersSorted = $rightNumbersUnsorted | Sort-Object

$total = 0
$similarity = 0
for ($i = 0; $i -lt $leftNumbersSorted.Count; $i++) {
    $leftNum = $leftNumbersSorted[$i]
    $rightNum = $rightNumbersSorted[$i]

    $distance = [System.Math]::Abs($leftNum - $rightNum)
    $total += $distance
    $similarity += $leftNum * $rightFrequency[$leftNum]
}

Write-Host "Distance: $total"
Write-Host "Similarity: $similarity"
