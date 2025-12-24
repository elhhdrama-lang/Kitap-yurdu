# SQL Server Kontrol Script'i
Write-Host "SQL Server Kontrol Ediliyor..." -ForegroundColor Yellow

# SQL Server servislerini kontrol et
$services = Get-Service | Where-Object {$_.Name -like "*SQL*"}

if ($services.Count -eq 0) {
    Write-Host ""
    Write-Host "SQL Server servisi bulunamadi!" -ForegroundColor Red
    Write-Host "SQL Server yuklu degil veya servis adi farkli olabilir." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Cozum:" -ForegroundColor Cyan
    Write-Host "1. SQL Server Express indirin" -ForegroundColor White
    Write-Host "2. Veya LocalDB kullanin (appsettings.json'da connection string'i degistirin)" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "SQL Server servisleri bulundu:" -ForegroundColor Green
    foreach ($service in $services) {
        if ($service.Status -eq 'Running') {
            Write-Host "  - $($service.Name): CALISIYOR" -ForegroundColor Green
        } else {
            Write-Host "  - $($service.Name): DURDURULMUS" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    Write-Host "ONEMLI:" -ForegroundColor Yellow
    Write-Host "Veritabanini olusturmak icin SQL Server Management Studio (SSMS) kullanin." -ForegroundColor White
    Write-Host "Database/SetupDatabase.sql dosyasini SSMS'de calistirin." -ForegroundColor White
}

Write-Host ""

