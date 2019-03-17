import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";


export default class extends ApplicationController {

  static targets = [ "active", "reps" , "button", "weight"]

  updateReps(){
    
    if (this.data.get('active') == 'true'){
      console.log('workout is active');
      
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
      cookies.setValue('restTime', 60*5); 
    }
    else{
      console.log('workout not active');
    }

    
  }
  
  updateWeight(){
    console.log(`current weight ${this.weightTarget.value}`);
    this.railsUpdate(`/setts/${this.data.get("id")}`, "weight", this.weightTarget.value);
  }
  
}