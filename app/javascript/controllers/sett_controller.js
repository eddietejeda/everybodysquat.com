import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";


export default class extends ApplicationController {

  static targets = [ "active", "reps" , "button", "weight"]
  
  initialize(){
    window.clearTimeout(this.delayNotification);
  }
  
  disconnect(){

  }

  updateReps(){
    
    if (this.data.get('active') == 'true'){      
      var current, goal, reps_completed;  
      [current, goal] = this.repsTarget.innerHTML.trim().split("x").map(Number);
      reps_completed = (current == 0) ? goal : current - 1;
      this.repsTarget.innerHTML = `${Math.abs(reps_completed)} x ${goal}`;

      if (reps_completed == goal){
        this.buttonTarget.classList.add('btn-primary');
        this.buttonTarget.classList.remove('btn-primary-light-red');
      }
      else{
        this.buttonTarget.classList.add('btn-primary-light-red');
      }

      this.railsUpdate(`/setts/${this.data.get("id")}`, "reps_completed", reps_completed);
      cookies.setValue('restTime', 0); 
      setTimeout(this.delayNotification, 2000); 
    }
    
  }
  

  delayNotification() {
    cookies.setValue('restTime', parseInt(document.getElementById('restTime').value)); 
  }
  
  updateWeight(){
    console.log(`current weight ${this.weightTarget.value}`);
    this.railsUpdate(`/setts/${this.data.get("id")}`, "weight", this.weightTarget.value);
  }
  
}