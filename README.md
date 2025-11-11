# n8n 자동화 및 문서화 도구

n8n 워크플로우를 자동으로 생성하고 스크린샷을 캡처하여 워드 문서로 만드는 자동화 도구입니다.

## 🎯 기능

- 📄 텍스트 문서에서 n8n 워크플로우 지시사항 파싱 (AI 활용)
- 🤖 Playwright를 사용한 n8n UI 자동화
- 📸 각 단계별 스크린샷 자동 캡처
- 📝 캡처한 이미지로 워드 문서 자동 생성
- 🧠 Claude AI를 활용한 지능형 문서 파싱

## 🚀 빠른 시작

### 1. 의존성 설치

```bash
# Python 패키지 설치
pip install -r requirements.txt

# Playwright 브라우저 설치
playwright install chromium
```

### 2. 환경 설정

```bash
# Claude API 키 설정 (옵션, AI 문서 파싱용)
export ANTHROPIC_API_KEY="your_api_key_here"
```

### 3. n8n 사용법 문서 작성

`n8n_instructions.txt` 파일을 생성하거나 `n8n_instructions_sample.txt`를 참고하세요.

### 4. 실행

```python
python n8n_automation.py
```

## 📂 파일 구조

```
cursortest/
├── n8n_automation.py           # 메인 자동화 스크립트
├── requirements.txt             # Python 의존성
├── n8n_instructions_sample.txt # 샘플 지시사항 문서
├── alternative_solutions.md    # 대체 솔루션 가이드
├── setup.sh                    # 자동 설치 스크립트
└── screenshots/                # 캡처된 스크린샷 (자동 생성)
```

## 💡 사용 방법

### 기본 사용법

```python
import asyncio
from n8n_automation import N8nAutomation

async def main():
    automation = N8nAutomation(
        n8n_url="http://localhost:5678",
        api_key="your_claude_api_key"  # 옵션
    )

    await automation.run(
        instruction_doc="n8n_instructions.txt",
        username="your@email.com",  # n8n 로그인 (옵션)
        password="your_password"
    )

asyncio.run(main())
```

### 지시사항 문서 형식

```text
# 워크플로우 제목

## 목표
워크플로우 설명

## 단계별 작업

### 1단계: 노드 추가
- 노드 타입: Webhook
- 설정: ...

### 2단계: 설정 변경
- ...
```

자세한 예시는 `n8n_instructions_sample.txt`를 참고하세요.

## 🔧 설정 옵션

### n8n_automation.py 설정

```python
# n8n URL (로컬 또는 클라우드)
N8N_URL = "http://localhost:5678"
# 또는
N8N_URL = "https://your-n8n-instance.app.n8n.cloud"

# 지시사항 문서 경로
INSTRUCTION_DOC = "n8n_instructions.txt"

# Claude API 키 (AI 문서 파싱용, 옵션)
CLAUDE_API_KEY = "sk-ant-..."
```

### Playwright 옵션

```python
# 브라우저 표시 여부
headless=False  # 브라우저 보이기
headless=True   # 백그라운드 실행

# 화면 크기
viewport={'width': 1920, 'height': 1080}
```

## 📋 지원하는 기능

### AI 문서 파싱
- Claude API를 사용하여 자연어 지시사항을 구조화된 단계로 변환
- JSON 형식으로 단계별 작업 추출
- 노드 타입 및 설정 자동 인식

### 브라우저 자동화
- n8n 로그인 자동 처리
- 노드 추가 및 설정
- 노드 간 연결
- 워크플로우 실행

### 문서 생성
- 각 단계별 스크린샷 캡처
- 워드 문서 자동 생성
- 이미지 삽입 및 설명 추가

## 🔄 대체 솔루션

Playwright + Python 외에도 여러 방법이 있습니다:

1. **n8n API 활용** - REST API로 워크플로우 생성
2. **Puppeteer + Node.js** - JavaScript 환경에서 자동화
3. **Cursor AI + Playwright** - AI가 스크립트 자동 생성
4. **n8n 메타 자동화** - n8n으로 n8n 자동화

자세한 내용은 `alternative_solutions.md`를 참고하세요.

## 🐛 문제 해결

### Playwright 설치 오류
```bash
playwright install --force chromium
```

### n8n 로그인 실패
- `username`과 `password` 확인
- n8n이 로그인 없이 사용 가능한지 확인

### 노드 추가 실패
- n8n UI 구조가 버전마다 다를 수 있음
- `add_node()` 함수의 셀렉터 수정 필요

### 스크린샷 경로 오류
```python
Path("screenshots").mkdir(exist_ok=True)
```

## 📚 참고 자료

- [n8n 공식 문서](https://docs.n8n.io/)
- [n8n API 문서](https://docs.n8n.io/api/)
- [Playwright Python](https://playwright.dev/python/)
- [python-docx](https://python-docx.readthedocs.io/)
- [Anthropic Claude API](https://docs.anthropic.com/)

## 🤝 기여

이슈나 개선 사항은 GitHub Issues에 등록해주세요.

## 📄 라이선스

MIT License

## ⚠️  주의사항

- n8n 인스턴스에 접근 권한이 있어야 합니다
- Claude API 키는 AI 문서 파싱 시에만 필요합니다 (옵션)
- 자동화 실행 중 수동으로 브라우저를 조작하지 마세요
- n8n UI 구조는 버전에 따라 다를 수 있어 스크립트 조정이 필요할 수 있습니다

## 🎓 사용 예시

### 예시 1: 간단한 워크플로우

```text
# Slack 알림 워크플로우

### 1단계: Manual Trigger 추가
- 노드 타입: Manual

### 2단계: Slack 메시지 전송
- 노드 타입: Slack
- 설정:
  - Channel: #general
  - Message: 테스트 메시지
```

실행 후 `n8n_workflow_guide.docx` 파일에 스크린샷과 함께 문서화됩니다.

### 예시 2: 복잡한 데이터 처리 워크플로우

샘플 파일 참고: `n8n_instructions_sample.txt`

---

**Made with ❤️ using Playwright, Claude AI, and python-docx**
