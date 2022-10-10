import 'dart:async';

import 'package:phantom_connect/phantom_connect.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

class Phantom {
  bool connected = false;

  PhantomConnect phantomConnect() {
    return PhantomConnect(
      appUrl: "https://solana.com",
      deepLink: "dapp://flutterbooksample.com",
    );
  }

  void setConnected(bool connect) {
    connected = connect;
  }

  void connect(phantomConnect) async {
    Uri connectUrl = phantomConnect.generateConnectUri(
        cluster: 'devnet', redirect: '/connect');
    try {
      await launchUrl(connectUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      print(e);
    }

    // Open the url using (url_launcher)[https://pub.dev/packages/url_launcher]]
  }

  void send(
      PhantomConnect phantomConnect, String address, double amount) async {
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

  void Disconnect(PhantomConnect phantomConnect) async {
    Uri url = phantomConnect.generateDisconnectUri(redirect: '/disconnect');
    Future<void> launch() async {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    }

    launch();
  }
}
