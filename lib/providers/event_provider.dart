// lib/providers/event_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/event.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final eventsProvider = FutureProvider<List<Event>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.getEvents();
});

final addEventProvider = FutureProvider.family<bool, Event>((ref, event) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.addEvent(event);
});