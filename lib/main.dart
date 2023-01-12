import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Zego Live Streaming",
      home: HomePage(),
    );
  }
}

final String userID = Random().nextInt(900000 + 100000).toString();

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final liveIDController = TextEditingController(
    text: Random().nextInt(900000 + 100000).toString(),
  );

  // TODO Live Streaming Method
  jumpToLivePage(BuildContext context,
      {required String liveID, required bool isHost}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LivePage(
                  liveID: liveID,
                  isHost: isHost,
                )));
  }

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff034ada),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ));
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/call.svg",
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(height: 20.0),
            Text("Your UserID: $userID"),
            const Text("Please test with two or more devices"),
            const SizedBox(height: 30.0),
            TextFormField(
              controller: liveIDController,
              decoration: const InputDecoration(
                  labelText: 'Join or start a live by input and ID',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () => jumpToLivePage(context,
                  liveID: liveIDController.text, isHost: true),
              style: buttonStyle,
              child: const Text("Start a Live"),
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () => jumpToLivePage(context,
                  liveID: liveIDController.text, isHost: false),
              style: buttonStyle,
              child: const Text("Join a Live"),
            ),
          ],
        ),
      ),
    );
  }
}

class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  LivePage({Key? key, required this.liveID, this.isHost = false})
      : super(key: key);

  final int appID = int.parse(dotenv.get('ZEGO_APP_ID'));
  final String appSign = dotenv.get('ZEGO_APP_SIGN');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: 'user_$userID',
        liveID: liveID,
        config: isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
      ),
    );
  }
}
