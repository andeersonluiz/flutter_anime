import 'package:animes_io/core/error/failures.dart';
import 'package:animes_io/features/character/domain/entities/character.dart';
import 'package:animes_io/features/character/domain/usecases/get_characters.dart';
import 'package:animes_io/features/character/presentation/bloc/character_bloc.dart';
import 'package:animes_io/features/character/presentation/bloc/character_event.dart';
import 'package:animes_io/features/character/presentation/bloc/character_state.dart';
import 'package:animes_io/features/episode/domain/entities/episode.dart';
import 'package:animes_io/features/episode/domain/usecases/get_episodes.dart';
import 'package:animes_io/features/episode/presentation/bloc/episode_bloc.dart';
import 'package:animes_io/features/episode/presentation/bloc/episode_event.dart';
import 'package:animes_io/features/episode/presentation/bloc/episode_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'character/character_test.dart';
import 'episode/episode_test.dart';

void main() {
  group('CharacterBloc pagination & error branches', () {
    late MockGetCharacters mockGetCharacters;
    late MockGetAnimeCharacters mockGetAnimeCharacters;

    setUp(() {
      mockGetCharacters = MockGetCharacters();
      mockGetAnimeCharacters = MockGetAnimeCharacters();
    });

    CharacterBloc buildBloc() => CharacterBloc(
          getCharacters: mockGetCharacters,
          getAnimeCharacters: mockGetAnimeCharacters,
        );

    blocTest<CharacterBloc, CharacterState>(
      'LoadMoreCharacters appends characters on success when hasMore=true',
      build: () {
        // Return 20 items for first page so hasMore = true
        final page1 = List.generate(
          20,
          (i) => Character(id: '$i', name: 'Char $i', image: 'url'),
        );
        final page2 = [
          const Character(id: '99', name: 'Char 99', image: 'url')
        ];

        var calls = 0;
        when(() => mockGetCharacters(offset: any(named: 'offset'), limit: 20))
            .thenAnswer((_) async {
          calls++;
          return calls == 1 ? Right(page1) : Right(page2);
        });
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(LoadCharacters());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(LoadMoreCharacters());
      },
      expect: () => [
        CharacterLoading(),
        isA<CharacterLoaded>().having((s) => s.characters.length, 'length', 20),
        isA<CharacterLoaded>().having((s) => s.characters.length, 'length', 21),
      ],
    );

    blocTest<CharacterBloc, CharacterState>(
      'LoadMoreCharacters emits CharacterError when fetch fails',
      build: () {
        final page1 = List.generate(
          20,
          (i) => Character(id: '$i', name: 'Char $i', image: 'url'),
        );

        var calls = 0;
        when(() => mockGetCharacters(offset: any(named: 'offset'), limit: 20))
            .thenAnswer((_) async {
          calls++;
          return calls == 1
              ? Right(page1)
              : const Left(ServerFailure('page2 error'));
        });
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(LoadCharacters());
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(LoadMoreCharacters());
      },
      expect: () => [
        CharacterLoading(),
        isA<CharacterLoaded>(),
        const CharacterError(message: 'page2 error'),
      ],
    );
  });

  group('EpisodeBloc pagination & error branches', () {
    late MockGetEpisodes mockGetEpisodes;

    setUp(() => mockGetEpisodes = MockGetEpisodes());

    EpisodeBloc buildBloc() => EpisodeBloc(getEpisodes: mockGetEpisodes);

    blocTest<EpisodeBloc, EpisodeState>(
      'LoadMoreEpisodes appends episodes when hasMore=true',
      build: () {
        final page1 = List.generate(
          20,
          (i) => Episode(id: 'ep$i', episodeNumber: i + 1),
        );
        final page2 = [const Episode(id: 'ep99', episodeNumber: 21)];

        var calls = 0;
        when(() => mockGetEpisodes('anime1',
            offset: any(named: 'offset'), limit: 20)).thenAnswer((_) async {
          calls++;
          return calls == 1 ? Right(page1) : Right(page2);
        });
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const LoadEpisodes('anime1'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const LoadMoreEpisodes('anime1'));
      },
      expect: () => [
        EpisodeLoading(),
        isA<EpisodeLoaded>().having((s) => s.episodes.length, 'length', 20),
        isA<EpisodeLoaded>().having((s) => s.episodes.length, 'length', 21),
      ],
    );

    blocTest<EpisodeBloc, EpisodeState>(
      'LoadMoreEpisodes emits EpisodeError on pagination failure',
      build: () {
        final page1 = List.generate(
          20,
          (i) => Episode(id: 'ep$i', episodeNumber: i + 1),
        );

        var calls = 0;
        when(() => mockGetEpisodes('anime1',
            offset: any(named: 'offset'), limit: 20)).thenAnswer((_) async {
          calls++;
          return calls == 1
              ? Right(page1)
              : const Left(ServerFailure('episode page2 error'));
        });
        return buildBloc();
      },
      act: (bloc) async {
        bloc.add(const LoadEpisodes('anime1'));
        await Future<void>.delayed(const Duration(milliseconds: 50));
        bloc.add(const LoadMoreEpisodes('anime1'));
      },
      expect: () => [
        EpisodeLoading(),
        isA<EpisodeLoaded>(),
        const EpisodeError('episode page2 error'),
      ],
    );
  });
}
