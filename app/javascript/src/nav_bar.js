const addHandlers = () => {
  navBarPane().addEventListener('keydown', handleKeyDown);
  headerSiblings().forEach(el => {
    el.addEventListener('click', closePane);
  })
}

const closePane = () => {
  const button = navBarControl();
  const pane = navBarPane();

  button.setAttribute('aria-expanded', false);
  button.classList.remove('expanded');
  pane.classList.remove('expanded');
  removeHandlers();
}

const focusableElements = element => {
  element = element || navBarPane();
  return [...element.querySelectorAll('a, button, [tabindex]')];
}

const handleKeyDown = ev => {
  switch (ev.key) {
    case 'Escape':
    case 'Esc':
      // IE11 uses 'Esc'; all other browsers use 'Escape'
      closePane();
      break;
    case 'Tab':
      const nextFocusableElement = nextFocusableElement(ev.currentTarget, ev.shiftKey);
      nextFocusableElement.focus();
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

const navBarPane = () => {
  return document.getElementById('navbar');
}

const nextFocusableElement = (currElement, shiftUsed) => {
  const focusables = focusableElements();
  const numFocusables = focusables.length;
  // If currElement is undefined, return the first visible link in header drawer.
  // If the drawer is empty—which shouldn't really ever happen—then return the drawer anchor.
  if (!currElement) { return focusables[0] || navBarControl(); }
  if (!numFocusables) { return currElement; }
  const currIdx = [...focusables].indexOf(currElement);
  const delta = shiftUsed ? -1 : 1;
  const nextIdx = (numFocusables + currIdx + delta) % numFocusables;

  return focusables[nextIdx];
}

const openPane = () => {
  const button = navBarControl();
  const pane = navBarPane();

  button.setAttribute('aria-expanded', true);
  button.classList.add('expanded');
  pane.classList.add('expanded');
  addHandlers();

  const focusables = focusableElements(pane);
  focusables[0].focus();
}

const removeHandlers = () => {
  navBarPane().removeEventListener('keydown', handleKeyDown);
  headerSiblings().forEach(el => {
    el.removeEventListener('click', closePane);
  })
}

const toggleNavBarPane = () => {
  const button = navBarControl();
  const isExpanded = button.getAttribute('aria-expanded') === 'true';

  isExpanded ? closePane() : openPane();
}

const control = navBarControl();
control.addEventListener('click', toggleNavBarPane);
