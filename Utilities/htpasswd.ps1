#
$username = Read-Host "Enter the username"
$username = ($username).trim('"')
$username = ($username).trim("'")

$password = Read-Host "Enter the password"
$password = ($password).trim('"')
$password = ($password).trim("'")

# Compute hash over password
$passwordBytes = [System.Text.Encoding]::ASCII.GetBytes($password)
$sha1 = [System.Security.Cryptography.SHA1]::Create()
$hash = $sha1.ComputeHash($passwordBytes)

# Had we at this point converted $hash to a hex string with, say:
#
#   [BitConverter]::ToString($hash).ToLower() -replace '-'
#
# ... we would have gotten "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"

# Convert resulting bytes to base64
$hashedpasswd = [convert]::ToBase64String($hash)

# Generate htpasswd entry
Write-Host "The generated htpasswd entry:"
Write-Host "${username}`:`{SHA`}${hashedpasswd}" -ForegroundColor Green
