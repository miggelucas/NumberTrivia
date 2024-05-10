import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfoble {
  Future<bool> get isConnected;
}

class NetworkInfo implements NetworkInfoble {
  InternetConnectionChecker internetConnectionChecker;

  NetworkInfo(this.internetConnectionChecker);

  @override
  Future<bool> get isConnected => internetConnectionChecker.hasConnection;
}
