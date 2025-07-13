# ========================================
# Mind Canvas - 테스트 실행 스크립트 (PowerShell)
# ========================================

param(
    [Parameter(Position=0)]
    [ValidateSet('unit', 'widget', 'integration', 'all', 'coverage', 'clean', 'help')]
    [string]$TestType = 'help'
)

# 색상 정의
$Colors = @{
    Red = 'Red'
    Green = 'Green'
    Yellow = 'Yellow'
    Blue = 'Blue'
    Magenta = 'Magenta'
    Cyan = 'Cyan'
    White = 'White'
}

# 로그 함수
function Write-Log {
    param(
        [string]$Message,
        [string]$Color = 'White',
        [string]$Prefix = 'INFO'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Write-Host "[$timestamp] [$Prefix] $Message" -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-Log -Message $Message -Color $Colors.Green -Prefix 'SUCCESS'
}

function Write-Error {
    param([string]$Message)
    Write-Log -Message $Message -Color $Colors.Red -Prefix 'ERROR'
}

function Write-Warning {
    param([string]$Message)
    Write-Log -Message $Message -Color $Colors.Yellow -Prefix 'WARNING'
}

function Write-Info {
    param([string]$Message)
    Write-Log -Message $Message -Color $Colors.Cyan -Prefix 'INFO'
}

# 타이틀 출력
Write-Host ""
Write-Host "[Mind Canvas] 테스트 실행 시작..." -ForegroundColor Magenta
Write-Host ""

$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
Write-Host "========================================" -ForegroundColor White
Write-Host "[$timestamp] 테스트 실행 시작" -ForegroundColor White
Write-Host "========================================" -ForegroundColor White

# 도움말 함수
function Show-Help {
    Write-Host ""
    Write-Host "사용법: .\run_tests.ps1 [옵션]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "옵션:" -ForegroundColor Yellow
    Write-Host "  unit         - 유닛 테스트만 실행" -ForegroundColor White
    Write-Host "  widget       - 위젯 테스트만 실행" -ForegroundColor White
    Write-Host "  integration  - 통합 테스트만 실행" -ForegroundColor White
    Write-Host "  all          - 모든 테스트 실행" -ForegroundColor White
    Write-Host "  coverage     - 코드 커버리지 포함 테스트" -ForegroundColor White
    Write-Host "  clean        - 테스트 캐시 정리 후 실행" -ForegroundColor White
    Write-Host "  help         - 도움말 표시" -ForegroundColor White
    Write-Host ""
    Write-Host "예시:" -ForegroundColor Yellow
    Write-Host "  .\run_tests.ps1 unit" -ForegroundColor White
    Write-Host "  .\run_tests.ps1 coverage" -ForegroundColor White
    Write-Host ""
}

# 클린 함수
function Invoke-CleanTest {
    Write-Info "테스트 캐시 정리 중..."
    flutter clean | Out-Null
    Write-Info "패키지 재설치 중..."
    flutter pub get | Out-Null
    Write-Success "정리 완료!"
}

# 유닛 테스트 함수
function Invoke-UnitTests {
    Write-Info "🧪 유닛 테스트 실행 중..."
    Write-Host ""
    
    $result = flutter test test/unit/ --reporter=expanded
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✅ 유닛 테스트 완료!"
    } else {
        Write-Error "❌ 유닛 테스트 실패!"
        exit 1
    }
}

# 위젯 테스트 함수
function Invoke-WidgetTests {
    Write-Info "🖼️ 위젯 테스트 실행 중..."
    Write-Host ""
    
    $result = flutter test test/widget/ --reporter=expanded
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✅ 위젯 테스트 완료!"
    } else {
        Write-Error "❌ 위젯 테스트 실패!"
        exit 1
    }
}

# 통합 테스트 함수
function Invoke-IntegrationTests {
    Write-Info "🔗 통합 테스트 실행 중..."
    Write-Host ""
    
    $result = flutter test test/integration/ --reporter=expanded
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✅ 통합 테스트 완료!"
    } else {
        Write-Error "❌ 통합 테스트 실패!"
        exit 1
    }
}

# 커버리지 테스트 함수
function Invoke-CoverageTests {
    Write-Info "📊 코드 커버리지 테스트 실행 중..."
    Write-Host ""
    
    $result = flutter test --coverage --reporter=expanded
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Info "📈 커버리지 리포트 생성 중..."
        
        if (Test-Path "coverage\lcov.info") {
            Write-Success "💡 커버리지 파일 생성됨: coverage\lcov.info"
            Write-Info "💡 HTML 리포트 생성하려면 다음 명령어 실행:"
            Write-Host "    genhtml coverage\lcov.info -o coverage\html" -ForegroundColor Yellow
        }
        
        Write-Success "✅ 코드 커버리지 테스트 완료!"
    } else {
        Write-Error "❌ 커버리지 테스트 실패!"
        exit 1
    }
}

# 전체 테스트 함수
function Invoke-AllTests {
    Write-Info "🚀 모든 테스트 실행 중..."
    Write-Host ""
    
    # 1. 유닛 테스트
    Write-Info "[1/3] 🧪 유닛 테스트..."
    $result = flutter test test/unit/ --reporter=compact
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✅ 유닛 테스트 완료!"
    } else {
        Write-Error "❌ 유닛 테스트 실패!"
        exit 1
    }
    Write-Host ""
    
    # 2. 위젯 테스트
    Write-Info "[2/3] 🖼️ 위젯 테스트..."
    $result = flutter test test/widget/ --reporter=compact
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✅ 위젯 테스트 완료!"
    } else {
        Write-Error "❌ 위젯 테스트 실패!"
        exit 1
    }
    Write-Host ""
    
    # 3. 통합 테스트
    Write-Info "[3/3] 🔗 통합 테스트..."
    $result = flutter test test/integration/ --reporter=compact
    if ($LASTEXITCODE -eq 0) {
        Write-Success "✅ 통합 테스트 완료!"
    } else {
        Write-Error "❌ 통합 테스트 실패!"
        exit 1
    }
    Write-Host ""
    
    Write-Host "========================================" -ForegroundColor White
    Write-Host "🎉 모든 테스트 성공!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor White
}

# 메인 로직
switch ($TestType) {
    'unit' {
        Invoke-UnitTests
    }
    'widget' {
        Invoke-WidgetTests
    }
    'integration' {
        Invoke-IntegrationTests
    }
    'all' {
        Invoke-AllTests
    }
    'coverage' {
        Invoke-CoverageTests
    }
    'clean' {
        Invoke-CleanTest
        Invoke-AllTests
    }
    'help' {
        Show-Help
    }
    default {
        Show-Help
    }
}

Write-Host ""
$endTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
Write-Host "테스트 실행 종료: $endTime" -ForegroundColor White
Write-Host ""
