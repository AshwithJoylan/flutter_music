import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music/pages/home/seek_bar.dart';
import 'package:music/pages/utils/circle_clipper.dart';
import 'package:music/pages/utils/colors.dart';
import 'package:swipedetector/swipedetector.dart';

class BottumPart extends StatefulWidget {
  @override
  _BottumPartState createState() => _BottumPartState();
}

class _BottumPartState extends State<BottumPart> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AudioPlaylistComponent(
        playlistBuilder:
            (BuildContext context, Playlist playlist, Widget child) {
          return Stack(children: <Widget>[
            Align(alignment: AlignmentDirectional.bottomCenter, child: AudioRadialSeekbar()),

            SwipeDetector(
              onSwipeLeft: () => playlist.next(),
              onSwipeRight: () => playlist.previous(),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: ClipOval(
                        clipper: CircleClipper(),
                        child: Container(
                          width: 200.0,
                          height: 200.0,
                          color: redishOrange,
                        ),
                      ),
                    ),

                    Center(
                        child: Container(
                          width: 130,
                          height: 130,
                          child: Material(
                            elevation: 20.0,
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(140),
                          ),
                        )),
                    Center(
                      child: Container(
                        width: 210,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            PreviousButton(),
                            NextButton(),
                          ],
                        ),
                      ),
                    ),
                    PlayPauseButton(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  onPressed: () => print("pressed"),
                  highlightElevation: 3,
                  elevation: 0.0,
                  fillColor: Colors.orange,
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.repeat, color: Colors.white,),
                ),
              ),
            ),

            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  onPressed: () => print("pressed"),
                  highlightElevation: 3,
                  elevation: 0.0,
                  fillColor: redishOrange,
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.shuffle, color: Colors.white,),
                ),
              ),
            ),

          ]);
        },
      ),
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AudioComponent(
        updateMe: [WatchableAudioProperties.audioPlayerState],
        playerBuilder:
            (BuildContext context, AudioPlayer player, Widget child) {
          IconData icon = Icons.music_note;
          Function onPressed;

          if (player.state == AudioPlayerState.playing) {
            icon = Icons.pause;
            onPressed = player.pause;
          } else if (player.state == AudioPlayerState.paused ||
              player.state == AudioPlayerState.completed) {
            icon = Icons.play_arrow;
            onPressed = player.play;
          }

          return RawMaterialButton(
            shape: CircleBorder(),
            highlightElevation: 3,
            highlightColor: Colors.orange,
            onPressed: onPressed,
            elevation: 0.0,
            padding: EdgeInsets.all(18),
            fillColor: Colors.yellow[700],
            child: Icon(
              icon,
              color: Colors.white,
            ),
          );
        },
      ),
    );
  }
}

class PreviousButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return RawMaterialButton(
          shape: CircleBorder(),
          onPressed: () => playlist.previous(),
          elevation: 0.0,
          highlightElevation: 1,
          fillColor: Colors.orange,
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.skip_previous,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return RawMaterialButton(
          shape: CircleBorder(),
          highlightElevation: 1,
          onPressed: () => playlist.next(),
          elevation: 0.0,
          fillColor: Colors.orange,
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.skip_next,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
