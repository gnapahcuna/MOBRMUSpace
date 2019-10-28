class ItemsDataLogin {
  final bool LoginPass;
  final ItemsDataLoginResponse Response;

  ItemsDataLogin({
    this.LoginPass,
    this.Response,
  });

  factory ItemsDataLogin.fromJson(Map<String, dynamic> json) {
    return ItemsDataLogin(
      LoginPass: json['LoginPass'],
      Response: json['LoginPass']
          ?ItemsDataLoginResponse.fromJson(json['Response'])
          :null,
    );
  }
}
class ItemsDataLoginResponse {
  final String UserID;
  final String UserName;
  final String Password;
  final String UserCF;
  final String LastLogin;

  ItemsDataLoginResponse({
    this.UserID,
    this.UserName,
    this.Password,
    this.UserCF,
    this.LastLogin,
  });

  factory ItemsDataLoginResponse.fromJson(Map<String, dynamic> json) {
    return ItemsDataLoginResponse(
      UserID: json['UserID'],
      UserName: json['UserName'],
      Password: json['Password'],
      UserCF: json['UserCF'],
      LastLogin: json['LastLogin'],
    );
  }
}
