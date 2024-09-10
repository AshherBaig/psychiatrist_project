import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PhysicalExcersicVideo extends StatefulWidget {
  @override
  _PhysicalExcersicVideoState createState() => _PhysicalExcersicVideoState();
}

class _PhysicalExcersicVideoState extends State<PhysicalExcersicVideo> {
  late YoutubePlayerController _controller1;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with YouTube video IDs
    _controller1 = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId("https://youtube.com/shorts/5fFGzPCx4i4?feature=shared")!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );




  }

  @override
  void dispose() {
    _controller1.dispose();
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
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PhysicalExcersicVideo(),
  ));
}
