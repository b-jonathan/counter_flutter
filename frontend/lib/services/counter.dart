import 'package:dio/dio.dart';
import '../models/counter.dart';
import 'dio_client.dart';

class CounterService {
  final Dio _dio = DioClient.instance;

  Future<List<Counter>> getCounters() async {
    final response = await _dio.get('/counters');
    return (response.data as List).map((e) => Counter.fromJson(e)).toList();
  }

  Future<Counter> getCounterById(String id) async {
    final response = await _dio.get('/counters/$id');
    return (response.data as Counter);
  }
  Future<Counter> createCounter(String name) async {
    final response = await _dio.post('/counters', data: {
      'name': name,
      'count': 0,
    });
    return Counter.fromJson(response.data);
  }

  Future<void> updateCounter(Counter counter) async {
    await _dio.put('/counters/${counter.id}', data: {
      'name': counter.name,
      'count': counter.count,
    });
  }

  Future<void> deleteCounter(String id) async {
    await _dio.delete('/counters/$id');
  }
}
