import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";


export default class extends ApplicationController {

  static targets = [ "reps" , "button", "weight"]

  updateReps(){
    var current, goal, reps_completed;  
    [current, goal] = this.repsTarget.innerHTML.trim().split("x").map(Number);
    reps_completed = (current == goal) ? 0 : current + 1;
    this.repsTarget.innerHTML = `${reps_completed}x${goal}`;
    this.buttonTarget.classList.add('btn-primary');
    this.railsUpdate(`/setts/${this.data.get("id")}`, "reps_completed", reps_completed);

  }
  
  updateWeight(){
    console.log(`current weight ${this.weightTarget.value}`);
    this.railsUpdate(`/setts/${this.data.get("id")}`, "weight", this.weightTarget.value);
  }
  
}
