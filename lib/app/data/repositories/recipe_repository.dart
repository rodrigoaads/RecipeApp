import 'dart:convert';

import 'package:recipe_app/app/data/http/http_client.dart';
import 'package:recipe_app/app/data/models/recipe_model.dart';

abstract class RecipeRepository {
  Future<List<RecipeModel>> getRecipes();
}

class RecipeRepositoryImpl implements RecipeRepository {
  final HttpClient client;

  RecipeRepositoryImpl({required this.client});

  @override
  Future<List<RecipeModel>> getRecipes() async {
    final response = await client.get(url: 'https://dummyjson.com/recipes');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      return List<RecipeModel>.from(body['recipes'].map((element) {
        return RecipeModel.fromMap(element);
      }));
    } else {
      throw Exception('Algo deu errado, tente novamente mais tarde.');
    }
  }
}
