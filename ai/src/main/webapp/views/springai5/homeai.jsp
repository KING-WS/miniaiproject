<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  let homeAi = {
    init: function() {
      $('#send').click(() => {
        this.send();
      });
      $('#voice-btn').click(() => {
        this.startSpeech();
      });
      $('#spinner').css('visibility', 'hidden');
      this.updateStatus(); // Call on page load
    },
    startSpeech: function() {
      if (!('webkitSpeechRecognition' in window)) {
        alert("음성 인식을 지원하지 않는 브라우저입니다.");
        return;
      }

      const recognition = new webkitSpeechRecognition();
      recognition.lang = 'ko-KR';
      recognition.interimResults = false;
      recognition.maxAlternatives = 1;

      recognition.start();

      $('#voice-btn').text('듣는 중...');
      $('#voice-btn').prop('disabled', true);


      recognition.onresult = function(event) {
        const speechResult = event.results[0][0].transcript;
        $('#question').val(speechResult);
      };

      recognition.onspeechend = function() {
        recognition.stop();
        $('#voice-btn').text('음성인식');
        $('#voice-btn').prop('disabled', false);
      };

      recognition.onerror = function(event) {
        alert('음성 인식 오류: ' + event.error);
        $('#voice-btn').text('음성인식');
        $('#voice-btn').prop('disabled', false);
      };
    },
    send: async function() {
      $('#spinner').css('visibility', 'visible');
      let question = $('#question').val();

      // Display user's question
      let qForm = `
            <div class="media border p-3">
              <img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;">
              <div class="media-body">
                <h6>User</h6>
                <p>`+question+`</p>
              </div>
            </div>
    `;
      $('#result').prepend(qForm);
      $('#question').val(''); // Clear input

      // Prepare UI for AI response
      let uuid = this.makeUi("result");

      try {
        // AJAX request to the smarthome endpoint
        const response = await fetch('/springai5/smarthome', {
          method: "POST",
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'text/plain'
          },
          body: new URLSearchParams({ question })
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const answer = await response.text();
        // Display AI's answer
        $('#' + uuid).html(answer);
        this.updateStatus(); // Call after AI response
      } catch (error) {
        console.error('Error fetching AI response:', error);
        $('#' + uuid).html('오류가 발생했습니다. 다시 시도해주세요.');
      } finally {
        $('#spinner').css('visibility', 'hidden');
      }
    },
    updateStatus: async function() {
      try {
        const response = await fetch('/springai5/smarthome', { // Use the smarthome endpoint
          method: "POST",
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'text/plain'
          },
          body: new URLSearchParams({ question: '현재 집안 상태 알려줘' }) // Ask AI for status
        });

        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const status = await response.text();
        $('#statusText').html(status); // Use .html() to display status
      } catch (error) {
        console.error('Error fetching status:', error);
        $('#statusText').html('상태를 불러오지 못했습니다.');
      }
    },
    makeUi: function(target) {
      let uuid = "id-" + crypto.randomUUID();
      let aForm = `
          <div class="media border p-3">
            <div class="media-body">
              <h6>AI Assistant</h6>
              <p><pre id="`+uuid+`"></pre></p>
            </div>
            <img src="/image/assistant.png" alt="Assistant" class="ml-3 mt-3 rounded-circle" style="width:60px;">
          </div>
    `;
      $('#' + target).prepend(aForm);
      return uuid;
    }
  }

  $(() => {
    homeAi.init();
  });
</script>

<div class="col-sm-10">
  <h2>스마트홈 AI</h2>
  <p>AI에게 집안의 기기 제어를 요청해보세요. (예: 거실 불 켜줘, 에어컨 22도로 설정해줘)</p>
  <div class="example-commands mt-3 p-3 border rounded bg-light">
    <h5 class="text-primary">💡 스마트홈 AI 명령 가이드</h5>
    <p class="text-muted">AI 비서에게 다음과 같이 명령하여 기기를 제어하거나 상태를 확인할 수 있습니다.</p>
    <ul class="list-unstyled">
      <li class="mb-2">
        <strong>✨ 조명 제어:</strong>
        <span class="d-block ml-3">
          - <code>거실 불 켜줘</code>, <code>안방 조명 꺼줘</code>, <code>주방 조명 켜</code>
        </span>
      </li>
      <li class="mb-2">
        <strong>❄️ 에어컨 제어:</strong>
        <span class="d-block ml-3">
          - <code>에어컨 켜줘</code>, <code>에어컨 꺼줘</code>
          - <code>에어컨 온도를 22도로 설정해줘</code>, <code>에어컨 온도를 25도로 맞춰줘</code>
        </span>
      </li>
      <li class="mb-2">
        <strong>🏠 기기 상태 확인:</strong>
        <span class="d-block ml-3">
          - <code>현재 집안 상태 알려줘</code>, <code>모든 기기 상태 확인해줘</code>
        </span>
      </li>
    </ul>
    <p class="text-info">궁금한 점이 있다면 언제든지 질문해주세요!</p>
  </div>
  <div id="currentStatus" class="card mt-3">
    <div class="card-header bg-primary text-white">
      <h5 class="mb-0">🏠 현재 스마트홈 상태</h5>
    </div>
    <div class="card-body">
      <div id="statusText" style="display: block; white-space: normal;">
        <!-- Status will be loaded here by JavaScript -->
      </div>
    </div>
  </div>
            <div class="row">
      <div class="col-sm-7">
        <textarea id="question" class="form-control">거실 불 켜줘</textarea>
      </div>
      <div class="col-sm-5">
        <button type="button" class="btn btn-primary" id="send">전송</button>
              <button type="button" class="btn btn-info" id="voice-btn">음성인식</button>      </div>
    </div>
  <div id="result" class="container p-3 my-3 border" style="overflow: auto; width:auto; height: 300px;">
    <!-- Chat messages will be prepended here -->
  </div>
</div>
