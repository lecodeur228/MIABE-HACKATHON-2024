import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

class CheckConnecivity {
 static Future<bool> checkInternet() async {
    final hasInternet = await InternetConnectivity().hasInternetConnection;
    if (hasInternet) {
      return true;
    } else {
      return false;
    }
  }

  // Future<bool> checkRealTimeInternet() async {
  //     final subscription =
  //     InternetConnectivity().observeInternetConnection.listen((bool hasInternetAccess) {
  //       if(!hasInternetAccess){
  //         return false;
  //       }
  //     });

  //     await Future.delayed(const Duration(seconds: 10 ));
  //     subscription.cancel();
  // }
}
