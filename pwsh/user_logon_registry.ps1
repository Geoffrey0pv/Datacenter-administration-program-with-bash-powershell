function Get-LocalUsersLastLogon {

    try {
        $users = Get-LocalUser -ErrorAction Stop | Where-Object { $_.Enabled -eq $true }
        $hasLastLogon = $users | Where-Object { $_.LastLogon -ne $null } | Select-Object -First 1
        if ($hasLastLogon) {
            $users | Select-Object @{N='User';E={$_.Name}}, @{N='LastLogon';E={$_.LastLogon}}
            return
        }
    } catch {
        Write-Host "Get-LocalUser no disponible: $($_.Exception.Message)"
    }
}

Get-LocalUsersLastLogon
