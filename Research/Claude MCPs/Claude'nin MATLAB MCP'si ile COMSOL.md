# COMSOL'u Claude'nin MATLAB MCP'si üzerinden kullanma
 COMSOL modellerini düz dille sorgulayabilir — ve sıfırdan model kurdurabilirsiniz, 2B ya da 3B.

***Claude bir yapay zeka modelidir HATA yapabilir, lütfen çıktıları kontrol ediniz.***

Bölüm A

## MATLAB ve MCP sunucusu

MATLAB R2021a veya üzeri gerekir ve sistem `PATH`’inde olmalıdır.

1. 01

   ### Sunucuyu indirin ve kalıcı bir yere koyun

   [MathWorks sürüm sayfasından](https://github.com/matlab/matlab-mcp-server/releases/latest) tek bir çalıştırılabilir dosya: `matlab-mcp-server-windows-x64.exe`. Bu bir kurulum sihirbazı değildir; çift tıklamak işe yaramaz.

   `C:\` altında `mcp` diye bir klasör açın ve dosyayı oraya taşıyın. Yolda **boşluk ve Türkçe karakter olmasın** — sonraki adımlarda bu yolu iki yere yazacaksınız, kısa olması işinizi kolaylaştırır. Masaüstü ya da İndirilenler klasörü uygun değildir; dosya kalıcı olarak orada duracak.

   ```
   C:\mcp\matlab-mcp-server-windows-x64.exe
   ```
2. 02

   ### MATLAB eklentisini bir kez kurun

   Bu bir MATLAB komutu *değildir*; Windows komut satırında çalıştırılır. Başlat menüsüne `cmd` yazıp **Komut İstemi**’ni açın ve şu iki satırı sırayla yapıştırın (MATLAB sürümünüzü kendi sürümünüzle değiştirin):

   ```
   cd C:\mcp
   matlab-mcp-server-windows-x64.exe --setup-matlab --matlab-root="C:\Program Files\MATLAB\R2025b"
   ```

   Bu, MATLAB’in dışarıdan sürülmesini sağlayan *MATLAB MCP Server Toolbox* eklentisini kurar. Bir kez yapılır; başarılı olduğunda kısa bir onay yazısı görürsünüz.

   PowerShell Komut İstemi yerine PowerShell kullanıyorsanız dosya adının başına `.\` eklemeniz gerekir: `.\matlab-mcp-server-windows-x64.exe --setup-matlab …`
3. 03

   ### MATLAB oturumunuzu paylaşıma açın — ve bunu kalıcı yapın

   MATLAB varsayılan olarak dışarıdan erişime kapalıdır. Kullanılmasını istediğiniz MATLAB penceresinde şu komutu çalıştırmanız gerekir:

   ```
   shareMATLABSession()
   ```

   **Bu her yeni MATLAB oturumunda gerekir.** MATLAB’i her açışınızda elle yazmamak için `startup.m` kullanın: MATLAB’in açılışta kendiliğinden çalıştırdığı bir betiktir. Nerede olacağını MATLAB’e sorun — komut penceresine `userpath` yazın; genelde `C:\Users\<kullanıcı>\Documents\MATLAB` çıkar. Dosyayı açmak (yoksa oluşturmak) için:

   ```
   edit(fullfile(userpath,'startup.m'))
   ```

   İçine şunu yazıp kaydedin — COMSOL yolu da burada dursun:

   ```
   % --- COMSOL LiveLink'i MATLAB yoluna ekle ---
   addpath('C:\Program Files\COMSOL\COMSOL62\Multiphysics\mli')

   % --- MATLAB oturumunu MCP'ye ac ---
   shareMATLABSession()
   disp('[startup] MATLAB oturumu MCP icin paylasildi.')
   ```

   Bundan sonra MATLAB’i her açtığınızda son satırdaki yazıyı görürsünüz; gördüğünüzde hazırsınız demektir.

   hata verirse 2. adım çalıştırıldığında MATLAB zaten açıksa eklentiyi göremez — eklentiler açılışta kaydedilir. En kolayı MATLAB’i kapatıp yeniden açmaktır. Zorlamak isterseniz: `rehash toolboxcache` ve `%APPDATA%\MathWorks\MATLAB Add-Ons\Toolboxes\MATLAB MCP Server Toolbox` klasörüne bir `addpath`.
4. 04

   ### Claude masaüstü uygulamasına tanıtın

   **Settings → Developer → Edit Config** (Ayarlar → Geliştirici → Yapılandırmayı düzenle) `claude_desktop_config.json` dosyasını oluşturup açar. İçeriğini silip şunu yapıştırın — 1. adımdaki klasörü kullandıysanız yol aynen böyledir:

   ```
   {
     "mcpServers": {
       "matlab": {
         "command": "C:\\mcp\\matlab-mcp-server-windows-x64.exe",
         "args": ["--matlab-session-mode=existing"]
       }
     }
   }
   ```

   Ters bölü işaretleri **çift** yazılmalı: `C:\\mcp\\…`. Tek yazılırsa dosya geçersiz olur ve sunucu hiç başlamaz. Sonra uygulamadan tamamen çıkıp yeniden açın — pencereyi kapatmak yetmez.

   iki tuzak Varsayılan `auto` yerine `existing` kullanın: `auto` kipinde başarısız bir bağlanma denemesi **sessizce ikinci bir MATLAB başlatır**; o MATLAB’de LiveLink yoktur, her komut yanlış sürece gider ve dışarıdan her şey yolunda görünür. Ayrıca `--initial-working-folder` eklemeyin — `existing` kipinde kabul edilmez ve sunucu açılır açılmaz kapanır.

Bölüm B

## COMSOL sunucusu

1. 05

   ### Sunucuyu ve LiveLink’i kurun

   İkisi de düz bir COMSOL Desktop kurulumuyla gelmez — COMSOL kurulumunda ayrı seçeneklerdir ve çoğu kişide eksik olan tam olarak budur. Devam etmeden önce şu ikisinin varlığını doğrulayın:

   ```
   …\COMSOL62\Multiphysics\bin\win64\comsolmphserver.exe
   …\COMSOL62\Multiphysics\mli\                           (LiveLink for MATLAB)
   ```

   Biri yoksa kurulumu yeniden çalıştırıp “mevcut kurulumu değiştir” seçeneğiyle *COMSOL Multiphysics Server* ve *LiveLink for MATLAB* bileşenlerini ekleyin.
   COMSOL Multiphysics 6.2 Build 339\iso adresinden kuruluma başlayın ve COMSOL Multiphysics 6.2 with MATLAB kurulumunu yapın. Server için aşağıdaki lisansı kullanın.
   COMSOL Multiphysics 6.2 Build 339\_SolidSQUAD_\_SolidSQUAD_\_LMCOMSOL_Server_6.2_SSQ.lic konumundan server lisansını seçin.
2. 06

   ### Sunucu için kullanıcı adı ve parola oluşturun

   Sunucu kendisine bağlanan istemcileri doğrular. Başlat menüsünden *COMSOL Multiphysics Server*’ı bir kez elle çalıştırın; sizden bir kullanıcı adı ve parola belirlemenizi ister. Bunlar COMSOL hesabınız değildir, yalnızca bu sunucuya aittir. `%USERPROFILE%\.comsol\v62\login.properties` içinde saklanır ve bir daha sorulmaz. Unuttuysanız o dosyayı silip yeniden çalıştırın.
3. 07

   ### Sunucuyu başlatmak için bir kısayol hazırlayın

   Sunucuyu her seferinde elle başlatmak yerine tek tıkla açılan bir `.bat` dosyası yapın. **Not Defteri**’ni açın, şunu yazın (COMSOL yolunu kendi kurulumunuza göre düzeltin):

   ```
   @echo off
   "C:\Program Files\COMSOL\COMSOL62\Multiphysics\bin\win64\comsolmphserver.exe" -port 2038
   ```

   **Farklı Kaydet** deyin, 1. adımdaki `C:\mcp` klasörünü seçin, dosya adını `comsol-sunucu-2038.bat` yazın ve *Kayıt türü* kutusunu **Tüm Dosyalar** yapın. Bunu yapmazsanız Windows dosyayı `…bat.txt` olarak kaydeder ve çalışmaz.

   Çalıştırmak için dosyaya çift tıklayın: siyah bir konsol penceresi açılır ve *started listening on port 2038* yazar. **O pencereyi açık bırakın** — kapatırsanız sunucu durur ve MATLAB bağlantısı kopar. COMSOL ile çalışacağınız her oturumda bu dosyaya bir kez çift tıklamanız yeterli.

   tuzak **Varsayılan 2036 portunu kullanmayın.** İstemci kipinde çalışan bir COMSOL Desktop, o portta beliren sunucuyu kapar ve tek istemci hakkını alır; MATLAB de açıkça dinlemekte olan bir sunucudan `Connection refused` yanıtı alır.

Bölüm C

## İkisini birleştirmek

1. 08

   ### LiveLink MATLAB yolunda mı, doğrulayın

   3\. adımda `startup.m` içine `addpath` satırını yazdıysanız bu adım kendiliğinden tamamdır. MATLAB komut penceresinde sınayın — bir yol dönmeli, boş dönmemeli:

   ```
   which mphstart
   ```

   Boş dönüyorsa satırı elle çalıştırın:

   ```
   addpath('C:\Program Files\COMSOL\COMSOL62\Multiphysics\mli')
   ```
2. 09

   ### Bağlanın ve bir model açın

   ```
   mphstart(2038)
   import com.comsol.model.util.*
   model = mphload('C:\yol\model.mph');
   ```

   Çözülmüş bir `.mph` çözümünü içinde taşır; hiçbir şey yeniden çözülmez, model yüklenir yüklenmez sonuçlar oradadır. Bundan sonrası `mphmax`, `mphmean`, `mphint2`, `mphinterp`, `mphglobal` ve `mphtable` — ve bunları tek tek yazmak yerine düz dille isteyebilirsiniz.

## Çalıştığının kanıtı

- ✓Settings → Developer listesinde `matlab` çalışır görünüyor
- ✓`disp(version)` isteği yanıtlanıyor — hem de *kendi* MATLAB pencerenizde
- ✓`which mphload` boş değil, bir yol döndürüyor
- ✓sunucu penceresinde *listening on port 2038* yazıyor
- ✓`mphload` bir model döndürüyor ve `mphmax` gerçek bir sayı veriyor

## Sunucu, port ve "tek istemci" kuralı

Kurulum bittikten sonra en çok vakit kaybettiren konu bu. Üç cümlede özeti:
**portu sunucu belirler, istemciler aynı numarayı çevirir, ve bir sunucuya aynı
anda yalnızca bir istemci bağlanır.**

`comsolmphserver.exe -port 2036` dediğinizde o sunucu 2036'yı dinler. Bundan
sonra ona bağlanacak **her** istemci aynı numarayı yazmak zorundadır:

- MATLAB'den: `mphstart(2036)`
- COMSOL Desktop'tan: File → COMSOL Multiphysics Server → Connect to Server

Argümansız başlatırsanız (Başlat menüsündeki *COMSOL Multiphysics Server*
kısayolu) port **2036** olur. 2038 istiyorsanız sunucuyu `-port 2038` ile
başlatıp istemcide de 2038 yazmalısınız.

> Bir yanılgı: "LiveLink 2036'da açık" diye bir şey yok. Portu **sunucu**
> dinler; LiveLink yalnızca MATLAB tarafındaki kütüphanedir, yani numarayı
> çeviren taraf.

> COMSOL'un bağlantı penceresindeki port kutusu **en son yazdığınız numarayı
> hatırlar**. Orada 2038 görmeniz bir varsayılan olduğu anlamına gelmez; sunucu
> penceresinin yazdığı numaraya bakın.

### "Hedef makine etkin olarak reddettiğinden bağlantı kurulamadı"

Windows'un 10061 hatası. Anlamı tektir: **o portta dinleyen yok** (ya da yer
dolu). Sırayla bakın:

1. Sunucu gerçekten çalışıyor mu? `netstat -ano | findstr ":2036"` bir
   LISTENING satırı vermeli.
2. Sunucu penceresi kullanıcı adı/parola mı soruyor? Kurulumun 6. adımı hiç
   yapılmamışsa pencere girdi bekler ve dinlemeye hiç başlamaz. **`.bat`
   dosyanızda çıktıyı bir log dosyasına yönlendiren `> dosya.log 2>&1` varsa bu
   soru ekranda görünmez**, log dosyasının içinde bekler — hesap oluşana kadar
   yönlendirmeyi kaldırın.
3. Port numaraları tutuyor mu? Sunucu 2036'da, siz 2038'e bağlanıyor olabilir
   misiniz?
4. Dinleyen var ama yine reddediyorsa: tek istemci yeri doludur — büyük
   ihtimalle açık bir COMSOL Desktop kapmıştır.

### Desktop'ta açık model MATLAB'e görünmez

İkisi de sunucuya bağlı olsa bile geçerlidir: COMSOL Desktop ayrı bir süreçtir.
Orada kurduğunuz ya da çözdüğünüz şey, **`.mph` kaydedilene kadar** MATLAB için
yoktur. Ekranınızdaki modelin okunabilmesi için dosyayı kaydedip `mphload` ile
açmak gerekir.

## Kurulum bittiğinde neler yapılabilir

Hepsi bu düzenle fiilen yapıldı — başlıklar hâlinde:

- 01**Sıfırdan model kurma, 2B ve 3B.** Geometri, malzeme, fizik, ağ, çözüm ve kayıt — hepsi tarif üzerinden. GUI’de tek tık atmadan yeni bir `.mph` çıkar.
- 02**Var olan bir modeli tanıma.** Yapı dökümü: parametreler, fizikler, çalışmalar, hangi veri kümesinde gerçekten çözüm var.
- 03**Alan değerleri ve integraller.** Çizgi, çember ve düzlem üzerinde örnekleme; bölge bazında en büyük/ortalama; yüzey ve hacim integralleri.
- 04**Hava aralığı dalga biçimi ve harmonikler.** Mekanik açıya karşı `Bz`, uzay harmonikleri, THD — ve bir harmonik bildirmeden önce gürültü tabanı.
- 05**Parametrik süpürme sonuçları.** Açıya, zamana ya da frekansa karşı eğriler; akı bağı, zıt-EMK, kuvvet ve tork.
- 06**Görseller ve rapor.** COMSOL’un kendi görüntü dışa aktarımıyla PNG, veriler CSV, ve ne anlama geldiğini anlatan bir açıklama dosyası.
- 07**Toplu karşılaştırma.** Bir klasördeki onlarca modeli tek geçişte tarayıp tek bir karşılaştırma tablosuna indirmek.

Sınır şurada: tork, akı bağı, zıt-EMK gibi *global* büyüklükler ancak modelde onları üreten düğüm varsa (Force Calculation, Coil) okunur. Yoksa ya model değiştirilip yeniden çözülür ya da alandan türetilir.

## Bir şey bozulduğunda

| Belirti | Sebep | Çözüm |
| --- | --- | --- |
| her çağrı *failed to attach to MATLAB session* diyor | 2. ya da 3. adım hiç çalıştırılmadı | `--setup-matlab`, ardından `shareMATLABSession()` |
| yanıt geliyor ama modeliniz ve LiveLink ortada yok | `auto` kipi ikinci bir MATLAB başlattı | `existing` yapın; `feature('getpid')` ve `which mphload` ile doğrulayın |
| açılır açılmaz *server disconnected* | uyumsuz argüman, çoğunlukla `--initial-working-folder` | kaldırın; sebebi `%APPDATA%\Claude\logs` içindeki kayıtta yazar |
| dinlemekte olan bir portta `Connection refused` | 2036’daki yeri COMSOL Desktop kaptı | başka bir port kullanın |
| oturum ortasında `Cannot find COMSOL server` | sunucunun konsol penceresi kapandı | `.bat`’e yeniden çift tıklayın, sonra `mphstart` |
| `mphstart` tanımsız | LiveLink kurulu değil ya da yolda değil | `mli` klasörünü doğrulayıp `addpath` yapın |
| COMSOL Desktop’ta yapılan iş görünmüyor | Desktop, sunucudan ayrı bir süreçtir | `.mph`’yi kaydedin; kaydedene kadar başka hiçbir şey onu görmez |

Windows üzerinde MATLAB R2025b ve COMSOL 6.2 ile baştan sona iki kez yapılmış bir kurulumdan yazıldı. `COMSOL62` ve `R2025b`’yi kendi sürümlerinize göre değiştirin. Asıl kıymetli olan sıranın kendisi: her adımın bir sınaması var ve tablodaki arızaların hepsi, bir önceki adım oturmadan sonrakine geçmekten çıktı.