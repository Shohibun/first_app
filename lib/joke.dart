import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Final yang digunakan untuk menyimpan instance Dio, sehingga kita bisa menggunakan instance ini untuk memanggil API di seluruh aplikasi tanpa harus membuat instance baru setiap kali ingin memanggil API
final dio = Dio();

// Fungsi untuk memanggil API
// Future<Joke> untuk mengembalikan nilai berupa Future yang berisi objek Joke, karena kita akan memanggil API yang bersifat asynchronous
// async artinya fungsi ini bersifat asynchronous, sehingga kita bisa menggunakan await untuk menunggu hasil dari API sebelum melanjutkan ke kode berikutnya
Future<Joke> fetchRandomJoke() async {
  // await digunakan untuk menunggu hasil dari API sebelum melanjutkan ke kode berikutnya
  // dio.get<Map<String, Object?>> untuk memanggil API dengan method GET, dan mengembalikan response berupa Map<String, Object?> yang merupakan tipe data yang sesuai dengan response API
  // Hasilnya disimpan dalam variabel response
  // Kenapa menggunakan <Map<String, Object?>> karena tipe key pada JSON itu selalu String, sedangkan untuk tipe value bisa bermacam-macam, sehingga menggunakan solusinya menggunakan Object? yang artinya nilai apapun boleh
  // ? pada Object? artinya nilai boleh null, karena kita tidak tahu pasti apakah nilai dari API akan selalu ada atau tidak
  final response = await dio.get<Map<String, Object?>>(
    'https://official-joke-api.appspot.com/random_joke',
  );
  // response.data! untuk mengambil data dari response, ! artinya kita yakin data tidak null, dan kita cast ke tipe Map<String, Object?> agar bisa digunakan untuk membuat objek Joke
  // Joke.fromJson untuk membuat objek Joke dari data yang didapat dari API
  return Joke.fromJson(response.data!);
}

// Final yang meng-cache hasil API call
// Dengan menggunkan FutureProvider, kita hanya perlu request 1 kali mekipun ada 3 request || Bisa menggunakan fungsi value, error, dan loading secara otomatis || Bisa menyimpan data sebagai cache untuk data sebelumnya, jadi bisa ditampilkan lebih dulu
// final randomJokeProvider adalah variable global yang menyimpan provider, sehingga kita bisa menggunakan provider ini di seluruh aplikasi untuk mendapatkan data joke dari API
// FutureProvider adalah tipe provider yang digunakan untuk menyimpan state dari provider yang mengembalikan Future, sehingga kita bisa mendapatkan data dari API dan menyimpan state, loading, dan error secara otomatis
// (ref) async {...} fungsi yang dijlankan provider || ref adalah parameter yang digunakan untuk membaca prvider lain
// return fetchRandomJoke() untuk memanggil fungsi fetchRandomJoke yang akan memanggil API dan mengembalikan data joke
final randomJokeProvider = FutureProvider<Joke>((ref) async {
  return fetchRandomJoke();
});

// ====================== MODEL CLASS JOKE ======================
class Joke {
  Joke({
    // required artinya parameter ini wajib diisi saat membuat objek Joke, jika tidak maka akan terjadi error
    // id, type, setup, dan punchline adalah field yang ada di response API, kita buat field ini agar bisa menyimpan data dari API
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
  });

  // factory constructor digunakan untuk membuat objek Joke dari JSON
  // Perlu untuk cast ke tipe yang lebih spesifik, karena data yang didapat dari API itu berupa Map<String, Object?>, sehingga kita harus cast ke tipe yang sesuai dengan field yang ada di class Joke
  // Map<String, Object?> adalah tipe data yang digunakan untuk menyimpan data JSON
  // json['type] ambil nilai dengan key 'type' || ! artinya kita yakin nilainya tidak null
  // as String cast ke tipe yang spesifiik, karena niali Map bertipe Object?, kita harus cast ke tipe yang kita inginkan
  factory Joke.fromJson(Map<String, Object?> json) {
    return Joke(
      id: json['id']! as int,
      type: json['type']! as String,
      setup: json['setup']! as String,
      punchline: json['punchline']! as String,
    );
  }

  // Property untuk menyimpan data dari API, tipe data disesuaikan dengan tipe data yang ada di response API
  final int id;
  final String type;
  final String setup;
  final String punchline;
}
