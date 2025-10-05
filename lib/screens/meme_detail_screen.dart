// Meme Detail Screen - Shows individual meme with full details
// Similar to a detail page component in React

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meme.dart';

class MemeDetailScreen extends StatelessWidget {
  final Meme meme;

  const MemeDetailScreen({super.key, required this.meme});

  // Open Reddit post in browser - like window.open in React
  Future<void> _openRedditPost() async {
    final Uri url = Uri.parse(meme.postLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // Share meme - like sharing functionality in React
  void _shareMeme(BuildContext context) {
    // In a real app, you'd implement sharing here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with back button
      appBar: AppBar(
        title: Text(
          'r/${meme.subreddit}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        // Actions in app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareMeme(context),
            tooltip: 'Share Meme',
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: _openRedditPost,
            tooltip: 'Open in Reddit',
          ),
        ],
      ),

      // Body content
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meme title
            Text(
              meme.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),

            // Meme image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                meme.url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, size: 48, color: Colors.red),
                          SizedBox(height: 8),
                          Text('Failed to load image'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Meme details card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Meme Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    
                    // Subreddit info
                    _buildDetailRow(
                      icon: Icons.tag,
                      label: 'Subreddit',
                      value: 'r/${meme.subreddit}',
                    ),
                    const SizedBox(height: 8),
                    
                    // Author info
                    _buildDetailRow(
                      icon: Icons.person,
                      label: 'Author',
                      value: meme.author,
                    ),
                    const SizedBox(height: 8),
                    
                    // Upvotes info
                    _buildDetailRow(
                      icon: Icons.thumb_up,
                      label: 'Upvotes',
                      value: meme.formattedUps,
                    ),
                    const SizedBox(height: 8),
                    
                    // Content warnings
                    if (meme.nsfw || meme.spoiler) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (meme.nsfw) ...[
                            const Icon(Icons.warning, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            const Text('NSFW', style: TextStyle(color: Colors.orange)),
                          ],
                          if (meme.nsfw && meme.spoiler) const SizedBox(width: 16),
                          if (meme.spoiler) ...[
                            const Icon(Icons.visibility_off, color: Colors.blue, size: 16),
                            const SizedBox(width: 4),
                            const Text('Spoiler', style: TextStyle(color: Colors.blue)),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _openRedditPost,
                    icon: const Icon(Icons.reddit),
                    label: const Text('View on Reddit'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _shareMeme(context),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
