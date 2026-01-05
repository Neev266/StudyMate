import 'package:flutter/material.dart';
import 'package:flutter_app/features/Game/bloc/game_bloc.dart';
import 'package:flutter_app/features/Game/bloc/game_event.dart';
import 'package:flutter_app/features/Game/bloc/game_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class BoredView extends StatelessWidget {
  const BoredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("I'm Bored 🎲",
        style: TextStyle(
          color: Colors.black,
        ),
        )
        ),
      body: Center(
        child: BlocBuilder<BoredBloc, BoredState>(
          builder: (context, state) {
            if (state is BoredLoading) {
              return const CircularProgressIndicator();
            } else if (state is BoredLoaded) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.activity.activity,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text("New Challenge"),
                          onPressed: () {
                            context
                                .read<BoredBloc>()
                                .add(FetchBoredActivity());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is BoredError) {
              return Text(state.message);
            }
            return ElevatedButton(
              onPressed: () {
                context.read<BoredBloc>().add(FetchBoredActivity());
              },
              child: const Text("I'm Bored 😴"),
            );
          },
        ),
      ),
    );
  }
}
