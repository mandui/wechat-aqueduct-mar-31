import 'route_play_host.dart';

class RoutePlayHostChannel extends ApplicationChannel {

  @override
  Future prepare() async {
    logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router
      .route("/example")
      .linkFunction((request) async {
        return Response.ok({"key": "value"});
      });

    router
      .route("/*")
      .link(() => FileController("lib/pages/fool_day/"));

    return router;
  }
}