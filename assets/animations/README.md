# Lottie 애니메이션 파일들

## 추천 무료 Lottie 사이트:
1. **LottieFiles** - https://lottiefiles.com
2. **Lordicon** - https://lordicon.com
3. **Animista** - https://animista.net

## HTP 검사용 추천 애니메이션:
- tree_grow.json - 나무가 자라는 애니메이션
- house_build.json - 집이 건설되는 애니메이션  
- person_walk.json - 사람이 걸어가는 애니메이션
- drawing_pen.json - 펜으로 그리는 애니메이션

## 사용법:
1. LottieFiles에서 JSON 파일 다운로드
2. assets/animations/ 폴더에 저장
3. HomeScreen에서 주석 해제:
   ```dart
   // isLottie: true,
   // lottiePath: 'assets/animations/tree_grow.json',
   ```

## 파일 용량 최적화:
- 애니메이션 품질: Medium (512x512)
- 파일 크기: 100KB 이하 권장
- 프레임레이트: 30fps
