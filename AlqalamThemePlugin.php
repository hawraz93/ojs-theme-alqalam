<?php

/**
 * @file plugins/themes/alqalam/AlqalamThemePlugin.php
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @class AlqalamThemePlugin
 *
 * @brief Al-Qalam University theme for OJS 3.5 (child theme of the default theme).
 *
 * The theme never touches core files or the database schema. It stores its
 * options as ordinary plugin settings, so removing the theme is a matter of
 * switching back to another theme and deleting this folder
 * (see docs/UNINSTALL.md).
 */

namespace APP\plugins\themes\alqalam;

use APP\core\Application;
use PKP\core\PKPSessionGuard;
use PKP\plugins\Hook;
use PKP\plugins\ThemePlugin;

class AlqalamThemePlugin extends ThemePlugin
{
    /** Brand colours sampled from the official university logo */
    public const DEFAULT_PRIMARY = '#283078';   // navy (column, text)
    public const DEFAULT_ACCENT = '#910051';    // plum (laurel branches, links)
    public const DEFAULT_HIGHLIGHT = '#F0A018'; // gold (sun)

    public const DEFAULT_UNIVERSITY_URL = 'https://alqalam.edu.iq';

    /** Social networks offered as theme options (option name suffix => key) */
    public const SOCIAL_NETWORKS = ['facebook', 'instagram', 'youtube', 'x', 'telegram', 'linkedin', 'whatsapp'];

    /**
     * @copydoc ThemePlugin::isActive()
     */
    public function isActive()
    {
        if (PKPSessionGuard::isSessionDisable()) {
            return true;
        }
        return parent::isActive();
    }

    /**
     * Initialize the theme's styles, scripts and hooks. This is run on the
     * currently active theme and its parent themes.
     */
    public function init()
    {
        // Inherit everything from the default theme (templates, LESS, scripts)
        $this->setParent('defaultthemeplugin');

        // Options of the parent theme that this theme replaces
        $this->removeOption('typography');
        $this->removeOption('baseColour');
        $this->removeOption('useHomepageImageAsHeader');
        $this->removeOption('showDescriptionInJournalIndex');

        $this->registerOptions();

        // ---- Styles -----------------------------------------------------
        // Our LESS is appended to the parent's stylesheet so it is compiled
        // in the same pass and can override the parent's variables.
        $this->modifyStyle('stylesheet', ['addLess' => ['styles/alqalam.less']]);
        $this->modifyStyle('stylesheet', ['addLessVariables' => $this->getLessVariables()]);

        // Self-hosted fonts (Roboto for Latin, Almarai/Amiri for Arabic)
        $this->addStyle('alqalamFonts', 'styles/fonts.less', [
            'addLessVariables' => '@alq-theme-url: "' . $this->_getBaseUrl() . '";',
        ]);

        // The parent loads Noto Sans; not needed any more
        $this->removeStyle('font');

        // ---- Scripts ----------------------------------------------------
        $this->addScript('alqalamI18n', $this->getJsI18n(), ['inline' => true]);
        $this->addScript('alqalam', 'js/alqalam.js');

        // ---- Hooks ------------------------------------------------------
        // Expose theme data (university name, locales, social links...) to
        // every template.
        Hook::add('TemplateManager::display', $this->assignTemplateVars(...));

        // Add share buttons + dates to the article page without overriding
        // the whole article template.
        Hook::add('Templates::Article::Details', $this->addArticleDetails(...));

        // Navigation menu areas supported by this theme
        $this->addMenuArea(['primary', 'user']);
    }

    /**
     * Register the theme options shown in Website Settings > Appearance.
     */
    protected function registerOptions(): void
    {
        $this->addOption('primaryColour', 'FieldColor', [
            'label' => __('plugins.themes.alqalam.option.primaryColour.label'),
            'description' => __('plugins.themes.alqalam.option.primaryColour.description'),
            'default' => self::DEFAULT_PRIMARY,
        ]);

        $this->addOption('accentColour', 'FieldColor', [
            'label' => __('plugins.themes.alqalam.option.accentColour.label'),
            'description' => __('plugins.themes.alqalam.option.accentColour.description'),
            'default' => self::DEFAULT_ACCENT,
        ]);

        $this->addOption('highlightColour', 'FieldColor', [
            'label' => __('plugins.themes.alqalam.option.highlightColour.label'),
            'description' => __('plugins.themes.alqalam.option.highlightColour.description'),
            'default' => self::DEFAULT_HIGHLIGHT,
        ]);

        $this->addOption('headerStyle', 'FieldOptions', [
            'type' => 'radio',
            'label' => __('plugins.themes.alqalam.option.headerStyle.label'),
            'description' => __('plugins.themes.alqalam.option.headerStyle.description'),
            'options' => [
                ['value' => 'light', 'label' => __('plugins.themes.alqalam.option.headerStyle.light')],
                ['value' => 'dark', 'label' => __('plugins.themes.alqalam.option.headerStyle.dark')],
            ],
            'default' => 'light',
        ]);

        $this->addOption('showUniversityBar', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showUniversityBar.label'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showUniversityBar.option')],
            ],
            'default' => true,
        ]);

        $this->addOption('showUniversityLogo', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showUniversityLogo.label'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showUniversityLogo.option')],
            ],
            'default' => true,
        ]);

        // Note: multilingual options must keep a string default. ThemePlugin
        // converts stored values according to the default's type, and an
        // array default makes it json_decode() an already-decoded array.
        $this->addOption('universityName', 'FieldText', [
            'label' => __('plugins.themes.alqalam.option.universityName.label'),
            'description' => __('plugins.themes.alqalam.option.universityName.description'),
            'isMultilingual' => true,
            'default' => '',
        ]);

        $this->addOption('universityUrl', 'FieldText', [
            'label' => __('plugins.themes.alqalam.option.universityUrl.label'),
            'default' => self::DEFAULT_UNIVERSITY_URL,
        ]);

        $this->addOption('showJournalDescription', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showJournalDescription.label'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showJournalDescription.option')],
            ],
            'default' => true,
        ]);

        $this->addOption('showIssueCover', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showIssueCover.label'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showIssueCover.option')],
            ],
            'default' => true,
        ]);

        $this->addOption('showSubmissionDates', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showSubmissionDates.label'),
            'description' => __('plugins.themes.alqalam.option.showSubmissionDates.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showSubmissionDates.option')],
            ],
            'default' => false,
        ]);

        $this->addOption('showShareButtons', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showShareButtons.label'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showShareButtons.option')],
            ],
            'default' => true,
        ]);

        $this->addOption('indexingHtml', 'FieldTextarea', [
            'label' => __('plugins.themes.alqalam.option.indexingHtml.label'),
            'description' => __('plugins.themes.alqalam.option.indexingHtml.description'),
            'isMultilingual' => true,
            'size' => 'large',
            'default' => '',
        ]);

        foreach (self::SOCIAL_NETWORKS as $network) {
            $this->addOption('social' . ucfirst($network), 'FieldText', [
                'label' => __('plugins.themes.alqalam.option.social.' . $network),
                'default' => '',
            ]);
        }
    }

    /**
     * Assign theme variables to the template manager so that header, footer
     * and homepage templates can use them.
     *
     * @param string $hookName
     * @param array $args [$templateMgr, &$template, &$output]
     */
    public function assignTemplateVars(string $hookName, array $args): bool
    {
        $templateMgr = $args[0];
        $request = Application::get()->getRequest();
        $context = $request->getContext();

        $universityName = $this->getLocalizedTextOption('universityName');
        if ($universityName === '') {
            $universityName = __('plugins.themes.alqalam.university.name');
        }

        $universityUrl = trim((string) $this->getOption('universityUrl'));
        if ($universityUrl === '' || !preg_match('#^https?://#i', $universityUrl)) {
            $universityUrl = self::DEFAULT_UNIVERSITY_URL;
        }

        $social = [];
        foreach (self::SOCIAL_NETWORKS as $network) {
            $url = trim((string) $this->getOption('social' . ucfirst($network)));
            if ($url !== '' && preg_match('#^https?://#i', $url)) {
                $social[$network] = $url;
            }
        }

        try {
            $locales = $context
                ? $context->getSupportedLocaleNames()
                : $request->getSite()->getSupportedLocaleNames();
        } catch (\Throwable $e) {
            $locales = [];
        }

        $templateMgr->assign([
            'alqalamThemePath' => $this->_getBaseUrl(),
            'alqalamUniversityName' => $universityName,
            'alqalamUniversityUrl' => $universityUrl,
            'alqalamSocial' => $social,
            'alqalamLocales' => $locales,
            'alqalamIndexingHtml' => $this->getLocalizedTextOption('indexingHtml'),
            'alqalamHeaderStyle' => $this->getOption('headerStyle') === 'dark' ? 'dark' : 'light',
            'alqalamPrimaryColour' => $this->getColourOption('primaryColour', self::DEFAULT_PRIMARY),
            'alqalamYear' => date('Y'),
        ]);

        return false;
    }

    /**
     * Get the value of a multilingual text option in the current locale,
     * falling back to the other locales. Always returns a string.
     */
    protected function getLocalizedTextOption(string $name): string
    {
        $value = $this->getOption($name);
        if (is_array($value)) {
            $value = $this->getBestLocalizedData($value) ?? '';
        }
        return is_string($value) ? trim($value) : '';
    }

    /**
     * Build the LESS variables that depend on theme options.
     */
    protected function getLessVariables(): string
    {
        $primary = $this->getColourOption('primaryColour', self::DEFAULT_PRIMARY);
        $accent = $this->getColourOption('accentColour', self::DEFAULT_ACCENT);
        $highlight = $this->getColourOption('highlightColour', self::DEFAULT_HIGHLIGHT);

        $vars = [
            '@alq-primary: ' . $primary . ';',
            '@alq-accent: ' . $accent . ';',
            '@alq-highlight: ' . $highlight . ';',
            '@alq-theme-url: "' . $this->_getBaseUrl() . '";',
            // Variables of the parent theme
            '@bg-base: ' . $primary . ';',
            '@primary: ' . $accent . ';',
            '@primary-lift: lighten(' . $accent . ', 10%);',
        ];

        // Keep header text readable if a light primary colour is chosen
        if (!$this->isColourDark($primary)) {
            $vars[] = '@text-bg-base: rgba(0,0,0,0.84);';
            $vars[] = '@bg-base-border-color: rgba(0,0,0,0.2);';
        }

        return join("\n", $vars);
    }

    /**
     * Read a colour option and fall back to the default when the stored
     * value is not a valid hex colour (defence against LESS injection).
     */
    protected function getColourOption(string $name, string $default): string
    {
        $value = (string) $this->getOption($name);
        return preg_match('/^#[0-9a-fA-F]{3,6}$/', $value) ? $value : $default;
    }

    /**
     * @see ThemePlugin::saveOption
     */
    public function saveOption($name, $value, $contextId = null)
    {
        if (in_array($name, ['primaryColour', 'accentColour', 'highlightColour'])
            && !preg_match('/^#[0-9a-fA-F]{3,6}$/', (string) $value)) {
            $value = null;
        }
        parent::saveOption($name, $value, $contextId);
    }

    /**
     * Append theme blocks (share buttons, submission dates) to the article
     * details column.
     *
     * @param string $hookName
     * @param array $args [&$params, &$smarty, &$output]
     */
    public function addArticleDetails(string $hookName, array $args): bool
    {
        $smarty = &$args[1];
        $output = &$args[2];
        $output .= $smarty->fetch($this->getTemplateResource('frontend/components/alqalamArticleExtras.tpl'));
        return false;
    }

    /**
     * Translated strings used by the theme's JavaScript.
     */
    protected function getJsI18n(): string
    {
        return 'var alqalamThemeI18N = ' . json_encode([
            'copied' => __('plugins.themes.alqalam.share.copied'),
            'copyLink' => __('plugins.themes.alqalam.share.copyLink'),
            'backToTop' => __('plugins.themes.alqalam.backToTop'),
        ]) . ';';
    }

    /**
     * Get the name of the settings file to be installed on new journal creation.
     */
    public function getContextSpecificPluginSettingsFile()
    {
        return $this->getPluginPath() . '/settings.xml';
    }

    /**
     * Get the name of the settings file to be installed site-wide.
     */
    public function getInstallSitePluginSettingsFile()
    {
        return $this->getPluginPath() . '/settings.xml';
    }

    /**
     * Get the display name of this plugin.
     */
    public function getDisplayName()
    {
        return __('plugins.themes.alqalam.name');
    }

    /**
     * Get the description of this plugin.
     */
    public function getDescription()
    {
        return __('plugins.themes.alqalam.description');
    }
}

if (!PKP_STRICT_MODE) {
    class_alias('\APP\plugins\themes\alqalam\AlqalamThemePlugin', '\AlqalamThemePlugin');
}
