import 'package:flutter/material.dart';
import 'package:sports_news_app/youtube_api/models/channel_model.dart';
import 'package:sports_news_app/youtube_api/models/video_model.dart';
import 'package:sports_news_app/youtube_api/screens/video_screen.dart';
import 'package:sports_news_app/youtube_api/services/api_service.dart';

import 'package:sports_news_app/HomePage.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Channel _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCaNeFN9L6CHcfn_FA7I_Wng');
    setState(() {
      _channel = channel;
    });
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.id),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Image(
          image: NetworkImage(video.thumbnailUrl),
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Color(0xffF3F3F3);
    final Color primaryColor = Color(0xffE70F0B);
    return Scaffold(
      appBar: AppBar(
        title: Text('Highlights Powered by DAZN'),
        centerTitle: true,
      ),
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel.videos.length != int.parse(_channel.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _channel.videos.length,
                itemBuilder: (BuildContext context, int index) {
                  Video video = _channel.videos[index];
                  print(video.title);
                  return _buildVideo(video);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: bgColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade700,
        currentIndex: 1,
        elevation: 0,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.listAlt),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.film),
            title: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Icon(
                FontAwesomeIcons.solidCircle,
                size: 8.0,
                color: primaryColor,
              ),
            ),
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartBar),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboard),
            title: Text(""),
          ),
           */
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    print(index);
    setState(() {
      if (index == 0) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }
}
