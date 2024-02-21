# Define paths
$jsonFilePath = "tempfile.json"
$wavFilePath = "output_file.wav"

# Read the JSON content and convert it to a byte array
$jsonContent = Get-Content -Path $jsonFilePath -Raw
$dataBytes = [System.Text.Encoding]::UTF8.GetBytes($jsonContent)

# Calculate total file size (header + data)
$fileSize = 44 + $dataBytes.Length

# Create a WAV file header for PCM format, 1 channel (mono), 44100 Hz, 16 bits per sample
$header = New-Object byte[] 44
$encoding = [System.Text.Encoding]::ASCII
$chunkSize = $fileSize - 8
$format = 1 # PCM
$channels = 1
$sampleRate = 44100
$bitsPerSample = 16
$byteRate = $sampleRate * $channels * ($bitsPerSample / 8)
$blockAlign = $channels * ($bitsPerSample / 8)
$subchunk2Size = $dataBytes.Length

# Fill in the header information
$encoding.GetBytes("RIFF").CopyTo($header, 0)
[BitConverter]::GetBytes($chunkSize).CopyTo($header, 4)
$encoding.GetBytes("WAVE").CopyTo($header, 8)
$encoding.GetBytes("fmt ").CopyTo($header, 12)
[BitConverter]::GetBytes(16).CopyTo($header, 16) # Subchunk1Size
[BitConverter]::GetBytes($format).CopyTo($header, 20)
[BitConverter]::GetBytes($channels).CopyTo($header, 22)
[BitConverter]::GetBytes($sampleRate).CopyTo($header, 24)
[BitConverter]::GetBytes($byteRate).CopyTo($header, 28)
[BitConverter]::GetBytes($blockAlign).CopyTo($header, 32)
[BitConverter]::GetBytes($bitsPerSample).CopyTo($header, 34)
$encoding.GetBytes("data").CopyTo($header, 36)
[BitConverter]::GetBytes($subchunk2Size).CopyTo($header, 40)

# Combine the header and data
$wavData = $header + $dataBytes

# Write the combined byte array to the WAV file
[System.IO.File]::WriteAllBytes($wavFilePath, $wavData)

Write-Host "WAV file created at $wavFilePath"
