# 빠른 시작 가이드 (5분 안에 시작하기)

## 1️⃣ 자동 설치 (Linux/Mac)

```bash
./setup.sh
```

## 2️⃣ 수동 설치 (모든 OS)

```bash
# Python 패키지 설치
pip install playwright python-docx Pillow anthropic requests

# Playwright 브라우저 설치
playwright install chromium

# 스크린샷 폴더 생성
mkdir screenshots
```

## 3️⃣ n8n 준비

### 로컬 n8n 실행 (Docker)
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  n8nio/n8n
```

또는 클라우드 n8n 사용: https://n8n.io/

## 4️⃣ 사용법 문서 작성

`n8n_instructions.txt` 파일 생성:

```text
# 첫 번째 워크플로우

### 1단계: Manual Trigger 추가
- 노드 타입: Manual

### 2단계: Set 노드 추가
- 노드 타입: Set
- 설정:
  - name: myData
  - value: Hello World
```

## 5️⃣ 스크립트 수정

`n8n_automation.py` 파일의 main() 함수 수정:

```python
async def main():
    N8N_URL = "http://localhost:5678"  # 또는 클라우드 URL
    INSTRUCTION_DOC = "n8n_instructions.txt"
    CLAUDE_API_KEY = None  # AI 파싱 사용 안 함 (또는 API 키 입력)

    automation = N8nAutomation(
        n8n_url=N8N_URL,
        api_key=CLAUDE_API_KEY
    )

    await automation.run(
        instruction_doc=INSTRUCTION_DOC,
        # username=None,  # n8n 로그인 필요시 입력
        # password=None
    )
```

## 6️⃣ 실행

```bash
python n8n_automation.py
```

## 7️⃣ 결과 확인

- `screenshots/` 폴더: 캡처된 스크린샷들
- `n8n_workflow_guide.docx`: 생성된 워드 문서

---

## 🎯 옵션: AI 문서 파싱 활성화

더 정교한 자동화를 원한다면 Claude API 사용:

1. **Claude API 키 받기**: https://console.anthropic.com/
2. **환경 변수 설정**:
   ```bash
   export ANTHROPIC_API_KEY="sk-ant-api03-..."
   ```
3. **스크립트 수정**:
   ```python
   CLAUDE_API_KEY = os.getenv("ANTHROPIC_API_KEY")
   ```

이제 자연어로 작성된 지시사항도 자동 파싱됩니다!

---

## 🚨 문제 해결

### "playwright not found"
```bash
pip install playwright
playwright install chromium
```

### "Can't connect to n8n"
- n8n이 실행 중인지 확인: http://localhost:5678
- 방화벽 설정 확인

### "No screenshots captured"
- `screenshots/` 폴더 권한 확인
- 브라우저가 실행되는지 확인 (headless=False로 설정)

### "Word document creation failed"
```bash
pip install python-docx Pillow
```

---

## 📞 도움말

- 전체 문서: `README.md`
- 대체 방법: `alternative_solutions.md`
- 샘플 지시사항: `n8n_instructions_sample.txt`

---

**첫 실행 권장**: `headless=False`로 설정해서 브라우저 동작을 직접 확인하세요!

```python
browser = await p.chromium.launch(headless=False)  # 브라우저 표시
```
