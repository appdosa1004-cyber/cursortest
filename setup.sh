#!/bin/bash

# n8n 자동화 도구 설치 스크립트

echo "🚀 n8n 자동화 도구 설치 시작..."

# Python 버전 확인
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3가 설치되어 있지 않습니다."
    echo "Python 3.8 이상을 설치해주세요: https://www.python.org/"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
echo "✅ Python $PYTHON_VERSION 감지됨"

# pip 업그레이드
echo "📦 pip 업그레이드 중..."
python3 -m pip install --upgrade pip

# 의존성 설치
echo "📦 Python 패키지 설치 중..."
pip install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ 패키지 설치 실패"
    exit 1
fi

# Playwright 브라우저 설치
echo "🌐 Playwright 브라우저 설치 중..."
playwright install chromium

if [ $? -ne 0 ]; then
    echo "⚠️  Playwright 설치 실패. 수동으로 설치하세요:"
    echo "   playwright install chromium"
fi

# 스크린샷 디렉토리 생성
echo "📁 스크린샷 디렉토리 생성 중..."
mkdir -p screenshots

# 샘플 설정 파일 복사 (존재하지 않는 경우)
if [ ! -f "n8n_instructions.txt" ]; then
    echo "📄 샘플 지시사항 파일 복사 중..."
    cp n8n_instructions_sample.txt n8n_instructions.txt
fi

echo ""
echo "✅ 설치 완료!"
echo ""
echo "🎯 다음 단계:"
echo "1. n8n 인스턴스가 실행 중인지 확인"
echo "   - 로컬: http://localhost:5678"
echo "   - 클라우드: https://your-instance.app.n8n.cloud"
echo ""
echo "2. (옵션) Claude API 키 설정"
echo "   export ANTHROPIC_API_KEY='your_api_key'"
echo ""
echo "3. n8n_instructions.txt 파일 편집"
echo "   - 원하는 워크플로우 지시사항 작성"
echo ""
echo "4. 자동화 실행"
echo "   python3 n8n_automation.py"
echo ""
echo "📚 자세한 사용법은 README.md를 참고하세요."
