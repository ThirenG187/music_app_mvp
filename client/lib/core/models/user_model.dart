// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:client/features/home/models/fav_song_model.dart';

class UserModel {
  final String id;
  final String email;
  final String name;
  final String token;
  final List<FavSongModel> favorites;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    required this.favorites,
  });

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? token,
    List<FavSongModel>? favorites,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      token: token ?? this.token,
      favorites: favorites ?? this.favorites,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'favorites': favorites.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
      favorites: List<FavSongModel>.from(
        (map['favorites'] ?? []).map<FavSongModel>(
          (x) => FavSongModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, token: $token, favorites: $favorites)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.token == token &&
        listEquals(other.favorites, favorites);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        token.hashCode ^
        favorites.hashCode;
  }
}
