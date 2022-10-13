import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serumswap/phantom.dart';
import 'package:serumswap/providers/wallet_state_provider.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class Account extends StatefulWidget {
  Phantom phantom;
  Account({super.key, required this.phantom});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  double balance = 0;
  double netwokFee = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WalletStateProvider>(context, listen: true);
    return provider.isConnected
        ? Logged(context)
        : SafeArea(
            child: Center(
              child: TextButton(
                onPressed: () async {
                  if (!widget.phantom.connected) {
                    widget.phantom.connect();
                  }
                },
                child: const Text(
                  "Connect Wallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          );
  }

  SafeArea Logged(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Color.fromARGB(255, 46, 34, 46),
              Color.fromARGB(255, 39, 35, 43),
              Color.fromARGB(255, 36, 35, 42),
              Color.fromARGB(255, 34, 36, 41),
            ]),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 105,
                    color: Colors.white70,
                  ),
                  Container(
                    height: 20,
                  ),
                  SizedBox(
                    width: 400,
                    child: TextButton(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: widget.phantom.phantomConnect.userPublicKey,
                          ),
                        );
                      },
                      child: Text(
                        widget.phantom.phantomConnect.userPublicKey,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            wordSpacing: 10,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Container(
                    height: 30,
                  ),
                  Text("Balance: $balance SOL",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          wordSpacing: 10,
                          fontWeight: FontWeight.w500)),
                  Container(
                    height: 50,
                  ),
                  Column(
                    children: [
                      const Text(
                        "Send SOL",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 6,
                          right: 20,
                          bottom: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 25, 27, 31),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: addressController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 227, 225, 225),
                            hintText: "Reciever Public Address",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 178, 185, 210),
                              fontSize: 22,
                            ),
                            focusColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        width: 300,
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 6,
                          right: 20,
                          bottom: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 25, 27, 31),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          cursorHeight: 25,
                          keyboardType: TextInputType.number,
                          controller: amountController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 227, 225, 225),
                            hintText: "Amount SOL",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color.fromARGB(255, 178, 185, 210),
                              fontSize: 22,
                            ),
                            focusColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          widget.phantom.send(addressController.text,
                              double.parse(amountController.text));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            // color: const Color.fromARGB(255, 20, 27, 43),
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "Send",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          widget.phantom.airDrop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // color: const Color.fromARGB(255, 20, 27, 43),
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "AirDrop",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.phantom.disconnect();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 23, 42, 66),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Disconnect wallet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
