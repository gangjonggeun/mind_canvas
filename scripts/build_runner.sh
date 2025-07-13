#!/bin/bash

echo "🔥 Mind Canvas - 코드 생성 시작"
echo "================================"

# Pub get 실행
echo "📦 Dependencies 설치 중..."
flutter pub get

# 기존 생성된 파일들 삭제 (충돌 방지)
echo "🧹 기존 생성 파일 정리 중..."
find lib -name "*.g.dart" -delete
find lib -name "*.freezed.dart" -delete

# 코드 생성 실행
echo "⚡ 코드 생성 실행 중..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# 테스트 관련 코드 생성
echo "🧪 테스트 Mock 생성 중..."
flutter packages pub run build_runner build test --delete-conflicting-outputs

echo "✅ 코드 생성 완료!"
echo "================================"

# 생성된 파일 확인
echo "📁 생성된 파일 목록:"
find lib -name "*.g.dart" -o -name "*.freezed.dart" | head -10
