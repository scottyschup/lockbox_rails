const addHandlers = () => {
  focusableElements().forEach(el => {
    el.addEventListener('keydown', handleKeyDown);
  });
  headerSiblings().forEach(el => {
    el.addEventListener('click', closeDrawer);
  });
  const logoLink = document.querySelector('a[href="/"]');
  logoLink.addEventListener('click', closeDrawer);
}

const closeDrawer = () => {
  const button = navBarControl();
  const drawer = navBarDrawer();

  button.setAttribute('aria-expanded', false);
  button.classList.remove('expanded');
  drawer.classList.remove('expanded');
  removeHandlers();

  button.focus();
}

const focusableElements = element => {
  element = element || navBarDrawer();
  return [...element.querySelectorAll('a, button, [tabindex]')];
}

const handleKeyDown = ev => {
  switch (ev.key) {
    case 'Escape':
    case 'Esc':
      // IE11 uses 'Esc'; all other browsers use 'Escape'
      closeDrawer();
      break;
    case 'Tab':
      const nextElement = nextFocusableElement(ev.currentTarget, ev.shiftKey);
      nextElement.focus();
      break;
    default:
      return;
  }
  ev.preventDefault();
}

const headerSiblings = () => {
  return [...document.querySelectorAll('body > .wrapper > :not(header')];
}

const navBarControl = () => {
  return document.getElementById('navbar-control');
}

const navBarDrawer = () => {
  return document.getElementById('navbar-drawer');
}

const nextFocusableElement = (currElement, shiftUsed) => {
  const focusables = focusableElements();
  const numFocusables = focusables.length;
  // If currElement is undefined, return the first button/link in nav bar drawer.
  if (!currElement) { return focusables[0] || navBarControl(); }
  const currIdx = [...focusables].indexOf(currElement);
  const delta = shiftUsed ? -1 : 1;
  const nextIdx = (numFocusables + currIdx + delta) % numFocusables;

  return focusables[nextIdx];
}

const openDrawer = () => {
  const button = navBarControl();
  const drawer = navBarDrawer();

  button.setAttribute('aria-expanded', true);
  button.classList.add('expanded');
  drawer.classList.add('expanded');
  addHandlers();

  const focusables = focusableElements(drawer);
  focusables[0].focus();
}

const removeHandlers = () => {
  focusableElements().forEach(el => {
    el.removeEventListener('keydown', handleKeyDown);
  });
  headerSiblings().forEach(el => {
    el.removeEventListener('click', closeDrawer);
  });
  const logoLink = document.querySelector('a[href="/"]');
  logoLink.removeEventListener('click', closeDrawer);
}

const toggleNavBarDrawer = () => {
  const button = navBarControl();
  const isExpanded = button.getAttribute('aria-expanded') === 'true';

  isExpanded ? closeDrawer() : openDrawer();
}

const control = navBarControl();
control.addEventListener('click', toggleNavBarDrawer);
