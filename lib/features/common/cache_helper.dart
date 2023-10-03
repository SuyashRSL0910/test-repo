import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheHelper {

  Future<void> cacheMap(Map<dynamic, dynamic> data, String key) async {
    final jsonEncodedData = json.encode(data);
    await DefaultCacheManager().putFile(
      key,
      Uint8List.fromList(utf8.encode(jsonEncodedData)),
    );
  }

  Future<void> cacheList(List<dynamic> data, String key) async {
    final jsonEncodedData = json.encode(data);
    await DefaultCacheManager().putFile(
      key,
      Uint8List.fromList(utf8.encode(jsonEncodedData)),
    );
  }

  Future<Map<dynamic, dynamic>?> getCachedMap(String key) async {
    try {
      final file = await DefaultCacheManager().getSingleFile(key);

      if (file.existsSync()) {
        final jsonData = await file.readAsString();
        final decodedData = json.decode(jsonData);
        return decodedData as Map<dynamic, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<dynamic>?> getCachedList(String key) async {
    try {
      final file = await DefaultCacheManager().getSingleFile(key);

      if (file.existsSync()) {
        final jsonData = await file.readAsString();
        final decodedData = json.decode(jsonData);
        return decodedData as List<dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  clearCache() async {
    await DefaultCacheManager().emptyCache();
    debugPrint('Cache cleared');
  }
}
