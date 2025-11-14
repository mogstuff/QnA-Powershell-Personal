# Variables
$endpoint = "https://clyxportal-chatbot-ls-t-267.cognitiveservices.azure.com"
$apiKey = "88jS4sMfQ5PHLoIU9CF6ibW6l1swni2PYva3xFsK0oSQHAUdQcI7JQQJ99BJACmepeSXJ3w3AAAaACOG13vr"
$projectName = "clyxportal-chatbot-lp-t-267"
$outputFile = "QnAExport.txt"

# API URL
$url = "$endpoint/language/query-knowledgebases/projects/$projectName/qnas?api-version=2021-10-01"

# Headers
$headers = @{
    "Ocp-Apim-Subscription-Key" = $apiKey
    "Content-Type" = "application/json"
}

# Call API
$response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get

# Loop through QnA pairs
$output = ""
foreach ($qna in $response.value) {
    $output += "Question: $($qna.questions[0])`r`n"
    if ($qna.questions.Count -gt 1) {
        $output += "Alternative Questions:`r`n"
        foreach ($alt in $qna.questions[1..($qna.questions.Count-1)]) {
            $output += " - $alt`r`n"
        }
    }
    $output += "Answer: $($qna.answer)`r`n"
    $output += "----------------------------------------`r`n"
}

# Write to file
$output | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Export completed. File saved to $outputFile"
