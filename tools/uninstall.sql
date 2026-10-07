-- Al-Qalam University theme for OJS 3.5 — database clean-up
--
-- Run AFTER switching the site and every journal back to another theme
-- (Website Settings > Appearance > Theme) and deleting plugins/themes/alqalam.
-- See docs/UNINSTALL.md.

-- Make sure no context still points to the removed theme
UPDATE site_settings    SET setting_value = 'default' WHERE setting_name = 'themePluginPath' AND setting_value = 'alqalam';
UPDATE journal_settings SET setting_value = 'default' WHERE setting_name = 'themePluginPath' AND setting_value = 'alqalam';

-- Theme options (all contexts)
DELETE FROM plugin_settings WHERE plugin_name = 'alqalamthemeplugin';

-- Plugin version registration
DELETE FROM versions WHERE product_type = 'plugins.themes' AND product = 'alqalam';
