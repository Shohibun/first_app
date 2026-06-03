import 'package:first_app/joke.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Random Joke Generator")),
        // SizedBox.expand akan mengisi seluruh ruang yang tersedia
        body: SizedBox.expand(
          // Consumer digunakan untuk membaca provider dan membangun UI berdasarkan state dari provider tersebut
          child: Consumer(
            // context adalah BuildContext yang digunakan untuk membangun widget, ref adalah WidgetRef yang digunakan untuk membaca provider, child adalah widget yang tidak berubah saat provider berubah (tidak digunakan disini)
            builder: (context, ref, child) {
              // ref.watch adalah fungsi untuk membaca provider, jika provider berubah maka widget ini akan dibangun ulang
              final randomJoke = ref.watch(randomJokeProvider);

              return Stack(
                alignment: Alignment.center,
                children: [
                  // Loading indicator saat refresh
                  if (randomJoke.isRefreshing)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(),
                    ),

                  // Tampilkan joke / loading / error
                  // AsyncValue adalah tipe data yang digunakan untuk menyimpan state dari provider yang mengembalikan Future atau Stream, AsyncValue memiliki tiga state yaitu data, error, dan loading
                  switch (randomJoke) {
                    // Jika value tidak null, maka tampilkan joke
                    AsyncValue(:final value?) => SelectableText(
                      // SelectableText digunakan agar kita bisa menyalin teksnya
                      '${value.setup} \n ${value.punchline}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                    // Jika error tidak null, maka tampilkan pesan error
                    AsyncValue(error: != null) => const Text(
                      "Error fetching joke",
                      textAlign: TextAlign.center,
                    ),
                    AsyncValue() => const CircularProgressIndicator(),
                  },

                  // Tombol ambil joke baru
                  Positioned(
                    bottom: 20,
                    child: ElevatedButton(
                      // Saat ditekan, invalidate provider untuk memanggil API lagi dan mendapatkan joke baru
                      onPressed: () => ref.invalidate(randomJokeProvider),
                      child: const Text("Get another Joke"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
