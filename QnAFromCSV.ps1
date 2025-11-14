# Variables
$endpoint = "https://<your-resource-name>.cognitiveservices.azure.com"
$apiKey = "<your-api-key>"
$projectName = "<your-project-name>"
$csvPath = "QnAPairs.csv"

# API URL
$url = "$endpoint/language/query-knowledgebases/projects/$projectName/qnas?api-version=2021-10-01"
$headers = @{
    "Ocp-Apim-Subscription-Key" = $apiKey
    "Content-Type" = "application/json"
}

# Import CSV
$qnaPairs = Import-Csv -Path $csvPath

foreach ($pair in $qnaPairs) {
    $questions = @($pair.MainQuestion) + ($pair.AlternativeQuestions -split ";")
    $body = @{
        "questions" = $questions
        "answer"    = $pair.Answer
    } | ConvertTo-Json -Depth 3

    Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Body $body
    Write-Host "Added Q&A: $($pair.MainQuestion)"
}

Write-Host "Bulk upload completed!"