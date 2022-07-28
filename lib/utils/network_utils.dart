import 'package:commons_flutter/exceptions/no_internet_error.dart';
import 'package:connectivity/connectivity.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:async';

class NetworkUtils {
  static Future<bool> hasInternetConnection() async {
    try {
      bool result = await InternetConnectionChecker().hasConnection;
      return result;
    } catch (err) {
      // ignore: avoid_print
      print(err);
      return false;
    }
  }

  static Future<bool> isWifi() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult == ConnectivityResult.wifi;
    } catch (err) {
      // ignore: avoid_print
      print(err);
      return true;
    }
  }

  static Future<void> validateInternet() async {
    var hasInternet = await hasInternetConnection();
    if (!hasInternet) {
      throw NoInternetConnectionError();
    }
  }

  static StreamSubscription listenOnNetworkChanged(Function(bool hasInternet) onNetworkStatusChanged) {
    return Connectivity().onConnectivityChanged.listen((result) async {
      if(result != ConnectivityResult.none) {
        bool isDeviceConnected = await InternetConnectionChecker().hasConnection;
        onNetworkStatusChanged(isDeviceConnected);
      } else {
        onNetworkStatusChanged(false);
      }
    });
  }
}
