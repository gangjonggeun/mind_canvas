import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final dio = Dio();

  // 여기에 기본 서버 URL, 타임아웃 등 공통 설정을 합니다.
  dio.options.baseUrl = "http://192.168.219.103:8080/api/v1"; // 실제 서버 주소
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);

  dio.options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  // 디버그 모드일 때만 예쁜 로그(pretty_dio_logger)를 추가합니다.
  // 나중에 여기에 Access Token을 자동으로 헤더에 추가하는 인터셉터도 넣게 됩니다.
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 90,
  ));

  return dio;
}