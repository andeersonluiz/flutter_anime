import 'package:animes_io/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:animes_io/features/anime/presentation/widgets/anime_card.dart';
import 'package:animes_io/features/anime/presentation/widgets/anime_search_tile.dart';

Future<void> pumpUntilFound(WidgetTester tester, Finder finder,
    {int maxIterations = 30}) async {
  for (int i = 0; i < maxIterations; i++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (tester.any(finder)) return;
  }
  throw Exception('Timeout waiting for $finder');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End (E2E) Comprehensive App Flow Test', () {
    testWidgets(
        'Validates main user journey across all tabs, dialogs and search',
        (tester) async {
      try {
        // 1. Boot application
        await app.main();
        await tester.pump(const Duration(seconds: 3));

        // 2. Verify Home Page loaded with main title and bottom navigation bar
        expect(find.text('Animes IO'), findsOneWidget);
        expect(find.byType(NavigationBar), findsOneWidget);

        // --- 2.1 Test AnimeDetailsPage Deep Dive ---
        // Find the first AnimeCard and tap it to enter details
        final animeCardFinder = find.byType(AnimeCard);
        await pumpUntilFound(tester, animeCardFinder);
        final firstAnimeCard = animeCardFinder.first;
        expect(firstAnimeCard, findsOneWidget);
        await tester.tap(firstAnimeCard);
        await tester.pump(const Duration(seconds: 2));

        // Verify AnimeDetailsPage is open (checking for TabBar)
        expect(find.byType(TabBar), findsOneWidget);

        // Return to Home Page
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pump(const Duration(seconds: 2));

        // 3. Test Search Delegate trigger from Home AppBar
        final searchIcon = find.byIcon(Icons.search);
        expect(searchIcon, findsOneWidget);
        await tester.tap(searchIcon);
        await tester.pump(const Duration(seconds: 1));

        // --- 3.1 Test Search Functionality ---
        // Enter text into the search field
        final searchField = find.byType(TextField);
        expect(searchField, findsOneWidget);
        await tester.enterText(searchField, 'Naruto');

        // wait for debounce and network
        final searchTileFinder = find.byType(AnimeSearchTile);
        await pumpUntilFound(tester, searchTileFinder);

        // Verify AnimeSearchTile is present
        expect(searchTileFinder, findsWidgets);

        // Close search delegate back to home
        final backIcon = find.byIcon(Icons.arrow_back);
        expect(backIcon, findsWidgets);
        await tester.tap(backIcon.first);
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
        final themeSwitch = find.byType(SwitchListTile);
        expect(themeSwitch, findsOneWidget);

        // Toggle theme
        await tester.tap(themeSwitch);
        await tester.pump(const Duration(seconds: 1));

        // 8. Return safely to Home Tab (Branch 0)
        final homeTab = find.byIcon(Icons.home_outlined);
        expect(homeTab, findsOneWidget);
        await tester.tap(homeTab);
        await tester.pump(const Duration(seconds: 2));

        // Final assertion: App state is intact
        expect(find.text('Animes IO'), findsOneWidget);
      } catch (e, stack) {
        debugPrint('❌ E2E TEST EXCEPTION: $e');
        debugPrint('STACK TRACE:\n$stack');
        rethrow;
      }
    });
  });
}
