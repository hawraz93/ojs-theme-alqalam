{**
 * plugins/themes/alqalam/templates/frontend/components/alqalamSocial.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Social media icons configured in the theme options.
 *
 * @uses $alqalamSocial array network => URL (assigned by the theme)
 *}
{if $alqalamSocial}
	<ul class="alq_footer_social">
		{foreach from=$alqalamSocial item=socialUrl key=network}
			{if $network == 'facebook'}{assign var="alqIcon" value="facebook"}{assign var="alqLabel" value="Facebook"}
			{elseif $network == 'instagram'}{assign var="alqIcon" value="instagram"}{assign var="alqLabel" value="Instagram"}
			{elseif $network == 'youtube'}{assign var="alqIcon" value="youtube-play"}{assign var="alqLabel" value="YouTube"}
			{elseif $network == 'x'}{assign var="alqIcon" value="twitter"}{assign var="alqLabel" value="X"}
			{elseif $network == 'telegram'}{assign var="alqIcon" value="telegram"}{assign var="alqLabel" value="Telegram"}
			{elseif $network == 'linkedin'}{assign var="alqIcon" value="linkedin"}{assign var="alqLabel" value="LinkedIn"}
			{elseif $network == 'whatsapp'}{assign var="alqIcon" value="whatsapp"}{assign var="alqLabel" value="WhatsApp"}
			{else}{assign var="alqIcon" value="link"}{assign var="alqLabel" value=$network}
			{/if}
			<li>
				<a href="{$socialUrl|escape}" target="_blank" rel="noopener" aria-label="{$alqLabel|escape}" title="{$alqLabel|escape}">
					<span class="fa fa-{$alqIcon}" aria-hidden="true"></span>
				</a>
			</li>
		{/foreach}
	</ul>
{else}
	<p>
		<a href="{$alqalamUniversityUrl|escape}" target="_blank" rel="noopener">
			<span class="fa fa-globe" aria-hidden="true"></span>
			{$alqalamUniversityUrl|replace:"https://":""|replace:"http://":""|escape}
		</a>
	</p>
{/if}
