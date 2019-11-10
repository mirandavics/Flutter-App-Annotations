class HttpResponse {
  int status;
  String data;
  String message;
  int length;
  String token;

  HttpResponse({
    this.status,
    this.data,
    this.message,
    this.length,
    this.token,
  });
}