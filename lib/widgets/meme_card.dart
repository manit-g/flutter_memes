// Meme Card Widget - Reusable component for displaying memes
// Similar to a React component that can be reused

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meme.dart';

class MemeCard extends StatelessWidget {
  final Meme meme;
  final VoidCallback onTap;

  const MemeCard({
    super.key,
    required this.meme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 6,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meme title
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Text(
                meme.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Meme image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: meme.url,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 48),
                        SizedBox(height: 8),
                        Text('Failed to load image'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Meme info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Subreddit
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'r/${meme.subreddit}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Upvotes
                  Icon(
                    Icons.thumb_up,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    meme.formattedUps,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Content warnings
                  if (meme.nsfw || meme.spoiler) ...[
                    if (meme.nsfw)
                      Icon(
                        Icons.warning,
                        size: 16,
                        color: Colors.orange[700],
                      ),
                    if (meme.spoiler)
                      Icon(
                        Icons.visibility_off,
                        size: 16,
                        color: Colors.blue[700],
                      ),
                  ],
                  
                  // Tap indicator
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
