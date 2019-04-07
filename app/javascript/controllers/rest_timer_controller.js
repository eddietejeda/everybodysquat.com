import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";
import "../support/number";


export default class extends ApplicationController {

  static targets = [ "view", "toggle"]

  connect(){  
    if ( document.getElementById('active_workout').value == 'true' ){
      // clearInterval(this.refreshTimer);
      this.startCountdown();
    }
  }
  
  
  
  startCountdown(){
    var viewTarget = this.viewTarget;
    var dataTarget = this.data;

    setInterval(refreshTimer, 1000);
    
    
    function refreshTimer() {
      let restTime = parseInt(cookies.getValue('restTime')) - 1;
      let minutes, seconds = "0";

      if (cookies.getValue('restTime') && !parseInt(dataTarget.get("workoutCompleted"))){
        cookies.setValue('restTime', restTime);
        minutes = Math.floor(restTime / 60) % 60;
        seconds = Math.abs(parseInt(restTime % 60));

        if (restTime === 0){
          document.getElementById("bell").play();
        }
        // even if it's zero, we should clear the clock
        if (restTime >= 0){
          viewTarget.innerHTML = `${minutes.pad(2)}:${seconds.pad(2)}`;          
        }
      }
    }
    
  }
  
  

    
  
  pause(){
        

  }


}





