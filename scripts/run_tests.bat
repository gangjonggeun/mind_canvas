@echo off
REM ========================================
REM Mind Canvas - 테스트 실행 스크립트 (Windows)
REM ========================================

echo.
echo [Mind Canvas] 테스트 실행 시작...
echo.

REM 색상 설정
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"
set "timestamp=%YYYY%-%MM%-%DD% %HH%:%Min%:%Sec%"

echo ========================================
echo [%timestamp%] 테스트 실행 시작
echo ========================================

REM 매개변수 체크
if "%1"=="unit" goto unit_test
if "%1"=="widget" goto widget_test
if "%1"=="integration" goto integration_test
if "%1"=="all" goto all_tests
if "%1"=="coverage" goto coverage_test
if "%1"=="clean" goto clean_test
if "%1"=="help" goto help
if "%1"=="" goto help

:help
echo.
echo 사용법: run_tests.bat [옵션]
echo.
echo 옵션:
echo   unit         - 유닛 테스트만 실행
echo   widget       - 위젯 테스트만 실행
echo   integration  - 통합 테스트만 실행
echo   all          - 모든 테스트 실행
echo   coverage     - 코드 커버리지 포함 테스트
echo   clean        - 테스트 캐시 정리 후 실행
echo   help         - 도움말 표시
echo.
echo 예시:
echo   run_tests.bat unit
echo   run_tests.bat coverage
echo.
goto end

:clean_test
echo [1/2] 테스트 캐시 정리 중...
flutter clean > nul 2>&1
echo [2/2] 패키지 재설치 중...
flutter pub get > nul 2>&1
echo ✅ 정리 완료!
goto all_tests

:unit_test
echo 🧪 유닛 테스트 실행 중...
echo.
flutter test test/unit/ --reporter=expanded
if %errorlevel% neq 0 (
    echo ❌ 유닛 테스트 실패!
    goto end
)
echo ✅ 유닛 테스트 완료!
goto end

:widget_test
echo 🖼️ 위젯 테스트 실행 중...
echo.
flutter test test/widget/ --reporter=expanded
if %errorlevel% neq 0 (
    echo ❌ 위젯 테스트 실패!
    goto end
)
echo ✅ 위젯 테스트 완료!
goto end

:integration_test
echo 🔗 통합 테스트 실행 중...
echo.
flutter test integration_test/ --reporter=expanded
if %errorlevel% neq 0 (
    echo ❌ 통합 테스트 실패!
    goto end
)
echo ✅ 통합 테스트 완료!
goto end

:coverage_test
echo 📊 코드 커버리지 테스트 실행 중...
echo.
flutter test --coverage --reporter=expanded
if %errorlevel% neq 0 (
    echo ❌ 커버리지 테스트 실패!
    goto end
)
echo.
echo 📈 커버리지 리포트 생성 중...
REM LCOV 리포트 생성 (lcov 설치 필요)
if exist "coverage\lcov.info" (
    echo 💡 커버리지 파일 생성됨: coverage\lcov.info
    echo 💡 HTML 리포트 생성하려면 다음 명령어 실행:
    echo    genhtml coverage\lcov.info -o coverage\html
)
echo ✅ 코드 커버리지 테스트 완료!
goto end

:all_tests
echo 🚀 모든 테스트 실행 중...
echo.

REM 1. 유닛 테스트
echo [1/3] 🧪 유닛 테스트...
flutter test test/unit/ --reporter=compact
if %errorlevel% neq 0 (
    echo ❌ 유닛 테스트 실패!
    goto end
)
echo ✅ 유닛 테스트 완료!
echo.

REM 2. 위젯 테스트
echo [2/3] 🖼️ 위젯 테스트...
flutter test test/widget/ --reporter=compact
if %errorlevel% neq 0 (
    echo ❌ 위젯 테스트 실패!
    goto end
)
echo ✅ 위젯 테스트 완료!
echo.

REM 3. 통합 테스트
echo [3/3] 🔗 통합 테스트...
flutter test test/integration/ --reporter=compact
if %errorlevel% neq 0 (
    echo ❌ 통합 테스트 실패!
    goto end
)
echo ✅ 통합 테스트 완료!
echo.

echo ========================================
echo 🎉 모든 테스트 성공!
echo ========================================

:end
echo.
echo 테스트 실행 종료: %timestamp%
echo.
pause
