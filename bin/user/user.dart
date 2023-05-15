import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UserApi {
  Router get router {
    final router = Router();

    router.post('/login', (Request request) async {
      final content = await request.readAsString();
      var queryParams = Uri(query: content).queryParameters;
      
      return Response.ok(
        headers: {'Content-type': 'application/json'},
        json.encode({
          'code': 200,
          'data': queryParams,
        }),
      );
    });

    return router;
  }
}
