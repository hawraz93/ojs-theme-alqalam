{**
 * plugins/themes/alqalam/templates/frontend/components/alqalamLanguageToggle.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Compact language switcher shown in the university bar.
 *
 * @uses $alqalamLocales array Locale key => display name (assigned by the theme)
 *}
{if $alqalamLocales && $alqalamLocales|@count > 1}
	<nav class="alq_lang" aria-label="{translate|escape key="common.language"}">
		<span class="fa fa-globe" aria-hidden="true"></span>
		<ul>
			{foreach from=$alqalamLocales item=localeName key=localeKey}
				<li class="locale_{$localeKey|escape}{if $localeKey == $currentLocale} current{/if}" lang="{$localeKey|replace:"_":"-"}">
					{if $localeKey == $currentLocale}
						<span aria-current="true">{$localeName|escape}</span>
					{else}
						<a href="{url router=PKP\core\PKPApplication::ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.SERVER_NAME|cat:$smarty.server.REQUEST_URI}">{$localeName|escape}</a>
					{/if}
				</li>
			{/foreach}
		</ul>
	</nav>
{/if}
