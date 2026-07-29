import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/anime/data/datasources/anime_local_datasource.dart';
import '../../features/anime/data/datasources/anime_remote_datasource.dart';
import '../../features/anime/data/repositories/anime_repository_impl.dart';
import '../../features/anime/domain/repositories/anime_repository.dart';
import '../../features/anime/domain/usecases/get_animes_by_category.dart';
import '../../features/anime/domain/usecases/get_anime_details.dart';
import '../../features/anime/domain/usecases/get_currently_airing_animes.dart';
import '../../features/anime/domain/usecases/get_most_popular_animes.dart';
import '../../features/anime/domain/usecases/get_top_rated_animes.dart';
import '../../features/anime/domain/usecases/get_trending_animes.dart';
import '../../features/anime/domain/usecases/get_upcoming_animes.dart';
import '../../features/anime/domain/usecases/search_animes.dart';
import '../../features/anime/presentation/bloc/anime_bloc.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/sign_in_as_guest.dart';
import '../../features/auth/domain/usecases/sign_in_with_email.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/update_user_profile.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/category/data/datasources/category_remote_datasource.dart';
import '../../features/category/data/repositories/category_repository_impl.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/category/domain/usecases/get_all_categories.dart';
import '../../features/category/domain/usecases/get_trending_categories.dart';
import '../../features/category/presentation/bloc/category_bloc.dart';
import '../../features/character/data/datasources/character_remote_datasource.dart';
import '../../features/character/data/repositories/character_repository_impl.dart';
import '../../features/character/domain/repositories/character_repository.dart';
import '../../features/character/domain/usecases/get_anime_characters.dart';
import '../../features/character/domain/usecases/get_characters.dart';
import '../../features/character/presentation/bloc/character_bloc.dart';
import '../../features/episode/data/datasources/episode_remote_datasource.dart';
import '../../features/episode/data/repositories/episode_repository_impl.dart';
import '../../features/episode/domain/repositories/episode_repository.dart';
import '../../features/episode/domain/usecases/get_episodes.dart';
import '../../features/episode/presentation/bloc/episode_bloc.dart';
import '../../features/favorites/data/datasources/favorites_remote_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/toggle_favorite.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/change_language.dart';
import '../../features/settings/domain/usecases/toggle_theme.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../network/api_client.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initExternal();
  _initCore();
  _initAnimeFeature();
  _initCharacterFeature();
  _initCategoryFeature();
  _initAuthFeature();
  _initFavoritesFeature();
  _initSettingsFeature();
  _initEpisodeFeature();
}

Future<void> _initExternal() async {
  await Hive.initFlutter();

  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPrefs);

  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
}

void _initCore() {
  sl.registerLazySingleton<ApiClient>(ApiClient.new);
}

void _initAnimeFeature() {
  sl.registerLazySingleton<AnimeRemoteDataSource>(
    () => AnimeRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AnimeLocalDataSource>(
    AnimeLocalDataSourceImpl.new,
  );

  sl.registerLazySingleton<AnimeRepository>(
    () => AnimeRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetTrendingAnimes(sl()));
  sl.registerLazySingleton(() => GetMostPopularAnimes(sl()));
  sl.registerLazySingleton(() => GetTopRatedAnimes(sl()));
  sl.registerLazySingleton(() => GetUpcomingAnimes(sl()));
  sl.registerLazySingleton(() => GetCurrentlyAiringAnimes(sl()));
  sl.registerLazySingleton(() => GetAnimeDetails(sl()));
  sl.registerLazySingleton(() => SearchAnimes(sl()));
  sl.registerLazySingleton(() => GetAnimesByCategory(sl()));

  sl.registerFactory(
    () => AnimeBloc(
      getTrendingAnimes: sl(),
      getMostPopularAnimes: sl(),
      getTopRatedAnimes: sl(),
      getUpcomingAnimes: sl(),
      getCurrentlyAiringAnimes: sl(),
      getAnimeDetails: sl(),
      searchAnimes: sl(),
      getAnimesByCategory: sl(),
    ),
  );
}

void _initCharacterFeature() {
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetCharacters(sl()));
  sl.registerLazySingleton(() => GetAnimeCharacters(sl()));
  sl.registerFactory(
    () => CharacterBloc(
      getCharacters: sl(),
      getAnimeCharacters: sl(),
    ),
  );
}

void _initCategoryFeature() {
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetTrendingCategories(sl()));
  sl.registerLazySingleton(() => GetAllCategories(sl()));
  sl.registerFactory(
    () => CategoryBloc(
      getTrendingCategories: sl(),
      getAllCategories: sl(),
    ),
  );
}

void _initAuthFeature() {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInAsGuest(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => UpdateUserProfile(sl()));
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmail: sl(),
      signInWithGoogle: sl(),
      signInAsGuest: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      updateUserProfile: sl(),
    ),
  );
}

void _initFavoritesFeature() {
  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));
  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      toggleFavorite: sl(),
    ),
  );
}

void _initSettingsFeature() {
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => ToggleTheme(sl()));
  sl.registerLazySingleton(() => ChangeLanguage(sl()));
  sl.registerFactory(
    () => SettingsBloc(
      repository: sl(),
      toggleTheme: sl(),
      changeLanguage: sl(),
    ),
  );
}

void _initEpisodeFeature() {
  sl.registerLazySingleton<EpisodeRemoteDataSource>(
    () => EpisodeRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<EpisodeRepository>(
    () => EpisodeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetEpisodes(sl()));
  sl.registerFactory(
    () => EpisodeBloc(getEpisodes: sl()),
  );
}
