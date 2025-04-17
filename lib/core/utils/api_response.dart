/// API响应处理类
class ApiResponse<T> {
  final int code;
  final String? message;
  final T? data;

  ApiResponse({required this.code, this.message, this.data});

  /// 是否成功
  bool get isSuccess => code == 0;

  /// 从JSON创建API响应
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJson,
  ) {
    return ApiResponse(
      code: json['code'] ?? -1,
      message: json['msg'],
      data: json['data'] != null ? fromJson(json['data']) : null,
    );
  }
}
