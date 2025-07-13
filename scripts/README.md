# Mind Canvas - 테스트 실행 스크립트 사용법

## 🚀 개요
이 스크립트들은 Mind Canvas Flutter 프로젝트의 테스트를 효율적으로 실행할 수 있도록 도와줍니다.

## 📁 스크립트 파일들

### Windows 사용자
- `run_tests.bat` - 배치 파일 (기본)
- `run_tests.ps1` - PowerShell 스크립트 (고급)

### Linux/macOS 사용자
- `run_tests.sh` - Bash 스크립트

## 🛠️ 사용법

### 1. Windows (배치 파일)
```cmd
# 프로젝트 루트에서 실행
scripts\run_tests.bat [옵션]

# 예시
scripts\run_tests.bat all
scripts\run_tests.bat coverage
scripts\run_tests.bat unit
```

### 2. Windows (PowerShell)
```powershell
# 실행 정책 설정 (처음 한 번만)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 테스트 실행
.\scripts\run_tests.ps1 [옵션]

# 예시
.\scripts\run_tests.ps1 all
.\scripts\run_tests.ps1 coverage
```

### 3. Linux/macOS (Bash)
```bash
# 실행 권한 부여 (처음 한 번만)
chmod +x scripts/run_tests.sh

# 테스트 실행
./scripts/run_tests.sh [옵션]

# 예시
./scripts/run_tests.sh all
./scripts/run_tests.sh coverage
```

## 📋 옵션

| 옵션 | 설명 |
|------|------|
| `unit` | 유닛 테스트만 실행 |
| `widget` | 위젯 테스트만 실행 |
| `integration` | 통합 테스트만 실행 |
| `all` | 모든 테스트 실행 (권장) |
| `coverage` | 코드 커버리지 포함 테스트 |
| `clean` | 캐시 정리 후 전체 테스트 |
| `help` | 도움말 표시 |

## 🎯 테스트 구조

```
test/
├── unit/                          # 🧪 유닛 테스트
│   ├── app_dimensions_test.dart
│   └── home_screen_mock_test.dart
├── widget/                        # 🖼️ 위젯 테스트
│   └── home_screen_test.dart
├── integration/                   # 🔗 통합 테스트
│   └── home_screen_integration_test.dart
└── widget_test.dart              # 기본 위젯 테스트
```

## 📊 코드 커버리지

커버리지 테스트 실행 후:
- `coverage/lcov.info` 파일이 생성됩니다
- HTML 리포트 생성: `genhtml coverage/lcov.info -o coverage/html`

## ⚡ 성능 최적화 팁

1. **일반 개발 시**: `scripts/run_tests.sh unit` (빠름)
2. **PR 전**: `scripts/run_tests.sh all` (전체)
3. **릴리즈 전**: `scripts/run_tests.sh coverage` (품질)
4. **문제 발생 시**: `scripts/run_tests.sh clean` (정리)

## 🐛 문제 해결

### Flutter 명령어를 찾을 수 없음
```bash
# Flutter가 PATH에 있는지 확인
flutter --version

# Flutter 설치 확인
which flutter  # Linux/macOS
where flutter  # Windows
```

### 권한 문제 (Linux/macOS)
```bash
chmod +x scripts/run_tests.sh
```

### PowerShell 실행 정책 문제 (Windows)
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 🔄 CI/CD 통합

### GitHub Actions 예시
```yaml
- name: Run Tests
  run: |
    chmod +x scripts/run_tests.sh
    ./scripts/run_tests.sh coverage
```

### GitLab CI 예시
```yaml
test:
  script:
    - chmod +x scripts/run_tests.sh
    - ./scripts/run_tests.sh all
```

## 📈 메모리 & 성능 모니터링

스크립트는 다음을 자동으로 처리합니다:
- 테스트 캐시 정리
- 메모리 사용량 최적화
- 병렬 테스트 실행
- 상세한 에러 리포팅

## 🎨 색상 출력

모든 스크립트는 컬러 출력을 지원합니다:
- 🟢 성공: 초록색
- 🔴 에러: 빨간색
- 🟡 경고: 노란색
- 🔵 정보: 파란색

## 🚨 주의사항

1. **테스트 실행 전** 항상 `flutter pub get` 실행
2. **통합 테스트**는 에뮬레이터/시뮬레이터가 필요할 수 있음
3. **커버리지 리포트**는 추가 도구(`lcov`) 설치 필요
4. **대용량 프로젝트**에서는 `clean` 옵션 주의 (시간 소요)
