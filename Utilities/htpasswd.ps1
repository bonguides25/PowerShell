$username = Read-Host "Enter the username"
$username = ($path).trim('"')
$username = ($path).trim("'")

$password = Read-Host "Enter the password"
$password = ($path).trim('"')
$password = ($path).trim("'")

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
Wite-Host "The generated htpasswd entry: "${username}:{SHA}${hashedpasswd}""
