import 'package:flutter/material.dart';
import '../models/story_model.dart';
import '../services/hn_api_service.dart';
import '../widgets/story_tile.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _api = HnApiService();
  final List<Story> _stories = [];
  List<int> _allIds = [];
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  int _page = 0;
  static const int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_loadingMore &&
        _page * _pageSize < _allIds.length) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _allIds = await _api.fetchTopStoryIds();
      _page = 0;
      _stories.clear();
      await _loadPage();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore) return;
    setState(() => _loadingMore = true);
    await _loadPage();
    setState(() => _loadingMore = false);
  }

  Future<void> _loadPage() async {
    final start = _page * _pageSize;
    final end = (start + _pageSize).clamp(0, _allIds.length);
    final ids = _allIds.sublist(start, end);
    final futures = ids.map((id) => _api.fetchStory(id));
    final results = await Future.wait(futures);
    final valid = results
        .whereType<Story>()
        .where((s) => s.type == 'story')
        .toList();
    setState(() {
      _stories.addAll(valid);
      _page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6EF),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6600)),
                  )
                : _error != null
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Error: $_error',
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _loadInitial,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadInitial,
                    color: const Color(0xFFFF6600),
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: _stories.length + (_loadingMore ? 1 : 0),
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: Color(0xFFE8E8E8)),
                      itemBuilder: (context, i) {
                        if (i == _stories.length) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF6600),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }
                        final story = _stories[i];
                        return StoryTile(
                          story: story,
                          index: i + 1,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(story: story),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: const Color(0xFFFF6600),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  // Y logo
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        'Y',
                        style: TextStyle(
                          color: Color(0xFFFF6600),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Hacker News',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'login',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            // Nav row
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                'new | past | comments | ask | show | jobs | submit',
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
