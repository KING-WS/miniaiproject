<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
  let ai3 = {
    init:function(){
      $('#send').click(()=>{
        this.send();
      });
      $('#spinner').css('visibility','hidden');
      $('#attach').change(()=>{
        this.previewImage();
      });
    },
    previewImage:function(){
      const file = document.getElementById("attach").files[0];

      if(file) {
        const uuid = "id-" + crypto.randomUUID();
        const previewHtml = `
            <div class="media border p-3">
              <img src="/image/user.png" alt="John Doe" class="mr-3 mt-3 rounded-circle" style="width:60px;">
              <div class="media-body">
                <p>올리신 이미지 입니다.</p>
                <img id="`+uuid+`" src="" alt="미리보기 이미지" height="200"/>
              </div>
            </div>
    `;
        $('#result').prepend(previewHtml);

        const reader = new FileReader();
        reader.onload = function (e) {
          const preview = document.getElementById(uuid);
          preview.src = e.target.result;
        };
        reader.readAsDataURL(file);
      }
    },
    send: async function(){
      $('#spinner').css('visibility','visible');

      const formData = new FormData();
      const attach = document.getElementById("attach").files[0];
      if(attach) {
        formData.append("attach", attach);
      } else {
        alert("번호판이 나오는 차량 이미지 파일을 선택해 주세요.");
        return;
      }



      // AJAX 요청하고 응답받기
      const response = await fetch('/ai5/boom-barrier-tools', {
        method: "post",
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
    ai3.init();
  });

</script>


<div class="col-sm-10">
  <h2>Spring AI 3</h2>
  <div class="row">
    <div class="col-sm-8">
      <span class="input-group-text">자동차 번호판 사진</span>
      <input id="attach" class="form-control" type="file"/>
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
