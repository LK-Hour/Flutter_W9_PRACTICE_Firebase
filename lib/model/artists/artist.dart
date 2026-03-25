class Artist {
  final String id;
  final String name;
  final String description;
  final Uri? imageUrl;

  Artist({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
  });

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Artist &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode;
  }
}
