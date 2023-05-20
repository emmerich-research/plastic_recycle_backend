import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db.dart';

class Labels {
  Router get router {
    final router = Router();


    router.get('/getAllLabels', (Request request) async {
      List<dynamic> labels = [];
      
      // FETCH DATA FROM DATABASE
      await DataFetcher().getAllLabel().then((value) {
        for (var element in value) {
          labels.add({"id": element[0], "label": element[1]});
        }
      });
      

      return Response.ok(
        headers: {'Content-type': 'application/json'},
        json.encode({'code': 200, 'data': labels}),
      );
    });

    return router;
  }
}
