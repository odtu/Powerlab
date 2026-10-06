# Onshape MCP Kurulum Rehberi (Lab)
## Başlamadan önce

Bu kurulumla Claude, Onshape hesabınızda doğrudan parça modelleyebilir, ölçüm alabilir ve modelin görüntüsünü çekebilir. Kurulum yaklaşık 15–20 dakika sürer ve komutlar Windows PowerShell içindir.

***Claude bir yapay zeka modelidir HATA yapabilir, lütfen çıktıları kontrol ediniz.***

Gerekenler:

- Bir Onshape hesabı
- Ücretli bir Claude hesabı ve bilgisayarınızda kurulu Claude Desktop uygulaması
- Programlara kurulum izni olan bir Windows kullanıcısı

Kullandığımız sunucu [@gpambrozio/onshape-mcp](https://github.com/gpambrozio/onshape-mcp). Bu bir topluluk paketidir, Onshape'in resmi ürünü değildir. Herkesin aynı sürümle çalışması için sürümü 0.1.2'ye sabitliyoruz.

Sıra şöyle: Node.js → Claude Code → MCP kaydı → API anahtarı → Claude Desktop ayarı → doğrulama.

## Adım 1: Node.js kurulumu

Onshape sunucusu Node.js ile çalışır ve en az 20 sürümü gerekir. Önce PowerShell'i açıp sürümü kontrol edin:

```powershell
node -v
```

`v20` veya üstü bir sürüm görüyorsanız bu adımı atlayın. Komut tanınmıyorsa ya da sürüm daha eskiyse Node.js'in LTS sürümünü kurun:

```powershell
winget install OpenJS.NodeJS.LTS
```

Kurulumdan sonra PowerShell'i kapatıp yeniden açın ve `node -v` ile tekrar kontrol edin.

## Adım 2: Claude Code kurulumu

Claude Code'u MCP sunucusunu kaydetmek ve ilk Onshape girişini yapmak için kullanacağız. Yönetici olarak çalıştırmanıza gerek yok; normal bir PowerShell penceresinde şunu çalıştırın:

```powershell
irm https://claude.ai/install.ps1 | iex
```

Kurulum bitince **yeni** bir PowerShell penceresi açıp kontrol edin:

```powershell
claude --version
```

Bir sürüm numarası görmelisiniz. `claude` tanınmıyorsa kurulum klasörü henüz PATH'e eklenmemiştir; çözümü [resmi sorun giderme sayfasında](https://code.claude.com/docs/en/troubleshoot-install) bulabilirsiniz.

Ardından `claude` yazıp çalıştırın. Tarayıcı açılır; Claude hesabınızla giriş yapın. Claude Code ücretsiz planda çalışmaz; Pro, Max, Team veya Enterprise hesabı gerekir. Giriş tamamlanınca `/exit` ile çıkabilirsiniz.

Kaynak: [Claude Code kurulum belgesi](https://code.claude.com/docs/en/setup)

## Adım 3: Onshape MCP'yi Claude Code'a ekleme

Sunucuyu `onshape-gp` adıyla kaydediyoruz. Labda herkes aynı adı kullanırsa birbirimizle paylaştığımız komutlar ve istemler her bilgisayarda aynı çalışır.

```powershell
claude mcp add --scope user --transport stdio onshape-gp -- cmd /c npx -y @gpambrozio/onshape-mcp@0.1.2
```

Komuttaki `cmd /c` kısmını silmeyin. Windows'ta `npx` doğrudan çağrıldığında Claude Code onu başlatamıyor.

Kaydı kontrol edin:

```powershell
claude mcp list
```

`onshape-gp` satırının yanında **Connected** yazmalı. Daha önce kurulmuş başka bir Onshape MCP'niz varsa ona dokunmayın; farklı adlar sayesinde ikisi çakışmadan birlikte çalışır.

## Adım 4: Onshape API anahtarı ve oturum açma

Her kişi kendi Onshape hesabıyla kendi anahtarını oluşturur; anahtarlar kişiye özeldir ve paylaşılmaz.

1. PowerShell'de `claude` yazarak Claude Code'u başlatın.
2. Claude'a şunu yazın: `onshape-gp sunucusundaki onshape_login aracını çalıştır`
3. Tarayıcıda adresi `127.0.0.1` ile başlayan yerel bir sayfa açılır. Bu sayfa sizi Onshape'in [API anahtarı sayfasına](https://cad.onshape.com/user/developer/apiKeys) yönlendirir.
4. Orada yeni bir anahtar oluşturun. Read ve Write izinlerini işaretleyin; Claude'un belge ya da özellik silebilmesini istiyorsanız Delete iznini de ekleyin.
5. Access Key ve Secret Key'i **yerel sayfadaki kutulara** yapıştırıp onaylayın. Secret Key yalnızca bir kez gösterilir.
6. Claude'a `onshape_auth_status çalıştır` yazın. Sonuçta `valid: true` görmelisiniz.

Sunucu anahtarı Windows Kimlik Bilgisi Yöneticisi'nde saklar; bir kez girmeniz yeterlidir. **Anahtarları hiçbir zaman sohbete yapıştırmayın. **Yanlışlıkla yapıştırırsanız o anahtarı Onshape'ten silip yenisini oluşturun.

## Adım 5: Claude Desktop'a ekleme

Claude Code'a yapılan kayıt Claude Desktop'a otomatik geçmez; sunucuyu Desktop'un kendi ayar dosyasına da eklemek gerekir.

**Dosyayı bulma.** En kolayı uygulamanın içinden açmaktır: **Claude Desktop → Settings → Developer → Edit Config**. Bu düğme `claude_desktop_config.json` dosyasının bulunduğu klasörü açar; dosya yoksa oluşturur. Elle aramak isterseniz Dosya Gezgini'nin adres çubuğuna `%APPDATA%\Claude` yazın. `AppData` gizli bir klasör olduğu için normal gezinmede görünmez. Uygulama Microsoft Store'dan kurulduysa dosya `%LOCALAPPDATA%\Packages\Claude_...\LocalCache\Roaming\Claude` altındadır.

**Sunucuyu ekleme.** Dosyayı Not Defteri ya da VS Code ile açın. Dosya boşsa içeriği aşağıdaki gibi olmalı:

```json
{
  "mcpServers": {
    "onshape-gp": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@gpambrozio/onshape-mcp@0.1.2"]
    }
  }
}
```

Dosyada başka sunucular varsa, `onshape-gp` girdisini aynı `mcpServers` bloğunun içine, öncekinden sonra **virgülle ayırarak** ekleyin. Var olan girdilere dokunmayın. Eksik ya da fazla bir virgül dosyayı bozar ve Desktop hiçbir sunucuyu yüklemez.

Kaydettikten sonra Claude Desktop'u tamamen kapatın; sistem tepsisindeki simgeden de çıkın. Sonra uygulamayı yeniden açın.

JSON ile uğraşmak istemeyenler için alternatif: [son sürüm sayfasından](https://github.com/gpambrozio/onshape-mcp/releases/latest) `.mcpb` uzantılı dosyayı indirip çift tıklayın; Desktop kurulumu kendisi yapar.

## Adım 6: Doğrulama

Claude Desktop'ta **yeni bir sohbet** açın; araç listesi sohbet başlarken yüklendiği için eski sohbetler yeni sunucuyu görmez. Sohbete şunu yazın:

`onshape-gp ile onshape_auth_status çalıştır, sonra son 5 belgemi listele`

Claude `valid: true` sonucunu ve Onshape belgelerinizin adlarını getiriyorsa kurulum tamamdır. Anahtarı Adım 4'te girdiğiniz için burada tekrar girmeniz gerekmez.

## Sorun giderme ve notlar

| Belirti | Çözüm |
| --- | --- |
| `claude mcp list` çıktısında **Failed** yazıyor | `npx -y @gpambrozio/onshape-mcp@0.1.2` komutunu elle çalıştırıp hata mesajını okuyun. Hata yoksa komut sessizce bekler; Ctrl+C ile çıkın. |
| Desktop'ta araçlar görünmüyor | Uygulamayı sistem tepsisinden de kapatıp yeniden açın ve yeni bir sohbet başlatın. Hâlâ yoksa JSON dosyasında virgül hatası olabilir. |
| Desktop açılınca hiçbir MCP sunucusu yüklenmiyor | `claude_desktop_config.json` bozuktur; eksik ya da fazla virgülü ve kapanmamış süslü parantezleri kontrol edin. |
| Silme işlemlerinde 403 hatası | API anahtarında Delete izni yok. Delete izniyle yeni bir anahtar oluşturup Adım 4'ü tekrarlayın. |
| Yeni belge oluştururken hata (ücretsiz Onshape hesabı) | Ücretsiz hesaplar yalnızca herkese açık belge oluşturabilir; Claude'dan belgeyi public olarak oluşturmasını isteyin. |

Bilmekte fayda var:

- Sunucu ölçüleri **inç ve derece** cinsinden alır. Milimetreyle çalışıyorsanız Claude'a ölçüleri milimetre olarak verin ve dönüşümü kontrol edin.
- Sürümü 0.1.2'ye bilerek sabitledik. Yeni sürüme geçmeden önce labda birinin denemesi iyi olur.
- Paket yeni ve topluluk tarafından geliştiriliyor. Önemli belgelerde çalışmadan önce Onshape'te bir sürüm (version) almak işi geri almayı kolaylaştırır.
