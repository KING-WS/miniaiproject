<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="col-sm-10">
    <div class="container" style="max-width: 900px; margin: auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
        <h1 style="color: #2c3e50; text-align: center; margin-bottom: 30px;">AI 주식 분석</h1>

        <div class="upload-section" style="border: 1px dashed #ccc; padding: 20px; text-align: center; margin-bottom: 20px; border-radius: 5px; background-color: #f9f9f9;">
            <form id="uploadForm" enctype="multipart/form-data">
                <p>분석할 차트 스크린샷 또는 뉴스 기사 캡처본을 업로드하세요.</p>
                <input type="file" id="fileInput" name="file" accept="image/*" style="display: none;">
                <label for="fileInput" style="background-color: #4CAF50; color: white; padding: 10px 15px; border-radius: 5px; cursor: pointer; margin-top: 10px; display: inline-block;">파일 선택</label>
                <p id="fileNameDisplay" style="margin-top: 10px; padding: 5px; border: 1px solid #007bff; background-color: #e0f7fa; color: #007bff; min-height: 20px;"></p>
            </form>
        </div>

        <div class="analysis-type" style="text-align: center; margin-bottom: 20px;">
            <button id="analyzeChartBtn" style="background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 0 10px; font-size: 16px;">차트 패턴 분석</button>
            <button id="analyzeNewsBtn" style="background-color: #007bff; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 0 10px; font-size: 16px;">뉴스 감성 분석</button>
        </div>

        <div class="loading" id="loadingSpinner" style="text-align: center; padding: 20px; display: none;">
            <img src="/image/loading.gif" alt="Loading..." style="width: 50px;">
            <p>분석 중...</p>
        </div>
        <div class="error" id="errorMessage" style="color: red; text-align: center; padding: 10px; display: none;"></div>

        <div class="result-section" style="margin-top: 30px; border-top: 1px solid #eee; padding-top: 20px;">
            <h2 style="color: #2c3e50; margin-bottom: 15px;">분석 결과</h2>
            <div class="result-content" id="analysisResult" style="background-color: #e9ecef; padding: 15px; border-radius: 5px; min-height: 150px; white-space: pre-wrap; word-wrap: break-word;">
                여기에 분석 결과가 표시됩니다.
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const fileInput = document.getElementById('fileInput');
        const fileNameDisplay = document.getElementById('fileNameDisplay');
        const analyzeChartBtn = document.getElementById('analyzeChartBtn');
        const analyzeNewsBtn = document.getElementById('analyzeNewsBtn');
        const analysisResult = document.getElementById('analysisResult');
        const loadingSpinner = document.getElementById('loadingSpinner');
        const errorMessage = document.getElementById('errorMessage');

        let selectedFile = null;

        // 초기 상태 설정
        fileNameDisplay.textContent = '파일이 선택되지 않았습니다.';
        fileNameDisplay.style.color = '#999';
        fileNameDisplay.style.borderColor = '#ccc';
        fileNameDisplay.style.backgroundColor = '#f9f9f9';

        fileInput.addEventListener('change', function(event) {
            selectedFile = event.target.files[0];

            if (selectedFile) {
                console.log('선택된 파일:', selectedFile.name);
                fileNameDisplay.textContent = '선택된 파일: ' + selectedFile.name;
                fileNameDisplay.style.borderColor = '#007bff';
                fileNameDisplay.style.backgroundColor = '#e0f7fa';
                fileNameDisplay.style.color = '#007bff';
                errorMessage.style.display = 'none';
            } else {
                fileNameDisplay.textContent = '파일이 선택되지 않았습니다.';
                fileNameDisplay.style.borderColor = '#ccc';
                fileNameDisplay.style.backgroundColor = '#f9f9f9';
                fileNameDisplay.style.color = '#999';
            }
        });

        analyzeChartBtn.addEventListener('click', () => {
            if (!selectedFile) {
                showError('파일을 먼저 선택해주세요.');
                return;
            }
            performAnalysis('/jusick/analyzeChart', selectedFile);
        });

        analyzeNewsBtn.addEventListener('click', () => {
            if (!selectedFile) {
                showError('파일을 먼저 선택해주세요.');
                return;
            }
            performAnalysis('/jusick/analyzeNews', selectedFile);
        });

        async function performAnalysis(url, file) {
            analysisResult.textContent = '';
            errorMessage.style.display = 'none';
            loadingSpinner.style.display = 'block';

            const formData = new FormData();
            formData.append('file', file);

            try {
                const response = await fetch(url, {
                    method: 'POST',
                    body: formData
                });

                if (!response.ok) {
                    const errorText = await response.text();
                    throw new Error(`서버 오류: ${response.status} - ${errorText}`);
                }

                const result = await response.text();
                analysisResult.innerHTML = result;
            } catch (error) {
                console.error('분석 중 오류 발생:', error);
                showError(`분석 실패: ${error.message}`);
            } finally {
                loadingSpinner.style.display = 'none';
            }
        }

        function showError(message) {
            errorMessage.textContent = message;
            errorMessage.style.display = 'block';
        }
    });
</script>
