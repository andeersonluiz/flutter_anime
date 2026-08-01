$ErrorActionPreference = 'Stop'

$storePassword = $env:ANIMES_KEYSTORE_PASSWORD
$keyPassword = $env:ANIMES_KEY_PASSWORD
$keyAlias = $env:ANIMES_KEY_ALIAS

if ([string]::IsNullOrWhiteSpace($storePassword) -or
    [string]::IsNullOrWhiteSpace($keyPassword) -or
    [string]::IsNullOrWhiteSpace($keyAlias)) {
  throw 'Set ANIMES_KEYSTORE_PASSWORD, ANIMES_KEY_PASSWORD and ANIMES_KEY_ALIAS before running this script.'
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$keystorePath = Join-Path $projectRoot 'android/app/upload-keystore.jks'
$propertiesPath = Join-Path $projectRoot 'android/key.properties'

if (Test-Path -LiteralPath $keystorePath) {
  throw "Refusing to overwrite existing keystore: $keystorePath"
}

& keytool -genkeypair -v `
  -keystore $keystorePath `
  -storetype JKS `
  -storepass $storePassword `
  -keypass $keyPassword `
  -alias $keyAlias `
  -keyalg RSA `
  -keysize 4096 `
  -validity 10000 `
  -dname 'CN=Animes IO, OU=Mobile, O=Anderson Luiz, L=Brazil, C=BR'

@"
storePassword=$storePassword
keyPassword=$keyPassword
keyAlias=$keyAlias
storeFile=upload-keystore.jks
"@ | Set-Content -LiteralPath $propertiesPath -Encoding ascii -NoNewline

Write-Host 'New keystore generated in an ignored path.'
Write-Host 'Copy the three secret values to GitHub Actions secrets:'
Write-Host 'KEYSTORE_BASE64, KEY_ALIAS, KEY_PASSWORD and STORE_PASSWORD.'
Write-Host 'Generate KEYSTORE_BASE64 with: [Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/upload-keystore.jks"))'
