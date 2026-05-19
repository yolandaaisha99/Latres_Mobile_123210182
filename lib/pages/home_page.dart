import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../models/tv_show.dart';
import '../services/tv_maze_service.dart';
import '../widgets/app_theme.dart';
import '../widgets/show_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TvShow> _shows = [];
  List<TvShow> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 0;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadShows();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      if (!_isLoadingMore && !_isSearching) {
        _loadMoreShows();
      }
    }
  }

  Future<void> _loadShows() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final shows = await TvMazeService.fetchShows(page: 0);
      if (mounted) {
        setState(() {
          _shows = shows;
          _isLoading = false;
          _currentPage = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data. Periksa koneksi internet kamu.';
        });
      }
    }
  }

  Future<void> _loadMoreShows() async {
    setState(() => _isLoadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final shows = await TvMazeService.fetchShows(page: nextPage);
      if (mounted) {
        setState(() {
          _shows.addAll(shows);
          _currentPage = nextPage;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  Future<void> _searchShows(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      final results = await TvMazeService.searchShows(query);
      if (mounted) {
        setState(() => _searchResults = results);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _searchResults = []);
      }
    }
  }

  void _navigateToDetail(TvShow show) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(showId: show.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'Skuy Nonton!',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
        onChanged: _searchShows,
        decoration: InputDecoration(
          hintText: 'Cari show...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
                  onPressed: () {
                    _searchController.clear();
                    _searchShows('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildShimmerGrid();
    if (_errorMessage != null) return _buildError();

    final displayShows = _isSearching ? _searchResults : _shows;

    if (displayShows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, color: AppColors.textMuted, size: 64),
            const SizedBox(height: 16),
            Text(
              'Tidak ada hasil ditemukan',
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _isSearching ? null : _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: displayShows.length + (_isLoadingMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= displayShows.length) {
          return _buildShimmerCard();
        }
        return ShowCard(
          show: displayShows[index],
          onTap: () => _navigateToDetail(displayShows[index]),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: AppColors.textMuted, size: 64),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadShows,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
