import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/provider/current_song_provider.dart';
import 'package:music_player_app/provider/favorite_list_provider.dart';
import 'package:music_player_app/provider/last_song_provider.dart';
import 'package:music_player_app/provider/music_player_provider.dart';
import 'package:music_player_app/provider/position_provider.dart';
import 'package:music_player_app/provider/song_list_provider.dart';
import 'package:music_player_app/screens/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return PositionProvider();
          },
        ),
        ChangeNotifierProxyProvider<PositionProvider, MusicPlayerProvider>(
          // builder: (context, positionProvider) => MusicPlayerProvider(positionProvider),
          create: (BuildContext context) {
            return MusicPlayerProvider(
              Provider.of<PositionProvider>(context, listen: false),
              AudioPlayer(),
            );
          },
          update: (BuildContext context, positionProvider, MusicPlayerProvider? previous) {
            return MusicPlayerProvider(positionProvider, AudioPlayer());
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return SongListProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return LastSongProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return FavoriteListProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return CurrentSongProvider();
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music player',
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}
