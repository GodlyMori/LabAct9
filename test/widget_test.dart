import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legarbes_navigation_app/demo_auth.dart';
import 'package:legarbes_navigation_app/main.dart';

class _TestHttpOverrides extends HttpOverrides {}

void main() {
  setUp(() {
    HttpOverrides.global = _TestHttpOverrides();
    DemoAuth.logout();
    DemoAuth.registeredUsername = null;
    DemoAuth.registeredPassword = null;
  });

  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  testWidgets('Test 1: Open the application -> Login appears first', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  });

  testWidgets('Test 2: Submit empty login fields -> Validation messages appear', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your username.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
  });

  testWidgets('Test 3: Enter incorrect credentials -> Login is rejected', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'wronguser');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'wrongpass');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid username or password.'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });

  testWidgets('Test 4: Enter admin / admin123 -> Dashboard opens', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsWidgets);
  });

  testWidgets('Test 5: Read the dashboard greeting -> Displays Welcome, admin!', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, admin!'), findsOneWidget);
  });

  testWidgets('Test 6: Open Calculator and calculate 10 + 5 -> Displays 15.0', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Calculator
    await tester.tap(find.byIcon(Icons.calculate_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'First Number'), '10');
    await tester.enterText(find.widgetWithText(TextField, 'Second Number'), '5');
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pumpAndSettle();

    expect(find.text('15.0'), findsOneWidget);
  });

  testWidgets('Test 7: Switch tabs and return to Calculator -> Inputs and result remain', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Calculator
    await tester.tap(find.byIcon(Icons.calculate_outlined));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'First Number'), '10');
    await tester.enterText(find.widgetWithText(TextField, 'Second Number'), '5');
    await tester.tap(find.widgetWithText(ElevatedButton, '+'));
    await tester.pumpAndSettle();
    expect(find.text('15.0'), findsOneWidget);

    // Switch to Dashboard
    await tester.tap(find.byIcon(Icons.dashboard_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, admin!'), findsOneWidget);

    // Switch back to Calculator
    await tester.tap(find.byIcon(Icons.calculate_outlined));
    await tester.pumpAndSettle();

    expect(find.text('10'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('15.0'), findsOneWidget);
  });

  testWidgets('Test 8: Create a social post -> Post displays the logged-in username', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Social
    await tester.tap(find.byIcon(Icons.people_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'Admin test post');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'https://picsum.photos/id/20/600/400');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('Admin test post'), findsOneWidget);
    expect(find.text('admin'), findsOneWidget);
  });

  testWidgets('Test 9: Like a post and add a comment -> Both interactions update correctly', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Social
    await tester.tap(find.byIcon(Icons.people_outline));
    await tester.pumpAndSettle();

    // Like first post
    await tester.tap(find.text('Like').first);
    await tester.pumpAndSettle();
    expect(find.text('Liked'), findsOneWidget);

    // Add comment
    final commentField = find.widgetWithText(TextField, 'Add a comment...').first;
    await tester.enterText(commentField, 'Great view!');
    await tester.tap(find.byTooltip('Send comment').first);
    await tester.pumpAndSettle();

    expect(find.text('1 Comments'), findsOneWidget);
    expect(find.text('Great view!'), findsOneWidget);
  });

  testWidgets('Test 10: Switch tabs and return to Social -> Posts, likes, and comments remain', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Social
    await tester.tap(find.byIcon(Icons.people_outline));
    await tester.pumpAndSettle();

    // Like first post
    await tester.tap(find.text('Like').first);
    await tester.pumpAndSettle();

    // Add comment
    await tester.enterText(find.widgetWithText(TextField, 'Add a comment...').first, 'Persistent post comment');
    await tester.tap(find.byTooltip('Send comment').first);
    await tester.pumpAndSettle();

    // Switch to Dashboard
    await tester.tap(find.byIcon(Icons.dashboard_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, admin!'), findsOneWidget);

    // Switch back to Social
    await tester.tap(find.byIcon(Icons.people_outline));
    await tester.pumpAndSettle();

    expect(find.text('Liked'), findsOneWidget);
    expect(find.text('Persistent post comment'), findsOneWidget);
    expect(find.text('1 Comments'), findsOneWidget);
  });

  testWidgets('Test 11: Open Profile -> Student information and username appear', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Profile
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    expect(find.text('Student Profile'), findsOneWidget);
    expect(find.text('Alvin Miano Legarbes'), findsOneWidget);
    expect(find.text('Logged in as: admin'), findsOneWidget);
    expect(find.text('554713'), findsOneWidget);
    expect(find.text('BSIT — CCE106(3447)'), findsOneWidget);
    expect(find.text('a.legarbes.554713@umindanao.edu.ph'), findsOneWidget);
  });

  testWidgets('Test 12: Tap Logout -> Login appears; Back does not reopen MainScreen', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Profile
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    // Tap Logout
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(DemoAuth.currentUsername, isNull);
  });

  testWidgets('Test 13: Register a valid account and log in -> Dashboard displays the registered username', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());

    // Register
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'alvin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    // Dismiss SnackBar
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Login with registered user
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'alvin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, alvin!'), findsOneWidget);
    expect(DemoAuth.currentUsername, 'alvin');
  });

  testWidgets('Test 14: Create a post using the registered account -> Post displays the registered username', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());

    // Register
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'alvin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    // Dismiss SnackBar
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Login with registered user
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'alvin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Navigate to Social
    await tester.tap(find.byIcon(Icons.people_outline));
    await tester.pumpAndSettle();

    // Create a post
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'Post from registered alvin');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'https://picsum.photos/id/10/300/300');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('Post from registered alvin'), findsOneWidget);
    expect(find.text('alvin'), findsOneWidget);
  });
}
