/**
 * Refresh star counts from the public GitHub API.
 *
 * Progressive enhancement only — the counts baked into the HTML are what a
 * visitor sees if this fails, and the unauthenticated API is rate-limited per
 * IP, so a failure here is expected and must stay silent.
 */
(function () {
  'use strict';

  var cards = document.querySelectorAll('[data-repo]');
  if (!cards.length || !window.fetch) return;

  function render(slot, stars) {
    slot.textContent = '★ ' + stars.toLocaleString('en-US');
  }

  Array.prototype.forEach.call(cards, function (card) {
    var slot = card.querySelector('[data-stars]');
    if (!slot) return;

    fetch('https://api.github.com/repos/' + card.dataset.repo, {
      headers: { Accept: 'application/vnd.github+json' }
    })
      .then(function (res) { return res.ok ? res.json() : Promise.reject(res.status); })
      .then(function (repo) {
        if (typeof repo.stargazers_count === 'number') {
          render(slot, repo.stargazers_count);
        }
      })
      .catch(function () { /* keep the baked-in value */ });
  });
})();
