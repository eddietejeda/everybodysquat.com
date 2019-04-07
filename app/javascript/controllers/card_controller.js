import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import Chart from 'chart.js/dist/Chart';




export default class extends ApplicationController {

  static targets = [ "card", "trash"]
  
  initialize() {

  }
  
  

  onBeforeDestroy(e) {
    console.log('do stuff BEFORE ajax call')
    
    this.elementToDelete = e.currentTarget.closest('.card');
    // e.preventDefault() stops ajax
  }

  onDestroy(e) {
    console.log('do stuff AFTER ajax call')

    const [data, status, xhr] = e.detail;

    if (this.elementToDelete) {
      this.elementToDelete.remove();
      this.elementToDelete = null;
    }
  }
  

}




