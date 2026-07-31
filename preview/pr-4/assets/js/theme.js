/**
 * Theme toggle.
 *
 * The initial theme is resolved by an inline script in <head> so the correct
 * colours are painted on the first frame — doing it here would flash light
 * before switching to dark. This file only owns the toggle interaction.
 */
(function () {
  'use strict';

  var STORAGE_KEY = 'theme';
  var root = document.documentElement;
  var toggle = document.querySelector('[data-theme-toggle]');

  if (!toggle) return;

  /* Light is the product default — the OS preference is deliberately ignored
     so first-time visitors always land on the light design. */
  function currentTheme() {
    return root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
  }

  function apply(theme) {
    root.setAttribute('data-theme', theme);
    toggle.setAttribute('aria-label', 'Switch to ' +
      (theme === 'dark' ? 'light' : 'dark') + ' theme');
    try {
      localStorage.setItem(STORAGE_KEY, theme);
    } catch (err) {
      /* Private browsing blocks writes; the toggle still works for this page. */
    }
  }

  apply(currentTheme());

  toggle.addEventListener('click', function () {
    apply(currentTheme() === 'dark' ? 'light' : 'dark');
  });
})();
