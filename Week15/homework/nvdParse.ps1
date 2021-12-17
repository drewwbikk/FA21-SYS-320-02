<#

    .SYNOPSIS
        Script to parse the latest NVD dataset feed.

    .Description
        This file will parse a json file and return the results as a CSV file.

    .Example
        .\nvdParse.ps1 -y "2020" -k "cisco" -f "nvd-data.csv"

    .Example
        .\nvdParse.ps1 -year "recent" -keyword "java" -filename "nvd-data.csv"

    .Notes
        Created by Drew Bikowicz. December 17, 2021.

#>
param(

    [Alias("y")]
    [Parameter(Mandatory=$true)]
    [string]$year,

    [Alias("k")]
    [Parameter(Mandatory=$true)]
    [string]$keyword,

    [Alias("f")]
    [Parameter(Mandatory=$true)]
    [string]$filename

)
# Storyline: Parsing the NVD datafeed
cls

# Convert Json File into Powershell Object
$nvd_vulns = (Get-Content -Raw -Path ".\nvdcve-1.1-$year.json" | `
ConvertFrom-Json) | Select  CVE_Items

# CSV File
#$filename = "nvd-data.csv"

# Headers for the CSV file
Set-Content -Value "`"PublishDate`",`"Description`",`"Impact`",`"CVS`"" $filename

# Srray to store the data
$theV = @()

foreach ($vuln in $nvd_vulns.CVE_Items) {

    # Vuln Description
    $descript = $vuln.cve.description.description_data

    #$keyword = "java"
    # Search for the keyword
    if ($descript -imatch "$keyword") {
        
        # Published date
        $pubDate = $vuln.publishedDate
        
        # Description
        $z = $descript | select value
        $description = $z.value
       
        # Impact
        $y = $vuln.impact
        $impact = $y.baseMetricV2.severity

        # CVE Number
        $cve = $vuln.cve.CVE_data_meta.ID

        # Format the CSV file
        $theV += "`"$pubDate`",`"$description`",`"$impact`",`"$cve`"`n"


    }


} # End foreach loop

# Convert the array to a string and append to the CSV file
"$theV" | Add-Content -Path $filename
