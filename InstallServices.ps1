If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

# Requires -RunAsAdministrator

# PowerShell task for installing and starting services
# Display Name: "Install Message Queuing"

# Enable required IIS features
dism.exe /Online /Enable-Feature /FeatureName:"IIS-WebServer" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-WebServerRole" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-DefaultDocument" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-DirectoryBrowsing" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-HttpErrors" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-HttpRedirect" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-HttpLogging" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-HealthAndDiagnostics" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-LoggingLibraries" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-RequestMonitor" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-HttpTracing" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-HttpCompressionStatic" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-Performance" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-ISAPIExtensions" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-ApplicationDevelopment" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-IIS6ManagementCompatibility" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"IIS-WebServerManagementTools" /All /NoRestart

# Enable MSMQ features
dism.exe /Online /Enable-Feature /FeatureName:"MSMQ-Container" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"MSMQ-Server" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"MSMQ-Triggers" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"MSMQ-ADIntegration" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"MSMQ-HTTP" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"MSMQ-Multicast" /All /NoRestart
dism.exe /Online /Enable-Feature /FeatureName:"MSMQ-DCOMProxy" /All /NoRestart

# Start Message Queue service
Start-Service -Name MSMQ

# Display the process: Install Microsoft Visual C++ Redistributable
Write-Host "Install Microsoft Visual C++ Redistributable"
# Install Microsoft Visual C++ Redistributable (replace the URL with the latest version)
$vcRedistUrl = 'https://aka.ms/vs/16/release/VC_redist.x64.exe'
$vcRedistPath = Join-Path $env:TEMP 'VC_redist.x64.exe'
Invoke-WebRequest -Uri $vcRedistUrl -OutFile $vcRedistPath
Start-Process -FilePath $vcRedistPath -ArgumentList '/quiet', '/install' -Wait
