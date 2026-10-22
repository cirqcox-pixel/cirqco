param(
  [string]$Php = 'C:\Users\user\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe\php.exe'
)

$ErrorActionPreference = 'Stop'
$OutputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$root = Split-Path -Parent $PSScriptRoot
# GitHub Pages serves this project below /cirqco/. Keep canonical and Open Graph
# URLs on cirqco.com, but prefix browser-facing local paths in published HTML.
$publicBase = 'cirqco'
$pages = @{
  'index.php' = 'index.html'
  'about-us.php' = 'about-us\index.html'
  'my-village.php' = 'my-village\index.html'
  'medveta.php' = 'medveta\index.html'
  'sentinel.php' = 'sentinel\index.html'
  'cruizly.php' = 'cruizly\index.html'
  'work.php' = 'work\index.html'
  'investors.php' = 'investors\index.html'
  '404.php' = '404.html'
}

foreach ($item in $pages.GetEnumerator()) {
  $destination = Join-Path $root $item.Value
  $directory = Split-Path -Parent $destination
  New-Item -ItemType Directory -Force -Path $directory | Out-Null
  $process = [System.Diagnostics.Process]::new()
  $process.StartInfo.FileName = $Php
  $process.StartInfo.Arguments = '"' + (Join-Path $root $item.Key) + '"'
  $process.StartInfo.UseShellExecute = $false
  $process.StartInfo.RedirectStandardOutput = $true
  $process.StartInfo.RedirectStandardError = $true
  $process.StartInfo.StandardOutputEncoding = [System.Text.UTF8Encoding]::new($false)
  [void]$process.Start()
  $rendered = $process.StandardOutput.ReadToEnd()
  $errors = $process.StandardError.ReadToEnd()
  $process.WaitForExit()
  if ($process.ExitCode -ne 0) { throw "PHP failed for $($item.Key): $errors" }
  $rendered = $rendered.Replace((([string][char]0x00E2) + [char]0x20AC + [char]0x201D), [string][char]0x2014)
  $rendered = $rendered.Replace((([string][char]0x00E2) + [char]0x20AC + [char]0x2122), [string][char]0x2019)
  $rendered = $rendered.Replace((([string][char]0x00E2) + [char]0x20AC + [char]0x201C), [string][char]0x2013)
  $rendered = $rendered.Replace((([string][char]0x00C2) + [char]0x00B7), [string][char]0x00B7)
  $rendered = $rendered -replace '((?:href|src)="/)', ('$1' + $publicBase + '/')
  [System.IO.File]::WriteAllText($destination, $rendered, [System.Text.UTF8Encoding]::new($false))
}
