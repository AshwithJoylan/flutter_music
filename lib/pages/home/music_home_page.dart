
import 'package:flutter/services.dart';
import 'package:music/pages/home/bottum_part.dart';
import 'package:music/pages/home/top_part.dart';
import 'package:music/pages/utils/colors.dart';
import 'package:music/songs.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:flute_music_player/flute_music_player.dart';


class MusicHomePage extends StatefulWidget {

  final currentSongDuration = 0.0;
  void initState() { 
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  @override
  _MusicHomePageState createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {

  Future initPlayer() async {
    final songs = await MusicFinder.allSongs();
    print("songs");
    print(songs);
  }
  @override
    void initState() {
      super.initState();
      initPlayer();
    }
  @override
  Widget build(BuildContext context) {
    return AudioPlaylist(
      playlist: demoPlaylist.songs.map((DemoSong song){
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Now Playing", style: TextStyle(
              color: Colors.black,
              fontSize: 18
            ),),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: redishOrange,
              ),
              onPressed: () => print("playing pressed"),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: redishOrange,
                ),
                onPressed: () => print("Action icon pressed"),
              )
            ],
          ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TopPart(),
            BottumPart(),
          ],
        ),
      ),
    );
  }
}

