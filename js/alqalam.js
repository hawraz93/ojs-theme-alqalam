/**
 * @file plugins/themes/alqalam/js/alqalam.js
 *
 * Copyright (c) 2026 Al-Qalam University, Kirkuk
 * Distributed under the GNU GPL v3. For full terms see the file LICENSE.
 *
 * @brief JavaScript for the Al-Qalam University theme. The parent (default)
 *  theme already handles the dropdown menus and the mobile menu toggle.
 */
(function ($) {
	'use strict';

	var i18n = window.alqalamThemeI18N || {};

	// Keep aria-expanded in sync with the mobile menu toggle
	$('.pkp_site_nav_toggle').on('click', function () {
		var expanded = this.getAttribute('aria-expanded') === 'true';
		this.setAttribute('aria-expanded', expanded ? 'false' : 'true');
	});

	// Copy-link button on the article page
	$(document).on('click', '.alq_copy_link', function () {
		var button = this;
		var url = button.getAttribute('data-url');

		function done() {
			button.classList.add('is_copied');
			button.setAttribute('title', i18n.copied || 'Copied');
			window.setTimeout(function () {
				button.classList.remove('is_copied');
				button.setAttribute('title', i18n.copyLink || 'Copy link');
			}, 2000);
		}

		if (navigator.clipboard && window.isSecureContext) {
			navigator.clipboard.writeText(url).then(done, function () { fallbackCopy(url); done(); });
		} else {
			fallbackCopy(url);
			done();
		}
	});

	function fallbackCopy(text) {
		var textarea = document.createElement('textarea');
		textarea.value = text;
		textarea.setAttribute('readonly', '');
		textarea.style.position = 'absolute';
		textarea.style.left = '-9999px';
		document.body.appendChild(textarea);
		textarea.select();
		try {
			document.execCommand('copy');
		} catch (e) {
			// ignore
		}
		document.body.removeChild(textarea);
	}

	// Back-to-top button
	var backToTop = document.createElement('button');
	backToTop.type = 'button';
	backToTop.className = 'alq_backtotop';
	backToTop.setAttribute('aria-label', i18n.backToTop || 'Back to top');
	backToTop.innerHTML = '<span class="fa fa-chevron-up" aria-hidden="true"></span>';
	document.body.appendChild(backToTop);

	backToTop.addEventListener('click', function () {
		window.scrollTo({ top: 0, behavior: 'smooth' });
	});

	function onScroll() {
		var y = window.pageYOffset || document.documentElement.scrollTop;
		backToTop.classList.toggle('is_visible', y > 400);
		document.body.classList.toggle('alq_scrolled', y > 10);
	}
	window.addEventListener('scroll', onScroll, { passive: true });
	onScroll();

	// Brand colours for the usage statistics chart (overrides the parent theme)
	document.addEventListener('usageStatsChartOptions.pkp', function (e) {
		var styles = window.getComputedStyle(document.documentElement);
		var accent = (styles.getPropertyValue('--alq-accent') || '#910051').trim();
		if (e.chartOptions && e.chartOptions.elements) {
			if (e.chartOptions.elements.line) {
				e.chartOptions.elements.line.backgroundColor = accent;
			}
			if (e.chartOptions.elements.bar) {
				e.chartOptions.elements.bar.backgroundColor = accent;
			}
		}
	});

})(jQuery);
