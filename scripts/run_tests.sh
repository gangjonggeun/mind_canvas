#!/bin/bash
# ========================================
# Mind Canvas - 테스트 실행 스크립트 (Linux/macOS)
# ========================================

set -e  # 에러 시 스크립트 종료

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 로그 함수
log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 타임스탬프 생성
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

echo
echo -e "${PURPLE}[Mind Canvas] 테스트 실행 시작...${NC}"
echo

echo "========================================"
echo "[$timestamp] 테스트 실행 시작"
echo "========================================"

# 도움말 함수
show_help() {
    echo
    echo "사용법: ./run_tests.sh [옵션]"
    echo
    echo "옵션:"
    echo "  unit         - 유닛 테스트만 실행"
    echo "  widget       - 위젯 테스트만 실행"
    echo "  integration  - 통합 테스트만 실행"
    echo "  all          - 모든 테스트 실행"
    echo "  coverage     - 코드 커버리지 포함 테스트"
    echo "  clean        - 테스트 캐시 정리 후 실행"
    echo "  help         - 도움말 표시"
    echo
    echo "예시:"
    echo "  ./run_tests.sh unit"
    echo "  ./run_tests.sh coverage"
    echo
}

# 클린 함수
clean_test() {
    log_info "테스트 캐시 정리 중..."
    flutter clean > /dev/null 2>&1
    log_info "패키지 재설치 중..."
    flutter pub get > /dev/null 2>&1
    log_success "정리 완료!"
}

# 유닛 테스트 함수
run_unit_tests() {
    log_info "🧪 유닛 테스트 실행 중..."
    echo
    if flutter test test/unit/ --reporter=expanded; then
        log_success "✅ 유닛 테스트 완료!"
    else
        log_error "❌ 유닛 테스트 실패!"
        exit 1
    fi
}

# 위젯 테스트 함수
run_widget_tests() {
    log_info "🖼️ 위젯 테스트 실행 중..."
    echo
    if flutter test test/widget/ --reporter=expanded; then
        log_success "✅ 위젯 테스트 완료!"
    else
        log_error "❌ 위젯 테스트 실패!"
        exit 1
    fi
}

# 통합 테스트 함수
run_integration_tests() {
    log_info "🔗 통합 테스트 실행 중..."
    echo
    if flutter test test/integration/ --reporter=expanded; then
        log_success "✅ 통합 테스트 완료!"
    else
        log_error "❌ 통합 테스트 실패!"
        exit 1
    fi
}

# 커버리지 테스트 함수
run_coverage_tests() {
    log_info "📊 코드 커버리지 테스트 실행 중..."
    echo
    if flutter test --coverage --reporter=expanded; then
        echo
        log_info "📈 커버리지 리포트 생성 중..."
        
        if [ -f "coverage/lcov.info" ]; then
            log_success "💡 커버리지 파일 생성됨: coverage/lcov.info"
            log_info "💡 HTML 리포트 생성하려면 다음 명령어 실행:"
            echo "    genhtml coverage/lcov.info -o coverage/html"
        fi
        
        log_success "✅ 코드 커버리지 테스트 완료!"
    else
        log_error "❌ 커버리지 테스트 실패!"
        exit 1
    fi
}

# 전체 테스트 함수
run_all_tests() {
    log_info "🚀 모든 테스트 실행 중..."
    echo
    
    # 1. 유닛 테스트
    log_info "[1/3] 🧪 유닛 테스트..."
    if flutter test test/unit/ --reporter=compact; then
        log_success "✅ 유닛 테스트 완료!"
    else
        log_error "❌ 유닛 테스트 실패!"
        exit 1
    fi
    echo
    
    # 2. 위젯 테스트
    log_info "[2/3] 🖼️ 위젯 테스트..."
    if flutter test test/widget/ --reporter=compact; then
        log_success "✅ 위젯 테스트 완료!"
    else
        log_error "❌ 위젯 테스트 실패!"
        exit 1
    fi
    echo
    
    # 3. 통합 테스트
    log_info "[3/3] 🔗 통합 테스트..."
    if flutter test test/integration/ --reporter=compact; then
        log_success "✅ 통합 테스트 완료!"
    else
        log_error "❌ 통합 테스트 실패!"
        exit 1
    fi
    echo
    
    echo "========================================"
    echo -e "${GREEN}🎉 모든 테스트 성공!${NC}"
    echo "========================================"
}

# 메인 로직
case "$1" in
    "unit")
        run_unit_tests
        ;;
    "widget")
        run_widget_tests
        ;;
    "integration")
        run_integration_tests
        ;;
    "all")
        run_all_tests
        ;;
    "coverage")
        run_coverage_tests
        ;;
    "clean")
        clean_test
        run_all_tests
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    "")
        show_help
        ;;
    *)
        log_error "알 수 없는 옵션: $1"
        show_help
        exit 1
        ;;
esac

echo
echo "테스트 실행 종료: $(date '+%Y-%m-%d %H:%M:%S')"
echo
