import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final int truthCount;
  final int dareCount;

  const Player({
    required this.id,
    required this.name,
    this.truthCount = 0,
    this.dareCount = 0,
  });

  Player copyWith({
    String? id,
    String? name,
    int? truthCount,
    int? dareCount,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      truthCount: truthCount ?? this.truthCount,
      dareCount: dareCount ?? this.dareCount,
    );
  }

  @override
  List<Object?> get props => [id, name, truthCount, dareCount];
}
