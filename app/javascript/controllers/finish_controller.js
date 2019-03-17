import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";


export default class extends ApplicationController {

  static targets = [ "finish" ]

  finishWorkout(){
    cookies.remove('restTime');
    
  }
  
}
