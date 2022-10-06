import 'package:flutter/material.dart';
import 'package:phantom_connect/phantom_connect.dart';
import 'package:serumswap/phantom.dart';

class PhantomConnectButton extends StatefulWidget {
  late PhantomConnect phantomConnect;
  PhantomConnectButton({Key? key, required PhantomConnect phantomConnect})
      : super(key: key);

  @override
  State<PhantomConnectButton> createState() => _PhantomConnectButtonState();
}

class _PhantomConnectButtonState extends State<PhantomConnectButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Phantom().connect(widget.phantomConnect);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Row(
          children: const [
            Text(
              "Connect Phantom",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Icon(
              Icons.account_balance_wallet,
              size: 25,
            ),
          ],
        ),
      ),
    );
  }
}
