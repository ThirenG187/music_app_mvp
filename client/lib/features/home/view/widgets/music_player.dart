import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final currentSongNotifier = ref.read(currentSongNotifierProvider.notifier);
    final userFavorites = ref
        .watch(currentUserNotifierProvider.select((user) => user!.favorites));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexToColor(
              currentSong!.hex_code,
            ),
            const Color(0xff121212)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-15, 0),
            child: InkWell(
              highlightColor: Pallete.transparentColor,
              focusColor: Pallete.transparentColor,
              splashColor: Pallete.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Hero(
                tag: 'album_art',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                          currentSong.thumbnail_url,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSong.song_name,
                            style: const TextStyle(
                              color: Pallete.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            currentSong.artist,
                            style: const TextStyle(
                              color: Pallete.subtitleText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        onPressed: () async => await ref
                            .read(homeViewModelProvider.notifier)
                            .favSong(songId: currentSong.id),
                        icon: Icon(
                          userFavorites
                                  .where((fav) => fav.song_id == currentSong.id)
                                  .toList()
                                  .isNotEmpty
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: Pallete.whiteColor,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  StreamBuilder(
                      stream: currentSongNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox();
                        }

                        final position = snapshot.data;
                        final duration =
                            currentSongNotifier.audioPlayer!.duration;

                        double sliderValue = 0.0;

                        if (position != null && duration != null) {
                          sliderValue =
                              position.inMilliseconds / duration.inMilliseconds;
                        }

                        return Column(
                          children: [
                            StatefulBuilder(
                              builder: (context, setState) {
                                return SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Pallete.whiteColor,
                                    inactiveTrackColor:
                                        Pallete.whiteColor.withOpacity(0.117),
                                    thumbColor: Pallete.whiteColor,
                                    trackHeight: 4,
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: Slider(
                                    value: sliderValue,
                                    min: 0,
                                    max: 1,
                                    onChanged: (value) {
                                      sliderValue = value;
                                    },
                                    onChangeEnd: currentSongNotifier.seek,
                                  ),
                                );
                              },
                            ),
                            Row(
                              children: [
                                Text(
                                  getAudioDuration(position?.inSeconds ?? 0),
                                  style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Text(
                                  getAudioDuration(duration?.inSeconds ?? 0),
                                  //'${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0${duration?.inSeconds}' : duration?.inSeconds}',
                                  style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/shuffle.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/previus-song.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: currentSongNotifier.playPause,
                        icon: Icon(
                          currentSongNotifier.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 80,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/next-song.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/repeat.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/connect-device.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/images/playlist.png',
                          color: Pallete.whiteColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
