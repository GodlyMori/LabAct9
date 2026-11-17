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

  testWidgets('Test 1: Log in using the default admin account -> MainScreen opens', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    expect(find.text('Welcome Back!'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Student!'), findsOneWidget);
    expect(DemoAuth.currentUsername, 'admin');
  });

  testWidgets('Test 2: Open Social Media -> Sample posts appear', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Switch to Social Media tab
    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    expect(find.text('JohnDoe'), findsOneWidget);
    expect(find.text('Enjoying the sunny weather!'), findsOneWidget);
    expect(find.text('JaneSmith'), findsOneWidget);
    expect(find.text('Just finished a great book!'), findsOneWidget);
  });

  testWidgets('Test 3: Submit a post with empty fields -> Validation message appears', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Create Post'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('Complete both fields before submitting!'), findsOneWidget);
  });

  testWidgets('Test 4: Submit a post with an invalid URL -> URL validation message appears', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'Test Caption');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'not_a_valid_url');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid HTTP or HTTPS image URL.'), findsOneWidget);
  });

  testWidgets('Test 5: Submit a valid post -> New post appears at the top with the logged-in username', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'My first Flutter social media post!');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'https://picsum.photos/id/20/600/400');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('My first Flutter social media post!'), findsOneWidget);
    expect(find.text('admin'), findsOneWidget);
  });

  testWidgets('Test 6: Tap Like twice -> Changes to Liked, then back to Like', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    // Tap Like
    await tester.tap(find.text('Like').first);
    await tester.pumpAndSettle();

    expect(find.text('Liked'), findsOneWidget);

    // Tap Liked to unlike
    await tester.tap(find.text('Liked').first);
    await tester.pumpAndSettle();

    expect(find.text('Liked'), findsNothing);
    expect(find.text('Like'), findsWidgets);
  });

  testWidgets('Test 7: Add a nonempty comment -> Comment appears and count increases', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    expect(find.text('0 Comments'), findsWidgets);

    // Add comment
    final commentField = find.widgetWithText(TextField, 'Add a comment...').first;
    await tester.enterText(commentField, 'Awesome photo!');
    await tester.tap(find.byTooltip('Send comment').first);
    await tester.pumpAndSettle();

    expect(find.text('1 Comments'), findsOneWidget);
    expect(find.text('Awesome photo!'), findsOneWidget);
  });

  testWidgets('Test 8: Submit a blank comment -> No comment is added', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    expect(find.text('0 Comments'), findsWidgets);

    // Tap send without typing
    await tester.tap(find.byTooltip('Send comment').first);
    await tester.pumpAndSettle();

    expect(find.text('0 Comments'), findsWidgets);
  });

  testWidgets('Test 9: Like a sample post, then create another post -> The original post keeps its liked state', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    // Like JohnDoe's post
    await tester.tap(find.text('Like').first);
    await tester.pumpAndSettle();
    expect(find.text('Liked'), findsOneWidget);

    // Create another post
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'New post above');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'https://picsum.photos/id/1/200/200');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    // JohnDoe post still has 'Liked'
    expect(find.text('Liked'), findsOneWidget);
  });

  testWidgets('Test 10: Switch to Home and return -> Posts, likes, and comments remain', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    // Like first post
    await tester.tap(find.text('Like').first);
    await tester.pumpAndSettle();

    // Comment on first post
    await tester.enterText(find.widgetWithText(TextField, 'Add a comment...').first, 'Persistent comment');
    await tester.tap(find.byTooltip('Send comment').first);
    await tester.pumpAndSettle();

    // Switch to Home
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Student!'), findsOneWidget);

    // Switch back to Social Media
    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Liked'), findsOneWidget);
    expect(find.text('Persistent comment'), findsOneWidget);
    expect(find.text('1 Comments'), findsOneWidget);
  });

  testWidgets('Test 11: Log out, register, and log in with a new account -> New posts use the registered username', (WidgetTester tester) async {
    setLargeScreen(tester);
    await tester.pumpWidget(const StudentApp());

    // Login as admin
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'admin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'admin123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Go to Profile and Log out
    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back!'), findsOneWidget);

    // Register a new user
    await tester.tap(find.text("Don't have an account? Register"));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'alvin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.enterText(find.widgetWithText(TextFormField, 'Confirm Password'), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle();

    // Wait for the SnackBar from registration to clear
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    // Login with new user
    await tester.enterText(find.widgetWithText(TextFormField, 'Username'), 'alvin');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(DemoAuth.currentUsername, 'alvin');

    // Switch to Social Media tab
    await tester.tap(find.byIcon(Icons.share_outlined));
    await tester.pumpAndSettle();

    // Create post
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Create Post'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Caption'), 'Post from alvin');
    await tester.enterText(find.widgetWithText(TextField, 'Image URL'), 'https://picsum.photos/id/10/300/300');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Post'));
    await tester.pumpAndSettle();

    expect(find.text('Post from alvin'), findsOneWidget);
    expect(find.text('alvin'), findsOneWidget);
  });
}
