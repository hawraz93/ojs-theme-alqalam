{**
 * plugins/themes/alqalam/templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Journal homepage for the Al-Qalam University theme.
 *
 *  1. Highlights carousel (OJS 3.5 "Highlights" feature), if any
 *  2. Banner: journal name, description, calls to action, current issue cover
 *     (optionally with the homepage image as background)
 *  3. Homepage image (if uploaded and not used as banner background)
 *  4. Announcements
 *  5. Editor-in-chief card (theme option)
 *  6. Current issue table of contents
 *  7. Additional homepage content
 *  8. Indexing / partners block (theme option)
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the homepage
 * @uses $issue Issue Current issue
 *
 * @hook Templates::Index::journal []
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div class="page_index_journal alq_home">

	{call_hook name="Templates::Index::journal"}

	{if $highlights && $highlights->count()}
		{include file="frontend/components/highlights.tpl" highlights=$highlights}
	{/if}

	{* Banner *}
	{assign var="alqShowCover" value=$activeTheme && $activeTheme->getOption('showIssueCover') && $issue && $issue->getLocalizedCoverImageUrl()}
	{assign var="alqHeroImage" value=$alqalamUseHeroImage && $homepageImage}
	<section class="alq_hero{if $alqShowCover} alq_hero--has-cover{/if}{if $alqHeroImage} alq_hero--image{/if}"{if $alqHeroImage} style="background-image: url('{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}');"{/if}>
		<div class="alq_hero_text">
			{if $currentContext->getData('publisherInstitution')}
				<p class="alq_hero_kicker">{translate key="plugins.themes.alqalam.home.publishedBy"} {$currentContext->getData('publisherInstitution')|escape}</p>
			{/if}
			<h2 class="alq_hero_title">{$currentContext->getLocalizedName()|escape}</h2>
			{if $activeTheme && $activeTheme->getOption('showJournalDescription') && $journalDescription}
				<div class="alq_hero_desc">
					<a id="homepageAbout"></a>
					{$journalDescription}
				</div>
			{/if}
			{if $currentContext->getData('printIssn') || $currentContext->getData('onlineIssn')}
				<div class="alq_hero_meta">
					{if $currentContext->getData('printIssn')}
						<span><strong>{translate key="plugins.themes.alqalam.issn.print"}</strong> {$currentContext->getData('printIssn')|escape}</span>
					{/if}
					{if $currentContext->getData('onlineIssn')}
						<span><strong>{translate key="plugins.themes.alqalam.issn.online"}</strong> {$currentContext->getData('onlineIssn')|escape}</span>
					{/if}
				</div>
			{/if}
			<div class="alq_hero_actions">
				{if $issue}
					<a class="alq_btn alq_btn--primary" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="current"}">
						<span class="fa fa-book" aria-hidden="true"></span>
						{translate key="plugins.themes.alqalam.home.currentIssue"}
					</a>
				{/if}
				<a class="alq_btn alq_btn--outline" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="submissions"}">
					<span class="fa fa-paper-plane" aria-hidden="true"></span>
					{translate key="plugins.themes.alqalam.home.makeSubmission"}
				</a>
				<a class="alq_btn alq_btn--ghost" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}">
					{translate key="plugins.themes.alqalam.home.archives"}
					<span class="fa fa-angle-right" aria-hidden="true"></span>
				</a>
			</div>
		</div>
		{if $alqShowCover}
			<div class="alq_hero_cover">
				<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="view" path=$issue->getBestIssueId()}">
					{capture assign="alqCoverAlt"}{translate key="issue.viewIssueIdentification" identification=$issue->getIssueIdentification()|escape}{/capture}
					<img src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:$alqCoverAlt}">
					<span class="alq_hero_cover_caption">{$issue->getIssueIdentification()|escape}</span>
				</a>
			</div>
		{/if}
	</section>

	{* Homepage image *}
	{if $homepageImage && !$alqHeroImage}
		<div class="homepage_image">
			<img src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"{if $homepageImage.altText} alt="{$homepageImage.altText|escape}"{/if}>
		</div>
	{/if}

	{* Announcements *}
	{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}

	{* Editor-in-chief *}
	{if $alqalamEditor}
		<section class="alq_editor">
			<div class="alq_editor_card">
				{if $alqalamEditor.photo}
					<img class="alq_editor_photo" src="{$alqalamEditor.photo|escape}" alt="{$alqalamEditor.name|escape}" loading="lazy">
				{else}
					<span class="alq_editor_photo alq_editor_photo--placeholder" aria-hidden="true"><span class="fa fa-user"></span></span>
				{/if}
				<div class="alq_editor_body">
					<p class="alq_editor_kicker">{translate key="plugins.themes.alqalam.home.editorMessage"}</p>
					<h2 class="alq_editor_name">{$alqalamEditor.name|escape}</h2>
					{if $alqalamEditor.title}
						<p class="alq_editor_title">{$alqalamEditor.title|escape}</p>
					{/if}
					{if $alqalamEditor.message}
						<div class="alq_editor_message">{$alqalamEditor.message|strip_unsafe_html|nl2br}</div>
					{/if}
					<a class="alq_btn alq_btn--ghost" href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="about" op="editorialMasthead"}">
						{translate key="common.editorialMasthead"}
						<span class="fa fa-angle-right" aria-hidden="true"></span>
					</a>
				</div>
			</div>
		</section>
	{/if}

	{* Latest issue *}
	{if $issue}
		<section class="current_issue">
			<a id="homepageIssue"></a>
			<h2>
				{translate key="journal.currentIssue"}
			</h2>
			<div class="current_issue_title">
				{$issue->getIssueIdentification()|escape}
			</div>
			{include file="frontend/objects/issue_toc.tpl" heading="h3"}
			<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="issue" op="archive"}" class="read_more">
				{translate key="journal.viewAllIssues"}
			</a>
		</section>
	{/if}

	{* Additional Homepage Content *}
	{if $additionalHomeContent}
		<div class="additional_content">
			{$additionalHomeContent}
		</div>
	{/if}

	{* Indexing / partners *}
	{if $alqalamIndexingHtml}
		<section class="alq_indexing">
			<h2>{translate key="plugins.themes.alqalam.home.indexing"}</h2>
			<div class="alq_indexing_body">
				{$alqalamIndexingHtml|strip_unsafe_html}
			</div>
		</section>
	{/if}
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
