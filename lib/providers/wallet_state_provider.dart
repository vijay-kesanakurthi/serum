import 'package:flutter/foundation.dart';

class WalletStateProvider extends ChangeNotifier {
  bool _connected = false;
  Uint8List? nonce;

  bool get isConnected => _connected;

  void updateConnection(bool state) {
    _connected = state;
    notifyListeners();
  }
}
