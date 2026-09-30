// Offline demonstration only: no requests, storage, credentials or backend.
const auth = document.querySelector('#demo-auth');
if (auth) {
  const password = document.querySelector('#password');
  const toggle = document.querySelector('#toggle-password');
  toggle.addEventListener('click', () => {
    const visible = password.type === 'password';
    password.type = visible ? 'text' : 'password';
    toggle.setAttribute('aria-pressed', String(visible));
    toggle.setAttribute('aria-label', visible ? 'Ascunde parola' : 'Arată parola');
  });
  auth.addEventListener('submit', event => {
    event.preventDefault();
    const status = document.querySelector('#demo-status');
    status.hidden = false;
    status.textContent = 'Acesta este un exemplu vizual. Nu a fost efectuată autentificarea.';
  });
}
const dialog = document.querySelector('#example-dialog');
if (dialog) {
  const open = document.querySelector('#open-dialog');
  const filter = document.querySelector('#filter');
  const rows = document.querySelector('#layer-rows');
  const applyFilter = () => {
    const term = filter.value.toLocaleLowerCase('ro').trim();
    let visible = 0;
    for (const row of rows.rows) {
      row.hidden = !row.cells[0].textContent.toLocaleLowerCase('ro').includes(term);
      if (!row.hidden) visible++;
    }
    document.querySelector('#filter-empty').hidden = visible > 0;
  };
  open.addEventListener('click', () => dialog.showModal());
  for (const id of ['close-dialog','cancel-dialog']) document.getElementById(id).addEventListener('click', () => dialog.close());
  dialog.addEventListener('close', () => open.focus());
  filter.addEventListener('input', applyFilter);
  document.querySelector('#example-form').addEventListener('submit', event => {
    event.preventDefault();
    const title = event.currentTarget.elements.title.value.trim();
    if (!title) { event.currentTarget.elements.title.focus(); return; }
    const row = rows.insertRow();
    for (const text of [title, 'Exemplu', 'Nesalvat', '0']) row.insertCell().textContent = text;
    row.cells[3].className = 'num';
    document.querySelector('#layer-count').textContent = String(rows.rows.length);
    document.querySelector('#row-status').textContent = 'Rând demonstrativ adăugat.';
    event.currentTarget.reset();
    applyFilter();
    dialog.close();
  });
  for (const button of document.querySelectorAll('[data-demo-action]')) button.addEventListener('click', () => {
    document.querySelector('#action-status').textContent = `Exemplu: ${button.textContent}. Nicio modificare permanentă.`;
  });
}
