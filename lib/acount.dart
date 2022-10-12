import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phantom_connect/phantom_connect.dart';
import 'package:serumswap/phantom.dart';
import 'package:solana/solana.dart';

class Account extends StatefulWidget {
  PhantomConnect phantomConnect;
  Phantom phantom;
  Account({super.key, required this.phantomConnect, required this.phantom});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final client = RpcClient("https://api.devnet.solana.com");
  double balance = 0;
  double netwokFee = 0;

  void getBalance() {
    client
        .getBalance(widget.phantomConnect.userPublicKey)
        .then((value) => setState(() {
              balance = value / lamportsPerSol;
            }));
  }

  void airDrop() async {
    try {
      final y = await client.requestAirdrop(
          widget.phantomConnect.userPublicKey, 1 * lamportsPerSol);
      Alert(message: "1 SOL Airdroped");
    } catch (E) {
      Alert(message: E.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return widget.phantom.connected
        ? Logged(context)
        : Text("Connect Phantom Wallet");
  }

  SafeArea Logged(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            body: SingleChildScrollView(
                child: Container(
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
                          child: Text(
                            "PublicKey:  ${widget.phantomConnect.userPublicKey}",
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 22,
                                wordSpacing: 10,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          height: 50,
                        ),
                        Container(
                          child: Text("Balance: $balance SOL",
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 22,
                                  wordSpacing: 10,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Container(
                          height: 50,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Send SOL",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            Container(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 54, 52, 52),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextField(
                                controller: addressController,
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 20),
                                decoration: const InputDecoration(
                                    fillColor:
                                        Color.fromARGB(255, 227, 225, 225),
                                    hintText: "Reciever PublicAdress",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 145, 139, 139),
                                        fontSize: 22),
                                    focusColor: Colors.white),
                              ),
                            ),
                            Container(
                              height: 10,
                            ),
                            Container(
                              width: 300,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 54, 52, 52),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: amountController,
                                style: const TextStyle(color: Colors.white60),
                                decoration: const InputDecoration(
                                    fillColor:
                                        Color.fromARGB(255, 227, 225, 225),
                                    hintText: "Amount SOL",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(255, 145, 139, 139),
                                        fontSize: 22),
                                    focusColor: Colors.white),
                              ),
                            ),
                            Container(
                              height: 10,
                            ),
                            TextButton(
                                onPressed: () {
                                  widget.phantom.send(
                                      widget.phantomConnect,
                                      addressController.text,
                                      double.parse(amountController.text));
                                  setState(() {
                                    getBalance();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 54, 52, 52),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Text("Send",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ))
                          ],
                        ),
                        Container(
                          height: 50,
                        ),
                        TextButton(
                            onPressed: () {
                              widget.phantom.Disconnect(widget.phantomConnect);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 54, 52, 52),
                                  borderRadius: BorderRadius.circular(20)),
                              child: const Text("Disconnect wallet",
                                  style: TextStyle(color: Colors.white)),
                            ))
                      ],
                    )))));
  }
}
