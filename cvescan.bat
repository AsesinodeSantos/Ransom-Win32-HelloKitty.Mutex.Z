<#
domain_patch_audit.ps1
Read‑only patch inventory collector. Use only with written authorization.
#>

param(
  [string[]]$ComputerList,
  [pscredential]$Credential,
  [int]$Throttle = 16,
  [string]$OutDir = ".\audit_output"
)

if (-not (Test-Path $OutDir)) { New-Item -Path $OutDir -ItemType Directory | Out-Null }

$scriptBlock = {
  try {
    $os = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber,LastBootUpTime
  } catch {
    $os = $_.Exception.Message
  }

  try {
    $hotfixes = Get-HotFix | Select-Object HotFixID,InstalledOn
  } catch {
    $hotfixes = @()
  }

  try {
    $roles = Get-WindowsFeature | Where-Object {$_.Installed -eq $true} | Select-Object DisplayName,Name
  } catch {
    $roles = @()
  }

  @{
    Computer = $env:COMPUTERNAME
    OS = $os
    HotFixes = $hotfixes
    InstalledWindowsFeatures = $roles
    TimeCollected = (Get-Date).ToString("u")
  }
}

$results = [System.Collections.Concurrent.ConcurrentBag[object]]::new()

$jobs = @()
foreach ($c in $ComputerList) {
  $jobs += [PSCustomObject]@{ Computer = $c; Job = Start-Job -ScriptBlock {
      param($target,$cred,$sb)
      try {
        $res = Invoke-Command -ComputerName $target -Credential $cred -ScriptBlock $sb -ErrorAction Stop
        $res
      } catch {
        @{ Computer = $target; Error = $_.Exception.Message }
      }
    } -ArgumentList $c,$Credential,$scriptBlock
  }
}

# wait for completion
$jobs | ForEach-Object {
  $j = $_.Job
  $jobCompleted = $j | Wait-Job -Timeout 300
  $out = Receive-Job -Job $j -ErrorAction SilentlyContinue
  $fname = Join-Path $OutDir ("audit_" + $_.Computer + ".json")
  $out | ConvertTo-Json -Depth 6 | Out-File -FilePath $fname -Encoding UTF8
  Remove-Job -Job $j -Force
}

Write-Output "Collection complete. Files saved to: $((Get-Item $OutDir).FullName)"