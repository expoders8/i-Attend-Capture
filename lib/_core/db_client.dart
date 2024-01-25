import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

///
class DBClient {
  Database? _db;

  ///
  Future<Database> get db async {
    if (_db == null) {
      await _getDBInstance();
    }

    return _db!;
  }

  ///
  DBClient() {
    _getDBInstance();
  }

  Future<Database> _getDBInstance() async {
    const String dbPath = 'capture.db';
    final DatabaseFactory dbFactory = databaseFactoryIo;

// We use the database factory to open the database
    final dbDirectory = await getApplicationDocumentsDirectory();
    _db = await dbFactory.openDatabase(join(dbDirectory.path, dbPath));

    return _db!;
  }
}
