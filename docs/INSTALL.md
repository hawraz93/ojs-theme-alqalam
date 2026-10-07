# Installation guide / دليل التثبيت

## English

### Before you start

- Make a backup of the database and of the `plugins/themes` folder.
- Check the OJS version in **Administration → System Information**. The
  theme requires **OJS 3.5.x**.
- Installing a theme does not change existing content. The journal logo,
  menus, footer text and sidebar blocks are all kept.

### Method A – upload through the OJS interface (recommended)

1. Download `alqalam-theme-x.y.z.tar.gz` from the Releases page of the
   repository (or build it with `bash tools/build-release.sh x.y.z`).
2. Log in as **Site Administrator**.
3. Go to **Website Settings → Plugins** and click **Upload A New Plugin**
   (top right of the plugin list).
4. Select the archive and click **Save**. OJS copies the theme to
   `plugins/themes/alqalam`, registers its version and enables it.
5. Go to **Website Settings → Appearance → Theme**, select
   **Al-Qalam University Theme** and click **Save**.
6. The theme options appear below the theme selector (colours, header
   style, university bar, social links, ...). Adjust and save.
7. Repeat steps 5–6 **inside each journal** (Journal → Settings → Website →
   Appearance → Theme). The site-level setting only affects the site index
   page that lists the journals.

### Method B – copy the files manually (SSH / aaPanel file manager)

1. Copy the theme folder to `<ojs>/plugins/themes/alqalam` so that
   `plugins/themes/alqalam/AlqalamThemePlugin.php` exists.
   The folder name **must** be `alqalam`.
2. Make the folder readable by the web server user (e.g. `www`).
3. Register the plugin version so that OJS loads it:

   ```bash
   cd /www/wwwroot/scientificjournal.alqalam.edu.iq
   php lib/pkp/tools/installPluginVersion.php plugins/themes/alqalam/version.xml
   ```

4. Continue with steps 5–7 of Method A. If the theme is not listed, enable
   it first in **Website Settings → Plugins → Theme Plugins**.

### After installation

- Clear the caches: **Administration → Clear Template Cache** and
  **Clear Data Cache** (or delete `cache/t_compile/*` and `cache/*.css`).
- Upload the journal logo in **Settings → Website → Appearance → Setup →
  Logo** if the journal has one. If no logo is uploaded the theme shows the
  journal name as text next to the university logo.
- Fill in **Settings → Journal → Contact** (mailing address, e-mail,
  phone): the footer uses these values.
- Set the ISSN in **Settings → Journal → Masthead** (print / online): shown
  in the header, banner and footer.
- Optional: paste the HTML of the indexing logos (Google Scholar, Crossref,
  DOAJ...) into the theme option **Indexing and partners block**. Images
  can be uploaded with the file uploader of the rich-text editor in any
  OJS settings page, then referenced by URL.

### Updating

Upload the new archive the same way (Method A). OJS replaces the folder and
keeps the theme options.

---

## العربية

### قبل البدء

- خذ نسخة احتياطية من قاعدة البيانات ومن مجلد `plugins/themes`.
- تحقق من إصدار OJS من **الإدارة ← معلومات النظام**. يتطلب النمط
  **OJS 3.5.x**.
- تثبيت النمط لا يغيّر المحتوى الموجود؛ يبقى شعار المجلة والقوائم ونص
  التذييل وكتل الشريط الجانبي كما هي.

### الطريقة أ – الرفع من واجهة OJS (موصى بها)

1. حمّل الملف `alqalam-theme-x.y.z.tar.gz` من صفحة الإصدارات.
2. سجّل الدخول بحساب **مدير الموقع**.
3. اذهب إلى **إعدادات الموقع ← الإضافات** واضغط **رفع إضافة جديدة**.
4. اختر الملف واضغط **حفظ**. سينسخ النظام النمط إلى
   `plugins/themes/alqalam` ويسجّل إصداره ويفعّله.
5. اذهب إلى **إعدادات الموقع ← المظهر ← النمط**، اختر **نمط جامعة القلم**
   واضغط **حفظ**.
6. تظهر خيارات النمط أسفل قائمة الاختيار (الألوان، نمط الترويسة، شريط
   الجامعة، روابط التواصل...). اضبطها واحفظ.
7. كرّر الخطوتين 5–6 **داخل كل مجلة** (المجلة ← الإعدادات ← الموقع ←
   المظهر ← النمط). إعداد مستوى الموقع يؤثر فقط على صفحة قائمة المجلات.

### الطريقة ب – نسخ الملفات يدوياً (SSH أو مدير ملفات aaPanel)

1. انسخ مجلد النمط إلى `<ojs>/plugins/themes/alqalam` بحيث يوجد الملف
   `plugins/themes/alqalam/AlqalamThemePlugin.php`. يجب أن يكون اسم
   المجلد `alqalam`.
2. تأكد من أن مستخدم خادم الويب (مثل `www`) يستطيع قراءة المجلد.
3. سجّل إصدار الإضافة ليتمكن النظام من تحميلها:

   ```bash
   cd /www/wwwroot/scientificjournal.alqalam.edu.iq
   php lib/pkp/tools/installPluginVersion.php plugins/themes/alqalam/version.xml
   ```

4. أكمل الخطوات 5–7 من الطريقة أ. إن لم يظهر النمط في القائمة فعّله أولاً من
   **إعدادات الموقع ← الإضافات ← إضافات الأنماط**.

### بعد التثبيت

- امسح الذاكرة المؤقتة: **الإدارة ← مسح ذاكرة القوالب** و**مسح ذاكرة
  البيانات**.
- ارفع شعار المجلة من **الإعدادات ← الموقع ← المظهر ← الإعداد ← الشعار**
  إن وُجد؛ وإلا يعرض النمط اسم المجلة نصاً بجانب شعار الجامعة.
- املأ **الإعدادات ← المجلة ← الاتصال** (العنوان البريدي، البريد
  الإلكتروني، الهاتف): يستخدمها التذييل.
- أدخل الترقيم الدولي (ISSN) من **الإعدادات ← المجلة ← الهوية**.
- اختيارياً: ضع كود HTML لشعارات الفهرسة في خيار النمط **قسم الفهرسة
  والشركاء**.

### التحديث

ارفع الملف الجديد بالطريقة نفسها (الطريقة أ). يستبدل النظام المجلد ويحتفظ
بخيارات النمط.
