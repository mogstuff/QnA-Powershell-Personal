# Variables
$endpoint = "https://<your-resource-name>.cognitiveservices.azure.com"
$apiKey = "<your-api-key>"
$projectName = "<your-project-name>"

# New Q&A details
$mainQuestion = "How do I reset my password?"
$alternativeQuestions = @("Forgot password", "Reset account password")
$answer = "Go to Settings > Security > Reset Password."

# API URL
$url = "$endpoint/language/query-knowledgebases/projects/$projectName/qnas?api-version=2021-10-01"

# Headers
$headers = @{
    "Ocp-Apim-Subscription-Key" = $apiKey
    "Content-Type" = "application/json"
}

# Body
$body = @{
    "questions" = @($mainQuestion) + $alternativeQuestions
    "answer"    = $answer
} | ConvertTo-Json -Depth 3

# Call API
$response = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Body $body

Write-Host "Q&A pair added successfully!"