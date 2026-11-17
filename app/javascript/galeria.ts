function mostrarFoto(galeria: HTMLElement, indice: number): void {
  const principal = galeria.querySelector<HTMLImageElement>("[data-principal]");
  const miniaturas = Array.from(
    galeria.querySelectorAll<HTMLElement>("[data-miniatura]")
  );
  if (!principal || miniaturas.length === 0) return;

  // o resto da divisão faz a galeria dar a volta (última foto -> primeira)
  const novo = (indice + miniaturas.length) % miniaturas.length;

  principal.src = miniaturas[novo].dataset.src ?? principal.src;
  miniaturas.forEach((m, i) => m.classList.toggle("ativa", i === novo));
  galeria.dataset.atual = String(novo);
}

export function iniciarGaleria(): void {
  document.addEventListener("click", (evento) => {
    const alvo = evento.target as HTMLElement;
    const galeria = alvo.closest<HTMLElement>("[data-galeria]");
    if (!galeria) return;

    const atual = Number(galeria.dataset.atual ?? 0);
    const miniatura = alvo.closest<HTMLElement>("[data-miniatura]");

    if (miniatura) {
      mostrarFoto(galeria, Number(miniatura.dataset.indice));
    } else if (alvo.closest("[data-anterior]")) {
      mostrarFoto(galeria, atual - 1);
    } else if (alvo.closest("[data-proxima]")) {
      mostrarFoto(galeria, atual + 1);
    }
  });
}