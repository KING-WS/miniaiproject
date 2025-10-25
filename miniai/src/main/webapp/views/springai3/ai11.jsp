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

      const response = await fetch('/ai3/tts', {
        method: "post",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/octet-stream'
        },
        body: new URLSearchParams({ text: text })
      });

      const audioPlayer = document.getElementById("audioPlayer");
      await this.playAudio(response, audioPlayer);

      audioPlayer.addEventListener("play", () => {
        $('#spinner').css('visibility','hidden');
      }, { once: true });

    },
    playAudio:async function(response, audioPlayer){
      try {
        // 스트리밍을 위한 미디어소스 생성과 audioPlaye 소스로 설정
        const mediaSource = new MediaSource();
        audioPlayer.src = URL.createObjectURL(mediaSource);

        // 스트림이 열리면 콜백되는 함수 등록
        mediaSource.addEventListener('sourceopen', async () => {
          // 본문의 오디오 데이터 타입을 알려주고 데이터 버퍼 준비
          // MIME 타입은 서버에서 실제 인코딩한 포맷으로 맞춰야 함
          // 예) MP3: 'audio/mpeg', WAV: 'audio/wav'
          const sourceBuffer = mediaSource.addSourceBuffer('audio/mpeg');
          // 응답 본문을 읽는 리더 얻기
          const reader = response.body.getReader();
          // 스트리밍되는 데이터가 있을 동안 반복
          while (true) {
            // 스트리밍 음성 데이터(청크) 읽기
            const { done, value } = await reader.read();
            //스트리밍이 종료될 경우 스트림을 닫고 반복 중지
            if (done) {
              mediaSource.endOfStream();
              break;
            }
            // 스트리밍이 계속 진행 중일 경우
            await new Promise(resolve => {
              // 버퍼 데이터가 갱신 완료될 때마다 핸들러(resolve) 실행,
              // { once: true }: 핸들러를 한 번만 실행한 후 자동으로 제거
              sourceBuffer.addEventListener('updateend', resolve, { once: true });
              // 버퍼에 데이터 추가
              sourceBuffer.appendBuffer(value);
            });
          }
        });
        // 재생 시작
        audioPlayer.play();
      } catch (error) {
        console.log(error);
      }

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
