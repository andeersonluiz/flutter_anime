import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../core/utils/responsive.dart';
import '../../../../character/presentation/bloc/character_bloc.dart';
import '../../../../character/presentation/bloc/character_event.dart';
import '../../../../character/presentation/bloc/character_state.dart';
import '../../../domain/entities/anime.dart';

class CharactersTab extends StatelessWidget {
  const CharactersTab({super.key, required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CharacterBloc>()..add(LoadAnimeCharacters(anime.id)),
      child: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CharacterError) {
            return Center(child: Text(state.message));
          } else if (state is CharacterLoaded) {
            final characters = state.characters;
            if (characters.isEmpty) {
              return const Center(child: Text('No characters found.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.characterGridColumns(context),
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return Card(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          character.image ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.person),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          character.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
