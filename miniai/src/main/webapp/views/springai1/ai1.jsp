<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
  ai1 = {
    init:function(){
      $('#send').click(()=>{
        this.send();
      });
      $('#spinner').css('visibility','hidden');
    },
    send:function(){
      // 1. spinner 동작
      $('#spinner').css('visibility','visible');

      // 2. 질문 가저온다. 화면에 출력 한다.
      const question = $('#question').val();
      let qForm = `
            <div class="media border p-3">
              <img src="/image/user.png" alt="John Doe" class="mr-3 mt-3 rounded-circle" style="width:60px;">
              <div class="media-body">
                <h6>이말숙</h6>
                <p>`+question+`</p>
              </div>
            </div>
        `;
      $('#result').prepend(qForm);

      // 3. ajax로 서버에 전송
      // 4. 결과를 출력 한다.
      $.ajax({
        url:'<c:url value="/ai1/chat-model"/>',
        data:{question:question},
        success:(result)=>{
          this.display(result);
        }
      });

    },
    display:function(result){
      $('#spinner').css('visibility','hidden');
      let aForm = `
          <div class="media border p-3">
            <div class="media-body">
              <h6>GPT4 </h6>
              <p><pre>`+result+`</pre></p>
            </div>
            <img src="/image/assistant.png" alt="John Doe" class="ml-3 mt-3 rounded-circle" style="width:60px;">
          </div>
        `;
      $('#result').prepend(aForm);
    }
  }
  $(()=>{
    ai1.init();
  });
</script>

<div class="col-sm-10">
  <h2>Spring AI 1 Chat Model</h2>
  <div class="row">
    <div class="col-sm-8">
      <textarea id="question" class="form-control">Spring AI에 대해 300자 이내로 설명해줘</textarea>
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
