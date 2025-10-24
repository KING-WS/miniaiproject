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

      const response = await fetch('/ai1/few-shot-prompt', {
        method: "post",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/x-ndjson' //라인으로 구분된 청크 텍스트
        },
        body: new URLSearchParams({ question })
      });

      let uuid = this.makeUi("result");

      const jsonString = await response.text();
      const jsonObject = JSON.parse(jsonString);
      console.log(jsonObject);
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
    ai4.init();
  });

</script>


<div class="col-sm-10">
  <h2>Spring AI 4 Few shot Prompt</h2>
  <div class="row">
    <div class="col-sm-8">
      <textarea id="question" class="form-control">큰 피자 하나, 절반은 치즈랑 모짜렐라로, 나머지 절반은 토마토 소스랑 햄, 파인애플로 주세요.</textarea>
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


  <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 500px;">

  </div>

</div>