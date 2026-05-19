// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../models/tv_show.dart';
import '../services/tv_maze_service.dart';
import '../services/favorite_service.dart';
import '../widgets/app_theme.dart';

class DetailPage extends StatefulWidget {
  final int showId;

  const DetailPage({super.key, required this.showId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TvShow? _show;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final show = await TvMazeService.fetchShowDetail(widget.showId);
      if (mounted) {
        setState(() {
          _show = show;
          _isFavorite = FavoriteService.isFavorite(show.id);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat detail show.';
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    if (_show == null) return;

    await FavoriteService.toggleFavorite(_show!);
    setState(() => _isFavorite = FavoriteService.isFavorite(_show!.id));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavorite ? '❤️ Ditambahkan ke favorit!' : '💔 Dihapus dari favorit',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: _isFavorite ? AppColors.primary : AppColors.card,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? _buildLoading()
          : _errorMessage != null
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.textMuted, size: 64),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _loadDetail, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final show = _show!;
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(show),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(show),
                const SizedBox(height: 12),
                if (show.genres.isNotEmpty) _buildGenres(show.genres),
                const SizedBox(height: 20),
                _buildActionButtons(),
                const SizedBox(height: 24),
                if (show.summary != null) ...[
                  Text(
                    'Overview',
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Html(
                    data: show.summary,
                    style: {
                      "body": Style(
                        color: AppColors.textSecondary,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: FontSize(14),
                        lineHeight: const LineHeight(1.6),
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                      ),
                    },
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(TvShow show) {
    final imageUrl = show.imageUrl ?? show.mediumImageUrl;
    return SliverAppBar(
      expandedHeight: 420,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_ios_rounded, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Shimmer.fromColors(
                  baseColor: AppColors.shimmerBase,
                  highlightColor: AppColors.shimmerHighlight,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: const Icon(Icons.broken_image_outlined,
                      color: AppColors.textMuted, size: 64),
                ),
              )
            else
              Container(
                color: AppColors.surface,
                child: const Icon(Icons.movie_outlined,
                    color: AppColors.textMuted, size: 80),
              ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 0.4, 1.0],
                  colors: [
                    AppColors.background,
                    Color(0xCC000000),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection(TvShow show) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          show.name,
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        if (show.rating != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: AppColors.accent, size: 20),
              const SizedBox(width: 6),
              Text(
                show.rating!.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  color: AppColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' / 10',
                style: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildGenres(List<String> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(
            genre,
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow_rounded, size: 22),
            label: Text(
              'Nonton',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(0, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _toggleFavorite,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isFavorite ? AppColors.primary.withOpacity(0.2) : AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isFavorite ? AppColors.primary : AppColors.divider,
              ),
            ),
            child: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
              color: _isFavorite ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
