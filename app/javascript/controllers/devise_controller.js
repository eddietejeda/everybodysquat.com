import { ApplicationController } from "../support/application-controller";



export default class extends ApplicationController {
  // static targets = ["message", "commentList"]

  onLoginSuccess(event) {
    console.log('success');
    // let [data, status, xhr] = event.detail;
    // this.commentListTarget.innerHTML += xhr.response;
    // this.messageTarget.value = "";
  }
}