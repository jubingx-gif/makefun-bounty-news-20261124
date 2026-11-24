# 20261124_deploy_bounty.ps1
# make.fun Bounty One-Click Deployer (Artisan Edition)
# Follows GR-113 & DNA 32

$ErrorActionPreference = "Stop"

# 1. Load Environment Variables from .env
$envPath = Join-Path $PSScriptRoot ".env"
if (-not (Test-Path $envPath)) {
    Write-Host "🔴 Error: .env file not found! Please create it and add GITHUB_TOKEN and GITHUB_USERNAME." -ForegroundColor Red
    exit 1
}

$envVars = Get-Content $envPath | ConvertFrom-StringData
$GITHUB_TOKEN = $envVars.GITHUB_TOKEN
$GITHUB_USER = $envVars.GITHUB_USERNAME
$REPO_NAME = "makefun-bounty-news-20261124"

if (-not $GITHUB_TOKEN -or -not $GITHUB_USER) {
    Write-Host "🔴 Error: GITHUB_TOKEN or GITHUB_USERNAME is missing in .env!" -ForegroundColor Red
    exit 1
}

Write-Host "🚀 Starting deployment for project: $REPO_NAME..." -ForegroundColor Cyan

# 2. Create Repository via GitHub API (Invoke-RestMethod)
$headers = @{
    "Authorization" = "token $GITHUB_TOKEN"
    "Accept"        = "application/vnd.github.v3+json"
}
$body = @{
    name = $REPO_NAME
    description = "make.fun bounty entry for 2026-11-24 world news image summary."
    private = $false
} | ConvertTo-Json

try {
    Write-Host "📂 Creating GitHub repository..."
    $response = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Headers $headers -Body $body
    Write-Host "✅ Repository created: $($response.html_url)" -ForegroundColor Green
} catch {
    if ($_.Exception.Message -match "422") {
        Write-Host "ℹ️ Repository already exists, skipping creation." -ForegroundColor Yellow
    } else {
        Write-Host "❌ Failed to create repository: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# 3. Git Push Operations
Write-Host "📦 Initializing git and pushing code..."
git init
git add .
git commit -m "Initial commit: make.fun bounty 2026-11-24"

# Set remote (includes token for auth, but won't be saved in logs if run locally)
$remoteUrl = "https://$GITHUB_USER`:$GITHUB_TOKEN@github.com/$GITHUB_USER/$REPO_NAME.git"
if (git remote | Select-String "origin") {
    git remote remove origin
}
git remote add origin $remoteUrl
git branch -M main
git push -u origin main --force

Write-Host "`n🏆 Deployment Successful!" -ForegroundColor Green
Write-Host "🔗 Bounty Link: https://make.fun/bounty/news-image-20261124" -ForegroundColor Cyan
Write-Host "🔗 Your Repo: https://github.com/$GITHUB_USER/$REPO_NAME" -ForegroundColor Cyan
Write-Host "`nNext: Go to the bounty link and submit your repo URL!" -ForegroundColor Yellow
