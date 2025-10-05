// Meme List Screen - Main screen showing list of memes
// Similar to a React component with useState and useEffect

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meme.dart';
import '../services/meme_api_service.dart';
import '../widgets/meme_card.dart';
import 'meme_detail_screen.dart';

class MemeListScreen extends StatefulWidget {
  const MemeListScreen({super.key});

  @override
  State<MemeListScreen> createState() => _MemeListScreenState();
}

class _MemeListScreenState extends State<MemeListScreen> {
  // State variables - like useState in React
  List<Meme> memes = [];
  bool isLoading = false;
  String? errorMessage;
  String selectedSubreddit = 'random';
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // Similar to useEffect(() => {}, []) in React
    _loadMemes();
  }

  // Load memes from API - like an async function in React
  Future<void> _loadMemes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      List<Meme> newMemes;
      
      if (selectedSubreddit == 'random') {
        // Load 10 random memes from various subreddits
        newMemes = await MemeApiService.fetchMultipleMemes(10);
      } else {
        // Load 10 memes from specific subreddit
        newMemes = await MemeApiService.fetchMemesFromSubreddit(selectedSubreddit, 10);
      }

      setState(() {
        memes = newMemes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  // Refresh memes - like refreshing data in React
  Future<void> _refreshMemes() async {
    await _loadMemes();
  }

  // Navigate to meme detail - like React Router navigation
  void _navigateToMemeDetail(Meme meme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemeDetailScreen(meme: meme),
      ),
    );
  }

  // Open portfolio website
  Future<void> _openPortfolio() async {
    final Uri url = Uri.parse('https://portfoliobymg.netlify.app/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar - like a header component
      appBar: AppBar(
        title: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTap: _openPortfolio,
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  children: [
                    const TextSpan(text: 'Memes by '),
                    WidgetSpan(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(
                          horizontal: _isHovering ? 12 : 8,
                          vertical: _isHovering ? 4 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: _isHovering
                              ? Colors.white.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isHovering
                                ? Colors.white.withOpacity(0.8)
                                : Colors.transparent,
                            width: _isHovering ? 2 : 0,
                          ),
                          boxShadow: _isHovering
                              ? [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          'MG',
                          style: TextStyle(
                            color: _isHovering ? Colors.yellow[300] : Colors.white,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.8),
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
        
        // Actions in app bar - like buttons in header
        actions: [
          // Portfolio link button
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: _openPortfolio,
            tooltip: 'Visit MG Portfolio',
          ),
          // Subreddit selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (String subreddit) {
              setState(() {
                selectedSubreddit = subreddit;
              });
              _loadMemes();
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'random',
                  child: Text('Random Mix'),
                ),
                const PopupMenuItem(
                  value: 'memes',
                  child: Text('r/memes'),
                ),
                const PopupMenuItem(
                  value: 'dankmemes',
                  child: Text('r/dankmemes'),
                ),
                const PopupMenuItem(
                  value: 'wholesomememes',
                  child: Text('r/wholesomememes'),
                ),
                const PopupMenuItem(
                  value: 'ProgrammerHumor',
                  child: Text('r/ProgrammerHumor'),
                ),
                const PopupMenuItem(
                  value: 'funny',
                  child: Text('r/funny'),
                ),
              ];
            },
          ),
        ],
      ),

      // Body - main content area
      body: _buildBody(),

      // Floating action button - like a FAB in Material Design
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _refreshMemes,
        tooltip: 'Refresh Memes',
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text(
          'Refresh',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 8,
      ),
    );
  }

  Widget _buildBody() {
    // Show loading state - like loading spinner in React
    if (isLoading && memes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading fresh memes...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Show error state - like error handling in React
    if (errorMessage != null && memes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      size: 64,
                      color: Colors.red[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.red[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _loadMemes,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show memes list - like rendering a list in React
    return RefreshIndicator(
      onRefresh: _refreshMemes,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: memes.length,
        itemBuilder: (context, index) {
          final meme = memes[index];
          return MemeCard(
            meme: meme,
            onTap: () => _navigateToMemeDetail(meme),
          );
        },
      ),
    );
  }
}
