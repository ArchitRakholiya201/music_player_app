
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/provider/current_song_provider.dart';
import 'package:music_player_app/provider/favorite_list_provider.dart';
import 'package:music_player_app/provider/last_song_provider.dart';
import 'package:music_player_app/provider/music_player_provider.dart';
import 'package:music_player_app/provider/song_list_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> with TickerProviderStateMixin{

  late AnimationController _animationIconController1;

  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  List<Color> colors = [
    Colors.blue.withOpacity(0.2),
    Colors.orange.withOpacity(0.2),
    Colors.yellow.withOpacity(0.2),
    Colors.pink.withOpacity(0.2),
    Colors.white.withOpacity(0.2),
    Colors.green.withOpacity(0.2),
    Colors.cyan.withOpacity(0.2),
  ];
  List<bool> scrollLeft = [
    for(int i = 0; i < 20; i++)
      Random().nextInt(2) == 0,
  ];
  List<bool> scrollTop = [
    for(int i = 0; i < 20; i++)
      Random().nextInt(2) == 0,
  ];
  List<double> backgroundLeft = [
    for(int i = 0; i < 20; i++)
      0.0,
  ];
  List<double> backgroundTop = [
    for(int i = 0; i < 20; i++)
      0.0,
  ];
  List<double> backgroundWidth = [
    for(int i = 0; i < 20; i++)
      0.0,
  ];
  List<Color> backgroundColor = [
    for(int i = 0; i < 20; i++)
      Colors.blue.withOpacity(0.2),
  ];

  double containerWidth = 200;
  double containerHeight = 200;

  Timer? timer;
  Timer? backgroundScrollLeftTimer;
  Timer? backgroundScrollTopTimer;
  double turns = 0.0;

  double secondaryTrack = 0.0;
  bool isDrag = false;

  bool isFavorite = false;

  @override
  void initState() {
    super.initState();

    _animationIconController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );

    init();

    MusicPlayerProvider musicPlayerProvider = Provider.of<MusicPlayerProvider>(context, listen: false);
    musicPlayerProvider.audioPlayer.onPlayerComplete.listen((event) {
      print("Song completed.......");
      if(!mounted) return;
      secondaryTrack = 0;
      if(_animationIconController1.isCompleted){
        _animationIconController1.reverse();
      }
      // containerTimer.cancel();
      if(timer != null){
        timer!.cancel();
        backgroundScrollLeftTimer!.cancel();
        backgroundScrollTopTimer!.cancel();
      }
      turns = 0;
      setState(() {});
    });

  }

  @override
  void dispose() {
    // AppState.audioPlayer.dispose();
    if(timer != null){
      timer!.cancel();
    }
    if(backgroundScrollLeftTimer != null){
      backgroundScrollLeftTimer!.cancel();
    }
    if(backgroundScrollTopTimer != null){
      backgroundScrollTopTimer!.cancel();
    }
    _animationIconController1.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> init()async{
    await Future.delayed(const Duration(seconds: 0));

    if(!mounted) return;
    MusicPlayerProvider musicPlayerProvider = Provider.of<MusicPlayerProvider>(context, listen: false);
    if(musicPlayerProvider.isSongPlaying) {
      CurrentSongProvider currentSongProvider = Provider.of<CurrentSongProvider>(context, listen: false);
      if (currentSongProvider.selectedSong!.id == currentSongProvider.playingSong!.id) {
        startRotation();
        _animationIconController1.forward();
        setState(() {});
      }
    }

    containerWidth = (MediaQuery.of(context).size.width) - 200;
    containerHeight = (MediaQuery.of(context).size.width) - 200;

    backgroundWidth = [
      for(int i = 0; i < 20; i++)
        (Random().nextInt(65) + 5.0),
    ];

    backgroundColor = [
      for(int i = 0; i < 20; i++)
        colors[Random().nextInt(7)],
    ];

    if(!mounted) return;
    backgroundLeft = [
      for(int i = 0; i < 20; i++)
        Random().nextInt(MediaQuery.of(context).size.width.floor()).toDouble(),
    ];

    backgroundTop = [
      for(int i = 0; i < 20; i++)
        Random().nextInt(MediaQuery.of(context).size.height.floor()).toDouble(),
    ];

    setState(() {});

  }

  void startRotation(){
    // containerTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
    //   if(containerWidth == (MediaQuery.of(context).size.width) - 200){
    //     containerWidth = (MediaQuery.of(context).size.width) - 190;
    //     containerHeight = (MediaQuery.of(context).size.width) - 190;
    //   }else{
    //     containerWidth = (MediaQuery.of(context).size.width) - 200;
    //     containerHeight = (MediaQuery.of(context).size.width) - 200;
    //   }
    // });
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      turns = turns + 0.005;
      if(!mounted) return;
      setState(() {});
    });
    backgroundScrollLeftTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      turns = turns + 0.005;
      if(!mounted) return;
      setState(() {});
      for(int i = 0; i < 20; i++){
        if(backgroundLeft[i] >= (MediaQuery.of(context).size.width - backgroundWidth[i])){
          backgroundLeft[i] = backgroundLeft[i] - 0.5;
          scrollLeft[i] = true;
        }else if(backgroundLeft[i] <= 0 ){
          backgroundLeft[i] = backgroundLeft[i] + 0.5;
          scrollLeft[i] = false;
        }else if(scrollLeft[i]){
          backgroundLeft[i] = backgroundLeft[i] - 0.5;
        }else{
          backgroundLeft[i] = backgroundLeft[i] + 0.5;
        }
      }
    });
    backgroundScrollTopTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      turns = turns + 0.005;
      if(!mounted) return;
      setState(() {});
      for(int i = 0; i < 20; i++){
        if(backgroundTop[i] >= MediaQuery.of(context).size.height - backgroundWidth[i]){
          backgroundTop[i] = backgroundTop[i] - 0.5;
          scrollTop[i] = true;
        }else if(backgroundTop[i] <= 0){
          backgroundTop[i] = backgroundTop[i] + 0.5;
          scrollTop[i] = false;
        }else if(scrollTop[i]){
          backgroundTop[i] = backgroundTop[i] - 0.5;
        }else{
          backgroundTop[i] = backgroundTop[i] + 0.5;
        }
      }
    });
    setState(() {});
  }

  void stopRotation(){
    // containerTimer.cancel();
    if(timer != null){
      timer!.cancel();
      backgroundScrollLeftTimer!.cancel();
      backgroundScrollTopTimer!.cancel();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            // color: Colors.grey.shade100.withOpacity(0.55),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SizedBox(
              width: (MediaQuery.of(context).size.width),
              height: (MediaQuery.of(context).size.height),
              child: Center(
                child: Stack(
                  children: [
                    for(int i = 0; i < 20; i++)
                      Positioned(
                        left: backgroundLeft[i],
                        top: backgroundTop[i],
                        child: Container(
                          width: backgroundWidth[i],
                          height: backgroundWidth[i],
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: backgroundColor[i],
                          ),
                        ),
                      ),
                    Consumer<SongListProvider>(
                        builder: (context, songListProvider, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Consumer<CurrentSongProvider>(
                                builder: (context, currentSongProvider, child) {
                                  return Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const SizedBox(height: 70,),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Consumer<FavoriteListProvider>(
                                            builder: (context, favoriteListProvider, child) {
                                              return GestureDetector(
                                                onTap: () {
                                                  if(favoriteListProvider.favoriteList.contains(currentSongProvider.selectedSong!.id)){
                                                    favoriteListProvider.favoriteList.remove(currentSongProvider.selectedSong!.id);
                                                  }else{
                                                    favoriteListProvider.favoriteList.add(currentSongProvider.selectedSong!.id);
                                                  }
                                                  setState(() {});
                                                  _controller
                                                      .reverse()
                                                      .then((value) => _controller.forward());
                                                },
                                                child: ScaleTransition(
                                                  scale: Tween(begin: 0.7, end: 1.0).animate(
                                                      CurvedAnimation(
                                                        parent: AnimationController(
                                                            duration: const Duration(milliseconds: 200), vsync: this, value: 1.0),
                                                        curve: Curves.easeOut,
                                                      )),
                                                  child: favoriteListProvider.favoriteList.contains(currentSongProvider.selectedSong!.id)
                                                      ? const Icon(
                                                    Icons.favorite,
                                                    size: 30,
                                                    color: Colors.red,
                                                  )
                                                      : const Icon(
                                                    Icons.favorite_border,
                                                    size: 30,
                                                  ),
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                      SizedBox(
                                        width: (MediaQuery.of(context).size.width) - 190,
                                        height: (MediaQuery.of(context).size.width) - 190,
                                        child: Center(
                                          child: AnimatedRotation(
                                            turns: turns,
                                            duration: const Duration(milliseconds: 100),
                                            child: QueryArtworkWidget(
                                              id: currentSongProvider.selectedSong!.id,
                                              type: ArtworkType.AUDIO,
                                              keepOldArtwork: true,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius: BorderRadius.circular(((MediaQuery.of(context).size.width) - 190)/2),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.asset(
                                                  "assets/images/empty.png",
                                                  fit: BoxFit.cover,
                                                  width: containerWidth,
                                                  height: containerHeight,
                                                ),
                                              ),
                                              artworkWidth: containerWidth,
                                              artworkHeight: containerHeight,
                                              artworkBorder: BorderRadius.circular(((MediaQuery.of(context).size.width) - 190)/2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20,),
                                      Text(
                                        currentSongProvider.selectedSong!.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      Text(
                                        currentSongProvider.selectedSong!.artist ?? "",
                                        style: const TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFFd5d5d5),
                                          // letterSpacing: 1.5,
                                        ),
                                      ),
                                      const Expanded(child: Center()),
                                      Consumer<MusicPlayerProvider>(
                                          builder: (context, musicPlayerProvider, child) {
                                            return Slider(
                                              activeColor: Colors.pink[600],
                                              inactiveColor: Colors.grey,
                                              secondaryTrackValue: secondaryTrack,
                                              secondaryActiveColor: Colors.blue,
                                              divisions: musicPlayerProvider.positionProvider.duration.inMilliseconds == 0 ? null : musicPlayerProvider.positionProvider.duration.inMilliseconds,
                                              label: "${Duration(milliseconds: secondaryTrack.floor()).toString().split(":")[0]}:${Duration(milliseconds: secondaryTrack.floor()).toString().split(":")[1]}:${double.parse(Duration(milliseconds: secondaryTrack.floor()).toString().split(":")[2]).floor()}",
                                              value: isDrag ? secondaryTrack : musicPlayerProvider.positionProvider.duration < musicPlayerProvider.positionProvider.position ? 0.0 : musicPlayerProvider.positionProvider.position.inMilliseconds.toDouble(),
                                              max: musicPlayerProvider.positionProvider.duration.inMilliseconds.toDouble(),
                                              onChangeEnd: (double value){
                                                musicPlayerProvider.audioPlayer.seek(Duration(milliseconds: value.floor()));
                                                isDrag = false;
                                              },
                                              onChangeStart: (double value){
                                                isDrag = true;
                                                setState(() {});
                                              },
                                              onChanged: (double value) {
                                                secondaryTrack = value;
                                                setState(() {});
                                                // AppState.audioPlayer.seek(Duration(milliseconds: value.floor()));
                                                // setState(() {});
                                                // Add code to track the music duration.
                                              },
                                            );
                                          }
                                      ),
                                      Consumer<MusicPlayerProvider>(
                                          builder: (context, musicPlayerProvider, child) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${musicPlayerProvider.positionProvider.position.toString().split(":")[0]}:${musicPlayerProvider.positionProvider.position.toString().split(":")[1]}:${double.parse(musicPlayerProvider.positionProvider.position.toString().split(":")[2]).floor()}",
                                                  ),
                                                  Text(
                                                    "${musicPlayerProvider.positionProvider.duration.toString().split(":")[0]}:${musicPlayerProvider.positionProvider.duration.toString().split(":")[1]}:${double.parse(musicPlayerProvider.positionProvider.duration.toString().split(":")[2]).floor()}",
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                      const SizedBox(height: 50,),
                                      Consumer<MusicPlayerProvider>(
                                          builder: (context, musicPlayerProvider, child) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.navigate_before,
                                                  size: 55,
                                                  color: Colors.white,
                                                ),
                                                Consumer<LastSongProvider>(
                                                    builder: (context, lastSongProvider, child) {
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          if(musicPlayerProvider.isSongPlaying){
                                                            stopRotation();
                                                            _animationIconController1.reverse();
                                                            musicPlayerProvider.audioPlayer.pause();
                                                            musicPlayerProvider.isSongPlaying = false;
                                                            setState(() {});
                                                            if(currentSongProvider.selectedSong!.id != currentSongProvider.playingSong!.id){
                                                              currentSongProvider.playingSong = currentSongProvider.selectedSong;
                                                              startRotation();
                                                              _animationIconController1.forward();
                                                              musicPlayerProvider.audioPlayer.play(DeviceFileSource(currentSongProvider.selectedSong!.data));
                                                              lastSongProvider.lastSong = currentSongProvider.selectedSong!;
                                                              musicPlayerProvider.isSongPlaying = true;
                                                              setState(() {});
                                                            }
                                                          }else{
                                                            currentSongProvider.playingSong = currentSongProvider.selectedSong;
                                                            startRotation();
                                                            _animationIconController1.forward();
                                                            musicPlayerProvider.audioPlayer.play(DeviceFileSource(currentSongProvider.selectedSong!.data));
                                                            lastSongProvider.lastSong = currentSongProvider.selectedSong!;
                                                            musicPlayerProvider.isSongPlaying = true;
                                                            setState(() {});
                                                          }

                                                          // Add code to pause and play the music.
                                                        },
                                                        child: ClipOval(
                                                          child: Container(
                                                            color: Colors.pink[600],
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: AnimatedIcon(
                                                                icon: AnimatedIcons.play_pause,
                                                                size: 55,
                                                                progress: _animationIconController1,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                ),
                                                const Icon(
                                                  Icons.navigate_next,
                                                  size: 55,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            );
                                          }
                                      ),
                                      const SizedBox(height: 70,),
                                    ],
                                  );
                                }
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
