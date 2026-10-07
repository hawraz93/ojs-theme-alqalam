{**
 * plugins/themes/alqalam/templates/frontend/components/alqalamArticleExtras.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Blocks appended to the article details column through the
 *  Templates::Article::Details hook: submission date and share buttons.
 *
 * @uses $article Submission
 * @uses $publication Publication
 *}
{if $activeTheme && $activeTheme->getOption('showSubmissionDates') && $article->getData('dateSubmitted')}
	<div class="item alq_dates">
		<section class="sub_item">
			<h2 class="label">{translate key="plugins.themes.alqalam.article.received"}</h2>
			<div class="value">{$article->getData('dateSubmitted')|date_format:$dateFormatShort}</div>
		</section>
	</div>
{/if}

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
