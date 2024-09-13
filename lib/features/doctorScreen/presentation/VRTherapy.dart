import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psychiatrist_project/features/patientScreen/presentation/video_player_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VRTherapy extends StatefulWidget {
  @override
  _VRTherapyState createState() => _VRTherapyState();
}

class _VRTherapyState extends State<VRTherapy> {
  String? videoId1 = "";
  String? videoId2 = "";
  @override
  void initState() {
    super.initState();

    // Get video IDs
    videoId1 = getYoutubeVideoId("https://www.youtube.com/watch?v=79kpoGF8KWU");
    videoId2 = getYoutubeVideoId("https://youtu.be/lDakSe04hQg?si=sFBr2K0BCfDHVXPp");
  }

  String? getYoutubeVideoId(String url) {
    // RegExp to extract video ID from YouTube URL
    final RegExp regex = RegExp(
        r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})');
    final match = regex.firstMatch(url);
    return match?.group(1);
  }


  @override
  Widget build(BuildContext context) {
    if(videoId1 == null || videoId2 == null)
    {
      return Center(child: CircularProgressIndicator(color: Colors.white,),);
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: Text('VR Therapy Videos'),
        ),
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            _buildVideoThumbnail(context, videoId1!),
            SizedBox(height: 16.0),
            _buildVideoThumbnail(context, videoId2!),
            SizedBox(height: 16.0),
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
  //           onReady: () {
  //             _controller1.addListener(() {
  //               if (_controller1.value.isFullScreen) {
  //                 _goFullScreen(_controller1); // Go full screen on button press
  //               }
  //             });
  //           },
  //         ),
  //         SizedBox(height: 16.0),
  //         YoutubePlayer(
  //           controller: _controller2,
  //           showVideoProgressIndicator: true,
  //           progressColors: ProgressBarColors(
  //             playedColor: Colors.red,
  //             handleColor: Colors.redAccent,
  //           ),
  //           onReady: () {
  //             _controller2.addListener(() {
  //               if (_controller2.value.isFullScreen) {
  //                 _goFullScreen(_controller2); // Go full screen on button press
  //               }
  //             });
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
// }

