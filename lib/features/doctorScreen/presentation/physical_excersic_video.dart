import 'package:flutter/material.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/video_player_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PhysicalExcersicVideo extends StatefulWidget {
  @override
  _PhysicalExcersicVideoState createState() => _PhysicalExcersicVideoState();
}

class _PhysicalExcersicVideoState extends State<PhysicalExcersicVideo> {
  String? videoId1 = "";

  @override
  void initState() {
    super.initState();
    // Get video IDs
    videoId1 = getYoutubeVideoId("https://youtube.com/shorts/5fFGzPCx4i4?feature=shared");
  }

  String? getYoutubeVideoId(String url) {
    // Updated RegExp to handle both standard YouTube and YouTube Shorts URLs
    final RegExp regex = RegExp(
        r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:watch\?v=|shorts\/)|youtu\.be\/)([a-zA-Z0-9_-]{11})'
    );

    final match = regex.firstMatch(url);
    return match?.group(1);
  }


  @override
  Widget build(BuildContext context) {
    if(videoId1 == null)
    {
      return Center(child: CircularProgressIndicator(color: Colors.white,),);
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text('Islamic Therapy Videos'),
        ),
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            _buildVideoThumbnail(context, videoId1!),
          ],
        ),
      );
    }
  }
  // Function to build the video thumbnail with a tap event
  Widget _buildVideoThumbnail(BuildContext context, String videoId) {
    return GestureDetector(
      onTap: () {
        // When the thumbnail is tapped, navigate to the video player screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(videoId: videoId),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Display the video thumbnail
          Image.network(
            'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200.0,
          ),
          // Add a play button overlay
          Icon(
            Icons.play_circle_fill,
            color: Colors.white,
            size: 64.0,
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('VR Therapy Videos'),
  //     ),
  //     body: ListView(
  //       padding: EdgeInsets.all(8.0),
  //       children: [
  //         YoutubePlayer(
  //           controller: _controller1,
  //           showVideoProgressIndicator: true,
  //           progressColors: ProgressBarColors(
  //             playedColor: Colors.red,
  //             handleColor: Colors.redAccent,
  //           ),
  //         ),
  //
  //         SizedBox(height: 16.0),
  //       ],
  //     ),
  //   );
  // }


}

