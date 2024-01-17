import 'package:equatable/equatable.dart';

class PostCreate extends Equatable {
  final String text;
  final String image;
  final int likes;
  final List<String> tags;
  final String owner;

  const PostCreate({
    required this.text,
    required this.image,
    required this.likes,
    required this.tags,
    required this.owner,
  });

  @override
  List<Object?> get props => [
        text,
        image,
        likes,
        tags,
        owner,
      ];
}
