# GitHub'a Yükleme Rehberi 🚀

Bu projeyi GitHub hesabınıza yüklemek için aşağıdaki adımları sırasıyla terminalde (PowerShell veya CMD) projenin klasöründeyken uygulayın.

## 1. Adım: Git'i Başlatın
Eğer bilgisayarınızda Git yüklü değilse önce [git-scm.com](https://git-scm.com/) adresinden indirip kurun. Ardından projenin ana klasöründe şu komutu çalıştırın:
```powershell
git init
```

## 2. Adım: Dosyaları Hazırlayın
Tüm dosyaları (oluşturduğumuz .gitignore sayesinde gereksiz dosyalar hariç tutulacaktır) takibe alın:
```powershell
git add .
```

## 3. Adım: İlk Commit'i Yapın
Değişiklikleri kaydedin:
```powershell
git commit -m "İlk commit: Kitapyurdu Projesi Başlatıldı"
```

## 4. Adım: GitHub'da Repo Oluşturun
1. [GitHub](https://github.com/) adresine gidin ve giriş yapın.
2. Sağ üstteki **+** ikonuna tıklayıp **New repository** seçin.
3. Repository name kısmına `kitapyurdu` yazın.
4. Diğer ayarları ellemeden **Create repository** butonuna basın.

## 5. Adım: Yerel Projeyi GitHub'a Bağlayın
Açılan sayfada size verilen URL'yi (aşağıdaki örnekteki gibi) kullanarak projeyi bağlayın:
```powershell
git remote add origin https://github.com/KULLANICI_ADINIZ/kitapyurdu.git
git branch -M main
```
*(NOT: `KULLANICI_ADINIZ` yazan yeri kendi GitHub kullanıcı adınızla değiştirin)*

## 6. Adım: Projeyi Gönderin (Push)
Son olarak dosyaları buluta gönderin:
```powershell
git push -u origin main
```

---
### Olası Sorunlar ve Çözümleri:
*   **Authentication Hatası:** Eğer ilk kez yükleme yapıyorsanız tarayıcıda bir giriş ekranı açılabilir, onay verin.
*   **Permission Denied:** GitHub kullanıcı adınızın ve şifrenizin (veya token'ın) doğru olduğundan emin olun.
*   **.gitignore:** Az önce oluşturduğumuz dosya sayesinde `bin`, `obj` ve `.vs` gibi devasa klasörler yüklenmez, bu sayede işleminiz daha hızlı biter.
