{**
 * plugins/themes/alqalam/templates/frontend/components/alqalamArticleExtras.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Blocks appended to the article details column through the
 *  Templates::Article::Details hook: usage counters, submission timeline,
 *  share buttons and citation badges.
 *
 * @uses $article Submission
 * @uses $publication Publication
 * @uses $alqalamStats array|null ['views' => int, 'downloads' => int]
 * @uses $alqalamAcceptedDate string|null
 * @uses $alqalamDoi string|null
 *}

{* Usage counters *}
{if $activeTheme && $activeTheme->getOption('showStatsCounters') && $alqalamStats}
	<div class="item alq_stats">
		<h2 class="label">{translate key="plugins.themes.alqalam.article.usage"}</h2>
		<ul class="value alq_stats_list">
			<li>
				<span class="fa fa-eye" aria-hidden="true"></span>
				<strong>{$alqalamStats.views|number_format}</strong>
				<span>{translate key="plugins.themes.alqalam.article.views"}</span>
			</li>
			<li>
				<span class="fa fa-download" aria-hidden="true"></span>
				<strong>{$alqalamStats.downloads|number_format}</strong>
				<span>{translate key="plugins.themes.alqalam.article.downloads"}</span>
			</li>
		</ul>
	</div>
{/if}

{* Submission timeline: received / accepted / published *}
{if $activeTheme && $activeTheme->getOption('showSubmissionDates') && ($article->getData('dateSubmitted') || $alqalamAcceptedDate)}
	<div class="item alq_timeline">
		<h2 class="label">{translate key="plugins.themes.alqalam.article.timeline"}</h2>
		<ol class="value alq_timeline_list">
			{if $article->getData('dateSubmitted')}
				<li>
					<span class="alq_timeline_label">{translate key="plugins.themes.alqalam.article.received"}</span>
					<span class="alq_timeline_date">{$article->getData('dateSubmitted')|date_format:$dateFormatShort}</span>
				</li>
			{/if}
			{if $alqalamAcceptedDate}
				<li>
					<span class="alq_timeline_label">{translate key="plugins.themes.alqalam.article.accepted"}</span>
					<span class="alq_timeline_date">{$alqalamAcceptedDate|date_format:$dateFormatShort}</span>
				</li>
			{/if}
			{if $publication->getData('datePublished')}
				<li>
					<span class="alq_timeline_label">{translate key="submissions.published"}</span>
					<span class="alq_timeline_date">{$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
				</li>
			{/if}
		</ol>
	</div>
{/if}

{* Share buttons *}
{if $activeTheme && $activeTheme->getOption('showShareButtons')}
	{capture assign="alqShareUrl"}{url router=PKP\core\PKPApplication::ROUTE_PAGE page="article" op="view" path=$article->getBestId()}{/capture}
	{assign var="alqShareTitle" value=$publication->getLocalizedTitle()|strip_tags}
	{assign var="alqShareUrlEnc" value=$alqShareUrl|escape:"url"}
	{assign var="alqShareTitleEnc" value=$alqShareTitle|escape:"url"}
	<div class="item alq_share">
		<h2 class="label">{translate key="plugins.themes.alqalam.share.title"}</h2>
		<ul class="value alq_share_list">
			<li>
				<a href="https://x.com/intent/tweet?url={$alqShareUrlEnc}&amp;text={$alqShareTitleEnc}" target="_blank" rel="noopener" aria-label="{translate|escape key="plugins.themes.alqalam.share.on" network="X"}" title="X">
					<span class="fa fa-twitter" aria-hidden="true"></span>
				</a>
			</li>
			<li>
				<a href="https://www.facebook.com/sharer/sharer.php?u={$alqShareUrlEnc}" target="_blank" rel="noopener" aria-label="{translate|escape key="plugins.themes.alqalam.share.on" network="Facebook"}" title="Facebook">
					<span class="fa fa-facebook" aria-hidden="true"></span>
				</a>
			</li>
			<li>
				<a href="https://www.linkedin.com/sharing/share-offsite/?url={$alqShareUrlEnc}" target="_blank" rel="noopener" aria-label="{translate|escape key="plugins.themes.alqalam.share.on" network="LinkedIn"}" title="LinkedIn">
					<span class="fa fa-linkedin" aria-hidden="true"></span>
				</a>
			</li>
			<li>
				<a href="https://wa.me/?text={$alqShareTitleEnc}%20{$alqShareUrlEnc}" target="_blank" rel="noopener" aria-label="{translate|escape key="plugins.themes.alqalam.share.on" network="WhatsApp"}" title="WhatsApp">
					<span class="fa fa-whatsapp" aria-hidden="true"></span>
				</a>
			</li>
			<li>
				<a href="https://t.me/share/url?url={$alqShareUrlEnc}&amp;text={$alqShareTitleEnc}" target="_blank" rel="noopener" aria-label="{translate|escape key="plugins.themes.alqalam.share.on" network="Telegram"}" title="Telegram">
					<span class="fa fa-telegram" aria-hidden="true"></span>
				</a>
			</li>
			<li>
				<a href="mailto:?subject={$alqShareTitleEnc}&amp;body={$alqShareUrlEnc}" aria-label="{translate|escape key="plugins.themes.alqalam.share.email"}" title="{translate|escape key="plugins.themes.alqalam.share.email"}">
					<span class="fa fa-envelope" aria-hidden="true"></span>
				</a>
			</li>
			<li>
				<button type="button" class="alq_copy_link" data-url="{$alqShareUrl|escape}" aria-label="{translate|escape key="plugins.themes.alqalam.share.copyLink"}" title="{translate|escape key="plugins.themes.alqalam.share.copyLink"}">
					<span class="fa fa-link" aria-hidden="true"></span>
				</button>
			</li>
		</ul>
	</div>
{/if}

{* Citation badges (need a DOI) *}
{if $alqalamDoi && $activeTheme && ($activeTheme->getOption('showDimensionsBadge') || $activeTheme->getOption('showAltmetricBadge'))}
	<div class="item alq_badges">
		<h2 class="label">{translate key="plugins.themes.alqalam.article.metrics"}</h2>
		<div class="value alq_badges_list">
			{if $activeTheme->getOption('showDimensionsBadge')}
				<span class="__dimensions_badge_embed__" data-doi="{$alqalamDoi|escape}" data-style="small_circle" data-legend="hover-right"></span>
				<script async src="https://badge.dimensions.ai/badge.js" charset="utf-8"></script>
			{/if}
			{if $activeTheme->getOption('showAltmetricBadge')}
				<div class="altmetric-embed" data-badge-type="donut" data-badge-popover="right" data-doi="{$alqalamDoi|escape}"></div>
				<script async src="https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js"></script>
			{/if}
		</div>
	</div>
{/if}
