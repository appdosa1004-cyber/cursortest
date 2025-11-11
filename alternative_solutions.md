# n8n 자동화 및 문서화 대체 솔루션

## 방법 비교

| 방법 | 난이도 | 자동화 수준 | 장점 | 단점 |
|------|--------|------------|------|------|
| Playwright + Python | 중간 | 높음 | 완전 자동화, 정확한 UI 캡처 | 초기 설정 필요 |
| n8n API + 스크립트 | 쉬움 | 중간 | 워크플로우 자동 생성 빠름 | UI 스크린샷은 별도 작업 |
| Puppeteer + Node.js | 중간 | 높음 | n8n과 같은 환경(Node.js) | Python보다 문서 생성 복잡 |
| 수동 + Cursor AI | 쉬움 | 낮음 | 가장 간단 | 반복 작업 수동 |

---

## 1. n8n API 활용 방법

n8n의 REST API를 사용하여 워크플로우를 프로그래밍 방식으로 생성합니다.

### 장점
- 워크플로우 생성 속도 빠름
- JSON 기반으로 정확한 구성 가능
- 스크립트로 재사용 가능

### 구현 예시

```python
import requests
import json

class N8nAPIClient:
    def __init__(self, base_url, api_key):
        self.base_url = base_url
        self.headers = {
            'X-N8N-API-KEY': api_key,
            'Content-Type': 'application/json'
        }

    def create_workflow(self, workflow_data):
        """워크플로우 생성"""
        response = requests.post(
            f"{self.base_url}/api/v1/workflows",
            headers=self.headers,
            json=workflow_data
        )
        return response.json()

    def get_workflow(self, workflow_id):
        """워크플로우 조회"""
        response = requests.get(
            f"{self.base_url}/api/v1/workflows/{workflow_id}",
            headers=self.headers
        )
        return response.json()

# 사용 예시
client = N8nAPIClient("http://localhost:5678", "your_api_key")

workflow = {
    "name": "이메일 to Slack",
    "nodes": [
        {
            "parameters": {},
            "name": "Webhook",
            "type": "n8n-nodes-base.webhook",
            "typeVersion": 1,
            "position": [250, 300]
        },
        {
            "parameters": {
                "channel": "#general",
                "text": "={{$json[\"subject\"]}}"
            },
            "name": "Slack",
            "type": "n8n-nodes-base.slack",
            "typeVersion": 1,
            "position": [450, 300]
        }
    ],
    "connections": {
        "Webhook": {
            "main": [[{"node": "Slack", "type": "main", "index": 0}]]
        }
    }
}

result = client.create_workflow(workflow)
print(f"워크플로우 생성됨: {result['id']}")
```

---

## 2. Puppeteer + Node.js 방법

JavaScript/TypeScript 환경에서 Puppeteer를 사용합니다.

### 장점
- n8n과 같은 Node.js 환경
- Playwright보다 가벼움
- npm 패키지 생태계 활용

### 구현 예시

```javascript
const puppeteer = require('puppeteer');
const fs = require('fs');
const { Document, Packer, Paragraph, ImageRun } = require('docx');

class N8nAutomation {
    constructor(n8nUrl) {
        this.n8nUrl = n8nUrl;
        this.screenshots = [];
    }

    async run(instructionFile) {
        const browser = await puppeteer.launch({ headless: false });
        const page = await browser.newPage();

        await page.setViewport({ width: 1920, height: 1080 });

        try {
            // n8n 접속
            await page.goto(this.n8nUrl);
            await page.waitForNetworkIdle();

            // 지시사항 파일 읽기
            const instructions = JSON.parse(fs.readFileSync(instructionFile, 'utf8'));

            // 각 단계 실행
            for (const step of instructions.steps) {
                await this.executeStep(page, step);

                // 스크린샷
                const screenshotPath = `screenshots/step_${step.number}.png`;
                await page.screenshot({ path: screenshotPath, fullPage: true });

                this.screenshots.push({
                    step: step.number,
                    description: step.description,
                    path: screenshotPath
                });
            }

            // 워드 문서 생성
            await this.createWordDoc();

        } finally {
            await browser.close();
        }
    }

    async executeStep(page, step) {
        switch(step.action) {
            case 'add_node':
                await this.addNode(page, step.nodeType);
                break;
            case 'configure':
                await this.configureNode(page, step.config);
                break;
            // ... 기타 액션
        }
    }

    async addNode(page, nodeType) {
        // 캔버스 더블클릭
        await page.evaluate(() => {
            const canvas = document.querySelector('.canvas');
            canvas.dispatchEvent(new MouseEvent('dblclick', { bubbles: true }));
        });

        // 노드 검색 및 선택
        await page.type('input[type="search"]', nodeType);
        await page.click(`.node-item:has-text("${nodeType}")`);
    }

    async createWordDoc() {
        const doc = new Document({
            sections: [{
                children: [
                    new Paragraph({
                        text: "n8n 워크플로우 가이드",
                        heading: "Heading1"
                    }),
                    // 스크린샷 추가
                    ...this.screenshots.map(s => {
                        const imageBuffer = fs.readFileSync(s.path);
                        return new Paragraph({
                            children: [
                                new ImageRun({
                                    data: imageBuffer,
                                    transformation: { width: 600, height: 400 }
                                })
                            ]
                        });
                    })
                ]
            }]
        });

        const buffer = await Packer.toBuffer(doc);
        fs.writeFileSync('n8n_guide.docx', buffer);
        console.log('워드 문서 생성 완료');
    }
}

// 실행
const automation = new N8nAutomation('http://localhost:5678');
automation.run('instructions.json');
```

---

## 3. Cursor AI + Playwright 조합

Cursor AI에서 Playwright 스크립트를 생성하고 실행합니다.

### 작업 흐름
1. Cursor AI에서 n8n 사용법 문서 열기
2. AI에게 "이 문서를 기반으로 Playwright 자동화 스크립트 생성해줘" 요청
3. 생성된 스크립트 실행
4. 스크린샷 캡처
5. AI에게 "이 스크린샷들로 워드 문서 만들어줘" 요청

### Cursor AI 프롬프트 예시
```
나는 n8n 워크플로우를 자동으로 생성하고 문서화하고 싶어.

첨부한 instructions.txt 파일을 읽고:
1. Playwright Python 스크립트를 생성해서 n8n UI를 자동화
2. 각 단계마다 스크린샷 캡처
3. 캡처한 이미지들로 python-docx를 사용해 워드 문서 생성

스크립트를 만들어줘.
```

---

## 4. n8n 워크플로우로 자동화 (메타 자동화)

n8n 자체에서 워크플로우를 만들어 자동화합니다.

### 워크플로우 구성
```
[Webhook Trigger]
    → [Read File (지시사항)]
    → [Execute Command (Playwright 스크립트 실행)]
    → [Wait]
    → [Read Files (스크린샷)]
    → [Python Code (워드 문서 생성)]
    → [Send Email/Slack (완료 알림)]
```

### 장점
- n8n을 사용해 n8n 자동화
- 스케줄링 가능
- 에러 핸들링 쉬움

### 단점
- n8n 내에서 브라우저 자동화는 제한적
- 외부 Playwright 스크립트 필요

---

## 5. AI 완전 자동화 (Claude/GPT 활용)

### 최신 방법: AI가 모든 것을 처리

```python
import anthropic
import subprocess

def ai_automated_n8n_doc(instruction_file):
    """
    AI가 지시사항을 읽고 스크립트 생성, 실행, 문서화까지 모두 처리
    """
    client = anthropic.Anthropic(api_key="your_key")

    # 1. 지시사항 읽기
    with open(instruction_file, 'r') as f:
        instructions = f.read()

    # 2. AI에게 Playwright 스크립트 생성 요청
    message = client.messages.create(
        model="claude-3-5-sonnet-20241022",
        max_tokens=4000,
        messages=[{
            "role": "user",
            "content": f"""
다음 n8n 지시사항을 읽고, Playwright Python 스크립트를 생성해주세요.
스크립트는:
1. n8n에 접속
2. 지시사항에 따라 워크플로우 생성
3. 각 단계마다 스크린샷 캡처
4. python-docx로 워드 문서 생성

완전한 실행 가능한 Python 코드만 반환하세요.

지시사항:
{instructions}
"""
        }]
    )

    # 3. 생성된 스크립트 저장
    script_code = message.content[0].text
    with open('generated_automation.py', 'w') as f:
        f.write(script_code)

    # 4. 스크립트 실행
    subprocess.run(['python', 'generated_automation.py'])

    print("✅ AI가 자동화 완료!")

# 실행
ai_automated_n8n_doc('n8n_instructions.txt')
```

---

## 추천 방법 선택 가이드

### 상황별 추천

1. **Python 환경 선호, 완전 자동화 원함**
   → **Playwright + Python** (제공한 메인 스크립트)

2. **빠르게 워크플로우만 생성하면 됨**
   → **n8n API**

3. **Node.js 환경, JavaScript 선호**
   → **Puppeteer + Node.js**

4. **코딩 최소화, AI에게 맡기기**
   → **Cursor AI + Claude API**

5. **정기적으로 반복 실행 필요**
   → **n8n 워크플로우로 메타 자동화**

---

## 실행 순서 (Playwright + Python 기준)

```bash
# 1. 패키지 설치
pip install -r requirements.txt
playwright install chromium

# 2. 환경 변수 설정
export ANTHROPIC_API_KEY="your_claude_api_key"

# 3. n8n 사용법 문서 작성
# n8n_instructions.txt 파일 생성

# 4. 스크립트 실행
python n8n_automation.py

# 5. 결과 확인
# - screenshots/ 폴더: 캡처된 이미지들
# - n8n_workflow_guide.docx: 생성된 워드 문서
```

---

## 참고 자료

- [n8n API 문서](https://docs.n8n.io/api/)
- [Playwright Python 문서](https://playwright.dev/python/)
- [python-docx 문서](https://python-docx.readthedocs.io/)
- [Anthropic Claude API](https://docs.anthropic.com/)
