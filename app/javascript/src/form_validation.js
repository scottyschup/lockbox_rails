const addPristineToInputs = () => {
  const inputs = document.getElementsByTagName("input");
  for (let i = 0; i < inputs.length; i++) {
    let input = inputs[i];
    input.classList.add("pristine");
    input.addEventListener("blur", () => {
      event.currentTarget.classList.remove("pristine");
    });
  }
}

const removePristineFromInputs = () => {
  const inputs = document.getElementsByTagName("input");
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
