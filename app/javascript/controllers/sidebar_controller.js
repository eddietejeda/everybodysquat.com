import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";


export default class extends ApplicationController {

  static targets = [ "menu", "overlay"]

  
  toggle(){
    console.log('animate====', this.menuTarget.style.transform);
    if (this.menuTarget.style.transform === 'translateX(0px)'){
      console.log('if');
      this.menuTarget.style.transform = `translateX(-100%)`;
      this.overlayTarget.style.display = `none`;
    }
    else{
      console.log('else');
      this.menuTarget.style.transform = `translateX(0px)`;
      this.overlayTarget.style.display = `block`;
    }
  }
}


