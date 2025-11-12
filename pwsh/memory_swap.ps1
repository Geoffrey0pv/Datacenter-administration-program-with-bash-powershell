$os = Get-CimInstance Win32_OperatingSystem
$totalKB = [int64]$os.TotalVisibleMemorySize
$freeKB = [int64]$os.FreePhysicalMemory
$totalBytes = $totalKB * 1024
$freeBytes = $freeKB * 1024
$usedBytes = $totalBytes - $freeBytes
$usedPct = if ($totalBytes -ne 0) { [math]::Round(($usedBytes / $totalBytes) * 100, 2) } else { 0 }

$pagefiles = Get-CimInstance Win32_PageFileUsage -ErrorAction SilentlyContinue

if ($pagefiles) {
    $allocatedMB = ($pagefiles | Measure-Object -Property AllocatedBaseSize -Sum).Sum
    $currentUsageMB = ($pagefiles | Measure-Object -Property CurrentUsage -Sum).Sum
    $allocatedBytes = [int64]$allocatedMB * 1MB
    $currentBytes = [int64]$currentUsageMB * 1MB
    $swapPct = if ($allocatedBytes -ne 0) { [math]::Round(($currentBytes / $allocatedBytes) * 100, 2) } else { 0 }
} else {
    $allocatedBytes = 0
    $currentBytes = 0
    $swapPct = 0
}

$report = [PSCustomObject]@{
    "TotalMemoryBytes"      = ("{0:N2}" -f $totalBytes)
    "FreeMemoryBytes"       = ("{0:N2}" -f $freeBytes)
    "UsedMemoryBytes"       = ("{0:N2}" -f $usedBytes)
    "UsedMemoryPercent"     = "$usedPct %"
    "SwapAllocatedBytes"    = ("{0:N2}" -f $allocatedBytes)
    "SwapUsedBytes"         = ("{0:N2}" -f $currentBytes)
    "SwapUsedPercent"       = "$swapPct %"
}

$report | Format-List
