<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
  let ai6 = {
    init:function(){
      this.previewCamera('video');

      setInterval(()=>{
        this.captureFrame("video", (pngBlob) => {
          this.send(pngBlob);
        });
      }, 20000);

      // $('#send').click(()=>{
      //   this.captureFrame("video", (pngBlob) => {
      //     this.send(pngBlob);
      //   });
      // });

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

      // let question = $('#question').val();
      let date = new Date();
      let question = date.getHours()+':'+date.getMinutes()+'사진의 현제 상황은 어떤 상황이야';

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
      const response = await fetch('/ai3/image-analysis2', {
        method: "post",
        headers: {
          'Accept': 'application/json'
        },
        body: formData
      });

      // 응답 JSON 받기
      const answerJson = await response.json();
      console.log(answerJson);

      //음성 답변을 재생하기 위한 소스 설정
      const audioPlayer = document.getElementById("audioPlayer");
      audioPlayer.src = "data:audio/mp3;base64," + answerJson.audio;

      //음성 답변이 재생 시작되면 콜백되는 함수 등록
      audioPlayer.addEventListener("play", () => {
        //텍스트 답변을 채팅 패널에 보여주기
        let uuid = this.makeUi("result");
        let answer = answerJson.text;
        $('#'+uuid).html(answer);
      }, { once: true });

      //음성 답변이 재생 완료되었을 때 콜백되는 함수 등록
      audioPlayer.addEventListener("ended", () => {
        // 음성 답변 스피커 애니메이션 중지
        // 스피너 숨기기
        $('#spinner').css('visibility','hidden');
        console.log("대화 종료");
        // 음성 질문 다시 받기
        this.startQuestion();
      }, { once: true });

      audioPlayer.play();


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
  <h2>Spring AI 7</h2>

  <div class="row">
    <div class="col-sm-9">
      <div class="row">
        <audio id="audioPlayer" controls style="display:none;"></audio>

      <%--        <div class="col-sm-8">--%>
<%--          <textarea id="question" class="form-control" placeholder="질문을 입력하세요"></textarea>--%>
<%--        </div>--%>
<%--        <div class="col-sm-2">--%>
<%--          <button type="button" class="btn btn-primary" id="send">Send</button>--%>
<%--        </div>--%>
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
