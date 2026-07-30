import 'package:animes_io/core/utils/app_localization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLocalization Tests', () {
    test('init loads language maps and translates keys correctly', () async {
      await AppLocalization.init('en');

      // Test English translation
      expect(AppLocalization.currentLanguage, equals('en'));
      expect(
        AppLocalization.translate('drawer_options.home'),
        equals('Home'),
      );
      expect(
        AppLocalization.translate('drawer_options.categories'),
        equals('Categories'),
      );
      expect(
        AppLocalization.translate('drawer_options.my_favorites'),
        equals('Favorites'),
      );

      // Switch language to Portuguese
      AppLocalization.setLanguage('pt');
      expect(AppLocalization.currentLanguage, equals('pt'));

      expect(
        AppLocalization.translate('drawer_options.home'),
        equals('Início'),
      );
      expect(
        AppLocalization.translate('drawer_options.categories'),
        equals('Categorias'),
      );
      expect(
        AppLocalization.translate('drawer_options.my_favorites'),
        equals('Favoritos'),
      );
    });

    test('translate returns key if key is missing in map', () async {
      await AppLocalization.init('en');
      expect(
        AppLocalization.translate('non_existent_key'),
        equals('non_existent_key'),
      );
    });
  });
}
