<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
  let ai1 = {
    init:function(){
      $('#send').click(()=>{
        this.send();
      });
      $('#del').click(()=>{
        $.ajax({
          url:'/ai4/rag-clear',
          success:function(result){
            alert('삭제 되었습니다.');
          }
        });
      });
      $('#spinner').css('visibility','hidden');
    },
    send: async function(){

      const type = $('#type').val();
      if(!type){
        alert("타입을 입력해야 합니다.");
        return;
      }
      const attach = document.getElementById("attach").files[0];
      if(!attach) {
        alert("문서 파일을 선택해야 합니다.");
        return;
      }
      $('#spinner').css('visibility','visible');

      // 멀티파트 폼 구성하기
      const formData = new FormData();
      formData.append("type", type);
      formData.append("attach", attach);

      // AJAX 요청하고 응답받기
      const response = await fetch('/ai4/txt-pdf-docx-etl', {
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
    ai1.init();
  });

</script>


<div class="col-sm-10">
  <h2>Spring AI 1 File Upload System</h2>
  <div class="row">
    <div class="input-group p-2">
      <span class="input-group-text">구분</span>
      <input id="type" class="form-control" type="text" placeholder="구분 입력"/>
    </div>
    <div class="col-sm-8">
      <span class="input-group-text">문서</span>
      <input id="attach" class="form-control" type="file"/>
    </div>
    <div class="col-sm-1">
      <button type="button" class="btn btn-primary" id="send">Send</button>
    </div>
    <div class="col-sm-1">
      <button type="button" class="btn btn-primary" id="del">Delete</button>
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
