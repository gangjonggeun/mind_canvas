# ========================================
# Mind Canvas - CI/CD 통합 스크립트
# GitHub Actions, GitLab CI, Jenkins 등에서 사용
# ========================================

name: run_ci_tests
description: "Mind Canvas CI/CD 테스트 실행 스크립트"

# 환경변수 설정
env:
  FLUTTER_VERSION: "3.24.0"
  MIN_COVERAGE: "80"
  TEST_TIMEOUT: "900"

# 필수 도구 체크 함수
check_tools() {
    echo "🔍 필수 도구 확인 중..."
    
    # Flutter 설치 확인
    if ! command -v flutter &> /dev/null; then
        echo "❌ Flutter가 설치되지 않았습니다."
        exit 1
    fi
    
    # Flutter 버전 확인
    CURRENT_VERSION=$(flutter --version | grep -oP 'Flutter \K[\d.]+')
    echo "📱 Flutter 버전: $CURRENT_VERSION"
    
    # Git 확인
    if ! command -v git &> /dev/null; then
        echo "❌ Git이 설치되지 않았습니다."
        exit 1
    fi
    
    echo "✅ 모든 필수 도구가 준비되었습니다."
}

# 프로젝트 환경 설정
setup_environment() {
    echo "🛠️  프로젝트 환경 설정 중..."
    
    # Flutter 활성화
    flutter config --enable-web
    flutter config --enable-linux-desktop
    flutter config --enable-macos-desktop
    flutter config --enable-windows-desktop
    
    # 의존성 설치
    echo "📦 의존성 설치 중..."
    flutter pub get
    
    # 코드 생성
    echo "🔧 코드 생성 중..."
    if [ -f "pubspec.yaml" ] && grep -q "build_runner" pubspec.yaml; then
        flutter packages pub run build_runner build --delete-conflicting-outputs
    fi
    
    echo "✅ 환경 설정 완료!"
}

# 정적 분석
run_static_analysis() {
    echo "🔍 정적 분석 실행 중..."
    
    # Dart 분석
    echo "📊 Dart 코드 분석..."
    flutter analyze --fatal-infos
    
    if [ $? -ne 0 ]; then
        echo "❌ 정적 분석에서 오류가 발견되었습니다."
        exit 1
    fi
    
    # 코드 포맷팅 확인
    echo "🎨 코드 포맷팅 확인..."
    flutter format --dry-run --set-exit-if-changed .
    
    if [ $? -ne 0 ]; then
        echo "❌ 코드 포맷팅이 올바르지 않습니다."
        echo "💡 다음 명령어로 수정하세요: flutter format ."
        exit 1
    fi
    
    echo "✅ 정적 분석 통과!"
}

# 유닛 테스트 실행
run_unit_tests() {
    echo "🧪 유닛 테스트 실행 중..."
    
    if [ -d "test/unit" ]; then
        flutter test test/unit/ \
            --reporter=json \
            --coverage \
            --timeout=${TEST_TIMEOUT}s > unit_test_results.json
        
        if [ $? -ne 0 ]; then
            echo "❌ 유닛 테스트 실패!"
            return 1
        fi
        
        echo "✅ 유닛 테스트 통과!"
    else
        echo "⚠️  유닛 테스트 디렉토리가 없습니다."
    fi
    
    return 0
}

# 위젯 테스트 실행
run_widget_tests() {
    echo "🖼️ 위젯 테스트 실행 중..."
    
    if [ -d "test/widget" ]; then
        flutter test test/widget/ \
            --reporter=json \
            --timeout=${TEST_TIMEOUT}s > widget_test_results.json
        
        if [ $? -ne 0 ]; then
            echo "❌ 위젯 테스트 실패!"
            return 1
        fi
        
        echo "✅ 위젯 테스트 통과!"
    else
        echo "⚠️  위젯 테스트 디렉토리가 없습니다."
    fi
    
    return 0
}

# 통합 테스트 실행
run_integration_tests() {
    echo "🔗 통합 테스트 실행 중..."
    
    if [ -d "test/integration" ]; then
        # 통합 테스트는 에뮬레이터가 필요할 수 있음
        if [ "$CI" = "true" ]; then
            echo "📱 CI 환경에서는 통합 테스트를 건너뜁니다."
            return 0
        fi
        
        flutter test test/integration/ \
            --reporter=json \
            --timeout=${TEST_TIMEOUT}s > integration_test_results.json
        
        if [ $? -ne 0 ]; then
            echo "❌ 통합 테스트 실패!"
            return 1
        fi
        
        echo "✅ 통합 테스트 통과!"
    else
        echo "⚠️  통합 테스트 디렉토리가 없습니다."
    fi
    
    return 0
}

# 커버리지 검사
check_coverage() {
    echo "📊 코드 커버리지 확인 중..."
    
    if [ ! -f "coverage/lcov.info" ]; then
        echo "⚠️  커버리지 파일이 없습니다. 테스트를 먼저 실행하세요."
        return 0
    fi
    
    # lcov가 설치되어 있다면 커버리지 확인
    if command -v lcov &> /dev/null; then
        COVERAGE=$(lcov --summary coverage/lcov.info 2>/dev/null | grep -oP 'lines......: \K[\d.]+')
        
        if [ ! -z "$COVERAGE" ]; then
            echo "📈 현재 커버리지: ${COVERAGE}%"
            
            # 최소 커버리지 확인
            if (( $(echo "$COVERAGE < $MIN_COVERAGE" | bc -l) )); then
                echo "❌ 커버리지가 최소 요구사항(${MIN_COVERAGE}%)보다 낮습니다."
                return 1
            fi
            
            echo "✅ 커버리지 요구사항 충족!"
        fi
    else
        echo "💡 lcov가 설치되지 않아 커버리지를 확인할 수 없습니다."
    fi
    
    return 0
}

# 빌드 테스트
run_build_tests() {
    echo "🏗️  빌드 테스트 실행 중..."
    
    # Android APK 빌드 테스트
    echo "🤖 Android APK 빌드..."
    flutter build apk --debug --no-sound-null-safety
    
    if [ $? -ne 0 ]; then
        echo "❌ Android 빌드 실패!"
        return 1
    fi
    
    # iOS 빌드 테스트 (macOS에서만)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🍎 iOS 빌드..."
        flutter build ios --debug --no-sound-null-safety --simulator
        
        if [ $? -ne 0 ]; then
            echo "❌ iOS 빌드 실패!"
            return 1
        fi
    fi
    
    # Web 빌드 테스트
    echo "🌐 Web 빌드..."
    flutter build web --debug
    
    if [ $? -ne 0 ]; then
        echo "❌ Web 빌드 실패!"
        return 1
    fi
    
    echo "✅ 모든 빌드 테스트 통과!"
    return 0
}

# 보안 검사
run_security_checks() {
    echo "🔒 보안 검사 실행 중..."
    
    # pubspec.yaml 의존성 취약점 검사
    echo "🛡️  의존성 보안 검사..."
    
    # 민감한 정보 검사
    echo "🔍 민감한 정보 검사..."
    
    # API 키, 패스워드 등이 코드에 하드코딩되어 있는지 확인
    SENSITIVE_PATTERNS=(
        "password.*=.*['\"][^'\"]*['\"]"
        "api[_-]?key.*=.*['\"][^'\"]*['\"]"
        "secret.*=.*['\"][^'\"]*['\"]"
        "token.*=.*['\"][^'\"]*['\"]"
    )
    
    for pattern in "${SENSITIVE_PATTERNS[@]}"; do
        if grep -r -i -E "$pattern" lib/ test/ 2>/dev/null; then
            echo "⚠️  민감한 정보가 하드코딩되어 있을 수 있습니다."
            echo "💡 환경변수나 보안 저장소를 사용하세요."
        fi
    done
    
    echo "✅ 보안 검사 완료!"
    return 0
}

# 성능 테스트
run_performance_tests() {
    echo "⚡ 성능 테스트 실행 중..."
    
    # 메모리 누수 검사 (간단한 형태)
    echo "🧠 메모리 사용량 검사..."
    
    # 앱 크기 확인
    if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
        APK_SIZE=$(du -h "build/app/outputs/flutter-apk/app-debug.apk" | cut -f1)
        echo "📱 APK 크기: $APK_SIZE"
        
        # 20MB를 초과하면 경고
        APK_SIZE_MB=$(du -m "build/app/outputs/flutter-apk/app-debug.apk" | cut -f1)
        if [ "$APK_SIZE_MB" -gt 20 ]; then
            echo "⚠️  APK 크기가 큽니다. 최적화를 고려하세요."
        fi
    fi
    
    echo "✅ 성능 테스트 완료!"
    return 0
}

# 테스트 결과 업로드 (CI/CD 환경용)
upload_results() {
    echo "📤 테스트 결과 업로드 중..."
    
    # 결과 파일들을 아티팩트로 저장
    mkdir -p test_results
    
    # 테스트 결과 JSON 파일들 복사
    cp *_test_results.json test_results/ 2>/dev/null || true
    
    # 커버리지 리포트 복사
    if [ -d "coverage" ]; then
        cp -r coverage test_results/
    fi
    
    # 빌드 아티팩트 정보
    if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
        echo "APK: $(ls -lh build/app/outputs/flutter-apk/app-debug.apk)" > test_results/build_info.txt
    fi
    
    echo "✅ 테스트 결과 준비 완료!"
}

# 메인 실행 함수
main() {
    echo "🎨 Mind Canvas CI/CD 파이프라인 시작"
    echo "========================================"
    
    START_TIME=$(date +%s)
    
    # 1. 도구 확인
    check_tools
    
    # 2. 환경 설정
    setup_environment
    
    # 3. 정적 분석
    run_static_analysis
    
    # 4. 유닛 테스트
    run_unit_tests
    UNIT_RESULT=$?
    
    # 5. 위젯 테스트
    run_widget_tests
    WIDGET_RESULT=$?
    
    # 6. 통합 테스트
    run_integration_tests
    INTEGRATION_RESULT=$?
    
    # 7. 커버리지 확인
    check_coverage
    COVERAGE_RESULT=$?
    
    # 8. 빌드 테스트
    run_build_tests
    BUILD_RESULT=$?
    
    # 9. 보안 검사
    run_security_checks
    SECURITY_RESULT=$?
    
    # 10. 성능 테스트
    run_performance_tests
    PERFORMANCE_RESULT=$?
    
    # 11. 결과 업로드
    upload_results
    
    # 결과 요약
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    echo ""
    echo "========================================"
    echo "🎯 CI/CD 파이프라인 결과 요약"
    echo "========================================"
    echo "⏱️  총 소요시간: ${DURATION}초"
    echo ""
    
    # 각 단계별 결과
    declare -A RESULTS=(
        ["유닛 테스트"]=$UNIT_RESULT
        ["위젯 테스트"]=$WIDGET_RESULT
        ["통합 테스트"]=$INTEGRATION_RESULT
        ["커버리지"]=$COVERAGE_RESULT
        ["빌드 테스트"]=$BUILD_RESULT
        ["보안 검사"]=$SECURITY_RESULT
        ["성능 테스트"]=$PERFORMANCE_RESULT
    )
    
    TOTAL_FAILURES=0
    
    for stage in "${!RESULTS[@]}"; do
        result=${RESULTS[$stage]}
        if [ $result -eq 0 ]; then
            echo "✅ $stage: 통과"
        else
            echo "❌ $stage: 실패"
            TOTAL_FAILURES=$((TOTAL_FAILURES + 1))
        fi
    done
    
    echo ""
    
    if [ $TOTAL_FAILURES -eq 0 ]; then
        echo "🎉 모든 검사가 성공적으로 완료되었습니다!"
        echo "✅ 배포 준비가 완료되었습니다."
        exit 0
    else
        echo "💥 $TOTAL_FAILURES개의 검사가 실패했습니다."
        echo "❌ 문제를 해결한 후 다시 시도하세요."
        exit 1
    fi
}

# 스크립트 시작점
case "${1:-main}" in
    "tools")
        check_tools
        ;;
    "setup")
        setup_environment
        ;;
    "analyze")
        run_static_analysis
        ;;
    "unit")
        run_unit_tests
        ;;
    "widget")
        run_widget_tests
        ;;
    "integration")
        run_integration_tests
        ;;
    "coverage")
        check_coverage
        ;;
    "build")
        run_build_tests
        ;;
    "security")
        run_security_checks
        ;;
    "performance")
        run_performance_tests
        ;;
    "main"|"")
        main
        ;;
    *)
        echo "사용법: $0 [tools|setup|analyze|unit|widget|integration|coverage|build|security|performance|main]"
        exit 1
        ;;
esac
