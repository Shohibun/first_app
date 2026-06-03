import 'package:first_app/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Void artinya fungsi ini tidak mengembalikan nilai apapun
void main() {
  // ProviderScope adalah widget yang diperlukan untuk menggunakan Riverpod || Menyimpan semua state dari seluruh provider
  runApp(const ProviderScope(child: MyApp()));
}

// StatefulWidget adalah widget yang memiliki state yang bisa berubah-ubah, sedangkan StatelessWidget adalah widget yang tidak memiliki state
class MyApp extends StatelessWidget {
  // Constructor untuk MyApp, super.key digunakan untuk mengirimkan key ke widget induk
  const MyApp({super.key});

  // @override digunakan untuk menandai bahwa fungsi ini mengoverride fungsi dari kelas induk, dalam hal ini build() dari StatelessWidget
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Home());
  }
}
