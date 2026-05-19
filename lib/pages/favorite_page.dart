import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/tv_show.dart';
import '../services/favorite_service.dart';
import '../widgets/app_theme.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Future<void> _removeFavorite(TvShow show) async {
    await FavoriteService.removeFavorite(show.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${show.name} dihapus dari favorit',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.card,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppColors.primary,
            onPressed: () => FavoriteService.addFavorite(show),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Daftar Favorit',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TvShow>('favorites').listenable(),
        builder: (context, box, _) {
          final favorites = box.values.toList().reversed.toList();

          if (favorites.isEmpty) {
            return _buildEmpty();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final show = favorites[index];
              return _buildFavoriteItem(show);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              color: AppColors.textMuted,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Belum ada favorit',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan show favoritmu dari halaman detail',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteItem(TvShow show) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(showId: show.id)),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 60,
                height: 80,
                child: show.mediumImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: show.mediumImageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surface,
                          child: const Icon(Icons.movie_outlined,
                              color: AppColors.textMuted),
                        ),
                      )
                    : Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.movie_outlined,
                            color: AppColors.textMuted),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (show.rating != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppColors.accent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          show.rating!.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            color: AppColors.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (show.genres.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      show.genres.take(2).join(', '),
                      style: GoogleFonts.poppins(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: () => _removeFavorite(show),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
