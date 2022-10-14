import 'dart:async';

import 'package:alert/alert.dart';
import 'package:phantom_connect/phantom_connect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

class Phantom {
  bool connected = false;
  late double balance;
  late PhantomConnect phantomConnect;
  RpcClient client = RpcClient("https://api.devnet.solana.com");

  Phantom() {
    phantomConnect = PhantomConnect(
      appUrl: "https://solana.com",
      deepLink: "dapp://flutterbooksample.com",
    );
  }

  void setConnected(bool connect) {
    connected = connect;
  }

  void connect() async {
    try {
      Uri connectUrl = phantomConnect.generateConnectUri(
          cluster: 'devnet', redirect: '/connect');

      await launchUrl(connectUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      Alert(message: e.toString());
    }
  }

  void send(String address, double amount) async {
    final transferIx = SystemInstruction.transfer(
      fundingAccount:
          Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
      recipientAccount: Ed25519HDPublicKey.fromBase58(address),
      lamports: (amount * lamportsPerSol).floor(),
    );
    final message = Message.only(transferIx);
    final blockhash = await RpcClient('https://api.devnet.solana.com')
        .getRecentBlockhash()
        .then((b) => b.blockhash);
    final compiled = message.compile(recentBlockhash: blockhash);

    final tx = SignedTx(
      messageBytes: compiled.data,
      signatures: [
        Signature(
          List.filled(64, 0),
          publicKey:
              Ed25519HDPublicKey.fromBase58(phantomConnect.userPublicKey),
        )
      ],
    ).encode();

    var launchUri = phantomConnect.generateSignAndSendTransactionUri(
        transaction: tx, redirect: '/signAndSendTransaction');
    await launchUrl(
      launchUri,
      mode: LaunchMode.externalApplication,
    );
  }

  void disconnect() {
    Uri url = phantomConnect.generateDisconnectUri(redirect: '/disconnect');
    Future<void> launch() async {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }

    launch();
  }

  Future getBalance() async {
    final value = await client.getBalance(phantomConnect.userPublicKey);

    return value / lamportsPerSol;
  }

  Future airDrop() async {
    try {
      await client.requestAirdrop(
          phantomConnect.userPublicKey, 1 * lamportsPerSol);

      return true;
    } catch (E) {
      return false;
    }
  }
}
