import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_router.dart';
import '../../../anime/domain/entities/anime.dart';
import '../../../anime/domain/usecases/get_anime_details.dart';

class FavoriteAnimeTile extends StatefulWidget {
  final String animeId;
  final VoidCallback onRemove;

  const FavoriteAnimeTile({
    super.key,
    required this.animeId,
    required this.onRemove,
  });

  @override
  State<FavoriteAnimeTile> createState() => _FavoriteAnimeTileState();
}

class _FavoriteAnimeTileState extends State<FavoriteAnimeTile> {
  late Future<Anime?> _animeFuture;

  @override
  void initState() {
    super.initState();
    _animeFuture = _fetchAnimeDetails();
  }

  Future<Anime?> _fetchAnimeDetails() async {
    final getAnimeDetails = sl<GetAnimeDetails>();
    final result = await getAnimeDetails(
      GetAnimeDetailsParams(id: widget.animeId),
    );
    return result.fold(
      (failure) => null,
      (anime) => anime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Anime?>(
      future: _animeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Container(
              height: 80,
              padding: const EdgeInsets.all(12),
              child: const Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 64,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Carregando informações do anime...'),
                ],
              ),
            ),
          );
        }

        final anime = snapshot.data;

        if (anime == null) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.movie, color: Colors.grey),
              title: Text('Anime ID: ${widget.animeId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: widget.onRemove,
              ),
            ),
          );
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.push(
                '/anime/${anime.id}',
                extra: AnimeRouteArgs(
                  anime: anime,
                  isFavorite: true,
                  fromRoute: 'favorites',
                ),
              );
            },
            child: Row(
              children: [
                Hero(
                  tag: 'fav_anime_${anime.id}',
                  child: Image.network(
                    anime.posterImage ?? anime.coverImage ?? '',
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 100,
                      color: Colors.grey.shade800,
                      child: const Icon(Icons.movie, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            if (anime.rating != null) ...[
                              const Icon(Icons.star,
                                  size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                anime.rating!.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: 12),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                anime.status.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.redAccent),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
