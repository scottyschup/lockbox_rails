// 1. Add the `.pristine` class to all inputs
// 2. Add an event listner to remove `.pristine` once an input has been
// interacted with.
const addPristineToInputs = () => {
  const inputs = document.querySelectorAll("input:not([type=submit]):not([type=hidden]), select");
  for (let i = 0; i < inputs.length; i++) {
    let input = inputs[i];
    if (input.value === "") {
      input.classList.add("pristine");
      input.addEventListener("blur", () => {
        event.currentTarget.classList.remove("pristine");
      });
    }
  }
}

// Remove `.pristine` from all inputs when submit button is clicked.
const removePristineFromInputs = () => {
  const inputs = document.querySelectorAll("input:not([type=submit]):not([type=hidden]), select");
  for (let i = 0; i < inputs.length; i++) {
    let input = inputs[i];
    input.classList.remove("pristine");
  }
}

addPristineToInputs();
const submitButton = document.querySelectorAll('[type="submit"]')[0];
submitButton.addEventListener("click", () => {
  removePristineFromInputs();
});
