import 'dart:io';
import 'dart:ui';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/fav_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<SongResultModel> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  final result = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };

  return result;
}

@riverpod
Future<SongResultModel> getAllFavSongs(GetAllFavSongsRef ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res =
      await ref.watch(homeRepositoryProvider).getAllFavSongs(token: token);

  final result = switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };

  return result;
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRemoteRepository _homeRemoteRepository;
  late HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue? build() {
    _homeRemoteRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = const AsyncLoading();
    final res = await _homeRemoteRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };

    print(val);
  }

  Future<void> favSong({
    required String songId,
  }) async {
    state = const AsyncLoading();
    final res = await _homeRemoteRepository.favoriteSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };

    print(val);
  }

  AsyncValue _favSongSuccess(bool isFavorite, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorite) {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
          favorites: [
            ...ref.read(currentUserNotifierProvider)!.favorites,
            FavSongModel(
              id: '',
              song_id: songId,
              user_id: '',
            ),
          ],
        ),
      );
    } else {
      userNotifier.addUser(
        ref.read(currentUserNotifierProvider)!.copyWith(
              favorites: ref
                  .read(currentUserNotifierProvider)!
                  .favorites
                  .where((fav) => fav.song_id != songId)
                  .toList(),
            ),
      );
    }
    ref.invalidate(getAllFavSongsProvider);
    return state = AsyncData(isFavorite);
  }

  SongResultModel getRecentlyPlayedSongs() => _homeLocalRepository.loadSongs();
}
