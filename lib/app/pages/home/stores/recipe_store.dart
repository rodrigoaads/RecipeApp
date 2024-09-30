import 'package:flutter/material.dart';
import 'package:recipe_app/app/data/models/recipe_model.dart';
import 'package:recipe_app/app/data/repositories/recipe_repository.dart';

class RecipeStore {
  final RecipeRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  final ValueNotifier<List<RecipeModel>> state = ValueNotifier([]);

  final ValueNotifier<String> error = ValueNotifier('');

  RecipeStore({required this.repository});

  Future getRecipes() async {
    isLoading.value = true;

    try {
      final result = await repository.getRecipes();
      state.value = result;
    } catch (e) {
      error.value = e.toString();
    }

    isLoading.value = false;
  }
}
