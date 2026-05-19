import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tv_show.dart';
import '../widgets/app_theme.dart';

class ShowCard extends StatelessWidget {
  final TvShow show;
  final VoidCallback onTap;

  const ShowCard({super.key, required this.show, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xCC000000),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (show.rating != null)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xCC000000),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.accent,
                              size: 13,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              show.rating!.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                show.name,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = show.mediumImageUrl ?? show.imageUrl;
    if (imageUrl == null) {
      return Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(Icons.movie_outlined, color: AppColors.textMuted, size: 48),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surface,
        child: const Center(
          child: Icon(Icons.broken_image_outlined, color: AppColors.textMuted, size: 48),
        ),
      ),
    );
  }
}
