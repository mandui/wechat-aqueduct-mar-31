import 'package:aqueduct/aqueduct.dart';
import 'package:route_play_host/data/local_store.dart' as store;

class WechatApis extends ResourceController {

  @Bind.query("signature")
  String signature;

  @Operation.get("api")
  Future<Response> api() async {
    final api = request.path.variables['api'];

    switch (api) {
      case "access_token":
        return _getAccessToken();
      default:
        return Response.ok("unknown api");
    }
  }

  Response _getAccessToken() {
    if (_checkSignature(signature)) {
      return Response.ok({"access_token": store.accessToken});
    } else {
      return Response.ok("my dear friend, who are you ~ ");
    }
  }


  bool _checkSignature(String sig) {
    if (sig == null)
      return false;
    return true;
  }
}