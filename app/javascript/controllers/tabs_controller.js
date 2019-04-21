import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";


export default class extends ApplicationController {


  static targets = [ "tabs"]

  initialize(){
    let current = window.location.hash ? window.location.hash : `#${document.querySelector(".tab-content").id}`;
    this.show(current);
  }
  
  onClick(event){
    console.log(event.target.dataset.link);
    this.show(event.target.dataset.link);
  }
  
  show(tabName){

    document.querySelectorAll('.tab-content').forEach(function(item) {
      item.classList.remove('active');
    });

    var current;
    // debugger;
    if (current = document.getElementById(tabName.substr(1))){
      window.location.hash = tabName;
      current.classList.add('active');
    }
    else{
      document.querySelector('.tab-content').classList.add('active');
    }
    
      
    
  }
}








