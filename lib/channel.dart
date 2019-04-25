import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:route_play_host/data/local_store.dart' as store;
import 'package:route_play_host/controllers/wechat_api.dart';
import 'route_play_host.dart';


class RoutePlayHostChannel extends ApplicationChannel {

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    //_updateAccessToken();
    //Timer.periodic(Duration(seconds: 5400), (Timer t) => _updateAccessToken());
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/example")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });

    router.route("/wechat/*")
      .link(() => FileController("/lib/file/"));

    /*router
      .route("/wechat/[:api]")
      .link(() => WechatApis());*/

    router
      .route("/wechat/app/*")
      .link(() => FileController("lib/pages/april_4th/"));
	
    router.route("/fun/highlight/*")
      .link(() => FileController("lib/pages/highlight/"));

    router.route("/fun/number_mystery/*")
      .link(() => FileController("lib/pages/number_mystery/"));

    router.route("/fun/get_me_a_dog/*")
      .link(() => FileController("lib/pages/get_me_a_dog/"));

    return router;
  }

   void _updateAccessToken() async {
     const _id = "wx10823f9799c7f8dc";
     const _sec = "Be91c1df6197e26f129bcf7608aabdb1";
     final _tokenAPI = Uri.https("api.weixin.qq.com", "/cgi-bin/token", {
       "grant_type": "client_credential",
       "appid": _id, "secret": _sec
     });

     try {
       final response = await http.get(_tokenAPI);
       final data = await json.decode(response.body) as Map<String, dynamic>;
       for (String key in data.keys) {
         print("key: $key");
         print("value: ${data[key]}");
         logger.log(Level.SEVERE, "key: $key");
         logger.log(Level.SEVERE, "value: ${data[key]}");
       }
       final token = await data["access_token"] as String;
       print("token: $token");
       if (token != null) {
         store.accessToken = token;
         store.lastRefresh = DateTime.now().millisecondsSinceEpoch;
       }
     } catch (e) {
       print(e);
       logger.log(Level.SEVERE, e.toString());
     }
  }
}
