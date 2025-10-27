<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<script>
  let ai2 = {
    init:function(){
      this.startQuestion();
      $('#spinner').css('visibility','hidden');
    },
    startQuestion:function(){
      // 마이크 초기화
      springai.voice.initMic(this);
      let qForm = `
            <div class="media border p-3">
<!--              <img src="/image/user.png" alt="John Doe" class="mr-3 mt-3 rounded-circle" style="width:60px;">-->
               <div  class="speakerPulse"
              style="width: 30px; height: 30px;
              background: url('/image/speaker-yellow.png') no-repeat center center / contain;"></div>음성으로 질문하세요
            </div>
    `;
      // 사용자가 음성을 입력할 차례임을 알려주는 UI 추가
      $('#result').prepend(qForm);
    },
    handleVoice: async function(mp3Blob){

      //스피너 보여주기
      $('#spinner').css('visibility','visible');

      // 멀티파트 폼 구성
      const formData = new FormData();
      formData.append("speech", mp3Blob, 'speech.mp3');

      // 녹화된 음성을 텍스트로 변환 요청
      const response = await fetch("/ai3/stt", {
        method: "post",
        headers: {
          // Content-Type은 자동 생성되는 것을 사용해야함(파트 구분선 포함)
          'Accept': 'text/plain'
        },
        body: formData
      });

      // 텍스트 질문을 채팅 패널에 보여주기
      const questionText = await response.text();
      console.log('Handle:'+questionText);


      let qForm = `
              <div class="media border p-3">
                <img src="/image/user.png" alt="John Doe" class="mr-3 mt-3 rounded-circle" style="width:60px;">
                <div class="media-body">
                  <h6>John Doe</h6>
                  <p>`+questionText+`</p>
                </div>
              </div>
         `;
      $('#result').prepend(qForm);


      await this.chat(questionText);



    },
    chat:async function(questionText){

      const response = await fetch("/ai3/chat-text", {
        method: "post",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: new URLSearchParams({ question: questionText })
      });

      // AI 답변을 보여줄 엘리먼트를 채팅 패널에 추가하기


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
    send: async function(){
      $('#spinner').css('visibility','visible');

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

      const response = await fetch('/ai2/bean-output-converter', {
        method: "post",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: new URLSearchParams({ city: question })
      });

      let uuid = this.makeUi("result");

      const jsonString = await response.text();
      const jsonObject = JSON.parse(jsonString);
      const prettyJson = JSON.stringify(jsonObject, null, 2);
      $('#'+uuid).html(prettyJson)


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
    ai2.init();
  });

</script>


<div class="col-sm-10">
  <h2>Spring AI 2</h2>
  <div class="row">
    <div class="col-sm-8">
      <h4>음성으로 질문 하세요</h4>
      <audio id="audioPlayer" controls style="display:none;"></audio>
    </div>

    <div class="col-sm-2">
      <button class="btn btn-primary" disabled >
        <span class="spinner-border spinner-border-sm" id="spinner"></span>
        Loading..
      </button>
    </div>
  </div>


  <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 500px;">

  </div>

</div>
