@echo off
echo 🔥 Mind Canvas - 코드 생성 시작
echo ================================

echo 📦 Dependencies 설치 중...
call flutter pub get

echo 🧹 기존 생성 파일 정리 중...
for /r lib %%f in (*.g.dart) do del "%%f" 2>nul
for /r lib %%f in (*.freezed.dart) do del "%%f" 2>nul

echo ⚡ 코드 생성 실행 중...
call flutter packages pub run build_runner build --delete-conflicting-outputs

echo 🧪 테스트 Mock 생성 중...
call flutter packages pub run build_runner build test --delete-conflicting-outputs

echo ✅ 코드 생성 완료!
echo ================================

pause
