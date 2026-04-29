import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dio = Dio();

// Fungsi untuk memanggil API
Future<Joke> fetchRandomJoke() async {
  final response = await dio.get<Map<String, Object?>>(
    'https://official-joke-api.appspot.com/random_joke',
  );
  return Joke.fromJson(response.data!);
}

// Final yang meng-cache hasil API call
final randomJokeProvider = FutureProvider<Joke>((ref) async {
  return fetchRandomJoke();
});

class Joke {
  Joke({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
  });

  factory Joke.fromJson(Map<String, Object?> json) {
    return Joke(
      id: json['id'] as int,
      type: json['type'] as String,
      setup: json['setup'] as String,
      punchline: json['punchline'] as String,
    );
  }

  final int id;
  final String type;
  final String setup;
  final String punchline;
}
