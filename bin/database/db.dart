import 'package:postgres/postgres.dart';

class DataFetcher {
  final String hostname = "localhost";
  final int port = 5432;
  final String dbName = "plastic_recycle";
  final String username = "emmerich";
  final String password = "emmerich";

  PostgreSQLConnection? connection;
  // CONSTRUCTOR
  DataFetcher() {
    connection = PostgreSQLConnection(hostname, port, dbName, username: username, password: password, allowClearTextPassword: true);
  }

  // GET
  // GET ALL LABELS
  Future<List<dynamic>> getAllLabel() async {
    PostgreSQLResult? dataResult;
    List<dynamic> fetchedData = [];
    String destination = "labels";
    try {
      await connection!.open();
      dataResult = await connection!.query("""
          SELECT * FROM $destination
          ORDER BY id ASC
          """, allowReuse: false);
      fetchedData = dataResult.toList(growable: true);
      await connection!.close();
    } catch (e) {
      print(e);
    }
    return fetchedData;
  }

  // GET ALL DIRECTORY
  Future<List<dynamic>> getAllDirectory() async {
    PostgreSQLResult? dataResult;
    List<dynamic> fetchedData = [];
    String destination = "images";
    try {
      await connection!.open();
      dataResult = await connection!.query("""
          SELECT * FROM $destination
          ORDER BY id ASC
          """, allowReuse: false);
      fetchedData = dataResult.toList(growable: true);
      await connection!.close();
    } catch (e) {
      print(e);
    }
    return fetchedData;
  }

  // GET ALL DIRECTORY
  Future<dynamic> getLatestId(int labelId) async {
    PostgreSQLResult? dataResult;
    dynamic fetchedData;
    String destination = "images";
    try {
      await connection!.open();
      dataResult = await connection!.query("""
          SELECT id FROM $destination
          ORDER BY id DESC
          LIMIT 1
          """, allowReuse: false);
      fetchedData = dataResult.toList(growable: true).first;
      await connection!.close();
    } catch (e) {
      print(e);
    }

    if (fetchedData != null) {
      return fetchedData.first;
    } else {
      return null;
    }
  }

  // INSERT NEW IMAGE
  Future<dynamic> insertNewImage(int labelId, String imageDir, String coordinateDir, int id) async {
    String destination = "images";

    // try {
      await connection!.open();
      await connection!.transaction((connection) async {
        await connection.query("""
          INSERT INTO $destination (label_id, image_dir, coordinate_dir, id)
          VALUES ('$labelId', '$imageDir', '$coordinateDir', '$id')
          """, allowReuse: false);
      });
      await connection!.close();
    // } catch (e) {
    //   print(e);
    // }
  }
}
