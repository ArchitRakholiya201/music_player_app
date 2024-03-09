
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/provider/current_song_provider.dart';
import 'package:music_player_app/provider/favorite_list_provider.dart';
import 'package:music_player_app/provider/last_song_provider.dart';
import 'package:music_player_app/provider/music_player_provider.dart';
import 'package:music_player_app/provider/song_list_provider.dart';
import 'package:music_player_app/screens/play.dart';
import 'package:music_player_app/services/app_state.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 200), vsync: this, value: 1.0);

  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<ArtistModel> artists = [];
  List<AlbumModel> albums = [];

  bool showProgress = true;

  int selectedType = 0;

  bool isFavorite = false;

  List<List<Color>> colors = [
    [
      const Color(0xFF44a5A9),
      const Color(0xFF3199c0),
    ],
    [
      const Color(0xFF883278),
      const Color(0xFF66275a ),
    ],
  ];
  List<Icon> categoryIconList = [
    const Icon(Icons.access_time_filled_outlined, color: Colors.white, size: 20,),
    const Icon(Icons.favorite, color: Colors.white, size: 20,),
  ];
  List<String> category = [
    "Recent",
    "Favorites",
  ];

  List<String> list = [
    "Songs",
    "Artists",
    "Albums",
  ];

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  @override
  void dispose() {
    MusicPlayerProvider musicPlayerProvider = Provider.of<MusicPlayerProvider>(context, listen: false);
    musicPlayerProvider.audioPlayer.dispose();
    super.dispose();
  }

  requestPermission() async {
    await Future.delayed(const Duration(seconds: 0));
    if(!mounted) return;
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      permissionStatus = await _audioQuery.permissionsRequest();
      if(permissionStatus){
        await getSongs();
        await getArtists();
        await getAlbums();
      }
    }else{
      await getSongs();
      await getArtists();
      await getAlbums();
    }
    setState(() {});
  }

  Future<void> getSongs() async{
    SongListProvider songListProvider = Provider.of<SongListProvider>(context, listen: false);
    songListProvider.songList = await _audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    showProgress = false;
    setState(() {});
  }

  Future<void> getArtists() async{
    artists = await _audioQuery.queryArtists(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for(int i = 0; i < artists.length; i++){
      print("-=-=-=-=-=-=-=-=-${artists[i].artist}");
      print("-=-=-=-=-=-=-=-=-${artists[i].getMap}");
      print("-=-=-=-=-=-=-=-=-${artists[i].numberOfAlbums}");
      print("-=-=-=-=-=-=-=-=-${artists[i].numberOfTracks}");
    }
  }

  Future<void> getAlbums() async{
    albums = await _audioQuery.queryAlbums(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for(int i = 0; i < albums.length; i++){
      print("-=-=-=-=-=-=-=-=-${albums[i].album}");
      print("-=-=-=-=-=-=-=-=-${albums[i].artist}");
      print("-=-=-=-=-=-=-=-=-${albums[i].numOfSongs}");
      print("-=-=-=-=-=-=-=-=-${albums[i].getMap}");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("I am refreshing");
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF250c3e),
              Color(0xFF441f67),
              // Color(0xFF0F0817),
            ],
          )
        ),
        child: Consumer<LastSongProvider>(
          builder: (BuildContext context, lastSongProvider, Widget? child) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Welcome back!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "What do you feel like today?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFd5d5d5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for(int i = 0; i < 2; i++)
                              Container(
                                width: 110,
                                height: 85,
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: colors[i],
                                  ),
                                ),
                                child: Material(
                                  elevation: 0,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    onTap: (){

                                    },
                                    leading: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        categoryIconList[i],
                                        const SizedBox(height: 5,),
                                        Text(
                                          category[i],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    tileColor: Colors.transparent,
                                    horizontalTitleGap: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.all(15),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for(int i = 0; i < list.length; i++)
                              GestureDetector(
                                onTap: () async {
                                  selectedType = i;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  margin: const EdgeInsets.only(right: 25),
                                  decoration: selectedType == i ? const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color(0xFFC22BB7), width: 2.5)),
                                  ) : null,
                                  child: Text(
                                    list[i],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: selectedType == i ? Colors.white : const Color(0xFFd5d5d5),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: showProgress ? const Center(
                        child: CircularProgressIndicator(),
                      ) : selectedType == 1 ?
                      Consumer<SongListProvider>(
                          builder: (BuildContext context, songListProvider, Widget? child) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  if(selectedType == 1)
                                    for(int i = 0; i < artists.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: ListTile(
                                          onTap: (){

                                          },
                                          leading: Container(
                                            margin: const EdgeInsets.only(right: 20),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: QueryArtworkWidget(
                                              id: artists[i].id,
                                              type: ArtworkType.ARTIST,
                                              artworkBorder: BorderRadius.circular(5),
                                              keepOldArtwork: true,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            artists[i].artist,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${artists[i].numberOfAlbums} songs",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFd5d5d5),
                                            ),
                                          ),
                                          // trailing: GestureDetector(
                                          //   onTap: () {
                                          //     if(AppState.favoriteList.contains(AppState.songList[i].id)){
                                          //       AppState.favoriteList.remove(AppState.songList[i].id);
                                          //     }else{
                                          //       AppState.favoriteList.add(AppState.songList[i].id);
                                          //     }
                                          //     setState(() {});
                                          //     _controller
                                          //         .reverse()
                                          //         .then((value) => _controller.forward());
                                          //   },
                                          //   child: ScaleTransition(
                                          //     scale: Tween(begin: 0.7, end: 1.0).animate(
                                          //         CurvedAnimation(
                                          //           parent: AnimationController(
                                          //               duration: const Duration(milliseconds: 200), vsync: this, value: 1.0),
                                          //           curve: Curves.easeOut,
                                          //         )),
                                          //     child: AppState.favoriteList.contains(AppState.songList[i].id)
                                          //         ? const Icon(
                                          //       Icons.favorite,
                                          //       size: 30,
                                          //       color: Colors.red,
                                          //     )
                                          //         : const Icon(
                                          //       Icons.favorite_border,
                                          //       size: 30,
                                          //     ),
                                          //   ),
                                          // ),
                                          horizontalTitleGap: 0,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      )
                                  else if(selectedType == 2)
                                    for(int i = 0; i < albums.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: ListTile(
                                          onTap: (){

                                          },
                                          leading: Container(
                                            margin: const EdgeInsets.only(right: 20),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: QueryArtworkWidget(
                                              id: albums[i].id,
                                              type: ArtworkType.ARTIST,
                                              artworkBorder: BorderRadius.circular(5),
                                              keepOldArtwork: true,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            albums[i].album,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${albums[i].numOfSongs} songs",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFd5d5d5),
                                            ),
                                          ),
                                          // trailing: GestureDetector(
                                          //   onTap: () {
                                          //     if(AppState.favoriteList.contains(AppState.songList[i].id)){
                                          //       AppState.favoriteList.remove(AppState.songList[i].id);
                                          //     }else{
                                          //       AppState.favoriteList.add(AppState.songList[i].id);
                                          //     }
                                          //     setState(() {});
                                          //     _controller
                                          //         .reverse()
                                          //         .then((value) => _controller.forward());
                                          //   },
                                          //   child: ScaleTransition(
                                          //     scale: Tween(begin: 0.7, end: 1.0).animate(
                                          //         CurvedAnimation(
                                          //           parent: AnimationController(
                                          //               duration: const Duration(milliseconds: 200), vsync: this, value: 1.0),
                                          //           curve: Curves.easeOut,
                                          //         )),
                                          //     child: AppState.favoriteList.contains(AppState.songList[i].id)
                                          //         ? const Icon(
                                          //       Icons.favorite,
                                          //       size: 30,
                                          //       color: Colors.red,
                                          //     )
                                          //         : const Icon(
                                          //       Icons.favorite_border,
                                          //       size: 30,
                                          //     ),
                                          //   ),
                                          // ),
                                          horizontalTitleGap: 0,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      )
                                  else
                                    for(int i = 0; i < songListProvider.songList.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Consumer<CurrentSongProvider>(
                                            builder: (BuildContext context, currentSongProvider, Widget? child) {
                                              return ListTile(
                                                onTap: (){
                                                  currentSongProvider.selectedSong = songListProvider.songList[i];
                                                  setState(() {});
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayScreen()));
                                                },
                                                leading: Container(
                                                  margin: const EdgeInsets.only(right: 20),
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        blurRadius: 6,
                                                      )
                                                    ],
                                                  ),
                                                  child: QueryArtworkWidget(
                                                    id: songListProvider.songList[i].id,
                                                    type: ArtworkType.AUDIO,
                                                    artworkBorder: BorderRadius.circular(5),
                                                    keepOldArtwork: true,
                                                    nullArtworkWidget: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      clipBehavior: Clip.antiAlias,
                                                      child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  songListProvider.songList[i].title,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  songListProvider.songList[i].artist != null ? songListProvider.songList[i].artist! : "<unknown>",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFFd5d5d5),
                                                  ),
                                                ),
                                                trailing: Consumer<FavoriteListProvider>(
                                                    builder: (BuildContext context, favoriteListProvider, Widget? child) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if(favoriteListProvider.favoriteList.contains(songListProvider.songList[i].id)){
                                                            favoriteListProvider.favoriteList.remove(songListProvider.songList[i].id);
                                                          }else{
                                                            favoriteListProvider.favoriteList.add(songListProvider.songList[i].id);
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
                                                          child: favoriteListProvider.favoriteList.contains(songListProvider.songList[i].id)
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
                                                horizontalTitleGap: 0,
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              );
                                            }
                                        ),
                                      ),
                                ],
                              ),
                            );
                          }
                      ) : selectedType == 2 ?
                      Consumer<SongListProvider>(
                          builder: (BuildContext context, songListProvider, Widget? child) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  if(selectedType == 1)
                                    for(int i = 0; i < artists.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: ListTile(
                                          onTap: (){

                                          },
                                          leading: Container(
                                            margin: const EdgeInsets.only(right: 20),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: QueryArtworkWidget(
                                              id: artists[i].id,
                                              type: ArtworkType.ARTIST,
                                              artworkBorder: BorderRadius.circular(5),
                                              keepOldArtwork: true,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            artists[i].artist,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${artists[i].numberOfAlbums} songs",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFd5d5d5),
                                            ),
                                          ),
                                          // trailing: GestureDetector(
                                          //   onTap: () {
                                          //     if(AppState.favoriteList.contains(AppState.songList[i].id)){
                                          //       AppState.favoriteList.remove(AppState.songList[i].id);
                                          //     }else{
                                          //       AppState.favoriteList.add(AppState.songList[i].id);
                                          //     }
                                          //     setState(() {});
                                          //     _controller
                                          //         .reverse()
                                          //         .then((value) => _controller.forward());
                                          //   },
                                          //   child: ScaleTransition(
                                          //     scale: Tween(begin: 0.7, end: 1.0).animate(
                                          //         CurvedAnimation(
                                          //           parent: AnimationController(
                                          //               duration: const Duration(milliseconds: 200), vsync: this, value: 1.0),
                                          //           curve: Curves.easeOut,
                                          //         )),
                                          //     child: AppState.favoriteList.contains(AppState.songList[i].id)
                                          //         ? const Icon(
                                          //       Icons.favorite,
                                          //       size: 30,
                                          //       color: Colors.red,
                                          //     )
                                          //         : const Icon(
                                          //       Icons.favorite_border,
                                          //       size: 30,
                                          //     ),
                                          //   ),
                                          // ),
                                          horizontalTitleGap: 0,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      )
                                  else if(selectedType == 2)
                                    for(int i = 0; i < albums.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: ListTile(
                                          onTap: (){

                                          },
                                          leading: Container(
                                            margin: const EdgeInsets.only(right: 20),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: QueryArtworkWidget(
                                              id: albums[i].id,
                                              type: ArtworkType.ARTIST,
                                              artworkBorder: BorderRadius.circular(5),
                                              keepOldArtwork: true,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            albums[i].album,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${albums[i].numOfSongs} songs",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFd5d5d5),
                                            ),
                                          ),
                                          // trailing: GestureDetector(
                                          //   onTap: () {
                                          //     if(AppState.favoriteList.contains(AppState.songList[i].id)){
                                          //       AppState.favoriteList.remove(AppState.songList[i].id);
                                          //     }else{
                                          //       AppState.favoriteList.add(AppState.songList[i].id);
                                          //     }
                                          //     setState(() {});
                                          //     _controller
                                          //         .reverse()
                                          //         .then((value) => _controller.forward());
                                          //   },
                                          //   child: ScaleTransition(
                                          //     scale: Tween(begin: 0.7, end: 1.0).animate(
                                          //         CurvedAnimation(
                                          //           parent: AnimationController(
                                          //               duration: const Duration(milliseconds: 200), vsync: this, value: 1.0),
                                          //           curve: Curves.easeOut,
                                          //         )),
                                          //     child: AppState.favoriteList.contains(AppState.songList[i].id)
                                          //         ? const Icon(
                                          //       Icons.favorite,
                                          //       size: 30,
                                          //       color: Colors.red,
                                          //     )
                                          //         : const Icon(
                                          //       Icons.favorite_border,
                                          //       size: 30,
                                          //     ),
                                          //   ),
                                          // ),
                                          horizontalTitleGap: 0,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      )
                                  else
                                    for(int i = 0; i < songListProvider.songList.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Consumer<CurrentSongProvider>(
                                            builder: (BuildContext context, currentSongProvider, Widget? child) {
                                              return ListTile(
                                                onTap: (){
                                                  currentSongProvider.selectedSong = songListProvider.songList[i];
                                                  setState(() {});
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayScreen()));
                                                },
                                                leading: Container(
                                                  margin: const EdgeInsets.only(right: 20),
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.2),
                                                        blurRadius: 6,
                                                      )
                                                    ],
                                                  ),
                                                  child: QueryArtworkWidget(
                                                    id: songListProvider.songList[i].id,
                                                    type: ArtworkType.AUDIO,
                                                    artworkBorder: BorderRadius.circular(5),
                                                    keepOldArtwork: true,
                                                    nullArtworkWidget: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      clipBehavior: Clip.antiAlias,
                                                      child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  songListProvider.songList[i].title,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  songListProvider.songList[i].artist != null ? songListProvider.songList[i].artist! : "<unknown>",
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFFd5d5d5),
                                                  ),
                                                ),
                                                trailing: Consumer<FavoriteListProvider>(
                                                    builder: (BuildContext context, favoriteListProvider, Widget? child) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          if(favoriteListProvider.favoriteList.contains(songListProvider.songList[i].id)){
                                                            favoriteListProvider.favoriteList.remove(songListProvider.songList[i].id);
                                                          }else{
                                                            favoriteListProvider.favoriteList.add(songListProvider.songList[i].id);
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
                                                          child: favoriteListProvider.favoriteList.contains(songListProvider.songList[i].id)
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
                                                horizontalTitleGap: 0,
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              );
                                            }
                                        ),
                                      ),
                                ],
                              ),
                            );
                          }
                      ) : Consumer<SongListProvider>(
                          builder: (BuildContext context, songListProvider, Widget? child) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  if(selectedType == 1)
                                    for(int i = 0; i < artists.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: ListTile(
                                          onTap: (){

                                          },
                                          leading: Container(
                                            margin: const EdgeInsets.only(right: 20),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: QueryArtworkWidget(
                                              id: artists[i].id,
                                              type: ArtworkType.ARTIST,
                                              artworkBorder: BorderRadius.circular(5),
                                              keepOldArtwork: true,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            artists[i].artist,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${artists[i].numberOfAlbums} songs",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFd5d5d5),
                                            ),
                                          ),
                                          // trailing: GestureDetector(
                                          //   onTap: () {
                                          //     if(AppState.favoriteList.contains(AppState.songList[i].id)){
                                          //       AppState.favoriteList.remove(AppState.songList[i].id);
                                          //     }else{
                                          //       AppState.favoriteList.add(AppState.songList[i].id);
                                          //     }
                                          //     setState(() {});
                                          //     _controller
                                          //         .reverse()
                                          //         .then((value) => _controller.forward());
                                          //   },
                                          //   child: ScaleTransition(
                                          //     scale: Tween(begin: 0.7, end: 1.0).animate(
                                          //         CurvedAnimation(
                                          //           parent: AnimationController(
                                          //               duration: const Duration(milliseconds: 200), vsync: this, value: 1.0),
                                          //           curve: Curves.easeOut,
                                          //         )),
                                          //     child: AppState.favoriteList.contains(AppState.songList[i].id)
                                          //         ? const Icon(
                                          //       Icons.favorite,
                                          //       size: 30,
                                          //       color: Colors.red,
                                          //     )
                                          //         : const Icon(
                                          //       Icons.favorite_border,
                                          //       size: 30,
                                          //     ),
                                          //   ),
                                          // ),
                                          horizontalTitleGap: 0,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      )
                                  else if(selectedType == 2)
                                    for(int i = 0; i < albums.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: ListTile(
                                          onTap: (){

                                          },
                                          leading: Container(
                                            margin: const EdgeInsets.only(right: 20),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 6,
                                                )
                                              ],
                                            ),
                                            child: QueryArtworkWidget(
                                              id: albums[i].id,
                                              type: ArtworkType.ARTIST,
                                              artworkBorder: BorderRadius.circular(5),
                                              keepOldArtwork: true,
                                              nullArtworkWidget: ClipRRect(
                                                borderRadius: BorderRadius.circular(5),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            albums[i].album,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "${albums[i].numOfSongs} songs",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFFd5d5d5),
                                            ),
                                          ),
                                          // trailing: GestureDetector(
                                          //   onTap: () {
                                          //     if(AppState.favoriteList.contains(AppState.songList[i].id)){
                                          //       AppState.favoriteList.remove(AppState.songList[i].id);
                                          //     }else{
                                          //       AppState.favoriteList.add(AppState.songList[i].id);
                                          //     }
                                          //     setState(() {});
                                          //     _controller
                                          //         .reverse()
                                          //         .then((value) => _controller.forward());
                                          //   },
                                          //   child: ScaleTransition(
                                          //     scale: Tween(begin: 0.7, end: 1.0).animate(
                                          //         CurvedAnimation(
                                          //           parent: AnimationController(
                                          //               duration: const Duration(milliseconds: 200), vsync: this, value: 1.0),
                                          //           curve: Curves.easeOut,
                                          //         )),
                                          //     child: AppState.favoriteList.contains(AppState.songList[i].id)
                                          //         ? const Icon(
                                          //       Icons.favorite,
                                          //       size: 30,
                                          //       color: Colors.red,
                                          //     )
                                          //         : const Icon(
                                          //       Icons.favorite_border,
                                          //       size: 30,
                                          //     ),
                                          //   ),
                                          // ),
                                          horizontalTitleGap: 0,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                        ),
                                      )
                                  else
                                    for(int i = 0; i < songListProvider.songList.length; i++)
                                      Material(
                                        elevation: 0,
                                        color: Colors.transparent,
                                        child: Consumer<CurrentSongProvider>(
                                          builder: (BuildContext context, currentSongProvider, Widget? child) {
                                            return ListTile(
                                              onTap: (){
                                                currentSongProvider.selectedSong = songListProvider.songList[i];
                                                setState(() {});
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayScreen()));
                                              },
                                              leading: Container(
                                                margin: const EdgeInsets.only(right: 20),
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.2),
                                                      blurRadius: 6,
                                                    )
                                                  ],
                                                ),
                                                child: QueryArtworkWidget(
                                                  id: songListProvider.songList[i].id,
                                                  type: ArtworkType.AUDIO,
                                                  artworkBorder: BorderRadius.circular(5),
                                                  keepOldArtwork: true,
                                                  nullArtworkWidget: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    clipBehavior: Clip.antiAlias,
                                                    child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                songListProvider.songList[i].title,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                songListProvider.songList[i].artist != null ? songListProvider.songList[i].artist! : "<unknown>",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFd5d5d5),
                                                ),
                                              ),
                                              trailing: Consumer<FavoriteListProvider>(
                                                builder: (BuildContext context, favoriteListProvider, Widget? child) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      if(favoriteListProvider.favoriteList.contains(songListProvider.songList[i].id)){
                                                        favoriteListProvider.favoriteList.remove(songListProvider.songList[i].id);
                                                      }else{
                                                        favoriteListProvider.favoriteList.add(songListProvider.songList[i].id);
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
                                                      child: favoriteListProvider.favoriteList.contains(songListProvider.songList[i].id)
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
                                              horizontalTitleGap: 0,
                                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            );
                                          }
                                        ),
                                      ),
                                ],
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
                if(lastSongProvider.lastSong != null)
                  Consumer<MusicPlayerProvider>(
                    builder: (context, musicPlayerProvider, child) {
                      return Positioned(
                        left: 0,
                        bottom: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Material(
                              elevation: 0,
                              color: Colors.transparent,
                              child: ListTile(
                                onTap: (){

                                },
                                leading: Container(
                                  margin: const EdgeInsets.only(right: 20),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    // image: const DecorationImage(
                                    //   image: AssetImage("assets/images/lady.jpeg"),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 6,
                                      )
                                    ],
                                  ),
                                  child: QueryArtworkWidget(
                                    id: lastSongProvider.lastSong!.id,
                                    type: ArtworkType.AUDIO,
                                    artworkBorder: BorderRadius.circular(5),
                                    keepOldArtwork: true,
                                    nullArtworkWidget: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.asset("assets/images/empty.png", fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  lastSongProvider.lastSong!.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  lastSongProvider.lastSong!.artist != null ? lastSongProvider.lastSong!.artist! : "<unknown>",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    if(musicPlayerProvider.isSongPlaying) {
                                      musicPlayerProvider.audioPlayer.pause();
                                      musicPlayerProvider.isSongPlaying = false;
                                      setState(() {});
                                    }else{
                                      musicPlayerProvider.audioPlayer.play(DeviceFileSource(lastSongProvider.lastSong!.data));
                                      musicPlayerProvider.isSongPlaying = true;
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(musicPlayerProvider.isSongPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline, color: Colors.pink, size: 30,),
                                ),
                                tileColor: Colors.white,
                                horizontalTitleGap: 0,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              ),
                            ),
                            LinearProgressIndicator(
                              valueColor: const AlwaysStoppedAnimation(Colors.pink),
                              backgroundColor: Colors.white,
                              value: !(musicPlayerProvider.positionProvider.position.inMilliseconds/musicPlayerProvider.positionProvider.duration.inMilliseconds).isFinite ? 0.0 : (musicPlayerProvider.positionProvider.position.inMilliseconds/musicPlayerProvider.positionProvider.duration.inMilliseconds),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
              ],
            );
          }
        ),
      ),
    );
  }
}
