class ResponseModel {
  ResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.subData,
    this.exception = '',
    this.errorCode,
  });
  final bool isSuccess;
  final String message;
  final dynamic data;
  final dynamic subData;
  final String exception;
  final String? errorCode;
}
