
# Read all QnA Pairs
Reads all question and answer pairs and writes them to a .txt file.


```
# Variables
$endpoint = "https://<your-resource-name>.cognitiveservices.azure.com"
$apiKey = "<your-api-key>"
$projectName = "<your-project-name>"
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

```

## Running the Scripts

### Open PowerShell

Check current policy

```
Get-ExecutionPolicy
```

### Temporarily Allow Scripts (Safe Option)

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### Allow Script Execution (if needed)


If you haven’t run scripts before, you might need to enable execution:

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Press Y when prompted.

### Run Script

```
.\Export-QnA.ps1
```

The script will create a file called QnAExport.txt in the same folder (or the path you set in $outputFile).


# PowerShell Script to Add Q&A Pair

```
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
```


## How It Works

- questions: Combines the main question and alternative questions into one array. 
- answer: The text answer for the Q&A pair. 
- Uses the POST method to add the Q&A pair to your project.



## How to Run

1. Replace: <your-resource-name> with your Azure resource name. 
- <your-api-key> with your Language Studio API key. 
- <your-project-name> with your project name.   
2. Save as Add-QnA.ps1. 
3. Run in PowerShell:

```
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\Add-QnA.ps1
```

# PowerShell: Bulk Add Q&A from CSV

Assume your CSV has columns: MainQuestion,AlternativeQuestions,Answer
(AlternativeQuestions separated by ;)

```
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

```








 




