import 'package:animes_io/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End (E2E) Comprehensive App Flow Test', () {
    testWidgets(
        'Validates main user journey across all tabs, dialogs and search',
        (tester) async {
      // 1. Boot application
      await app.main();
      await tester.pump(const Duration(seconds: 3));

      // 2. Verify Home Page loaded with main title and bottom navigation bar
      expect(find.text('Animes IO'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);

      // 3. Test Search Delegate trigger from Home AppBar
      final searchIcon = find.byIcon(Icons.search);
      expect(searchIcon, findsOneWidget);
      await tester.tap(searchIcon);
      await tester.pump(const Duration(seconds: 1));

      // Close search delegate back to home
      await tester.pageBack();
      await tester.pump(const Duration(seconds: 1));

      // 4. Navigate to Categories Tab (Branch 1)
      final categoriesTab = find.byIcon(Icons.category_outlined);
      expect(categoriesTab, findsOneWidget);
      await tester.tap(categoriesTab);
      await tester.pump(const Duration(seconds: 2));

      // 5. Navigate to Characters Tab (Branch 2)
      final charactersTab = find.byIcon(Icons.people_outline);
      expect(charactersTab, findsOneWidget);
      await tester.tap(charactersTab);
      await tester.pump(const Duration(seconds: 2));

      // 6. Navigate to Favorites Tab (Branch 3 - Unauthenticated State)
      final favoritesTab = find.byIcon(Icons.favorite_outline);
      expect(favoritesTab, findsOneWidget);
      await tester.tap(favoritesTab);
      await tester.pump(const Duration(seconds: 2));

      // Verify Login button appears for unauthenticated user on Favorites tab
      final loginBtn = find.byIcon(Icons.login);
      expect(loginBtn, findsWidgets);

      // 7. Navigate to Profile & Settings Tab (Branch 4)
      final profileTab = find.byIcon(Icons.person_outline);
      expect(profileTab, findsOneWidget);
      await tester.tap(profileTab);
      await tester.pump(const Duration(seconds: 2));

      // Verify Dark Mode switch is present
      expect(find.byType(SwitchListTile), findsOneWidget);

      // 8. Return safely to Home Tab (Branch 0)
      final homeTab = find.byIcon(Icons.home_outlined);
      expect(homeTab, findsOneWidget);
      await tester.tap(homeTab);
      await tester.pump(const Duration(seconds: 2));

      // Final assertion: App state is intact
      expect(find.text('Animes IO'), findsOneWidget);
    });
  });
}
