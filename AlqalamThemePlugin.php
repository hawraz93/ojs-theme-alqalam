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
use APP\facades\Repo;
use APP\file\PublicFileManager;
use Illuminate\Support\Facades\Cache;
use PKP\core\PKPApplication;
use PKP\core\PKPSessionGuard;
use PKP\decision\Decision;
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

    /** Lifetime of cached per-article statistics (seconds) */
    public const STATS_CACHE_TTL = 3600;

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
        // every template and add Open Graph tags.
        Hook::add('TemplateManager::display', $this->assignTemplateVars(...));

        // Add share buttons, statistics, dates and badges to the article
        // page without overriding the whole article template.
        Hook::add('Templates::Article::Details', $this->addArticleDetails(...));

        // Navigation menu areas supported by this theme
        $this->addMenuArea(['primary', 'user']);
    }

    /**
     * Register the theme options shown in Website Settings > Appearance.
     *
     * Note: multilingual options must keep a string default. ThemePlugin
     * converts stored values according to the default's type, and an array
     * default makes it json_decode() an already-decoded array.
     */
    protected function registerOptions(): void
    {
        // ---- Colours & header -------------------------------------------
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

        // ---- Notice bar ---------------------------------------------------
        $this->addOption('noticeText', 'FieldTextarea', [
            'label' => __('plugins.themes.alqalam.option.noticeText.label'),
            'description' => __('plugins.themes.alqalam.option.noticeText.description'),
            'isMultilingual' => true,
            'default' => '',
        ]);

        // ---- Homepage -----------------------------------------------------
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

        $this->addOption('useHomepageImageAsHero', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.useHomepageImageAsHero.label'),
            'description' => __('plugins.themes.alqalam.option.useHomepageImageAsHero.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.useHomepageImageAsHero.option')],
            ],
            'default' => false,
        ]);

        $this->addOption('editorName', 'FieldText', [
            'label' => __('plugins.themes.alqalam.option.editorName.label'),
            'description' => __('plugins.themes.alqalam.option.editorName.description'),
            'isMultilingual' => true,
            'default' => '',
        ]);

        $this->addOption('editorTitle', 'FieldText', [
            'label' => __('plugins.themes.alqalam.option.editorTitle.label'),
            'isMultilingual' => true,
            'default' => '',
        ]);

        $this->addOption('editorPhotoUrl', 'FieldText', [
            'label' => __('plugins.themes.alqalam.option.editorPhotoUrl.label'),
            'description' => __('plugins.themes.alqalam.option.editorPhotoUrl.description'),
            'default' => '',
        ]);

        $this->addOption('editorMessage', 'FieldTextarea', [
            'label' => __('plugins.themes.alqalam.option.editorMessage.label'),
            'isMultilingual' => true,
            'size' => 'large',
            'default' => '',
        ]);

        $this->addOption('indexingHtml', 'FieldTextarea', [
            'label' => __('plugins.themes.alqalam.option.indexingHtml.label'),
            'description' => __('plugins.themes.alqalam.option.indexingHtml.description'),
            'isMultilingual' => true,
            'size' => 'large',
            'default' => '',
        ]);

        // ---- Article lists & article page --------------------------------
        $this->addOption('showAffiliationsInLists', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showAffiliationsInLists.label'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showAffiliationsInLists.option')],
            ],
            'default' => false,
        ]);

        $this->addOption('showStatsCounters', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showStatsCounters.label'),
            'description' => __('plugins.themes.alqalam.option.showStatsCounters.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showStatsCounters.option')],
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

        $this->addOption('showDimensionsBadge', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showDimensionsBadge.label'),
            'description' => __('plugins.themes.alqalam.option.badges.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showDimensionsBadge.option')],
            ],
            'default' => false,
        ]);

        $this->addOption('showAltmetricBadge', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.showAltmetricBadge.label'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.showAltmetricBadge.option')],
            ],
            'default' => false,
        ]);

        $this->addOption('enableOpenGraph', 'FieldOptions', [
            'label' => __('plugins.themes.alqalam.option.enableOpenGraph.label'),
            'description' => __('plugins.themes.alqalam.option.enableOpenGraph.description'),
            'options' => [
                ['value' => true, 'label' => __('plugins.themes.alqalam.option.enableOpenGraph.option')],
            ],
            'default' => true,
        ]);

        // ---- Social -------------------------------------------------------
        foreach (self::SOCIAL_NETWORKS as $network) {
            $this->addOption('social' . ucfirst($network), 'FieldText', [
                'label' => __('plugins.themes.alqalam.option.social.' . $network),
                'default' => '',
            ]);
        }
    }

    /**
     * Assign theme variables to the template manager so that header, footer
     * and homepage templates can use them, and add Open Graph tags.
     *
     * @param string $hookName
     * @param array $args [$templateMgr, &$template, &$output]
     */
    public function assignTemplateVars(string $hookName, array $args): bool
    {
        $templateMgr = $args[0];
        $template = (string) ($args[1] ?? '');
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

        $notice = $this->getLocalizedTextOption('noticeText');

        $editorPhoto = trim((string) $this->getOption('editorPhotoUrl'));
        if ($editorPhoto !== '' && !preg_match('#^(https?://|/)#i', $editorPhoto)) {
            $editorPhoto = '';
        }
        $editor = [
            'name' => $this->getLocalizedTextOption('editorName'),
            'title' => $this->getLocalizedTextOption('editorTitle'),
            'photo' => $editorPhoto,
            'message' => $this->getLocalizedTextOption('editorMessage'),
        ];

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
            'alqalamNotice' => $notice,
            'alqalamNoticeId' => $notice !== '' ? substr(md5($notice), 0, 10) : '',
            'alqalamEditor' => $editor['name'] !== '' ? $editor : null,
            'alqalamUseHeroImage' => (bool) $this->getOption('useHomepageImageAsHero'),
        ]);

        // Article page: statistics, acceptance date, DOI for badges
        if ($template === 'frontend/pages/article.tpl') {
            $this->assignArticleVars($templateMgr, $context);
        }

        if ($this->getOption('enableOpenGraph')) {
            $this->addOpenGraphTags($templateMgr, $template, $context);
        }

        return false;
    }

    /**
     * Assign the extra data used by the article page blocks.
     */
    protected function assignArticleVars($templateMgr, $context): void
    {
        $article = $templateMgr->getTemplateVars('article');
        $publication = $templateMgr->getTemplateVars('publication');
        if (!$article || !$publication || !$context) {
            return;
        }

        $vars = [
            'alqalamStats' => null,
            'alqalamAcceptedDate' => null,
            'alqalamDoi' => null,
        ];

        if ($this->getOption('showStatsCounters')) {
            $vars['alqalamStats'] = $this->getArticleStats((int) $article->getId(), (int) $context->getId());
        }

        if ($this->getOption('showSubmissionDates')) {
            $vars['alqalamAcceptedDate'] = $this->getAcceptedDate((int) $article->getId());
        }

        $doiObject = $publication->getData('doiObject');
        if ($doiObject && $doiObject->getData('doi')) {
            $vars['alqalamDoi'] = $doiObject->getData('doi');
        }

        $templateMgr->assign($vars);
    }

    /**
     * Total abstract views and file downloads of an article (cached).
     *
     * @return array{views:int,downloads:int}|null
     */
    protected function getArticleStats(int $submissionId, int $contextId): ?array
    {
        try {
            return Cache::remember(
                "alqalamArticleStats-{$contextId}-{$submissionId}",
                self::STATS_CACHE_TTL,
                function () use ($submissionId, $contextId) {
                    $statsService = app()->get('publicationStats');
                    $totals = $statsService->getTotalsByType($submissionId, $contextId, null, null);
                    return [
                        'views' => (int) ($totals['abstract'] ?? 0),
                        'downloads' => (int) (($totals['pdf'] ?? 0) + ($totals['html'] ?? 0) + ($totals['other'] ?? 0) + ($totals['suppFileViews'] ?? 0)),
                    ];
                }
            );
        } catch (\Throwable $e) {
            error_log('alqalam theme: could not load article statistics: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Date of the first "Accept" editorial decision of a submission, or null.
     */
    protected function getAcceptedDate(int $submissionId): ?string
    {
        try {
            $decisions = Repo::decision()->getCollector()
                ->filterBySubmissionIds([$submissionId])
                ->filterByDecisionTypes([Decision::ACCEPT, Decision::SKIP_EXTERNAL_REVIEW])
                ->getMany();

            $earliest = null;
            foreach ($decisions as $decision) {
                $date = $decision->getData('dateDecided');
                if ($date && ($earliest === null || $date < $earliest)) {
                    $earliest = $date;
                }
            }
            return $earliest;
        } catch (\Throwable $e) {
            error_log('alqalam theme: could not load editorial decisions: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Add Open Graph / Twitter Card meta tags for the current page so that
     * shared links show a proper title, description and image.
     */
    protected function addOpenGraphTags($templateMgr, string $template, $context): void
    {
        try {
            $this->buildOpenGraphTags($templateMgr, $template, $context);
        } catch (\Throwable $e) {
            // Social metadata must never break the page
            error_log('alqalam theme: could not build Open Graph tags: ' . $e->getMessage());
        }
    }

    /**
     * @see self::addOpenGraphTags()
     */
    protected function buildOpenGraphTags($templateMgr, string $template, $context): void
    {
        $request = Application::get()->getRequest();
        $dispatcher = $request->getDispatcher();
        if (!$dispatcher) {
            return;
        }

        $publicFileManager = new PublicFileManager();
        $baseUrl = $request->getBaseUrl();
        $siteName = $context ? $context->getLocalizedName() : $request->getSite()->getLocalizedTitle();
        $fallbackImage = $this->_getBaseUrl('images/alqalam-university-logo.png');

        $type = 'website';
        $title = $siteName;
        $description = '';
        $image = null;
        $url = $request->getCompleteUrl();
        $extra = [];

        // Journal logo / thumbnail as default image
        if ($context) {
            $logo = $context->getLocalizedData('journalThumbnail') ?: $context->getLocalizedData('pageHeaderLogoImage');
            if (!empty($logo['uploadName'])) {
                $image = $baseUrl . '/' . $publicFileManager->getContextFilesPath($context->getId()) . '/' . $logo['uploadName'];
            }
            $description = (string) $context->getLocalizedData('description');
        } else {
            $description = (string) $request->getSite()->getLocalizedData('about');
        }

        if ($template === 'frontend/pages/article.tpl') {
            $article = $templateMgr->getTemplateVars('article');
            $publication = $templateMgr->getTemplateVars('publication');
            $issue = $templateMgr->getTemplateVars('issue');
            if ($article && $publication && $context) {
                $type = 'article';
                $title = (string) $publication->getLocalizedFullTitle();
                $description = (string) $publication->getLocalizedData('abstract');
                $url = $dispatcher->url($request, PKPApplication::ROUTE_PAGE, null, 'article', 'view', [$article->getBestId()]);
                if ($publication->getLocalizedData('coverImage')) {
                    $image = $publication->getLocalizedCoverImageUrl($context->getId());
                } elseif ($issue && $issue->getLocalizedCoverImageUrl()) {
                    $image = $issue->getLocalizedCoverImageUrl();
                }
                if ($datePublished = $publication->getData('datePublished')) {
                    $extra['article:published_time'] = date('c', strtotime($datePublished));
                }
                // Authors are lazy-loaded on the publication; fetch them explicitly
                $authors = Repo::author()->getCollector()
                    ->filterByPublicationIds([$publication->getId()])
                    ->getMany();
                foreach ($authors as $author) {
                    $extra['article:author'][] = $author->getFullName();
                }
                $extra['article:section'] = $siteName;
            }
        } elseif ($template === 'frontend/pages/issue.tpl') {
            $issue = $templateMgr->getTemplateVars('issue');
            if ($issue) {
                $title = $issue->getIssueIdentification() . ' | ' . $siteName;
                $description = (string) $issue->getLocalizedDescription() ?: $description;
                if ($issue->getLocalizedCoverImageUrl()) {
                    $image = $issue->getLocalizedCoverImageUrl();
                }
            }
        }

        $description = trim(preg_replace('/\s+/u', ' ', strip_tags(html_entity_decode($description, ENT_QUOTES | ENT_HTML5, 'UTF-8'))));
        if (mb_strlen($description) > 300) {
            $description = rtrim(mb_substr($description, 0, 297)) . '…';
        }

        $tags = [
            'og:type' => $type,
            'og:site_name' => $siteName,
            'og:title' => $title,
            'og:description' => $description,
            'og:url' => $url,
            'og:image' => $image ?: $fallbackImage,
            'og:locale' => str_replace('-', '_', \PKP\facades\Locale::getLocale()),
            'twitter:card' => $image ? 'summary_large_image' : 'summary',
            'twitter:title' => $title,
            'twitter:description' => $description,
            'twitter:image' => $image ?: $fallbackImage,
        ];

        $html = '';
        foreach ($tags as $property => $content) {
            if ($content === '' || $content === null) {
                continue;
            }
            $attr = str_starts_with($property, 'twitter:') ? 'name' : 'property';
            $html .= '<meta ' . $attr . '="' . $property . '" content="' . htmlspecialchars((string) $content, ENT_QUOTES, 'UTF-8') . '">' . "\n";
        }
        foreach ($extra as $property => $content) {
            foreach ((array) $content as $value) {
                $html .= '<meta property="' . $property . '" content="' . htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8') . '">' . "\n";
            }
        }

        $templateMgr->addHeader('alqalamOpenGraph', $html, ['contexts' => ['frontend']]);
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
     * Append theme blocks (statistics, dates, share buttons, badges) to the
     * article details column.
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
