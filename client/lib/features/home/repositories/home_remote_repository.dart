import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_remote_repository.g.dart';

@riverpod
HomeRemoteRepository homeRepository(HomeRepositoryRef ref) =>
    HomeRemoteRepository();

class HomeRemoteRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstants.serverURL}/song/upload'),
      );

      request
        ..files.addAll(
          [
            await http.MultipartFile.fromPath(
              'song',
              selectedAudio.path,
            ),
            await http.MultipartFile.fromPath(
              'thumbnail',
              selectedThumbnail.path,
            ),
          ],
        )
        ..fields.addAll(
          {
            'artist': artist,
            'song_name': songName,
            'hex_code': hexCode,
          },
        )
        ..headers.addAll(
          {
            'x-auth-token': token,
          },
        );

      final response = await request.send();

      if (response.statusCode != 201) {
        return Left(AppFailure(await response.stream.bytesToString()));
      }

      return Right(await response.stream.bytesToString());
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, SongResultModel>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstants.serverURL}/song/list'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;

        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as Map<String, dynamic>;

      return Right(SongResultModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favoriteSong({
    required String token,
    required String songId,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${ServerConstants.serverURL}/song/favorite'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {
            "song_id": songId,
          },
        ),
      );

      var resBodyMap = jsonDecode(res.body);
      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, SongResultModel>> getAllFavSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstants.serverURL}/song/list/favorites'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;

        return Left(AppFailure(resBodyMap['detail']));
      }

      resBodyMap = resBodyMap as Map<String, dynamic>;

      return Right(SongResultModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
