// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import { Application } from "@hotwired/stimulus";
import "./controllers"
import * as bootstrap from "bootstrap"

const application = Application.start();
