const diagnosisModal = document.querySelector("#diagnosisModal");

if (diagnosisModal && typeof diagnosisModal.showModal === "function") {
  const openTriggers = document.querySelectorAll('[data-open-modal="diagnosis"]');
  const closeTriggers = diagnosisModal.querySelectorAll("[data-close-modal]");

  const openModal = (event) => {
    if (event) event.preventDefault();
    document.body.classList.add("modal-open");
    diagnosisModal.showModal();
  };

  const closeModal = () => {
    diagnosisModal.close();
  };

  openTriggers.forEach((trigger) => {
    trigger.addEventListener("click", openModal);
  });

  closeTriggers.forEach((trigger) => {
    trigger.addEventListener("click", (event) => {
      event.preventDefault();
      closeModal();
    });
  });

  diagnosisModal.addEventListener("click", (event) => {
    if (event.target === diagnosisModal) {
      closeModal();
    }
  });

  diagnosisModal.addEventListener("close", () => {
    document.body.classList.remove("modal-open");
  });

  const diagnosisForm = diagnosisModal.querySelector(".diagnosis-form");
  const concernsFieldset = diagnosisModal.querySelector(".diagnosis-checkboxes");

  if (diagnosisForm && concernsFieldset) {
    diagnosisForm.addEventListener("submit", (event) => {
      const anyChecked = concernsFieldset.querySelector('input[type="checkbox"]:checked');
      if (!anyChecked) {
        event.preventDefault();
        concernsFieldset.classList.add("is-invalid");
        if (!concernsFieldset.querySelector(".diagnosis-field-error")) {
          const error = document.createElement("p");
          error.className = "diagnosis-field-error";
          error.textContent = "1つ以上選択してください。";
          concernsFieldset.appendChild(error);
        }
        concernsFieldset.scrollIntoView({ behavior: "smooth", block: "center" });
      }
    });

    concernsFieldset.addEventListener("change", () => {
      const anyChecked = concernsFieldset.querySelector('input[type="checkbox"]:checked');
      if (anyChecked) {
        concernsFieldset.classList.remove("is-invalid");
        const error = concernsFieldset.querySelector(".diagnosis-field-error");
        if (error) error.remove();
      }
    });
  }
}

const revealItems = document.querySelectorAll(".reveal");

if ("IntersectionObserver" in window) {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.15 }
  );

  revealItems.forEach((item) => observer.observe(item));
} else {
  revealItems.forEach((item) => item.classList.add("is-visible"));
}
