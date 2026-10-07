{**
 * plugins/themes/alqalam/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Common frontend site header for the Al-Qalam University theme.
 *
 * Structure:
 *   1. University bar  – university name/link, language switcher, user menu
 *   2. Masthead        – university logo, journal logo or name, ISSN, search
 *   3. Navigation bar  – primary menu
 *
 * The ids and classes used by OJS core and the parent theme's JavaScript
 * (pkp_structure_head, pkp_site_nav_toggle, pkp_site_nav_menu,
 * navigationPrimary, navigationUser, pkp_structure_content, pkp_structure_main)
 * are preserved.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars?
 *}
{strip}
	{assign var="showingLogo" value=true}
	{if !$displayPageHeaderLogo}
		{assign var="showingLogo" value=false}
	{/if}
	{assign var="alqHeaderStyle" value=$alqalamHeaderStyle|default:"light"}
	{assign var="alqShowBar" value=$activeTheme && $activeTheme->getOption('showUniversityBar')}
	{assign var="alqShowUnivLogo" value=$activeTheme && $activeTheme->getOption('showUniversityLogo')}
{/strip}
<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if} alq_body alq_header_{$alqHeaderStyle|escape}" dir="{$currentLocaleLangDir|escape|default:"ltr"}">

	<div class="pkp_structure_page">

		{* Header *}
		<header class="pkp_structure_head alq_head" id="headerNavigationContainer" role="banner">
			{* Skip to content nav links *}
			{include file="frontend/components/skipLinks.tpl"}

			{capture assign="homeUrl"}{url page="index" router=PKP\core\PKPApplication::ROUTE_PAGE}{/capture}

			{* 1. University bar *}
			{if $alqShowBar}
				<div class="alq_topbar">
					<div class="alq_container alq_topbar_inner">
						<a class="alq_topbar_univ" href="{$alqalamUniversityUrl|escape}" target="_blank" rel="noopener">
							<span class="fa fa-university" aria-hidden="true"></span>
							<span>{$alqalamUniversityName|escape}</span>
							<span class="pkp_screen_reader">({translate key="plugins.themes.alqalam.topbar.universitySite"})</span>
						</a>
						<div class="alq_topbar_tools">
							{include file="frontend/components/alqalamLanguageToggle.tpl"}
						</div>
					</div>
				</div>
			{/if}

			{* 2. Masthead *}
			<div class="alq_masthead">
				<div class="alq_container alq_masthead_inner">
					<button class="pkp_site_nav_toggle" aria-controls="siteNavMenu" aria-expanded="false">
						<span>{translate key="common.navigation.site"}</span>
					</button>

					{if !$requestedPage || $requestedPage === 'index'}
						<h1 class="pkp_screen_reader">
							{if $currentContext}
								{$displayPageHeaderTitle|escape}
							{else}
								{$siteTitle|escape}
							{/if}
						</h1>
					{/if}

					<div class="alq_brand">
						{if $alqShowUnivLogo}
							<a href="{$alqalamUniversityUrl|escape}" class="alq_brand_univ" target="_blank" rel="noopener" title="{$alqalamUniversityName|escape}">
								<img src="{$alqalamThemePath}/images/alqalam-university-logo-256.png" alt="{$alqalamUniversityName|escape}" width="256" height="238">
							</a>
						{/if}
						<div class="alq_brand_text">
							{if $displayPageHeaderLogo}
								{* A wide (banner-like) logo usually already contains the journal
								   name; a compact logo is shown together with the name. *}
								{assign var="alqLogoIsWide" value=$displayPageHeaderLogo.width > ($displayPageHeaderLogo.height * 2.5)}
								<div class="alq_brand_logo_row{if !$alqLogoIsWide} alq_brand_logo_row--with-title{/if}">
									<a href="{$homeUrl}" class="alq_brand_logo is_img">
										<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" width="{$displayPageHeaderLogo.width|escape}" height="{$displayPageHeaderLogo.height|escape}" alt="{if $displayPageHeaderLogo.altText}{$displayPageHeaderLogo.altText|escape}{else}{$displayPageHeaderTitle|escape}{/if}" />
									</a>
									{if !$alqLogoIsWide && $displayPageHeaderTitle}
										<a href="{$homeUrl}" class="alq_brand_title is_text">{$displayPageHeaderTitle|escape}</a>
									{/if}
								</div>
							{elseif $displayPageHeaderTitle}
								<a href="{$homeUrl}" class="alq_brand_title is_text">{$displayPageHeaderTitle|escape}</a>
							{else}
								<a href="{$homeUrl}" class="alq_brand_title is_text">{$siteTitle|escape|default:$applicationName|escape}</a>
							{/if}
							<div class="alq_brand_sub">
								{if $currentContext}
									{if $currentContext->getData('publisherInstitution')}
										<span class="alq_brand_publisher">{$currentContext->getData('publisherInstitution')|escape}</span>
									{/if}
									{if $currentContext->getData('printIssn')}
										<span class="alq_issn"><span class="alq_issn_label">{translate key="plugins.themes.alqalam.issn.print"}</span> {$currentContext->getData('printIssn')|escape}</span>
									{/if}
									{if $currentContext->getData('onlineIssn')}
										<span class="alq_issn"><span class="alq_issn_label">{translate key="plugins.themes.alqalam.issn.online"}</span> {$currentContext->getData('onlineIssn')|escape}</span>
									{/if}
								{else}
									<span class="alq_brand_publisher">{$alqalamUniversityName|escape}</span>
								{/if}
							</div>
						</div>
					</div>

					{if $currentContext && $requestedPage !== 'search'}
						<form class="alq_masthead_search" method="get" action="{url page="search"}" role="search">
							<label class="pkp_screen_reader" for="alqSearchQuery">{translate key="common.search"}</label>
							<input type="search" id="alqSearchQuery" name="query" placeholder="{translate|escape key="common.search"}">
							<button type="submit" aria-label="{translate|escape key="common.search"}">
								<span class="fa fa-search" aria-hidden="true"></span>
							</button>
						</form>
					{/if}
				</div>
			</div>

			{* 3. Navigation *}
			{capture assign="primaryMenu"}
				{load_menu name="primary" id="navigationPrimary" ulClass="pkp_navigation_primary"}
			{/capture}

			<nav class="pkp_site_nav_menu alq_nav" id="siteNavMenu" aria-label="{translate|escape key="common.navigation.site"}">
				<a id="siteNav"></a>
				<div class="alq_container alq_nav_inner">
					<div class="pkp_navigation_primary_row">
						<div class="pkp_navigation_primary_wrapper">
							{* Primary navigation menu for current application *}
							{$primaryMenu}

							{* Search link (shown inside the mobile menu) *}
							{if $currentContext && $requestedPage !== 'search'}
								<div class="pkp_navigation_search_wrapper">
									<a href="{url page="search"}" class="pkp_search pkp_search_desktop">
										<span class="fa fa-search" aria-hidden="true"></span>
										{translate key="common.search"}
									</a>
								</div>
							{/if}
						</div>
					</div>
					<div class="pkp_navigation_user_wrapper" id="navigationUserWrapper">
						{load_menu name="user" id="navigationUser" ulClass="pkp_navigation_user" liClass="profile"}
					</div>
				</div>
			</nav>

			{* 4. Site-wide notice (theme option) *}
			{if $alqalamNotice}
				<div class="alq_notice" role="status" data-notice-id="{$alqalamNoticeId|escape}">
					<div class="alq_container alq_notice_inner">
						<span class="fa fa-bullhorn" aria-hidden="true"></span>
						<div class="alq_notice_text">{$alqalamNotice|strip_unsafe_html|nl2br}</div>
						<button type="button" class="alq_notice_close" aria-label="{translate|escape key="common.close"}">
							<span class="fa fa-times" aria-hidden="true"></span>
						</button>
					</div>
				</div>
			{/if}
		</header><!-- .pkp_structure_head -->

		{* Wrapper for page content and sidebars *}
		{if $isFullWidth}
			{assign var=hasSidebar value=0}
		{/if}
		<div class="pkp_structure_content{if $hasSidebar} has_sidebar{/if}">
			<div class="pkp_structure_main" role="main">
				<a id="pkp_content_main"></a>
