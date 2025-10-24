<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #result-container {
    margin-top: 20px;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 8px;
    background-color: #f9f9f9;
  }
  #result-item {
    font-weight: bold;
    font-size: 1.2em;
    color: #0056b3;
  }
  #result-instructions {
    white-space: pre-wrap; /* Allow newlines in instructions */
    font-family: 'Malgun Gothic', sans-serif;
  }
</style>

<script>
  let recyclingHelper = {
    init: function () {
      this.previewCamera('video');

      $('#classifyBtn').on('click', () => {
        const classifyButton = $('#classifyBtn');
        classifyButton.prop('disabled', true).text('분석 중...');
        $('#result-container').html('분리수거 방법을 분석하고 있습니다...');

        this.captureFrame("video", (pngBlob) => {
          this.sendForClassification(pngBlob);
        });
      });
    },

    previewCamera: function (videoId) {
      const video = document.getElementById(videoId);
      navigator.mediaDevices.getUserMedia({video: true})
              .then((stream) => {
                video.srcObject = stream;
                video.play();
              })
              .catch((error) => {
                console.error('카메라 접근 에러:', error);
                alert('카메라를 시작할 수 없습니다. 권한을 확인해주세요.');
              });
    },

    captureFrame: function (videoId, handleFrame) {
      const video = document.getElementById(videoId);
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const context = canvas.getContext('2d');
      context.drawImage(video, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        handleFrame(blob);
      }, 'image/jpeg'); // Send as JPEG for smaller size
    },

    sendForClassification: async function (imageBlob) {
      const formData = new FormData();
      formData.append('image', imageBlob, 'capture.jpg');
      const classifyButton = $('#classifyBtn');

      try {
        console.log('Sending image to /ai5/recycling...');
        const response = await fetch('/ai5/recycling', {
          method: "post",
          body: formData
        });

        console.log('Received response:', response);

        if (response.ok) {
          const resultText = await response.text();
          console.log('Response text from server:', resultText);
          this.displayResult(resultText);
        } else {
          console.error('Server responded with an error:', response.status, response.statusText);
          this.displayError(`분류에 실패했습니다. 서버 에러: ${response.status}`);
        }
      } catch (error) {
        console.error("Error sending frame for classification:", error);
        this.displayError('오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      } finally {
        classifyButton.prop('disabled', false).text('분류하기');
      }
    },

    displayResult: function(resultText) {
      console.log('Displaying result:', resultText);
      const resultContainer = document.getElementById('result-container');
      if (resultContainer) {
        // Create a <pre> element to preserve formatting and treat text safely
        const preElement = document.createElement('pre');
        preElement.innerText = resultText;

        // Clear previous content and append the new safe element
        resultContainer.innerHTML = '';
        resultContainer.appendChild(preElement);
      } else {
        console.error('Error: Could not find element with id "result-container"');
      }
    },

    displayError: function(message) {
      console.error('Displaying error:', message);
      $('#result-container').html(`<p style="color: red;">${message}</p>`);
    }
  }

  $(() => {
    recyclingHelper.init();
  });
</script>


<div class="col-sm-10">
  <h2>실시간 쓰레기 분리수거 도우미</h2>
  <p>웹캠에 쓰레기를 비추고 '분류하기' 버튼을 누르면 AI가 분리수거 방법을 알려줍니다.</p>

  <div class="row">
    <div class="col-sm-12">
      <div class="container p-3 my-3 border">
        <div class="row">
          <div class="col-sm-12 text-center">
            <video id="video" src="" style="max-width: 100%; height: auto; border-radius: 8px;" autoplay muted playsinline></video>
          </div>
        </div>
      </div>
      <div class="text-center">
        <button id="classifyBtn" class="btn btn-primary mt-3">분류하기</button>
      </div>
      <div id="result-container" class="text-left">
        결과가 여기에 표시됩니다.
      </div>
    </div>
  </div>
</div>