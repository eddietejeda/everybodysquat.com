import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";
import "../support/number";


export default class extends ApplicationController {

  static targets = [ "sett", "workout"]

  connect(){
    
    this.workoutTimer();
  }
  
  settTimer(){
    let restTime = parseInt(cookies.getValue('restTime')) - 1;
    let minutes = "5";
    let seconds = "01";
    
    if (cookies.getValue('restTime') && !parseInt(this.data.get("workoutCompleted"))){
      cookies.setValue('restTime', restTime);

      minutes = Math.floor(restTime / 60) % 60;
      seconds = Math.abs(parseInt(restTime % 60));

      this.settTarget.innerHTML = `${minutes.pad(2)}:${seconds.pad(2)}`;
    }
  }

  workoutTimer(){
    setInterval( () => {
      // get total seconds between the times
      
      let completed_at = parseInt(this.data.get("workoutCompleted")) || parseInt(new Date().getTime())/1000;
      
      var delta = Math.abs( parseInt(this.data.get("workoutCreated"))  - completed_at  ) ;

      // calculate (and subtract) whole days
      var days = Math.floor(delta / 86400);
      delta -= days * 86400;

      // calculate (and subtract) whole hours
      var hours = Math.floor(delta / 3600) % 24;
      delta -= hours * 3600;

      // calculate (and subtract) whole minutes
      var minutes = Math.floor(delta / 60) % 60;
      delta -= minutes * 60;

      // what's left is seconds
      var seconds = parseInt(delta % 60);  // in theory the modulus is not required
      
      let response = [];
      if (days){
        response.push(`${days}d`);
      }
      response.push(`${hours.pad(2)}:${minutes.pad(2)}:${seconds.pad(2)}`);

      this.workoutTarget.innerHTML = response.join(" ");
      this.settTimer();
    },  1000);
    
  }
  
  

}

