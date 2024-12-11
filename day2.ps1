$inputFile = "$PSScriptRoot/day2-input.txt"
# $inputFile = "$PSScriptRoot/day2-tester.txt"

[string]$rawInput = Get-Content $inputFile -Raw
[string[]]$inputLines = $rawInput.Split("`n").Trim()

function Get-MutationsOfTemps
{
    param (
        [Parameter(Mandatory)]
        [int[]]
        $Temps
    )

    [int[][]]$result = @(
        ,$Temps
    )

    for($i = 0; $i -lt $Temps.Length; $i++)
    {
        [int[]]$newTempsArray = @()
        for($j = 0; $j -lt $Temps.Length; $j++)
        {
            if($i -ne $j)
            {
                $newTempsArray += $Temps[$j]
            }
        }

        # Write-Host "SubArray: $($newTempsArray | ConvertTo-Json)"
        $result += ,$newTempsArray
    }

    # Write-Host "Result Array: $($result | ConvertTo-Json)"

    return $result
}

[int]$count = 0
:outer foreach($line in $inputLines)
{
    if ([string]::IsNullOrEmpty($line)) {
        continue
    }
    [int[]]$temps = $line.Split(" ")
    [int[][]]$allTempMutations = Get-MutationsOfTemps $temps

    # Write-Host "Temp Mutations: $($allTempMutations  | ConvertTo-Json)"

    [int]$infractionCount = 0
    [int]$worksCount = 0
    :inner foreach($tempMutation in $allTempMutations)
    {
        # if($infractionCount -gt 1)
        # {
        #     continue inner
        # }

        [int]$temp1 = $tempMutation[0]
        [int]$temp2 = $tempMutation[1]

        if($temp1 -eq $temp2)
        {
            $infractionCount++
            continue inner
        } 
        elseif($temp1 -gt $temp2)
        {
            for($i = 0; $i -lt $tempMutation.Length - 1; $i++)
            {
                [int]$temp = $tempMutation[$i]
                [int]$nextTemp = $tempMutation[$i + 1]
                [int]$threshold = $temp - 3

                if($temp -le $nextTemp)
                {
                    $infractionCount++
                    continue inner
                }

                if($nextTemp -lt $threshold)
                {
                    $infractionCount++
                    continue inner
                }
            }
        } 
        elseif ($temp1 -lt $temp2)
        {
            for($i = 0; $i -lt $tempMutation.Length - 1; $i++)
            {
                [int]$temp = $tempMutation[$i]
                [int]$nextTemp = $tempMutation[$i + 1]
                [int]$threshold = $temp + 3

                if($temp -ge $nextTemp)
                {
                    $infractionCount++
                    continue inner
                }

                if($nextTemp -gt $threshold)
                {
                    $infractionCount++
                    continue inner
                }
            }
        }

        $worksCount++
    }

    if($worksCount -gt 0) {
        Write-Host "Entry: `"$line`" was marked as safe"
        $count++
    } else {
        Write-Host "Entry: `"$line`" was marked as unsafe"
    }
}

Write-Host "Safe Entries: $count"
Write-Host "Total Entries: $($inputLines.Length)"
