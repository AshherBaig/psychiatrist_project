import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VRTherapy extends StatefulWidget {
  @override
  _VRTherapyState createState() => _VRTherapyState();
}

class _VRTherapyState extends State<VRTherapy> {
  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with YouTube video IDs
    _controller1 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=HhjHYkPQ8F0")!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _controller2 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId("https://youtu.be/lDakSe04hQg?si=sFBr2K0BCfDHVXPp")!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );


  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VR Therapy Videos'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          YoutubePlayer(
            controller: _controller1,
            showVideoProgressIndicator: true,
            progressColors: ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
          ),
          SizedBox(height: 16.0),
          YoutubePlayer(
            controller: _controller2,
            showVideoProgressIndicator: true,
            progressColors: ProgressBarColors(
              playedColor: Colors.red,
              handleColor: Colors.redAccent,
            ),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VRTherapy(),
  ));
}
