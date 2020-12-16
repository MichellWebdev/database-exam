<div id="right">
  <div id="search">
    <form onsubmit="getTweetsFromUser(); return false">
      <div id="searchField">
        <a href="/searchResult" onclick="showPage('searchResult'); return false">
          <input id="searchInput" type="text" name="searchUserName" placeholder="Search">
        </a>
      </div>
    </form>
  </div>
  <?php require_once(__DIR__.'/trending.php') ?>
  <?php require_once(__DIR__.'/follow-suggestions.php') ?>
</div>