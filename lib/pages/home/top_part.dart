import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music/pages/utils/circle_clipper.dart';
import 'package:music/pages/utils/colors.dart';
import 'package:music/songs.dart';

class TopPart extends StatefulWidget {
  @override
  _TopPartState createState() => _TopPartState();
}

class _TopPartState extends State<TopPart> {

  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        String songName = demoPlaylist.songs[playlist.activeIndex].songTitle;
        String songArtist = demoPlaylist.songs[playlist.activeIndex].artist;
        String albumImage = demoPlaylist.songs[playlist.activeIndex].albumArtUrl;
        String songAlbum = "Album Has";
        // String currentDuration = "2.1";
        // String totalDuration = "5.3";
        var nameTag = "";
        if(albumImage == null) {
          var wordArray = songName.split(" ");
          nameTag = (wordArray[0].toString()[0] + wordArray[1].toString()[0]).toUpperCase();
        }
        


        return AudioComponent(
          updateMe: [
            WatchableAudioProperties.audioSeeking,
            WatchableAudioProperties.audioPlayhead
          ],
          playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {


            String currentDuration = player.position != null ? player.position.toString().split(".")[0] : "0.00.00";
            String totalDuration = player.audioLength != null ? player.audioLength.toString().split(".")[0] : "0.00.00";

            return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.favorite, color: redishOrange,),
                    onPressed: () => print("liked"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  ClipOval(
                    clipper: CircleClipper(),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [red, Colors.orange[800]],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight
                        )
                      ),
                      child: albumImage == null ? 
                        Center(
                          child: Text(
                              nameTag, style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Rock salt",
                                color: Colors.white
                              ),
                        ),
                        )
                        : CircleAvatar(
                          backgroundImage: NetworkImage(albumImage),
                        ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: redishOrange,),
                    onPressed: () => print("More icon pressed"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(songName, style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
              SizedBox(
                height: 10,
              ),
              Text(songArtist, style: TextStyle(
                color: Colors.black,
                fontSize: 12
              )),
              SizedBox(
                height: 8,
              ),
              Text(songAlbum,  style: TextStyle(
                color: Colors.black,
                fontSize: 12
              )),
              SizedBox(
                height: 12,
              ),
              Container(
                width: 20,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: redishOrange
                ),
              ),
              SizedBox(
                height: 14,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(currentDuration, style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),),
                  Text("  /  ", style: TextStyle(color: Colors.black, fontSize: 18, 
                    fontWeight: FontWeight.bold,),),
                  Text(totalDuration, style: TextStyle(color: Colors.black45,fontSize: 18, 
                    fontWeight: FontWeight.bold,))
                ],
              )
            ],
          );
          },
        );
      },
    );
  }
}