<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  let center = {
    init: function () {
      this.previewCamera('video');
      $('#send_btn').click(() => {
        this.captureFrame("video", (pngBlob) => {
          this.analyzeAndSend(pngBlob);
        });
      });
    },
    previewCamera: function(videoId){
      const video = document.getElementById(videoId);
      navigator.mediaDevices.getUserMedia({ video: true })
              .then((stream) => {
                video.srcObject = stream;
                video.play();
              })
              .catch((error) => {
                console.error('카메라 접근 에러:', error);
              });
    },
    captureFrame: function(videoId, handleFrame){
      const video = document.getElementById(videoId);
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const context = canvas.getContext('2d');
      context.drawImage(video, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        handleFrame(blob);
      }, 'image/png');
    },
    blobToDataUrl: function(blob) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onloadend = () => resolve(reader.result);
            reader.onerror = reject;
            reader.readAsDataURL(blob);
        });
    },
    analyzeAndSend: async function(pngBlob) {
      // 1. 이미지를 AI 서버로 보내 분석 요청
      let date = new Date();
      let question = date.getHours() + ':' + date.getMinutes() + ' 사진의 현재 상황은 어떤 상황이야?';
      const formData = new FormData();
      formData.append("question", question);
      formData.append('attach', pngBlob, 'frame.png');

      const response = await fetch('/ai3/image-analysis2', {
        method: "post",
        headers: {
          'Accept': 'application/json'
        },
        body: formData
      });

      const answerJson = await response.json();
      const analysisResult = answerJson.text;

      // 2. Blob을 Base64 데이터 URL로 변환
      const imageDataUrl = await this.blobToDataUrl(pngBlob);

      // 3. 분석 결과와 이미지 데이터를 admin 서버로 전송
      this.sendToAdmin(analysisResult, imageDataUrl);
    },
    sendToAdmin: function(text, image) {
        const payload = {
            text: text,
            image: image
        };

        $.ajax({
            url: '${adminserver}api/situation-update',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(payload),
            success: () => {
              console.log("Admin 서버로 상황 분석 정보 전송 완료");
            },
            error: (e) => {
              console.error("Admin 서버로 전송 실패:", e);
            }
      });
    }
  }

  $(() => {
    center.init();
  })
</script>

<div class="col-sm-10">
  <h2>AI3 Voice Image Chat System</h2>
  <h5>Admin Server: ${adminserver}</h5>
  <div class="row">
    <div class="col-sm-8">
      <button id="send_btn" class="btn btn-primary">상황 분석 및 전송</button>
    </div>
    <div class="col-sm-4">
      <video id="video" src="" alt="" height="200" autoplay></video>
    </div>
  </div>
</div>