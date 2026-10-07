{**
 * plugins/themes/alqalam/templates/frontend/pages/indexSite.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Site index: the list of journals published by the university.
 *}
{include file="frontend/components/header.tpl"}

<div class="page_index_site alq_home">

	{if $highlights && $highlights->count()}
		{include file="frontend/components/highlights.tpl" highlights=$highlights}
	{/if}

	<section class="alq_site_intro">
		<h2>{translate key="plugins.themes.alqalam.home.journals"}</h2>
		{if $about}
			<div class="about_site">
				{$about}
			</div>
		{else}
			<p>{translate key="plugins.themes.alqalam.home.journalsIntro"}</p>
		{/if}
	</section>

	{include file="frontend/objects/announcements_list.tpl" numAnnouncements=$numAnnouncementsHomepage}

	<div class="journals">
		<h2 class="pkp_screen_reader">
			{translate key="context.contexts"}
		</h2>
		{if !$journals|@count}
			{translate key="site.noJournals"}
		{else}
			<ul class="alq_journals">
				{foreach from=$journals item=journal}
					{capture assign="url"}{url journal=$journal->getPath()}{/capture}
					{assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}
					{assign var="description" value=$journal->getLocalizedDescription()}
					<li{if $thumb} class="has_thumb"{/if}>
						{if $thumb}
							<a class="alq_journal_thumb" href="{$url}">
								<img src="{$journalFilesPath}{$journal->getId()}/{$thumb.uploadName|escape:"url"}" alt="{$thumb.altText|escape|default:$journal->getLocalizedName()|escape}">
							</a>
						{/if}

						<div class="alq_journal_body">
							<h3>
								<a href="{$url}" rel="bookmark">
									{$journal->getLocalizedName()|escape}
								</a>
							</h3>
							{if $journal->getData('printIssn') || $journal->getData('onlineIssn')}
								<div class="alq_journal_issn">
									{if $journal->getData('printIssn')}
										<span>{translate key="plugins.themes.alqalam.issn.print"} {$journal->getData('printIssn')|escape}</span>
									{/if}
									{if $journal->getData('onlineIssn')}
										<span>{translate key="plugins.themes.alqalam.issn.online"} {$journal->getData('onlineIssn')|escape}</span>
									{/if}
								</div>
							{/if}
							{if $description}
								<div class="description">
									{$description}
								</div>
							{/if}
							<div class="alq_journal_links">
								<a class="alq_btn alq_btn--primary" href="{$url}">
									{translate key="site.journalView"}
								</a>
								<a class="alq_btn alq_btn--outline" href="{url journal=$journal->getPath() page="issue" op="current"}">
									{translate key="site.journalCurrent"}
								</a>
							</div>
						</div>
					</li>
				{/foreach}
			</ul>
		{/if}
	</div>

</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
