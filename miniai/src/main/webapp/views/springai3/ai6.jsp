<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
  let ai6 = {
    init:function(){
      this.previewCamera('video');
      $('#send').click(()=>{
        this.captureFrame("video", (pngBlob) => {
          this.send(pngBlob);
        });
      });

      $('#spinner').css('visibility','hidden');
    },
    previewCamera:function(videoId){
      const video = document.getElementById(videoId);
      //카메라를 활성화하고 <video>에서 보여주기
      navigator.mediaDevices.getUserMedia({ video: true })
              .then((stream) => {
                video.srcObject = stream;
                video.play();
              })
              .catch((error) => {
                console.error('카메라 접근 에러:', error);
              });
    },
    captureFrame:function(videoId, handleFrame){
      const video = document.getElementById(videoId);

      //캔버스를 생성해서 비디오 크기와 동일하게 맞춤
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;

      // 캔버스로부터  2D로 드로잉하는 Context를 얻어냄
      const context = canvas.getContext('2d');

      // 비디오 프레임을 캔버스에 드로잉
      context.drawImage(video, 0, 0, canvas.width, canvas.height);

      // 드로잉된 프레임을 PNG 포맷의 blob 데이터로 얻기
      canvas.toBlob((blob) => {
        handleFrame(blob);
      }, 'image/png');
    },
    send: async function(pngBlob){

      let question = $('#question').val();
      let qForm = `
            <div class="media border p-3">
              <img src="/image/user.png" alt="John Doe" class="mr-3 mt-3 rounded-circle" style="width:60px;">
              <div class="media-body">
                <h6>John Doe</h6>
                <p>`+question+`</p>
              </div>
            </div>
    `;
      $('#result').prepend(qForm);

      $('#spinner').css('visibility','visible');

      // 멀티파트 폼 구성하기
      const formData = new FormData();
      formData.append("question", question);
      formData.append('attach', pngBlob, 'frame.png');

      // AJAX 요청
      const response = await fetch('/ai3/image-analysis', {
        method: "post",
        headers: {
          'Accept': 'application/x-ndjson'
        },
        body: formData
      });

      let uuid = this.makeUi("result");

      const reader = response.body.getReader();
      const decoder = new TextDecoder("utf-8");
      let content = "";
      while (true) {
        const {value, done} = await reader.read();
        if (done) break;
        let chunk = decoder.decode(value);
        content += chunk;
        console.log(content);
        $('#'+uuid).html(content)
      }

      $('#spinner').css('visibility','hidden');

    },
    makeUi:function(target){
      let uuid = "id-" + crypto.randomUUID();

      let aForm = `
          <div class="media border p-3">
            <div class="media-body">
              <h6>GPT4 </h6>
              <p><pre id="`+uuid+`"></pre></p>
            </div>
            <img src="/image/assistant.png" alt="John Doe" class="ml-3 mt-3 rounded-circle" style="width:60px;">
          </div>
    `;
      $('#'+target).prepend(aForm);
      return uuid;
    }

  }

  $(()=>{
    ai6.init();
  });

</script>


<div class="col-sm-10">
  <h2>Spring AI 6</h2>

  <div class="row">
    <div class="col-sm-9">
      <div class="row">
        <div class="col-sm-8">
          <textarea id="question" class="form-control" placeholder="질문을 입력하세요"></textarea>
        </div>
        <div class="col-sm-2">
          <button type="button" class="btn btn-primary" id="send">Send</button>
        </div>
        <div class="col-sm-2">
          <button class="btn btn-primary" disabled >
            <span class="spinner-border spinner-border-sm" id="spinner"></span>
            Loading..
          </button>
        </div>

      </div>
      <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 300px;">

      </div>
    </div>

    <div class="col-sm-3">
      <video id="video" src="" alt="" height="200" autoplay />
    </div>

  </div>




</div>
