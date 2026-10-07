# Uninstallation / الإزالة

The theme is self-contained: one folder under `plugins/themes`, a few rows
in `plugin_settings` (its options) and one row in `versions`. Nothing else
in OJS is touched, so removing it is safe and reversible.

## English

### 1. Switch back to another theme (required)

Do this **before** deleting the folder, otherwise OJS will fall back to
the default theme automatically but may log warnings.

- **Site**: Administration → Site Settings → Appearance → Theme → choose
  *Default Theme* → Save.
- **Each journal**: Settings → Website → Appearance → Theme → choose
  *Default Theme* → Save.

Alternatively run in the database:

```sql
UPDATE site_settings    SET setting_value = 'default' WHERE setting_name = 'themePluginPath';
UPDATE journal_settings SET setting_value = 'default' WHERE setting_name = 'themePluginPath';
```

### 2. Delete the theme folder

```bash
rm -rf /www/wwwroot/scientificjournal.alqalam.edu.iq/plugins/themes/alqalam
```

(or delete the folder `plugins/themes/alqalam` in the aaPanel file
manager).

### 3. Remove the theme's database rows (optional, recommended)

Run `tools/uninstall.sql` (also reproduced here):

```sql
DELETE FROM plugin_settings WHERE plugin_name = 'alqalamthemeplugin';
DELETE FROM versions WHERE product_type = 'plugins.themes' AND product = 'alqalam';
```

### 4. Clear the caches

Administration → Clear Template Cache and Clear Data Cache, or:

```bash
rm -f cache/t_compile/* cache/*.css cache/fc-pluginSettings-*
```

### Re-installing later

The theme can be installed again at any time; the options are recreated
with their defaults (or kept, if step 3 was skipped).

---

## العربية

النمط مستقل بذاته: مجلد واحد تحت `plugins/themes`، وبضعة صفوف في جدول
`plugin_settings` (خياراته)، وصف واحد في جدول `versions`. لا يُمَسّ أي شيء
آخر في النظام، لذا فإن إزالته آمنة وقابلة للتراجع.

### 1. الرجوع إلى نمط آخر (إلزامي)

نفّذ هذه الخطوة **قبل** حذف المجلد.

- **الموقع**: الإدارة ← إعدادات الموقع ← المظهر ← النمط ← اختر *النمط
  الافتراضي* ← حفظ.
- **كل مجلة**: الإعدادات ← الموقع ← المظهر ← النمط ← اختر *النمط
  الافتراضي* ← حفظ.

أو نفّذ في قاعدة البيانات:

```sql
UPDATE site_settings    SET setting_value = 'default' WHERE setting_name = 'themePluginPath';
UPDATE journal_settings SET setting_value = 'default' WHERE setting_name = 'themePluginPath';
```

### 2. حذف مجلد النمط

احذف المجلد `plugins/themes/alqalam` (من SSH أو مدير ملفات aaPanel).

### 3. حذف صفوف النمط من قاعدة البيانات (اختياري، موصى به)

نفّذ الملف `tools/uninstall.sql`:

```sql
DELETE FROM plugin_settings WHERE plugin_name = 'alqalamthemeplugin';
DELETE FROM versions WHERE product_type = 'plugins.themes' AND product = 'alqalam';
```

### 4. مسح الذاكرة المؤقتة

الإدارة ← مسح ذاكرة القوالب ومسح ذاكرة البيانات.

يمكن إعادة تثبيت النمط لاحقاً في أي وقت.
