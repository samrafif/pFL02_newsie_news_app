import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:p02_newsie_news_app/core/config.dart';
import 'package:p02_newsie_news_app/uwu.dart'; // NOTE: iz a secret, plz make urself, `secret` comes from dis

import 'package:p02_newsie_news_app/app/data/top_headlines_response.dart' as top;
import 'package:p02_newsie_news_app/app/data/everything_response.dart' as everything;

class Endpoints {
  static const baseAPIUrl = Config.baseAPIUrl;
  static const defaultParams = "&language=en&pageSize=20";

  static String topHeadlinesBase(String apiKey, [String? country, String? category]) {
      String countryParam = (country != null) ? "&country=$country" : "";
      String categoryParam =  (category != null) ? "&category=$category" : "";
      return "$baseAPIUrl/top-headlines?apiKey=$apiKey$defaultParams$countryParam$categoryParam";
  }

  static everythingBase(String apiKey, String? query) {
      String safeQuery = (query != null) ? "&q=${Uri.encodeComponent(query)}" : "";
      return "$baseAPIUrl/everything?apiKey=$apiKey$defaultParams$safeQuery";
  }
  
  static String topHeadlines(String apiKey) {
      return topHeadlinesBase(apiKey);
  }

  static String topicHeadlines(String apiKey, String topic) {
      return topHeadlinesBase(apiKey, null, topic);
  }
}

class APIService {
  static const String apiKey = secret; // TODO: iz a secret

  static final http.Client _client = http.Client();

  /// Fetch general top headlines (uses top_headlines_response model)
  static Future<top.NewsResponse> fetchTopHeadlines({Duration timeout = const Duration(seconds: 10)}) async {
    final uri = Uri.parse(Endpoints.topHeadlines(apiKey));
    print("GET $uri");
    final resp = await _client.get(uri).timeout(timeout);
    if (resp.statusCode == 200) {
      return top.NewsResponse.fromRawJson(resp.body);
    }
    throw Exception('Failed to load top headlines (status: ${resp.statusCode})');
  }

  /// Fetch headlines for a specific topic
  static Future<top.NewsResponse> fetchTopicHeadlines(String topic, {Duration timeout = const Duration(seconds: 10)}) async {
    final uri = Uri.parse(Endpoints.topicHeadlines(apiKey, topic));
    print("GET $uri");
    final resp = await _client.get(uri).timeout(timeout);
    if (resp.statusCode == 200) {
      return top.NewsResponse.fromRawJson(resp.body);
    }
    throw Exception('Failed to load topic headlines (status: ${resp.statusCode})');
  }

  /// Fetch everything matching optional query (uses everything_response model)
  static Future<everything.NewsResponse> fetchEverything({String? query, Duration timeout = const Duration(seconds: 10)}) async {
    final uri = Uri.parse(Endpoints.everythingBase(apiKey, query));
    print("GET $uri");
    final resp = await _client.get(uri).timeout(timeout);
    if (resp.statusCode == 200) {
      return everything.NewsResponse.fromRawJson(resp.body);
    }
    throw Exception('Failed to load everything (status: ${resp.statusCode})');
  }

  /// Close the internal HTTP client when app shuts down
  static void dispose() => _client.close();
}