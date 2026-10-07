{**
 * plugins/themes/alqalam/templates/frontend/components/headerHead.tpl
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief Common site header <head> tag and contents. Adds a browser theme
 *  colour and falls back to the university logo as favicon when the journal
 *  has not uploaded one.
 *}
<head>
	<meta charset="{$defaultCharset|escape}">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>
		{$pageTitleTranslated|strip_tags}
		{* Add the journal name to the end of page titles *}
		{if $requestedPage|escape|default:"index" != 'index' && $currentContext && $currentContext->getLocalizedName()}
			| {$currentContext->getLocalizedName()}
		{/if}
	</title>
	<meta name="theme-color" content="{$alqalamPrimaryColour|escape|default:"#283078"}">
	{if !$currentContext || !$currentContext->getLocalizedFavicon()}
		<link rel="icon" type="image/png" href="{$alqalamThemePath}/images/favicon-64.png">
	{/if}

	{load_header context="frontend"}
	{load_stylesheet context="frontend"}
</head>
