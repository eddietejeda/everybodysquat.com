import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import Chart from 'chart.js/dist/Chart';




export default class extends ApplicationController {

  static targets = [ "show"]
  
  initialize() {
    this.load();
    
  }
  
  
  load() {
    fetch("/api/charts.json")
      .then(response => response.json())
      .then(content => {
        var ctx = this.showTarget.getContext('2d');
        new Chart(ctx, content);
      })
  }
  

}




