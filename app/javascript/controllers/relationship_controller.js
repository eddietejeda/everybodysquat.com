import { ApplicationController } from "../support/application-controller";
import pluralize from "pluralize";
import safetext from "../support/safetext";
import cookies from "../support/cookies";


export default class extends ApplicationController {

  static targets = [ "pending", "follower", "email", "button", "notice", "pending", "invites", "following"]
  

  send_invitation(){
    this.railsCreate(`/relationships`, "email", this.emailTarget.value).then(
      result => this.invitation_sent(result)
    );
    this.emailTarget.value = '';
    // this.noticeTarget.innerHTML = "Invitation sent!";
    // setTimeout( () => this.noticeTarget.style.display = 'none' , 3000);
  }
  
  invitation_sent(response){
    let button, display_name, view;
    if (response.exists){
      button = `<button class="btn btn-primary btn-sm">Cancel Request</button>`
      display_name = response.username;
      view = this.followingTarget;
    }
    else{
      button = `<button class="btn btn-primary btn-sm">Remove Invitation</button>`      
      display_name = response.email;
      view = this.invitesTarget
    }
    
    this.render(display_name, button, view);
  }
  
  render(display_name, button, view){

    view.innerHTML += `
     <div class="tile">
       <div class="tile-icon">
          <figure class="avatar avatar-lg">
             <img alt="Super User" src="https://picturepan2.github.io/spectre/img/avatar-3.png">
          </figure>
       </div>
       <div class="tile-content">
          <div class="column">
             <div class="columns">
                <div class="col-6 left">
                   ${display_name}
                </div>
                <div class="col-6 right">
                   ${button}
                </div>
             </div>
          </div>
       </div>
      </div>`;
    
  }
  
  
  
  
  unfollow(event){
    console.log('remove relationship');    
    this.railsCreate(`/relationships/unfollow`, "follow_user_id", event.target.value).then(
      result => event.target.closest('.row').remove()
    )  
    
    
  }

  remove_invitation(event){
    console.log('remove invitation');
    this.railsCreate(`/relationships/remove_invitation`, "invitation_id", event.target.value).then(
      result => event.target.closest('.row').remove()
    )  
  }
  
  
  approve(event){
    console.log('approve relationship');
    
    let followingTarget = this.followingTarget;
    this.railsCreate(`/relationships/approve`, "follow_user_id", event.target.value).then(
      result => {
        let button, display_name, view;
        button = `<button class="btn btn-primary btn-sm">Unfollow</button>`
        display_name = event.target.closest('.row').querySelector('.left').textContent.trim();
        debugger;
        this.render(display_name, button, followingTarget);
        
        event.target.closest('.row').remove();    
      }
    )
  }

  reject(event){
    console.log('approve relationship');
    this.railsCreate(`/relationships/reject`, "follow_user_id", event.target.value).then(
      result => {
        event.target.closest('.row').remove()
        // document.querySelectorAll('#requests .row').length;
      }
    );
  }






  
}