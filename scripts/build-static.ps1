param(
  [string]$Php = 'C:\Users\user\AppData\Local\Microsoft\WinGet\Packages\PHP.PHP.8.4_Microsoft.Winget.Source_8wekyb3d8bbwe\php.exe'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
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
  $rendered = & $Php (Join-Path $root $item.Key)
  [System.IO.File]::WriteAllText($destination, ($rendered -join [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
}
