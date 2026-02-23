import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'cache_service.dart';

abstract class DataManager<T, P> {
  CacheService<T>? _cacheService;

  @protected
  final BehaviorSubject<Map<String, T>> data = BehaviorSubject<Map<String, T>>.seeded(<String, T>{});

  DateTime? lastFetchingDate;
  Map<String, DateTime> lastFetchingForId = <String, DateTime>{};
  Map<String, Duration> functionsWithFetchingTime = <String, Duration>{};

  Stream<List<T>> get data$ => data.stream.map((Map<String, T> map) => map.values.toList());

  Stream<Map<String, T>> get dataMap$ => data.stream;

  Stream<List<T>> dataForIds$(List<String> ids) => data.stream.map(
        (Map<String, T> map) => ids.where((String id) => map.containsKey(id)).map((String id) => map[id]!).toList(),
      );

  Stream<T?> dataForId$(String id) => data.stream.map((Map<String, T> map) => map[id]);

  List<T> get lastKnownValues => data.value.values.toList();

  List<T> lastKnownValuesForIds(List<String> ids) =>
      data.value.keys.where((String id) => ids.contains(id)).map((String id) => data.value[id]!).toList();

  T? lastKnownValueForId(String id) => data.value[id];

  Future<bool> fetchData(
    P params, {
    bool forceFetching = true,
    bool showErrorToast = true,
  }) async {
    final Map<String, T> fetchedData = await fetch(params);
    data.add(fetchedData);
    lastFetchingDate = DateTime.now();
    return true;
  }

  bool validateCacheTime(String functionName, {bool forceFetch = false}) {
    if (forceFetch) {
      lastFetchingDate = DateTime.now();
      return true;
    }
    if (functionsWithFetchingTime[functionName] == null) return true;
    if (lastFetchingDate == null) {
      lastFetchingDate = DateTime.now();
      return true;
    }
    final Duration duration = functionsWithFetchingTime[functionName]!;
    if (DateTime.now().difference(lastFetchingDate!) > duration) {
      lastFetchingDate = DateTime.now();
      return true;
    }
    return false;
  }

  Future<void> updateStreamWith(
    Map<String, T?> updatedData, {
    bool Function(T item)? deleteWhere,
  }) async {
    final Map<String, T> current = Map<String, T>.from(data.value);
    if (deleteWhere != null) {
      current.removeWhere((_, T value) => deleteWhere(value));
    }
    for (final String id in updatedData.keys) {
      final T? item = updatedData[id];
      if (item == null) {
        current.remove(id);
      } else {
        current[id] = item;
      }
    }
    data.add(current);
    if (_cacheService != null) {
      await _cacheService!.cacheData(current);
    }
  }

  void clearData() {
    data.add(<String, T>{});
    lastFetchingDate = null;
    _cacheService?.clearCache();
  }

  Future<void> initializeCache() async {
    _cacheService = HiveCacheService<T>(
      collectionName: T.toString(),
      fromJson: fromJsonCache,
      toJson: toJsonCache,
    );
    await _cacheService?.init();
    final Map<String, T>? cached = _cacheService?.getCachedData();
    if (cached != null && cached.isNotEmpty) {
      data.add(cached);
    }

    // Listen to changes to update cache automatically
    // Note: We need to be careful not to create an infinite loop or excessive writes here.
    // The implementation in updateStreamWith already writes to cache, so we might not need a listener
    // if all updates go through updateStreamWith or fetchData.
    // However, if direct data.add is used, we need this listener.
    // But direct listener might conflict with initial load.
    // Let's stick to the user's logic:
    // "data.listen((value) => _cacheService?.cacheData(value));"
    data.listen((Map<String, T> value) {
      if (value.isNotEmpty) {
        _cacheService?.cacheData(value);
      }
    });
  }

  void clearCache() => _cacheService?.clearCache();

  @protected
  Future<Map<String, T>> fetch(P params);

  Map<String, dynamic> toJsonCache(T object) => throw UnimplementedError('Implement toJsonCache');

  T fromJsonCache(Map<String, dynamic> json) => throw UnimplementedError('Implement fromJsonCache');
}
