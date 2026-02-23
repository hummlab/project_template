import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

/// Service responsible for caching data locally using Hive
abstract class CacheService<T> {
  /// Initializes the cache service
  Future<void> init();

  /// Retrieves cached data as a map of ID to object
  Map<String, T> getCachedData();

  /// Caches the provided data
  Future<void> cacheData(Map<String, T> data);

  /// Clears all cached data
  Future<void> clearCache();
}

/// Implementation of CacheService using Hive
class HiveCacheService<T> implements CacheService<T> {
  final String collectionName;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  Box<String>? _box;

  HiveCacheService({
    required this.collectionName,
    required this.fromJson,
    required this.toJson,
  });

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(collectionName)) {
      _box = await Hive.openBox<String>(collectionName);
    } else {
      _box = Hive.box<String>(collectionName);
    }
  }

  @override
  Map<String, T> getCachedData() {
    if (_box == null) return <String, T>{};

    final Map<String, T> data = <String, T>{};
    for (int i = 0; i < _box!.length; i++) {
      try {
        final String key = _box!.keyAt(i) as String;
        final String? valueString = _box!.getAt(i);
        if (valueString != null) {
          final Map<String, dynamic> jsonMap = json.decode(valueString) as Map<String, dynamic>;
          data[key] = fromJson(jsonMap);
        }
      } catch (e) {
        debugPrint('Error parsing cached item for $collectionName: $e');
      }
    }
    return data;
  }

  @override
  Future<void> cacheData(Map<String, T> data) async {
    if (_box == null) return;

    // We store as JSON strings because Hive types can be tricky with generics
    // without TypeAdapters, and this approach is more flexible for a generic DataManager.
    final Map<String, String> dataToCache = <String, String>{};

    for (final MapEntry<String, T> entry in data.entries) {
      dataToCache[entry.key] = json.encode(toJson(entry.value));
    }

    await _box!.putAll(dataToCache);

    // Remove items that are no longer in the new data set?
    // DataManager usually syncs full state. If we want to support removal:
    final List<String> keysToRemove = _box!.keys.cast<String>().where((String k) => !data.containsKey(k)).toList();
    if (keysToRemove.isNotEmpty) {
      await _box!.deleteAll(keysToRemove);
    }
  }

  @override
  Future<void> clearCache() async {
    await _box?.clear();
  }
}
