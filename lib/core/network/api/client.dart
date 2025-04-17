import 'dart:io';

import 'package:dio/dio.dart';

import 'package:fkgame/core/constants/api.dart';
import 'package:fkgame/core/constants/error_messages.dart';
import 'package:fkgame/core/di.dart';
import 'package:fkgame/core/services/auth.dart';
import 'package:fkgame/core/services/log.dart';

/// API异常类
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  ApiException({required this.message, this.statusCode, this.errorCode});

  /// 工厂方法，从Dio错误创建
  factory ApiException.fromDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        message: ErrorMessages.connectionTimeout,
        statusCode: error.response?.statusCode,
        errorCode: 'CONNECTION_TIMEOUT',
      );
    }

    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        return ApiException(
          message: ErrorMessages.authExpired,
          statusCode: statusCode,
          errorCode: 'AUTH_EXPIRED',
        );
      }

      // 从错误响应中提取自定义错误信息
      final data = error.response?.data;
      if (data != null && data is Map && data.containsKey('message')) {
        return ApiException(
          message: data['message'],
          statusCode: statusCode,
          errorCode: data['code'],
        );
      }

      return ApiException(
        message: ErrorMessages.serverError,
        statusCode: statusCode,
        errorCode: 'SERVER_ERROR',
      );
    }

    return ApiException(
      message: ErrorMessages.connectionFailed,
      errorCode: 'CONNECTION_FAILED',
    );
  }

  @override
  String toString() =>
      'ApiException: $message (statusCode: $statusCode, errorCode: $errorCode)';
}

/// API客户端
class ApiClient {
  late final Dio _dio;
  final LogService _logger = getIt<LogService>();

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
        sendTimeout: Duration(milliseconds: ApiConstants.sendTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(_authInterceptor);
    _dio.interceptors.add(_loggingInterceptor);
  }

  /// 认证拦截器
  Interceptor get _authInterceptor {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final authService = getIt<AuthService>();
        final token = authService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // 认证错误，清除认证信息
          await getIt<AuthService>().clearAuthData();
        }
        return handler.next(error);
      },
    );
  }

  /// 日志拦截器
  Interceptor get _loggingInterceptor {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.info('请求: ${options.method} ${options.uri}', {
          'headers': options.headers,
          'data': options.data,
          'queryParams': options.queryParameters,
        });
        print('🌐 发送请求: ${options.method} ${options.uri}');
        print('🌐 请求参数: ${options.data ?? '无'}');
        print('🌐 请求查询: ${options.queryParameters ?? '无'}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.info(
          '响应: ${response.statusCode} ${response.requestOptions.uri}',
          {'data': response.data, 'headers': response.headers.map},
        );
        print('✅ 响应成功: ${response.statusCode} ${response.requestOptions.uri}');
        print('✅ 响应数据: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        _logger.error(
          '错误: ${error.response?.statusCode} ${error.requestOptions.uri}',
          {
            'message': error.message,
            'data': error.response?.data,
            'error': error.toString(),
          },
        );
        print('❌ 请求错误: ${error.requestOptions.uri}');
        print('❌ 错误状态: ${error.response?.statusCode ?? '无状态码'}');
        print('❌ 错误信息: ${error.message}');
        print('❌ 错误数据: ${error.response?.data ?? '无数据'}');
        return handler.next(error);
      },
    );
  }

  /// 发起GET请求
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(
        message: ErrorMessages.unknownError,
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  /// 发起POST请求
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(
        message: ErrorMessages.unknownError,
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  /// 发起PUT请求
  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(
        message: ErrorMessages.unknownError,
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  /// 发起DELETE请求
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    } catch (e) {
      throw ApiException(
        message: ErrorMessages.unknownError,
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }
}
