@echo off
echo ⚡ 긴급 코드 생성 - HTP 빨간줄 해결
echo ================================

echo 📦 Dependencies 재설치 중...
call flutter pub get

echo 🧹 기존 생성 파일 정리 중...
for /r lib %%f in (*.g.dart) do del "%%f" 2>nul
for /r lib %%f in (*.freezed.dart) do del "%%f" 2>nul

echo ⚡ Freezed + Riverpod 코드 생성 실행 중...
call flutter packages pub run build_runner build --delete-conflicting-outputs

echo 🔍 생성된 파일 확인...
echo.
echo 📁 HTP 관련 생성 파일들:
dir /s lib\core\htp\*.g.dart 2>nul
dir /s lib\core\htp\*.freezed.dart 2>nul

echo.
echo ✅ 코드 생성 완료!
echo 이제 Android Studio에서 빨간줄이 사라져야 합니다.
echo ================================

pause
