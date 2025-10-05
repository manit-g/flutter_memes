// API Service - similar to axios service in React
// Handles all HTTP requests to the Meme API

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meme.dart';

class MemeApiService {
  // Base URL for the Meme API
  static const String _baseUrl = 'https://meme-api.com/gimme';
  
  // Popular subreddits for memes
  static const List<String> popularSubreddits = [
    'memes',
    'dankmemes', 
    'me_irl',
    'wholesomememes',
    'ProgrammerHumor',
    'funny',
    'MemeEconomy',
    'PrequelMemes',
    'lotrmemes',
  ];

  // Fetch a single random meme
  // Similar to: const response = await axios.get('https://meme-api.com/gimme')
  static Future<Meme> fetchRandomMeme() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Meme.fromJson(jsonData);
      } else {
        throw Exception('Failed to load meme: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch multiple memes
  // Similar to: const response = await axios.get('https://meme-api.com/gimme/5')
  static Future<List<Meme>> fetchMultipleMemes(int count) async {
    try {
      // Limit count to 50 as per API documentation
      final actualCount = count > 50 ? 50 : count;
      
      final response = await http.get(
        Uri.parse('$_baseUrl/$actualCount'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final memesResponse = MemesResponse.fromJson(jsonData);
        return memesResponse.memes;
      } else {
        throw Exception('Failed to load memes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch meme from specific subreddit
  // Similar to: const response = await axios.get('https://meme-api.com/gimme/wholesomememes')
  static Future<Meme> fetchMemeFromSubreddit(String subreddit) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$subreddit'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Meme.fromJson(jsonData);
      } else {
        throw Exception('Failed to load meme from $subreddit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Fetch multiple memes from specific subreddit
  // Similar to: const response = await axios.get('https://meme-api.com/gimme/wholesomememes/3')
  static Future<List<Meme>> fetchMemesFromSubreddit(String subreddit, int count) async {
    try {
      // Limit count to 50 as per API documentation
      final actualCount = count > 50 ? 50 : count;
      
      final response = await http.get(
        Uri.parse('$_baseUrl/$subreddit/$actualCount'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final memesResponse = MemesResponse.fromJson(jsonData);
        return memesResponse.memes;
      } else {
        throw Exception('Failed to load memes from $subreddit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get random subreddit from popular list
  static String getRandomSubreddit() {
    final random = DateTime.now().millisecondsSinceEpoch % popularSubreddits.length;
    return popularSubreddits[random];
  }
}
