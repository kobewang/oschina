import 'package:shared_preferences/shared_preferences.dart';
class DataUtils {
  static final String SP_AC_TOKEN = "accessToken";
  static final String SP_RE_TOKEN = "refreshToken";
  static final String SP_UID = "uid";
  static final String SP_IS_LOGIN = "isLogin";
  static final String SP_EXPIRES_IN = "expiresIn";
  static final String SP_TOKEN_TYPE = "tokenType";

  //保存用户登录信息,data包含token等信息
  static saveLoginInfo(Map data) async {
    if (data != null) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      await sp.setString(SP_AC_TOKEN, data['access_token']);
      await sp.setString(SP_RE_TOKEN, data['refresh_token']);
      await sp.setInt(SP_UID, data['uid']);
      await sp.setString(SP_TOKEN_TYPE, data['tokenType']);
      await sp.setInt(SP_EXPIRES_IN, data['expires_in']);
      await sp.setBool(SP_IS_LOGIN, true);
    }
  }
  //是否登录
  static Future<bool> isLogin() async {
    SharedPreferences sp =  await SharedPreferences.getInstance();
    bool b = sp.getBool(SP_IS_LOGIN);
    return b != null && b;
  }
  //test写入登录
  static saveIsLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(SP_IS_LOGIN, true);
  }
  static logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool(SP_IS_LOGIN, false);
  }
}