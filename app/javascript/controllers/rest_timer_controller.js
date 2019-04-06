import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";
import "../support/number";


export default class extends ApplicationController {

  static targets = [ "view", "toggle"]

  connect(){    
    this.startCountdown();
  }
  
  
  
  startCountdown(){
    let viewTarget = this.viewTarget;
    let dataTarget = this.data;
    
    setInterval(function() {

      let restTime = parseInt(cookies.getValue('restTime')) - 1;
      let minutes = "0";
      let seconds = "0";

      if (cookies.getValue('restTime') && !parseInt(dataTarget.get("workoutCompleted"))){
        cookies.setValue('restTime', restTime);
        minutes = Math.floor(restTime / 60) % 60;
        seconds = Math.abs(parseInt(restTime % 60));
        
        if (restTime === -1){
          document.getElementById("bell").play();
        }
        else if (restTime > 0){
          viewTarget.innerHTML = `${minutes.pad(2)}:${seconds.pad(2)}`;          
        }
      }

    }, 1000);
    
  }
  
  pause(){
        

  }


}





