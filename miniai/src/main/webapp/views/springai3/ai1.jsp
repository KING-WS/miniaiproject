<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
  let ai1 = {
    init:function(){
      $('#send').click(()=>{
        this.send();
      });
      $('#spinner').css('visibility','hidden');
    },
    send: async function(){
      $('#spinner').css('visibility','visible');

      let text = $('#textInput').val();

      const response = await fetch('/ai3/tts2', {
        method: "post",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json'
        },
        body: new URLSearchParams({ text: text })
      });

      const answerJson = await response.json();
      console.log(answerJson);

      //음성 답변을 재생하기 위한 소스 설정
      const audioPlayer = document.getElementById("audioPlayer");
      let base64Src = "data:audio/mp3;base64," + answerJson.audio;
      audioPlayer.src = base64Src;

      const alink = document.createElement('a');
      alink.innerHTML = "Download";
      alink.href = base64Src;
      alink.download = "output-"+new Date().getTime()+".mp3";
      $('#result > a').remove();
      $('#result').prepend(alink);

      //음성 답변이 재생 완료되었을 때 콜백되는 함수 등록
      audioPlayer.addEventListener("ended", () => {
        // 음성 답변 스피커 애니메이션 중지
        // 스피너 숨기기
        $('#spinner').css('visibility','hidden');
        console.log("대화 종료");
        // 음성 질문 다시 받기

      }, { once: true });

      audioPlayer.play();

    }


  }
  $(()=>{
    ai1.init();
  });

</script>



<div class="col-sm-10">
  <h2>Spring AI 1 텍스를 음성으로 변환</h2>
  <div class="row">


    <div class="col-sm-8">
      <span class="input-group-text">텍스트 입력</span>
      <textarea id="textInput" class="form-control"></textarea>
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
    <span class="input-group-text me-2">변환된 음성</span>
    <audio id="audioPlayer" controls></audio>
  </div>

</div>
