# Define the path to the WAV file and the output text file
$wavFilePath = "output_file.wav"
$outputTextFilePath = "decoded_file.txt"

# Read the WAV file bytes
$wavBytes = [System.IO.File]::ReadAllBytes($wavFilePath)

$dataStartIndex = 44

$dataBytes = $wavBytes[$dataStartIndex..($wavBytes.Length - 1)]

$decodedString = [System.Text.Encoding]::UTF8.GetString($dataBytes)

# Save the decoded string to a text file
[System.IO.File]::WriteAllText($outputTextFilePath, $decodedString)

Write-Host "Data decoded and saved to $outputTextFilePath"
