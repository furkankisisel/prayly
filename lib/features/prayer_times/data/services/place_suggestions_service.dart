import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Dünya çapında şehir önerileri sağlayan servis.
/// Open-Meteo Geocoding API kullanır (ücretsiz / anahtar gerektirmez):
/// https://open-meteo.com/en/docs/geocoding-api
/// Rate limit'lere dikkat edin; yoğun kullanım için kendi backend'iniz üzerinden cacheleyin.
class PlaceSuggestionsService {
  PlaceSuggestionsService._();
  static final instance = PlaceSuggestionsService._();

  final Map<String, List<(String city, String country)>> _cache = {};

  Future<List<(String city, String country)>> fetch(
    String query, {
    String language = 'tr',
    int count = 10,
  }) async {
    final q = query.trim();
    if (q.length < 2) return const [];
    if (_cache.containsKey(q.toLowerCase())) return _cache[q.toLowerCase()]!;
    final uri = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeQueryComponent(q)}&count=$count&language=$language&format=json',
    );
    try {
      debugPrint('[PlaceSuggestionsService] fetch "$q" -> $uri');
      final resp = await http.get(uri);
      if (resp.statusCode != 200) {
        debugPrint(
          '[PlaceSuggestionsService] non-200 status ${resp.statusCode} body=${resp.body.substring(0, resp.body.length.clamp(0, 200))}',
        );
        return const [];
      }
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final results = (json['results'] as List<dynamic>?);
      if (results == null) return const [];
      final list = <(String, String)>[];
      for (final r in results) {
        final m = r as Map<String, dynamic>;
        final name = (m['name'] ?? '').toString();
        final country = (m['country'] ?? '').toString();
        if (name.isEmpty || country.isEmpty) continue;
        list.add((name, country));
      }
      _cache[q.toLowerCase()] = list;
      debugPrint(
        '[PlaceSuggestionsService] fetched ${list.length} result(s) for "$q"',
      );
      return list;
    } catch (e) {
      debugPrint('[PlaceSuggestionsService] error for "$q": $e');
      return const [];
    }
  }
}
