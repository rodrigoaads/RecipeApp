class RecipeModel {
  final String name;
  final String difficulty;
  final List<String> tags;
  final String image;

  RecipeModel(
      {required this.name,
      required this.difficulty,
      required this.tags,
      required this.image});

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
        name: map['name'],
        difficulty: map['difficulty'],
        tags: List<String>.from((map['tags'] as List)),
        image: map['image']);
  }
}
