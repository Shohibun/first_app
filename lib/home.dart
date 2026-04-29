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
        body: SizedBox.expand(
          child: Consumer(
            builder: (context, ref, child) {
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

                  // Tamplkan joke / loading / error
                  switch (randomJoke) {
                    AsyncValue(:final value?) => SelectableText(
                      '${value.setup}\n\n${value.punchline}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                    AsyncValue(error: != null) => const Text(
                      "Error fetching joke",
                    ),
                    AsyncValue() => const CircularProgressIndicator(),
                  },

                  // Tombol ambil joke baru
                  Positioned(
                    bottom: 20,
                    child: ElevatedButton(
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
