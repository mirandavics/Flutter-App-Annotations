class LoginPayload {
  String username;
  String password;
  String token;

  LoginPayload({
    this.username,
    this.password,
    this.token
  });

  dynamic toMap() => {
    "username": username,
    "password": password,
  };

}