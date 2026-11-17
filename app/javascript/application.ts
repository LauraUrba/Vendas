// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import { iniciarGaleria } from "./galeria";

iniciarGaleria();

const mensagem: string = "TypeScript funcionando";
console.log(mensagem);
