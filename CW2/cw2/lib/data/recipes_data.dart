import '../models/recipe.dart';

final List<Recipe> sampleRecipes = [
  Recipe(
    name: 'Spaghetti Bolognese',
    imagePath: 'assets/pasta.jpg',
    ingredients: ['Spaghetti', 'Ground beef', 'Tomato sauce', 'Onion', 'Garlic'],
    instructions: 'Cook pasta. Brown beef with onion & garlic. Add sauce. Combine & serve.',
  ),
  Recipe(
    name: 'Ratatouille',
    imagePath: 'assets/ratatouille.jpg',
    ingredients: ['Eggplant', 'Zucchini', 'Bell peppers', 'Tomatoes', 'Onion'],
    instructions: 'Slice and sauté vegetables. Layer in baking dish. Bake until tender.',
  ),
  Recipe(
    name: 'Chicken Alfredo',
    imagePath: 'assets/chikenalf.jpg',
    ingredients: ['Fettuccine', 'Chicken breast', 'Heavy cream', 'Parmesan cheese', 'Butter'],
    instructions: 'Cook fettuccine. Cook chicken. Make Alfredo sauce with cream and cheese. Combine & serve.',
  ),
  Recipe(
    name: 'Vegetable Stir Fry',
    imagePath: 'assets/vegstir.jpg',
    ingredients: ['Broccoli', 'Bell peppers', 'Carrots', 'Soy sauce', 'Ginger'],
    instructions: 'Stir fry vegetables. Add soy sauce and ginger. Serve over rice.',
  ),
];