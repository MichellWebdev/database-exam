function showPage(pageId) {
  document.querySelectorAll('.subpage').forEach(item => {
    item.style.display = 'none';
  });
  document.getElementById(pageId).style.display = 'grid';
}
