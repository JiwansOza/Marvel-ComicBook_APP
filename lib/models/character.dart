class Character {
  final int id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final List<String> comics;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.comics,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] ?? {};
    final thumbnailPath = thumbnail['path'] ?? '';
    final thumbnailExt = thumbnail['extension'] ?? '';

    final comicsData = json['comics']['items'] as List<dynamic>? ?? [];
    final comics = comicsData.map((comic) => comic['name'] as String).toList();

    return Character(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
      thumbnailUrl: '$thumbnailPath.$thumbnailExt',
      comics: comics,
    );
  }

  // For demo purposes, create a mock character
  static Character mockCharacter(int id) {
    return Character(
      id: id,
      name: _getMockName(id),
      description: 'A powerful Marvel character with amazing abilities and a complex backstory.',
      thumbnailUrl: '/placeholder.svg?height=400&width=300',
      comics: _getMockComics(),
    );
  }

  // Generate a list of mock characters for demo purposes
  static List<Character> getMockCharacters() {
    return List.generate(
      10,
      (index) => Character(
        id: index + 1,
        name: _getMockName(index),
        description: 'A powerful Marvel character with amazing abilities and a complex backstory.',
        thumbnailUrl: '/placeholder.svg?height=400&width=300',
        comics: _getMockComics(),
      ),
    );
  }

  static String _getMockName(int index) {
    final names = [
      'Spider-Man',
      'Iron Man',
      'Captain America',
      'Thor',
      'Hulk',
      'Black Widow',
      'Doctor Strange',
      'Black Panther',
      'Captain Marvel',
      'Scarlet Witch',
    ];
    
    return names[index % names.length];
  }

  static List<String> _getMockComics() {
    final comics = [
      'The Amazing Spider-Man #1',
      'Avengers #10',
      'X-Men #15',
      'Iron Man #23',
      'Captain America #7',
    ];
    
    return comics.take(3).toList();
  }
}

