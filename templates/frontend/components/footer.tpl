{**
 * plugins/themes/alqalam/templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Common site frontend footer for the Al-Qalam University theme.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars?
 *
 * @hook Templates::Common::Sidebar []
 * @hook Templates::Common::Footer::PageFooter []
 *}

	</div><!-- pkp_structure_main -->

	{* Sidebars *}
	{if empty($isFullWidth)}
		{capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
		{if $sidebarCode}
			<div class="pkp_structure_sidebar left" role="complementary">
				{$sidebarCode}
			</div><!-- pkp_sidebar.left -->
		{/if}
	{/if}
</div><!-- pkp_structure_content -->

{strip}
	{assign var="alqShowUnivLogo" value=$activeTheme && $activeTheme->getOption('showUniversityLogo')}
	{if $currentContext}
		{assign var="alqContactEmail" value=$currentContext->getData('contactEmail')}
		{assign var="alqContactPhone" value=$currentContext->getData('contactPhone')}
		{assign var="alqMailingAddress" value=$currentContext->getLocalizedData('mailingAddress')|strip_tags|trim}
		{assign var="alqPublisherUrl" value=$currentContext->getData('publisherUrl')}
	{/if}
{/strip}

<footer class="pkp_structure_footer_wrapper alq_footer" role="contentinfo">
	<a id="pkp_content_footer"></a>

	<div class="alq_footer_main">
		<div class="alq_container alq_footer_grid">

			{* Column 1: university + journal identity *}
			<div class="alq_footer_col alq_footer_about">
				<div class="alq_footer_brand">
					{if $alqShowUnivLogo}
						<a href="{$alqalamUniversityUrl|escape}" target="_blank" rel="noopener">
							<img src="{$alqalamThemePath}/images/alqalam-university-logo-white.png" alt="{$alqalamUniversityName|escape}" width="512" height="476">
						</a>
					{/if}
					<div>
						<div class="alq_footer_univ">{$alqalamUniversityName|escape}</div>
						{if $currentContext}
							<div class="alq_footer_journal">{$currentContext->getLocalizedName()|escape}</div>
						{/if}
					</div>
				</div>
				{if $currentContext}
					{assign var="alqDescription" value=$currentContext->getLocalizedData('description')|strip_tags|trim}
					{if $alqDescription}
						<p>{$alqDescription|truncate:240:"…"}</p>
					{/if}
					{if $currentContext->getData('printIssn') || $currentContext->getData('onlineIssn')}
						<div class="alq_footer_issn">
							{if $currentContext->getData('printIssn')}
								<span><strong>{translate key="plugins.themes.alqalam.issn.print"}</strong> {$currentContext->getData('printIssn')|escape}</span>
							{/if}
							{if $currentContext->getData('onlineIssn')}
								<span><strong>{translate key="plugins.themes.alqalam.issn.online"}</strong> {$currentContext->getData('onlineIssn')|escape}</span>
							{/if}
						</div>
					{/if}
				{/if}
			</div>

			{* Column 2: quick links *}
			<div class="alq_footer_col alq_footer_links">
				<h3>{translate key="plugins.themes.alqalam.footer.quickLinks"}</h3>
				<ul>
					{if $currentContext}
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="about.aboutContext"}</a></li>
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="editorialMasthead"}">{translate key="common.editorialMasthead"}</a></li>
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">{translate key="about.submissions"}</a></li>
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="current"}">{translate key="navigation.current"}</a></li>
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">{translate key="navigation.archives"}</a></li>
						{if $currentContext->getData('enableAnnouncements')}
							<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="announcement"}">{translate key="announcement.announcements"}</a></li>
						{/if}
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="search"}">{translate key="common.search"}</a></li>
					{else}
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="index"}">{translate key="common.homepageNavigationLabel"}</a></li>
						<li><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about"}">{translate key="navigation.about"}</a></li>
					{/if}
					<li><a href="{$alqalamUniversityUrl|escape}" target="_blank" rel="noopener">{translate key="plugins.themes.alqalam.footer.website"}</a></li>
				</ul>
			</div>

			{* Column 3: contact *}
			<div class="alq_footer_col alq_footer_contact">
				<h3>{translate key="plugins.themes.alqalam.footer.contact"}</h3>
				<ul>
					{if $alqMailingAddress}
						<li><span class="fa fa-map-marker" aria-hidden="true"></span><span>{$alqMailingAddress|escape}</span></li>
					{/if}
					{if $alqContactEmail}
						<li><span class="fa fa-envelope" aria-hidden="true"></span><a href="mailto:{$alqContactEmail|escape}">{$alqContactEmail|escape}</a></li>
					{/if}
					{if $alqContactPhone}
						<li><span class="fa fa-phone" aria-hidden="true"></span><a href="tel:{$alqContactPhone|replace:" ":""|escape}">{$alqContactPhone|escape}</a></li>
					{/if}
					<li><span class="fa fa-globe" aria-hidden="true"></span><a href="{if $alqPublisherUrl}{$alqPublisherUrl|escape}{else}{$alqalamUniversityUrl|escape}{/if}" target="_blank" rel="noopener">{if $alqPublisherUrl}{$alqPublisherUrl|replace:"https://":""|replace:"http://":""|escape}{else}{$alqalamUniversityUrl|replace:"https://":""|replace:"http://":""|escape}{/if}</a></li>
					{if $currentContext}
						<li><span class="fa fa-paper-plane" aria-hidden="true"></span><a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="contact"}">{translate key="plugins.themes.alqalam.footer.contactPage"}</a></li>
					{/if}
				</ul>
			</div>

			{* Column 4: social *}
			<div class="alq_footer_col">
				<h3>{translate key="plugins.themes.alqalam.footer.followUs"}</h3>
				{include file="frontend/components/alqalamSocial.tpl"}
			</div>
		</div>
	</div>

	{* Journal footer text from Website Settings > Appearance > Setup *}
	{if $pageFooter}
		<div class="alq_footer_custom">
			<div class="alq_container">
				<div class="pkp_footer_content">
					{$pageFooter}
				</div>
			</div>
		</div>
	{/if}

	<div class="alq_footer_bottom">
		<div class="alq_container alq_footer_bottom_inner">
			<div class="alq_footer_copyright">
				{translate key="plugins.themes.alqalam.footer.copyright" year=$alqalamYear name=$alqalamUniversityName|escape}
			</div>
			<div class="pkp_brand_footer">
				<a href="{url page="about" op="aboutThisPublishingSystem"}">
					<img alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/templates/images/ojs_brand_white.png">
				</a>
			</div>
		</div>
	</div>
</footer><!-- pkp_structure_footer_wrapper -->

</div><!-- pkp_structure_page -->

{load_script context="frontend"}

{call_hook name="Templates::Common::Footer::PageFooter"}
</body>
</html>
