$hintColor = "Magenta"

$imageName = "caeruleum-api"

$imageTag = "latest"
if ($t = Read-Host "Enter image tag (default = $imageTag)") {
    $imageTag = $t
}

$acrUrl = Read-Host "Enter ACR URL"
$acrUsername = Read-Host "Enter ACR User name"
$acrPassword = Read-Host "Enter ACR Password" -MaskInput

Write-Host "Build docker image" -ForegroundColor $hintColor
docker build --no-cache -t ${imageName}:$imageTag -f Caeruleum.Api.Dockerfile .

Write-Host "Tag docker image for ACR" -ForegroundColor $hintColor
docker tag ${imageName}:$imageTag $acrUrl/${imageName}:$imageTag

Write-Host "Login to ACR" -ForegroundColor $hintColor
docker login $acrUrl --username $acrUsername --password $acrPassword

Write-Host "Pushing image to ACR" -ForegroundColor $hintColor
docker push $acrUrl/${imageName}:$imageTag
