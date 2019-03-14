import "spectre.css/dist/spectre.css";
import "spectre.css/dist/spectre-exp.css";
import "spectre.css/dist/spectre-icons.css";

import { Application } from "stimulus";
import { definitionsFromContext } from "stimulus/webpack-helpers";
import Turbolinks from "turbolinks";
import Rails from "rails-ujs";
import "../stylesheets/main.scss";
import "../stylesheets/ios.scss";
import "../stylesheets/menu.scss";
import "../stylesheets/devise.scss";
import "../stylesheets/workouts.scss";
import "../stylesheets/newmenu.scss";
import "../stylesheets/login.scss";
import "../stylesheets/header.scss";
import "../stylesheets/charts.scss";

import "../images/index";
const application = Application.start();
const context = require.context("../controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

Rails.start();
Turbolinks.start();
