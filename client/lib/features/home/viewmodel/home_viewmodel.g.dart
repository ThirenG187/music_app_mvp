// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllSongsHash() => r'2e953b8c9d6c7e578dcfd0fb88bb75db9faf4740';

/// See also [getAllSongs].
@ProviderFor(getAllSongs)
final getAllSongsProvider = AutoDisposeFutureProvider<SongResultModel>.internal(
  getAllSongs,
  name: r'getAllSongsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllSongsRef = AutoDisposeFutureProviderRef<SongResultModel>;
String _$getAllFavSongsHash() => r'14e7e6b84ab8cb3586947f3e98dba0fc946bc0fb';

/// See also [getAllFavSongs].
@ProviderFor(getAllFavSongs)
final getAllFavSongsProvider =
    AutoDisposeFutureProvider<SongResultModel>.internal(
  getAllFavSongs,
  name: r'getAllFavSongsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAllFavSongsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetAllFavSongsRef = AutoDisposeFutureProviderRef<SongResultModel>;
String _$homeViewModelHash() => r'07785c8eaa4894168f522530002d07537b823e40';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider =
    AutoDisposeNotifierProvider<HomeViewModel, AsyncValue?>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
