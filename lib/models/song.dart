class Song {
  final String filename;
  final String name;
  final String? artist;

  const Song(this.filename, this.name, {this.artist});

  @override
  String toString() {
    return 'Song {filename: $filename, name: $name, artist: $artist}';
  }
}
