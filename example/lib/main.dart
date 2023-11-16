import 'package:flutter/material.dart';
import 'package:lightning/lightning.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LightningCard(),
    );
  }
}

class LightningCard extends StatefulWidget {
  @override
  _LightningCardState createState() => _LightningCardState();
}

class _LightningCardState extends State<LightningCard> {
  @override
  void initState() {
    super.initState();
  }

  LightningController controller = LightningController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lightning(
              useGesture: true,
              maxValue: 400,
              borderRadius: 15,
              controller: controller,
              direction: LightningDirection.RightToLeft,
              pauseDuration: const Duration(milliseconds: 200),
              durationIn: const Duration(milliseconds: 300),
              durationOut: const Duration(milliseconds: 450),
              overlayColor: Colors.white.withOpacity(0.1),
              child: Container(
                height: 200,
                  width: 400,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color:  Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                  ),child: Center(child: Image.network("https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png",width: 200,))),
            ),
          ),

          SizedBox(height: 100,),

          GestureDetector(
            onTap: () => controller.animate(),
            child: Container(
              height: 70,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue
              ),
              child: Center(
                child: Text("Animate",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20
                ),),
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
