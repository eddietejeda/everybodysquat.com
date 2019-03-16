// import { ApplicationController } from "../support/application-controller";
// import pluralize from "pluralize";
// import safetext from "../support/safetext";
//
//
// export default class extends ApplicationController {
//
//   static targets = [ "recorder"]
//
//
//   let log = console.log.bind(console);
//   let id = val => document.getElementById(val);
//   let ul = id('ul');
//   let gUMbtn = id('gUMbtn');
//   let start = id('start');
//   let stop = id('stop');
//   let stream;
//   let recorder;
//   let counter=1;
//   let chunks;
//   let media;
//
//
//   initialize(){
//
//     gUMbtn.onclick = function() {
//       let mv = id('mediaVideo'),
//           mediaOptions = {
//             video: {
//               tag: 'video',
//               type: 'video/webm',
//               ext: '.mp4',
//               gUM: {video: true, audio: true}
//             }
//           };
//       media = mediaOptions.video;
//       navigator.mediaDevices.getUserMedia(media.gUM).then(streamer => {
//         stream = streamer;
//         id('gUMArea').style.display = 'none';
//         id('btns').style.display = 'inherit';
//         start.removeAttribute('disabled');
//         recorder = new MediaRecorder(stream);
//         recorder.ondataavailable = e => {
//           chunks.push(e.data);
//           if(recorder.state == 'inactive')  makeLink();
//         };
//         log('got media successfully');
//       }).catch(log);
//     }
//
//
//   }
//
//   toggleVideoRecord(){
//
//     this.data.get("index")
//     if (this.buttonTarget.value == 0){
//       this.buttonTarget.value = 0;
//       chunks=[];
//       recorder.start();
//     }
//     else {
//       this.buttonTarget.value = 0;
//       chunks=[];
//       recorder.stop();
//     }
//   }
//
//
//
//   makeLink(){
//     let blob = new Blob(chunks, {type: media.type });
//     let url = URL.createObjectURL(blob);
//     let li = document.createElement('li');
//     let mt = document.createElement(media.tag);
//     let hf = document.createElement('a');
//
//     mt.controls = true;
//     mt.src = url;
//     hf.href = url;
//     hf.download = `${counter++}${media.ext}`;
//     hf.innerHTML = `donwload ${hf.download}`;
//     li.appendChild(mt);
//     li.appendChild(hf);
//     ul.appendChild(li);
//   }
//
// }
