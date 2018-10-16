###### Begin test script ######
Write-Host 'Running AppVeyor test script' -ForegroundColor Yellow

###### Run Pester tests ######
$testResultsFile = '.\TestsResults.xml'
$res = Invoke-Pester -Script .\Tests\PSScriptAnalyzerTests.ps1 -OutputFormat NUnitXml -OutputFile $testResultsFile -PassThru

Write-Host 'Uploading results'
(New-Object 'System.Net.WebClient').UploadFile("https://ci.appveyor.com/api/testresults/nunit/$($env:APPVEYOR_JOB_ID)", (Resolve-Path $testResultsFile))

###### Validate result ######
if (($res.FailedCount -gt 0) -or ($res.PassedCount -eq 0)) { 
    throw "$($res.FailedCount) tests failed."
} else {
  Write-Host 'All tests passed' -ForegroundColor Green
}