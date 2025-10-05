// Meme model - similar to a TypeScript interface
// This defines the structure of our Meme data from the API
// Based on: https://meme-api.com/gimme

class Meme {
  final String postLink;
  final String subreddit;
  final String title;
  final String url;
  final bool nsfw;
  final bool spoiler;
  final String author;
  final int ups;
  final List<String> preview;

  // Constructor - like creating an object in TypeScript
  Meme({
    required this.postLink,
    required this.subreddit,
    required this.title,
    required this.url,
    required this.nsfw,
    required this.spoiler,
    required this.author,
    required this.ups,
    required this.preview,
  });

  // Convert Meme to JSON (for saving locally later)
  Map<String, dynamic> toJson() {
    return {
      'postLink': postLink,
      'subreddit': subreddit,
      'title': title,
      'url': url,
      'nsfw': nsfw,
      'spoiler': spoiler,
      'author': author,
      'ups': ups,
      'preview': preview,
    };
  }

  // Create Meme from JSON (from API response)
  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      postLink: json['postLink'] ?? '',
      subreddit: json['subreddit'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      nsfw: json['nsfw'] ?? false,
      spoiler: json['spoiler'] ?? false,
      author: json['author'] ?? '',
      ups: json['ups'] ?? 0,
      preview: List<String>.from(json['preview'] ?? []),
    );
  }

  // Helper method to get the best preview image
  String get bestPreviewImage {
    if (preview.isEmpty) return url;
    // Return the largest preview image (last in the array)
    return preview.last;
  }

  // Helper method to format upvotes
  String get formattedUps {
    if (ups >= 1000) {
      return '${(ups / 1000).toStringAsFixed(1)}k';
    }
    return ups.toString();
  }
}

// API Response model for single meme
class MemeResponse {
  final Meme meme;

  MemeResponse({required this.meme});

  factory MemeResponse.fromJson(Map<String, dynamic> json) {
    return MemeResponse(
      meme: Meme.fromJson(json),
    );
  }
}

// API Response model for multiple memes
class MemesResponse {
  final int count;
  final List<Meme> memes;

  MemesResponse({required this.count, required this.memes});

  factory MemesResponse.fromJson(Map<String, dynamic> json) {
    return MemesResponse(
      count: json['count'] ?? 0,
      memes: (json['memes'] as List<dynamic>?)
          ?.map((memeJson) => Meme.fromJson(memeJson))
          .toList() ?? [],
    );
  }
}
