import 'package:battery_info_app/battery_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  const MethodChannel channel = MethodChannel('battery');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
          (MethodCall methodCall) async {
        if (methodCall.method == 'getBatteryInformation') {
          return 42; // Mocked battery level
        }
        throw PlatformException(code: 'UNAVAILABLE', message: 'Battery information not available.');
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  testWidgets('BatteryInfoWidget shows battery information', (WidgetTester tester) async {
    await tester.pumpWidget(const BatterInfoWidget());

    // Arrange
    expect(find.text('Unknown battery level.'), findsOneWidget);
    expect(find.text('Battery Information at 42%'), findsNothing);

    // Act
    await tester.pumpAndSettle();

    // Asser
    expect(find.text('Battery Information at 42%'), findsOneWidget);
  });

  testWidgets('shows error message', (WidgetTester tester) async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
          (MethodCall methodCall) async {
        throw PlatformException(code: 'UNAVAILABLE', message: 'Battery information not available.');
      },
    );

    await tester.pumpWidget(const BatterInfoWidget());

    // Arrange
    expect(find.text('Unknown battery level.'), findsOneWidget);
    expect(find.text("Failed to get battery Information: 'Battery information not available.'"), findsNothing);

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text("Failed to get battery Information: 'Battery information not available.'"), findsOneWidget);
  });
}
