<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #videoContainer { position: relative; width: 100%; margin-bottom: 10px; }
  #video { width: 100%; height: auto; border: 2px solid #007bff; border-radius: 5px; }
  #captureBtn {
    display: block;
    width: 100%;
    padding: 12px;
    background-color: #4CAF50;
    color: white;
    border: none;
    cursor: pointer;
    margin-top: 10px;
    border-radius: 5px;
    font-size: 16px;
    font-weight: bold;
    transition: background-color 0.3s;
  }
  #captureBtn:hover {
    background-color: #45a049;
  }
  #capturedImage {
    width: 100%;
    height: auto;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #f9f9f9;
  }

  /* Modal Styles (Basic, assuming Bootstrap is available for full styling) */
  .modal {
    display: none; /* Hidden by default */
    position: fixed; /* Stay in place */
    z-index: 1050; /* Sit on top */
    left: 0;
    top: 0;
    width: 100%; /* Full width */
    height: 100%; /* Full height */
    overflow: auto; /* Enable scroll if needed */
    background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
  }
  .modal-dialog {
    margin: 1.75rem auto;
    position: relative;
    width: auto;
    max-width: 500px;
  }
  .modal-content {
    background-color: #fefefe;
    margin: 15% auto; /* 15% from the top and centered */
    padding: 20px;
    border: 1px solid #888;
    width: 80%; /* Could be more or less, depending on screen size */
    box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2),0 6px 20px 0 rgba(0,0,0,0.19);
    -webkit-animation-name: animatetop; -webkit-animation-duration: 0.4s;
    animation-name: animatetop; animation-duration: 0.4s
  }
  /* Add Animation */
  @-webkit-keyframes animatetop {
    from {top:-300px; opacity:0}
    to {top:0; opacity:1}
  }
  @keyframes animatetop {
    from {top:-300px; opacity:0}
    to {top:0; opacity:1}
  }
  .modal-header {
    padding: 15px;
    border-bottom: 1px solid #e9ecef;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .modal-title {
    margin-bottom: 0;
    line-height: 1.5;
  }
  .modal-body {
    padding: 15px;
  }
  .modal-footer {
    padding: 15px;
    border-top: 1px solid #e9ecef;
    display: flex;
    justify-content: flex-end;
  }
  .close {
    font-size: 1.5rem;
    font-weight: 700;
    line-height: 1;
    color: #000;
    text-shadow: 0 1px 0 #fff;
    opacity: .5;
    cursor: pointer;
  }
  .close:hover {
    opacity: .75;
  }
  .btn {
    display: inline-block;
    font-weight: 400;
    color: #212529;
    text-align: center;
    vertical-align: middle;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    background-color: transparent;
    border: 1px solid transparent;
    padding: .375rem .75rem;
    font-size: 1rem;
    line-height: 1.5;
    border-radius: .25rem;
    transition: color .15s ease-in-out,background-color .15s ease-in-out,border-color .15s ease-in-out,box-shadow .15s ease-in-out;
  }
  .btn-secondary {
    color: #fff;
    background-color: #6c757d;
    border-color: #6c757d;
  }
  .btn-secondary:hover {
    color: #fff;
    background-color: #5a6268;
    border-color: #545b62;
  }

  .ai-section {
    background-color: #f8f9fa;
    border: 1px solid #dee2e6;
    border-radius: 5px;
    padding: 15px;
    margin-bottom: 15px;
  }

  .section-title {
    background-color: #007bff;
    color: white;
    padding: 8px 15px;
    margin: -15px -15px 15px -15px;
    border-radius: 5px 5px 0 0;
    font-weight: bold;
    font-size: 16px;
  }

  /* 추가 스타일링 */
  .btn-block {
    width: 100%;
    font-weight: bold;
    padding: 10px;
    font-size: 15px;
  }

  .form-control {
    border-radius: 5px;
    border: 1px solid #ced4da;
  }

  .form-control:focus {
    border-color: #007bff;
    box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
  }

  /* FullCalendar 스타일 개선 */
  #calendar {
    font-size: 14px;
  }

  /* 캘린더 날짜 셀 스타일 */
  .fc .fc-daygrid-day {
    min-height: 120px !important;
    height: 120px !important;
  }

  .fc .fc-daygrid-day-frame {
    min-height: 120px !important;
    height: 100% !important;
  }

  .fc .fc-daygrid-day-number {
    padding: 8px !important;
    font-size: 18px !important;
    font-weight: bold !important;
    color: #333 !important;
  }

  .fc .fc-daygrid-day-top {
    flex-direction: row !important;
    justify-content: flex-start !important;
    padding: 4px !important;
  }

  /* 다른 달 날짜 스타일 */
  .fc .fc-day-other .fc-daygrid-day-number {
    color: #999 !important;
  }

  /* 이벤트 스타일 */
  .fc-event {
    font-size: 13px !important;
    padding: 2px 4px !important;
    margin-bottom: 2px !important;
    border-radius: 3px !important;
  }

  /* 캘린더 헤더 스타일 */
  .fc .fc-col-header-cell {
    padding: 10px 0 !important;
    font-size: 15px !important;
    font-weight: bold !important;
    background-color: #f8f9fa !important;
  }

  /* 오늘 날짜 강조 */
  .fc .fc-day-today {
    background-color: #fff3cd !important;
  }

  /* 이벤트 제목 글자 잘림 방지 */
  .fc-event-title {
    white-space: nowrap !important;
    overflow: hidden !important;
    text-overflow: ellipsis !important;
  }

  /* 이벤트 컨테이너 영역 */
  .fc .fc-daygrid-day-events {
    margin-top: 4px !important;
    min-height: 60px !important;
  }

  /* 이벤트가 배치되는 영역 */
  .fc .fc-daygrid-event-harness {
    margin-bottom: 2px !important;
  }

  /* 캘린더 버튼 스타일 */
  .fc .fc-button {
    padding: 6px 12px !important;
    font-size: 14px !important;
  }

  .fc .fc-button:hover {
    background-color: #0056b3 !important;
  }

  /* 캘린더 타이틀 */
  .fc .fc-toolbar-title {
    font-size: 22px !important;
    font-weight: bold !important;
  }
</style>

<div class="col-sm-10">
  <h2>가계부 관리 시스템 (AI 어시스턴트 포함)</h2>
  <div class="row">
    <!-- 좌측: 캘린더 (넓게 - 9칸) -->
    <div class="col-md-9">
      <div class="ai-section" style="min-height: 800px;">
        <div class="section-title">가계부 캘린더</div>
        <div id='calendar'></div>
      </div>
    </div>

    <!-- 우측: 입력 및 처리 영역 (좁게 - 3칸) -->
    <div class="col-md-3">
      <!-- 영수증 스캐너 섹션 -->
      <div class="ai-section">
        <div class="section-title">영수증 스캐너</div>
        <div id="videoContainer">
          <video id="video" autoplay playsinline></video>
        </div>
        <button id="captureBtn">영수증 캡쳐</button>

        <div style="margin-top: 15px;">
          <strong>캡쳐된 이미지:</strong>
          <canvas id="capturedImage" style="width:100%; height:auto; border: 1px solid #ddd; margin-top: 5px;"></canvas>
        </div>
      </div>

      <!-- 영수증 분석 결과 섹션 -->
      <div class="ai-section">
        <div class="section-title">영수증 분석 결과</div>
        <div id="llmResult" style="padding: 15px; min-height: 200px; background-color: #fff; border: 1px solid #ddd; border-radius: 5px; overflow-y: auto; max-height: 400px; font-size: 12px;">
          <p style="color: #999; text-align: center; padding: 20px;">영수증을 캡쳐하면 LLM 분석 결과가 여기에 표시됩니다</p>
        </div>
      </div>

      <!-- AI 어시스턴트 섹션 -->
      <div class="ai-section">
        <div class="section-title">가계부 AI 어시스턴트</div>
        <div style="margin-bottom: 10px;">
          <textarea id="accountQuestion" class="form-control" rows="2" placeholder="예: 이번 달 가장 비싼 지출은?&#10;예: 총 지출 비용은?"></textarea>
        </div>
        <button id="askBtn" class="btn btn-success btn-block" style="font-size: 13px; padding: 8px;">질문하기</button>
        <div id="aiResponse" style="background-color: #f0f8ff; border: 1px solid #ccc; padding: 10px; min-height: 100px; max-height: 250px; overflow-y: auto; white-space: pre-wrap; margin-top: 10px; border-radius: 5px; font-size: 12px;">AI 어시스턴트가 대기 중입니다...</div>
      </div>
    </div>
  </div>
</div>

<!-- Event Detail Modal -->
<div class="modal" id="eventDetailModal" tabindex="-1" role="dialog" aria-labelledby="eventDetailModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="eventDetailModalLabel">이벤트 상세 정보</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="$('#eventDetailModal').hide();">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body" id="eventDetailModalBody">
        <!-- Event details will be loaded here -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="$('#eventDetailModal').hide();">닫기</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js"></script>
<script>
  // --- 웹캠 및 캡쳐 로직 시작 ---
  let camera_center = {
    video: null,
    canvas: null,
    captureBtn: null,

    init: function() {
      this.video = $("#video");
      this.canvas = $("#capturedImage");
      this.captureBtn = $("#captureBtn");
      this.startCamera();
      this.initEvent();
    },

    startCamera: function() {
      if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({ video: true })
                .then(stream => {
                  this.video[0].srcObject = stream;
                  this.video[0].play();
                })
                .catch(err => {
                  console.error("카메라 접근 에러:", err);
                  alert("카메라에 접근할 수 없습니다.");
                });
      }
    },

    initEvent: function() {
      this.captureBtn.on('click', () => {
        this.capture();
      });
    },

    capture: function() {
      let context = this.canvas[0].getContext('2d');
      this.canvas[0].width = this.video[0].videoWidth;
      this.canvas[0].height = this.video[0].videoHeight;
      context.drawImage(this.video[0], 0, 0, this.canvas[0].width, this.canvas[0].height);

      $("#llmResult").text('이미지 분석 중...');

      this.canvas[0].toBlob((blob) => {
        let formData = new FormData();
        formData.append('receipt', blob, 'receipt.png');

        $.ajax({
          url: '/springaiTest/process-receipt',
          type: 'POST',
          data: formData,
          processData: false,
          contentType: false,
          success: function(response) {
            let responseData = response;
            if (typeof response === 'string') {
              responseData = JSON.parse(response);
            }

            let displayHtml = '<h4 style="color: #007bff; margin-bottom: 15px;">영수증 분석 완료</h4>';
            if (!responseData.success) {
              displayHtml += '<p style="color: red;">오류: ' + responseData.error + '</p>';
            } else {
              // 실제 분석 결과가 있는 경우
              displayHtml += '<div style="background-color: #e8f5e9; padding: 8px; border-radius: 5px; margin-bottom: 8px; font-size: 11px;">';
              displayHtml += '<p style="margin: 3px 0;"><strong>날짜:</strong> ' + responseData.date + '</p>';
              if (responseData.storeName) {
                displayHtml += '<p style="margin: 3px 0;"><strong>가게:</strong> ' + responseData.storeName + '</p>';
              }
              displayHtml += '<p style="margin: 3px 0;"><strong>총 금액:</strong> <span style="color: #d32f2f; font-size: 14px; font-weight: bold;">' + responseData.totalAmount.toLocaleString() + '원</span></p>';
              if (responseData.category) {
                displayHtml += '<p style="margin: 3px 0;"><strong>분류:</strong> ' + responseData.category + '</p>';
              }
              displayHtml += '</div>';

              if (responseData.items && responseData.items.length > 0) {
                displayHtml += '<div style="margin-top: 8px; font-size: 11px;"><strong>상품 목록:</strong><ul style="margin-top: 3px; padding-left: 20px;">';
                responseData.items.forEach(item => {
                  displayHtml += '<li style="margin-bottom: 2px;">' + item.name + ': ' + item.price.toLocaleString() + '원</li>';
                });
                displayHtml += '</ul></div>';
              }

              // 데이터베이스 저장 성공 메시지
              displayHtml += '<p style="color: green; margin-top: 8px; font-weight: bold; font-size: 11px;">캘린더에 자동 저장되었습니다!</p>';

              // 캘린더 새로고침
              calendar_center.loadEvents();
            }
            $("#llmResult").html(displayHtml);
          },
          error: function(jqXHR, textStatus, errorThrown) {
            console.error("업로드 실패:", textStatus, errorThrown);
            $("#llmResult").text('오류가 발생했습니다: ' + textStatus);
          }
        });
      }, 'image/png');
    }
  };
  // --- 웹캠 및 캡쳐 로직 끝 ---

  // 캘린더 초기화 및 이벤트 추가 로직
  let calendar_center = {
    calendar: null,
    init:function(){
      this.display();
      this.loadEvents(); // 데이터베이스에서 이벤트 로드
    },
    display:function(){
      let calendarEl = document.getElementById('calendar');
      this.calendar = new FullCalendar.Calendar(calendarEl, {
        timeZone: 'UTC',
        initialView: 'dayGridMonth',
        locale: 'ko', // 캘린더 한글화
        height: 'auto', // 캘린더 높이 자동
        events: [], // 초기에는 비워둡니다.
        editable: true,
        selectable: true,
        displayEventTime: false, // 이벤트 시간 숨기기
        eventClick: function(info) {
          calendar_center.showEventDetailModal(info.event);
        },
        headerToolbar: {
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth'
        },
        buttonText: {
          today: '오늘',
          month: '월'
        },
        dayCellClassNames: function(arg) {
          return ['custom-day-cell'];
        },
        eventClassNames: function(arg) {
          return ['custom-event'];
        },
        dayMaxEvents: true, // 이벤트가 많을 경우 "more" 링크 표시
        moreLinkText: function(num) {
          return '+' + num + '개 더보기';
        }
      });
      this.calendar.render();
    },
    loadEvents: function() {
      // 데이터베이스에서 LLM 분석 결과를 가져와서 캘린더에 표시
      $.ajax({
        url: '/springaiTest/get-analysis-results',
        type: 'GET',
        success: function(response) {
          if (response.success && response.results) {
            let events = [];
            response.results.forEach(function(result) {
              let event = {
                start: result.analysisDate,
                allDay: true, // 기본값: 하루 종일 이벤트
                extendedProps: {
                  analysisType: result.analysisType,
                  analysisDate: result.analysisDate,
                  category: result.category,
                  totalAmount: result.amount,
                  items: result.items || []
                }
              };

              if (result.analysisType === 'expense' && typeof result.amount === 'number') {
                event.allDay = false;
                event.start = result.analysisDate + 'T12:00:00';
                event.title = result.amount.toLocaleString() + '원';
                event.backgroundColor = '#ff6b6b';
                event.borderColor = '#ff5252';
              } else if (result.analysisType === 'income' && typeof result.amount === 'number') {
                event.allDay = false;
                event.start = result.analysisDate + 'T12:00:00';
                event.title = '+' + result.amount.toLocaleString() + '원';
                event.backgroundColor = '#4ecdc4';
                event.borderColor = '#26a69a';
              } else if (result.analysisType === 'schedule') {
                event.title = result.description;
                event.backgroundColor = '#45b7d1';
                event.borderColor = '#2196f3';
                event.extendedProps.description = result.description;
              }

              events.push(event);
            });

            calendar_center.calendar.getEventSources().forEach(source => source.remove());
            calendar_center.calendar.addEventSource(events);
            console.log('데이터베이스에서 ' + events.length + '개의 이벤트를 로드했습니다.');
          }
        },
        error: function(xhr, status, error) {
          console.error('이벤트 로드 실패:', error);
        }
      });
    },
    addEvent: function(eventData) {
      this.calendar.addEvent({
        title: eventData.title,
        start: eventData.start,
        allDay: true // 하루 종일 이벤트로 설정
      });
    },
    showEventDetailModal: function(event) {
      let detailHtml = '';
      const props = event.extendedProps;

      console.log('props.items:', props.items); // 이 부분을 추가했습니다.

      if (props.analysisType === 'schedule') {
        detailHtml += '<p><strong>날짜:</strong> ' + props.analysisDate + '</p>';
        detailHtml += '<p><strong>내용:</strong> ' + props.description + '</p>';
      } else { // expense or income
        detailHtml += '<p><strong>날짜:</strong> ' + props.analysisDate + '</p>';
        detailHtml += '<p><strong>분류:</strong> ' + props.category + '</p>';

        if (props.items && props.items.length > 0) {
          let itemNames = props.items.map(item => item.name).join(', ');
          detailHtml += '<p><strong>상품명:</strong> ' + itemNames + '</p>';
        }

        detailHtml += '<p><strong>총 금액:</strong> ' + (typeof props.totalAmount === 'number' ? props.totalAmount.toLocaleString() + '원' : 'N/A') + '</p>';
      }

      $('#eventDetailModalBody').html(detailHtml);
      $('#eventDetailModal').show(); // Show the modal
    }
  }

  // 가계부 AI 어시스턴트 로직
  let ai_center = {
    init: function() {
      this.initEvents();
    },
    initEvents: function() {
      $('#askBtn').on('click', () => {
        this.askQuestion();
      });
      // Enter 키로도 질문 가능
      $('#accountQuestion').on('keypress', (e) => {
        if (e.which === 13 && !e.shiftKey) {
          e.preventDefault();
          this.askQuestion();
        }
      });
    },
    askQuestion: function() {
      const question = $('#accountQuestion').val().trim();
      if (!question) {
        alert('질문을 입력해주세요.');
        return;
      }

      // 버튼 비활성화 및 로딩 표시
      $('#askBtn').prop('disabled', true).text('답변 생성 중...');
      $('#aiResponse').text('AI가 답변을 생성하고 있습니다...');

      $.ajax({
        url: '/springaiTest/query-account-book',
        type: 'GET',
        data: { question: question },
        success: function(response) {
          $('#aiResponse').text(response);

          // 답변에 "추가", "삭제"가 포함되어 있으면 캘린더 새로고침
          if (response.includes('추가') || response.includes('삭제')) {
            setTimeout(() => {
              calendar_center.loadEvents();
            }, 500);
          }
        },
        error: function(xhr, status, error) {
          console.error('질문 처리 실패:', error);
          $('#aiResponse').text('질문 처리 중 오류가 발생했습니다: ' + error);
        },
        complete: function() {
          $('#askBtn').prop('disabled', false).text('질문하기');
        }
      });
    }
  };

  $(()=> {
    camera_center.init(); // 웹캠 로직 실행
    calendar_center.init(); // 캘린더 로직 실행
    ai_center.init(); // AI 어시스턴트 로직 실행
  });
</script>