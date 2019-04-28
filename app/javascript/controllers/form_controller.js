import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";


export default class extends ApplicationController {

  static targets = [ "submit"]
  
  onSubmit(event){
    let label = this.submitTarget.value;
    this.submitTarget.value = "Saving..";
    this.submitTarget.disabled = true;
    setTimeout(result => { this.submitTarget.value = label; this.submitTarget.disabled = false; }, 500);
  }

}