class Comic {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String publishDate;
  final List<String> creators;
  final int pageCount;
  final double price;

  Comic({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.publishDate,
    required this.creators,
    required this.pageCount,
    required this.price,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    final thumbnail = json['thumbnail'] ?? {};
    final thumbnailPath = thumbnail['path'] ?? '';
    final thumbnailExt = thumbnail['extension'] ?? '';
    
    final dates = json['dates'] as List<dynamic>? ?? [];
    String publishDate = 'Unknown';
    for (var date in dates) {
      if (date['type'] == 'onsaleDate') {
        publishDate = date['date'] ?? 'Unknown';
        break;
      }
    }

    final creatorsData = json['creators']['items'] as List<dynamic>? ?? [];
    final creators = creatorsData.map((creator) => creator['name'] as String).toList();

    final prices = json['prices'] as List<dynamic>? ?? [];
    double price = 0.0;
    if (prices.isNotEmpty) {
      price = double.tryParse(prices[0]['price'].toString()) ?? 0.0;
    }

    return Comic(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      description: json['description'] ?? 'No description available',
      thumbnailUrl: '$thumbnailPath.$thumbnailExt',
      publishDate: publishDate,
      creators: creators,
      pageCount: json['pageCount'] ?? 0,
      price: price,
    );
  }

  // For demo purposes, create a mock comic
  static Comic mockComic(int id) {
    return Comic(
      id: id,
      title: 'The Amazing Spider-Man #$id',
      description: 'Peter Parker faces new challenges as Spider-Man in this thrilling issue!',
      thumbnailUrl: '/placeholder.svg?height=400&width=300',
      publishDate: '2023-05-15T00:00:00-0400',
      creators: ['Stan Lee', 'Steve Ditko'],
      pageCount: 32,
      price: 3.99,
    );
  }

  // Generate a list of mock comics for demo purposes
  static List<Comic> getMockComics() {
    return List.generate(
      20,
      (index) => Comic(
        id: index + 1,
        title: _getMockTitle(index),
        description: 'Experience the thrilling adventure in this action-packed issue!',
        thumbnailUrl: '/placeholder.svg?height=400&width=300',
        publishDate: '2023-${(index % 12) + 1}-${(index % 28) + 1}T00:00:00-0400',
        creators: _getRandomCreators(),
        pageCount: 32,
        price: 3.99,
      ),
    );
  }

  static String _getMockTitle(int index) {
    final titles = [
      'The Amazing Spider-Man',
      'Avengers',
      'X-Men',
      'Iron Man',
      'Captain America',
      'Thor',
      'Black Panther',
      'Guardians of the Galaxy',
      'Doctor Strange',
      'Hulk',
    ];
    
    final title = titles[index % titles.length];
    final issueNumber = (index % 999) + 1;
    
    return '$title #$issueNumber';
  }

  static List<String> _getRandomCreators() {
    final creators = [
      'Stan Lee',
      'Jack Kirby',
      'Steve Ditko',
      'Chris Claremont',
      'Jim Lee',
      'Todd McFarlane',
      'Brian Michael Bendis',
      'Jonathan Hickman',
      'Ta-Nehisi Coates',
      'Jason Aaron',
    ];
    
    final selectedCreators = <String>[];
    selectedCreators.add(creators[DateTime.now().millisecond % creators.length]);
    selectedCreators.add(creators[(DateTime.now().millisecond + 5) % creators.length]);
    
    return selectedCreators;
  }
}

