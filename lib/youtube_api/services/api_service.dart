import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sports_news_app/youtube_api/models/channel_model.dart';
import 'package:sports_news_app/youtube_api/models/video_model.dart';
import 'package:sports_news_app/youtube_api/utilities/keys.dart';

class APIService {
  APIService._instantiate();

  static final APIService instance = APIService._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<Channel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/channels',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Channel
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      Channel channel = Channel.fromMap(data);

      // Fetch first batch of videos from uploads playlist
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '100',
      'pageToken': _nextPageToken,
      'key': API_KEY,
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    // Get Playlist Videos
    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = [];
      for (int i = 0; i < data['items'].length; i++) {
        if (data['items'][i]["snippet"]["title"].contains("HIGHLIGHTS") &&
            data['items'][i]["snippet"]["title"].contains("(") &&
            data['items'][i]["snippet"]["title"].contains(")") &&
            !data['items'][i]["snippet"]["title"].contains("Rugby")) {
          print(data["items"][i]);
          videosJson.add(data['items'][i]);
        }
      }
      print(videosJson.length);

      // Fetch first eight videos from uploads playlist
      List<Video> videos = [];
      videosJson.forEach((json) => videos.add(
            Video.fromMap(json['snippet']),
          ));
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
