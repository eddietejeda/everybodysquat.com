import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";
import "../support/number";


export default class extends ApplicationController {

  static targets = [ "view"]

  connect(){
    let completed_at = parseInt(this.data.get("completedAt")) || parseInt(new Date().getTime())/1000;
    let delta = Math.abs( parseInt(this.data.get("beganAt"))  - completed_at  ) ;
    this.renderTime(delta);

    if (parseInt(this.data.get("completedAt")) === 0){
      setInterval( () => {
        let completed_at = parseInt(new Date().getTime())/1000;
        let delta = Math.abs( parseInt(this.data.get("beganAt"))  - completed_at  ) ;
        this.renderTime(delta);
      },  1000);
    }

  }
  
  
  renderTime(delta){
    
    // calculate (and subtract) whole days
    let days = Math.floor(delta / 86400);
    delta -= days * 86400;

    // calculate (and subtract) whole hours
    let hours = Math.floor(delta / 3600) % 24;
    delta -= hours * 3600;

    // calculate (and subtract) whole minutes
    let minutes = Math.floor(delta / 60) % 60;
    delta -= minutes * 60;

    // what's left is seconds
    let seconds = parseInt(delta % 60);  // in theory the modulus is not required

    let response = [];
    if (days){
      response.push(`${days}d `);
    }
    if (hours){
      response.push(`${hours}h `);
    }

    response.push(`${minutes.pad(2)}:${seconds.pad(2)}`);

    this.viewTarget.innerHTML = response.join(""); 
  }

}





