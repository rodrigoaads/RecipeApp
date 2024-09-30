import 'package:flutter/material.dart';
import 'package:recipe_app/app/data/http/http_client.dart';
import 'package:recipe_app/app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/app/pages/home/stores/recipe_store.dart';

import '../../data/models/recipe_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RecipeStore store =
      RecipeStore(repository: RecipeRepositoryImpl(client: HttpClientImpl()));

  @override
  void initState() {
    super.initState();
    store.getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Recipe App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBuilder(
        animation:
            Listenable.merge([store.isLoading, store.error, store.state]),
        builder: (_, child) {
          if (store.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (store.error.value.isNotEmpty) {
            return InfoText(message: store.error.value);
          }

          if (store.state.value.isNotEmpty) {
            return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                padding: const EdgeInsets.all(16.0),
                itemCount: store.state.value.length,
                itemBuilder: (_, index) {
                  final item = store.state.value[index];
                  return RecipeCard(state: item);
                });
          } else {
            return const InfoText(message: "Não encontramos nenhuma receita.");
          }
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final RecipeModel state;

  const RecipeCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 110,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  state.image,
                  fit: BoxFit.cover,
                  height: 110,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      state.difficulty,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (state.tags.isNotEmpty)
                          Card(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                state.tags[0],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        if (state.tags.length > 1)
                          Card(
                            color: Colors.blue,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "+${state.tags.length - 1}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String message;

  const InfoText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.grey)),
    );
  }
}
