import 'package:flutter/material.dart';
import 'package:lightning_overlay/lightning_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LightningCard(),
    );
  }
}

class LightningCard extends StatefulWidget {
  const LightningCard({super.key});

  @override
  LightningCardState createState() => LightningCardState();
}

class LightningCardState extends State<LightningCard> {
  @override
  void initState() {
    super.initState();
  }

  LightningController controller = LightningController();

  void animate() async {
    controller.animateIn();
    await Future.delayed(const Duration(seconds: 1));
    controller.animateOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lightning(
              useGesture: false,
              borderRadius: 15,
              repeatInfinity: true,
              delayDuration: const Duration(milliseconds: 300),
              controller: controller,
              direction: LightningDirection.leftToRight,
              pauseDuration: const Duration(milliseconds: 200),
              durationIn: const Duration(milliseconds: 300),
              durationOut: const Duration(milliseconds: 450),
              overlayColor: Colors.white.withValues(alpha: .6),
              child: Container(
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                      child: Image.network(
                    "https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png",
                    width: 200,
                  ))),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          GestureDetector(
            onTap: () => animate(),
            child: Container(
              height: 70,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              child: const Center(
                child: Text(
                  "Animate",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
