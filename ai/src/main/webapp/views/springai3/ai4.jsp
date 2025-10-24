<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  let ai4 = {
    init:function(){
      $('#send').click(()=>{
        this.send();
      });
      $('#spinner').css('visibility','hidden');
    },
    send: async function(){
      $('#spinner').css('visibility','visible');

      let question = $('#question').val();

      const response = await fetch('/ai3/image-generate', {
        method: "post",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/x-ndjson' //라인으로 구분된 청크 텍스트
        },
        body: new URLSearchParams({ question })
      });

      const b64Json = await response.text();
      if (!b64Json.includes("Error")) {
        // <img>에서 생성된(편집된) 이미지 보여주기
        const base64Src = "data:image/png;base64," + b64Json;
        console.log('----------------------------------------');
        console.log(base64Src);
        const generatedImage = document.getElementById("generatedImage");
        generatedImage.src = base64Src;


        const alink = document.createElement('a');
        alink.innerHTML = "Download";
        alink.href = base64Src;
        alink.download = "output-"+new Date().getTime()+".png";
        $('#result').prepend(alink);

      } else {
        alert(b64Json);
      }

      $('#spinner').css('visibility','hidden');

    }

  }

  $(()=>{
    ai4.init();
  });

</script>
<div class="col-sm-10">
  <h2>Spring AI 4</h2>
  <div class="row">
    <div class="col-sm-8">
      <textarea id="question" class="form-control" placeholder="만들고자 하는 사진을 설명 하세요"></textarea>
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


  <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 1000px;">
    <img id="generatedImage" src="/image/assistant.png" class="img-fluid" alt="Generated Image" />
  </div>

</div>
