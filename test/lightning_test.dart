import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightning_overlay/lightning_overlay.dart';

void main() {
  Future<void> finishTest(WidgetTester tester) async {
    /// waiting fake timers to finish
    for (int i = 0; i < 100; i++) {
      await tester.pump(const Duration(minutes: 1));
    }
    await tester.pumpWidget(Container());
    await tester.pump();
    await tester.pumpAndSettle();
  }

  group('LightningController Tests', () {
    late LightningController controller;

    setUp(() {
      controller = LightningController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('should not animate when not initialized', () {
      // Controller ohne _init aufrufen
      expect(() => controller.animateIn(), returnsNormally);
      expect(() => controller.animateOut(), returnsNormally);
    });

    test('should be disposed correctly', () {
      controller.dispose();
      expect(() => controller.animateIn(), returnsNormally);
      expect(() => controller.animateOut(), returnsNormally);
    });

    testWidgets('should work with Lightning widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Lightning(
            controller: controller,
            delayDuration: null, // Disable auto-start
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test animateIn
      controller.animateIn();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      // Test animateOut
      controller.animateOut();
      await tester.pump();
      await tester.pumpAndSettle(const Duration(seconds: 25));

      finishTest(tester);
    });
  });

  group('Lightning Widget Tests', () {
    testWidgets('should render child widget', (WidgetTester tester) async {
      const testKey = Key('test-child');

      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            delayDuration: null, // Disable auto-start
            child: Text('Test Child', key: testKey),
          ),
        ),
      );

      expect(find.byKey(testKey), findsOneWidget);
      expect(find.text('Test Child'), findsOneWidget);
      finishTest(tester);
    });

    testWidgets('should auto-start with delay', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            delayDuration: Duration(milliseconds: 100),
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Wait for auto-start
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      finishTest(tester);
    });

    testWidgets('should repeat animations', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            repeatInfinity: true,
            delayDuration: Duration(milliseconds: 50),
            pauseRepeatInfinityDelay: Duration(milliseconds: 100),
            durationIn: Duration(milliseconds: 50),
            durationOut: Duration(milliseconds: 50),
            pauseDuration: Duration(milliseconds: 25),
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Wait for first cycle
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Wait for repeat
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();
      finishTest(tester);
    });

    testWidgets('should handle different directions',
        (WidgetTester tester) async {
      // Test leftToRight
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            direction: LightningDirection.leftToRight,
            delayDuration: Duration(milliseconds: 50),
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Test rightToLeft
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            direction: LightningDirection.rightToLeft,
            delayDuration: Duration(milliseconds: 50),
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );
      await tester.pumpAndSettle();
      finishTest(tester);
    });

    testWidgets('should dispose properly', (WidgetTester tester) async {
      final controller = LightningController();

      await tester.pumpWidget(
        MaterialApp(
          home: Lightning(
            controller: controller,
            delayDuration: null, // Disable auto-start
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Remove widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      // Controller sollte noch funktionieren (aber nichts tun)
      expect(() => controller.animateIn(), returnsNormally);

      finishTest(tester);
    });

    testWidgets('should handle border radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            borderRadius: 10.0,
            delayDuration: null,
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Lightning), findsOneWidget);
      finishTest(tester);
    });

    testWidgets('should handle custom overlay color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            overlayColor: Colors.red,
            delayDuration: null,
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Lightning), findsOneWidget);
      finishTest(tester);
    });

    testWidgets('should handle custom curves', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            curveIn: Curves.bounceIn,
            curveOut: Curves.bounceOut,
            delayDuration: Duration(milliseconds: 50),
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();
      finishTest(tester);
    });
  });

  group('Lightning Animation Tests', () {
    testWidgets('should not start auto animation when controller is provided',
        (WidgetTester tester) async {
      final controller = LightningController();

      await tester.pumpWidget(
        MaterialApp(
          home: Lightning(
            controller: controller,
            delayDuration: const Duration(milliseconds: 50),
            child: const SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Auto-start sollte nicht passieren wenn controller provided ist
      await tester.pump(const Duration(milliseconds: 100));

      finishTest(tester);
    });

    testWidgets('should handle gesture controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            useGesture: true,
            delayDuration: null, // Disable auto-start
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final lightningWidget = find.byType(Lightning);

      // Start a gesture
      final gesture =
          await tester.startGesture(tester.getCenter(lightningWidget));
      await tester.pump();

      // Release gesture (equivalent zu tap up)
      await gesture.up();
      await tester.pump();
      await tester.pumpAndSettle();
      finishTest(tester);
    });

    testWidgets('should handle gesture cancel', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            useGesture: true,
            delayDuration: null,
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final lightningWidget = find.byType(Lightning);

      // Start gesture (Tap Down)
      final gesture =
          await tester.startGesture(tester.getCenter(lightningWidget));
      await tester.pump();

      // Cancel the gesture
      await gesture.cancel();
      await tester.pump();
      await tester.pumpAndSettle();
      finishTest(tester);
    });
  });

  group('Memory Leak Tests', () {
    testWidgets('should not leak memory on multiple builds',
        (WidgetTester tester) async {
      for (int i = 0; i < 10; i++) {
        await tester.pumpWidget(
          MaterialApp(
            home: Lightning(
              key: ValueKey(i),
              delayDuration: null, // Disable auto-start for performance
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );
        await tester.pump(); // Don't wait for settle to speed up test
      }
      finishTest(tester);
    });

    testWidgets('should handle rapid dispose/create cycles',
        (WidgetTester tester) async {
      for (int i = 0; i < 5; i++) {
        final controller = LightningController();

        await tester.pumpWidget(
          MaterialApp(
            home: Lightning(
              controller: controller,
              delayDuration: null,
              child: const SizedBox(width: 100, height: 100),
            ),
          ),
        );

        await tester.pump();

        await tester.pumpWidget(const MaterialApp(home: SizedBox()));

        await finishTest(tester);
      }
    });
  });

  group('Edge Cases', () {
    testWidgets('should handle zero size child', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Lightning(
            delayDuration: null,
            child: SizedBox(width: 0, height: 0),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Lightning), findsOneWidget);
      finishTest(tester);
    });

    testWidgets('should handle very large child', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Lightning(
            delayDuration: null,
            child: Container(width: 1000, height: 1000, color: Colors.red),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Lightning), findsOneWidget);
      finishTest(tester);
    });

    testWidgets('should handle multiple controllers',
        (WidgetTester tester) async {
      final controller1 = LightningController();
      final controller2 = LightningController();

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Lightning(
                controller: controller1,
                delayDuration: null,
                child: const SizedBox(width: 100, height: 100),
              ),
              Lightning(
                controller: controller2,
                delayDuration: null,
                child: const SizedBox(width: 100, height: 100),
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      controller1.animateIn();
      controller2.animateIn();

      await tester.pump();

      controller1.dispose();
      controller2.dispose();
      finishTest(tester);
    });
  });
}
