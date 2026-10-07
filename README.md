# Al-Qalam University Theme for OJS 3.5

**نمط جامعة القلم لنظام OJS 3.5** — [العربية أدناه](#العربية)

Official Open Journal Systems theme for the scientific journals of
[Al-Qalam University](https://alqalam.edu.iq), Kirkuk, Iraq
(<https://scientificjournal.alqalam.edu.iq>).

The theme is a **child theme of the OJS default theme**: it inherits all of
the default theme's templates, styles and scripts and adds the university's
visual identity on top. It does not modify any OJS core file and does not
change the database schema, so it can be installed and removed safely at any
time (see [docs/UNINSTALL.md](docs/UNINSTALL.md)).

![Al-Qalam University logo](images/alqalam-university-logo-256.png)

## Features

- **University identity** – colours sampled from the official logo (navy
  `#283078`, plum `#910051`, gold `#F0A018`), university logo in the header
  and footer, a thin "university bar" linking to the university website.
- **Bilingual Arabic / English** with full right-to-left support and
  self-hosted fonts (Roboto for Latin, Almarai and Amiri for Arabic — no
  requests to Google Fonts).
- **Modern homepage** – banner with the journal name, description, ISSN,
  current issue cover and call-to-action buttons; announcements; current
  issue as cards; optional "Indexing and partners" logo block.
- **Improved article page** – card layout for the details column, prominent
  PDF button, share buttons (X, Facebook, LinkedIn, WhatsApp, Telegram,
  e-mail, copy link) and an optional "received" date.
- **Issue archive** as a grid of covers; site homepage as journal cards.
- **Structured footer** – university + journal identity, ISSN, quick links,
  contact details (from Journal Settings > Contact), social media icons and
  the journal's own footer text.
- **Theme options** in *Website Settings → Appearance → Theme*: colours,
  light/dark header, university bar/logo, university name and URL,
  description/cover on the homepage, share buttons, received date,
  indexing HTML, social links.
- Works per journal: each journal can have its own colours and options.
- Accessible (skip links, focus styles, ARIA labels), responsive, print
  styles.

## Requirements

- OJS **3.5.x** (tested with 3.5.0-5). It does not run on OJS 3.3 or 3.4
  because the plugin API changed in 3.4.
- PHP 8.2+ (same as OJS 3.5).

## Installation

See [docs/INSTALL.md](docs/INSTALL.md) for the full guide. In short:

1. Download the latest `alqalam-theme-x.y.z.tar.gz` from the Releases page.
2. In OJS go to **Website Settings → Plugins → Upload A New Plugin** and
   upload the archive.
3. Go to **Website Settings → Appearance → Theme**, choose
   **Al-Qalam University Theme** and save.
4. Adjust the theme options that appear below the theme selector.

Repeat step 3 for each journal (the theme is selected per journal; the
site-level setting applies to the site index page).

## Uninstallation

1. **Website Settings → Appearance → Theme**: choose *Default Theme* (for
   the site and for each journal) and save.
2. Delete the folder `plugins/themes/alqalam`.
3. Optionally run `tools/uninstall.sql` to delete the theme's rows from
   `plugin_settings` and `versions`.

Details: [docs/UNINSTALL.md](docs/UNINSTALL.md).

## Development

```
plugins/themes/alqalam/
├── AlqalamThemePlugin.php   # plugin class (child of the default theme)
├── index.php, version.xml, settings.xml
├── locale/{en,ar}/locale.po # theme strings
├── styles/alqalam.less      # all theme styles (compiled with the parent)
├── styles/fonts.less        # @font-face declarations
├── fonts/                   # Roboto, Almarai, Amiri (woff2)
├── images/                  # university logo variants, favicon
├── js/alqalam.js
├── templates/frontend/      # overridden templates (header, footer, home…)
├── docs/                    # INSTALL.md, UNINSTALL.md
└── tools/                   # uninstall.sql, build-release.sh
```

After changing LESS or templates, clear the OJS cache
(*Administration → Clear Template Cache / Clear Data Cache*, or delete
`cache/t_compile/*` and `cache/*.css`).

To build a release archive: `bash tools/build-release.sh 1.0.0`.

## License

GNU General Public License v3 (the same license as OJS). See [LICENSE](LICENSE).

Fonts: Roboto (Apache 2.0), Almarai (OFL 1.1), Amiri (OFL 1.1).

---

## العربية

النمط الرسمي لنظام إدارة المجلات العلمية (OJS) الخاص بمجلات
[جامعة القلم](https://alqalam.edu.iq) في كركوك
(<https://scientificjournal.alqalam.edu.iq>).

النمط **مشتق من النمط الافتراضي لـ OJS** (child theme)، فهو يرث جميع
قوالبه وأنماطه ويضيف عليها الهوية البصرية للجامعة. لا يعدّل أي ملف من ملفات
النظام الأساسية ولا يغيّر بنية قاعدة البيانات، لذا يمكن تثبيته وإزالته بأمان
في أي وقت (انظر [docs/UNINSTALL.md](docs/UNINSTALL.md)).

### المزايا

- **هوية الجامعة**: ألوان مأخوذة من الشعار الرسمي (كحلي `#283078`،
  أرجواني `#910051`، ذهبي `#F0A018`)، شعار الجامعة في الترويسة والتذييل،
  وشريط علوي يربط بموقع الجامعة.
- **ثنائي اللغة عربي/إنجليزي** مع دعم كامل للكتابة من اليمين إلى اليسار،
  وخطوط مستضافة محلياً (Roboto للاتينية، Almarai وAmiri للعربية).
- **صفحة رئيسية حديثة**: لافتة تعرض اسم المجلة ووصفها والترقيم الدولي وغلاف
  العدد الحالي وأزرار الإجراءات؛ الإعلانات؛ العدد الحالي على شكل بطاقات؛
  قسم اختياري لشعارات الفهرسة.
- **صفحة مقال محسّنة**: عمود تفاصيل على شكل بطاقات، زر PDF بارز، أزرار
  مشاركة، وتاريخ استلام اختياري.
- **أرشيف الأعداد** كشبكة أغلفة، وصفحة الموقع كبطاقات للمجلات.
- **تذييل منظم**: هوية الجامعة والمجلة، الترقيم الدولي، روابط سريعة، بيانات
  الاتصال، أيقونات التواصل الاجتماعي، ونص التذييل الخاص بالمجلة.
- **خيارات النمط** من *إعدادات الموقع ← المظهر ← النمط*.

### المتطلبات

- OJS **3.5.x** (تم اختباره مع 3.5.0-5). لا يعمل على 3.3 أو 3.4.
- PHP 8.2 أو أحدث.

### التثبيت

1. حمّل أحدث ملف `alqalam-theme-x.y.z.tar.gz` من صفحة الإصدارات.
2. في OJS: **إعدادات الموقع ← الإضافات ← رفع إضافة جديدة** وارفع الملف.
3. **إعدادات الموقع ← المظهر ← النمط**: اختر **نمط جامعة القلم** واحفظ.
4. اضبط خيارات النمط التي تظهر أسفل قائمة اختيار النمط.

كرّر الخطوة 3 لكل مجلة. التفاصيل في [docs/INSTALL.md](docs/INSTALL.md).

### الإزالة

1. **إعدادات الموقع ← المظهر ← النمط**: اختر *النمط الافتراضي* للموقع
   ولكل مجلة واحفظ.
2. احذف المجلد `plugins/themes/alqalam`.
3. اختيارياً نفّذ `tools/uninstall.sql` لحذف صفوف النمط من جدولي
   `plugin_settings` و`versions`.

التفاصيل في [docs/UNINSTALL.md](docs/UNINSTALL.md).

### الرخصة

رخصة GNU GPL v3 (نفس رخصة OJS).
