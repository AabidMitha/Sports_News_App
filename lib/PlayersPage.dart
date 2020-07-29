import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:sports_news_app/data_keys.dart';

class PlayersPage extends StatefulWidget {
  String playerName;

  PlayersPage(String playerName) {
    this.playerName = playerName;
  }

  //THIS IS THE SAME AS THE ONE ABOVE BUT DOESNT WORK:
  //SecondRoute({this.playerName});

  @override
  State<StatefulWidget> createState() =>
      new PlayersPageState(); //sets the state of the class
}

class PlayersPageState extends State<PlayersPage> {
  bool loaded = false;
  int player_club_team_id;
  int player_national_team_id;
  int player_id;

  int active_league_id;
  String active_league_name;
  String active_league_logo;

  var player_position_map = {1: 'GK', 2: 'DEF', 3: 'MID', 4: 'FWD'};

  @override
  void initState() {
    super.initState();
    waitForData();
  }

  void waitForData() async {
    await getPlayersData(widget.playerName);
    loaded = true;
  }

  List player_data;
  List player_club_team_data;
  PaletteColor backgroundTheme;
  List player_national_team_data;
  List team_latest_season_data;
  List player_latest_season_data;

  var titleTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );

  var playerNameTextStyle = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    if (loaded == true) {
      return Scaffold(
        backgroundColor: player_club_team_data[0]["data"]["venue"] != null &&
            player_club_team_data[0]["data"]["venue"]["data"]["image_path"] !=
                null ?
        Colors.grey[900] : Colors.white,
        appBar: AppBar(
          title: Text("" /*widget.playerName*/),
        ),
        body: Center(
          //CHANGE TO container
            child:
            player_data == null ||
                player_data[0]["data"].length == 0 ||
                player_club_team_data == null ||
                player_club_team_data[0]["data"].length == 0 ||
                player_national_team_data == null ||
                player_national_team_data[0]["data"].length == 0 ?
            Center(
                child: Text(
                  "No Matches Found",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18
                  ),
                  textAlign: TextAlign.center,
                )
            ) :
            Container(
              decoration: player_club_team_data[0]["data"]["venue"] != null &&
                  player_club_team_data[0]["data"]["venue"]["data"]["image_path"] !=
                      null ?
              BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      player_club_team_data[0]["data"]["venue"]["data"]["image_path"]),
                  fit: BoxFit.cover,
                ),
              ) :
              BoxDecoration(
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: player_data == null ||
                      player_data[0]["data"].length == 0 ||
                      player_club_team_data == null ||
                      player_club_team_data[0]["data"].length == 0 ||
                      player_national_team_data == null ||
                      player_national_team_data[0]["data"].length == 0
                      ? 0
                      : player_data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Container(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(children: <Widget>[
                          Container(
                            decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                //color: Colors.blue[900],
                                color: backgroundTheme.color),
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(width: 15.0),
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      player_data[0]["data"][0]["image_path"]),
                                  backgroundColor: Colors.white,
                                  //backgroundColor: backgroundTheme.color,
                                  radius: 30,
                                ),
                                const SizedBox(width: 10.0),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .width / 1.5,
                                        child: Text(
                                          player_data[0]["data"][0]["display_name"],
                                          style: playerNameTextStyle,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              player_club_team_data[0]["data"]
                                              ["logo_path"]),
                                          //backgroundColor: Colors.blue[900],
                                          backgroundColor: backgroundTheme
                                              .color,
                                          radius: 15,
                                        ),
                                        const SizedBox(width: 5.0),
                                        Text(
                                          player_club_team_data[0]["data"]["name"],
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ])
                                    ])
                              ],
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Container(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(children: <Widget>[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_data[0]["data"][0]
                                                ["height"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  player_data[0]["data"][0]
                                                  ["height"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  "Height",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                          Spacer(),
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_data[0]["data"][0]
                                                ["birthdate"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  player_data[0]["data"][0]
                                                  ["birthdate"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  "Birthdate",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                          Spacer(),
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_data[0]["data"][0]
                                                ["weight"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  player_data[0]["data"][0]
                                                  ["weight"],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  "Weight",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                        ]),
                                    const SizedBox(height: 30.0),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_data[
                                                0][
                                                "data"][0]
                                                [
                                                "birthdate"] != null ?
                                                Text(
                                                  (DateTime
                                                      .now()
                                                      .difference(DateFormat(
                                                      'd/M/yyyy')
                                                      .parse(player_data[
                                                  0][
                                                  "data"][0]
                                                  [
                                                  "birthdate"]))
                                                      .inDays /
                                                      365)
                                                      .floor()
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ) :
                                                Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  "Age      ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                          Spacer(),
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_national_team_data[
                                                0]["data"]
                                                ["image_path"] != null ?
                                                Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage(
                                                            player_national_team_data[
                                                            0]["data"]
                                                            ["image_path"]),
                                                        backgroundColor:
                                                        Colors.white,
                                                        radius: 10,
                                                      ),
                                                      const SizedBox(
                                                          width: 5.0),
                                                      Text(
                                                        player_national_team_data[0]
                                                        ["data"]["name"],
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: TextStyle(),
                                                      ),
                                                    ]) :
                                                Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        player_national_team_data[0]
                                                        ["data"]["name"],
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: TextStyle(),
                                                      ),
                                                    ]),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  "Country",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                          Spacer(),
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  player_position_map[player_data[0]
                                                  ["data"][0]["position_id"]],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  "Pos      ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                        ]),
                                    const SizedBox(height: 30.0),
                                    new Divider(),
                                    const SizedBox(height: 30.0),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          active_league_name != null ?
                                          Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Image.network(
                                                    active_league_logo,
                                                    width: 20,
                                                    height: 20),
                                                //const SizedBox(width: 5.0),
                                                //THIS IS ANNOYING!
                                                SizedBox(
                                                  width:
                                                  MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width / 2,
                                                  child: Text(
                                                    active_league_name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                ),
                                              ]) :
                                          Row(),
                                        ]),
                                    active_league_name != null ?
                                    const SizedBox(height: 30.0)
                                        : const SizedBox(),
                                    player_latest_season_data[0]
                                    ["data"]
                                    ["stats"]
                                    ["data"].length != 0 ?
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_latest_season_data[0]["data"]
                                                ["stats"]["data"][0]
                                                ["appearences"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  player_latest_season_data[0]
                                                  ["data"]
                                                  ["stats"]
                                                  ["data"][0]
                                                  ["appearences"]
                                                      .toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  "Games",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                          Spacer(),
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_position_map[player_data[0]
                                                ["data"][0]
                                                ["position_id"]] ==
                                                    'GK'
                                                    ? player_latest_season_data[0]
                                                ["data"]
                                                ["stats"]
                                                ["data"][0]
                                                ["saves"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  "  " +
                                                      player_latest_season_data[
                                                      0]
                                                      ["data"]
                                                      ["stats"][
                                                      "data"][0]["saves"]
                                                          .toString(),
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : player_latest_season_data[0]
                                                ["data"]
                                                ["stats"]
                                                ["data"][0]
                                                ["goals"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  "  " +
                                                      player_latest_season_data[
                                                      0]
                                                      ["data"]
                                                      ["stats"][
                                                      "data"][0]["goals"]
                                                          .toString(),
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                player_position_map[player_data[0]
                                                ["data"][0]
                                                ["position_id"]] ==
                                                    'GK'
                                                    ? Text(
                                                  "  Saves",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                                    : Text(
                                                  "  Goals",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                          Spacer(),
                                          Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                player_position_map[player_data[0]
                                                ["data"][0]
                                                ["position_id"]] ==
                                                    'GK'
                                                    ? player_latest_season_data[0]
                                                ["data"]
                                                ["stats"]
                                                ["data"][0]
                                                ["duels"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  player_latest_season_data[0]["data"]["stats"]
                                                  ["data"][0]
                                                  ["duels"]
                                                  ["won"]
                                                      .toString() +
                                                      "/" +
                                                      player_latest_season_data[0]
                                                      ["data"]
                                                      [
                                                      "stats"]
                                                      [
                                                      "data"][0]
                                                      [
                                                      "duels"]["total"]
                                                          .toString(),
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : player_latest_season_data[0]
                                                ["data"]
                                                ["stats"]
                                                ["data"][0]
                                                ["assists"] ==
                                                    null
                                                    ? Text(
                                                  "N/A",
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                )
                                                    : Text(
                                                  player_latest_season_data[
                                                  0]
                                                  ["data"]
                                                  [
                                                  "stats"]["data"]
                                                  [0]["assists"]
                                                      .toString(),
                                                  textAlign:
                                                  TextAlign.center,
                                                  style: TextStyle(),
                                                ),
                                                const SizedBox(height: 5.0),
                                                player_position_map[player_data[0]
                                                ["data"][0]
                                                ["position_id"]] ==
                                                    'GK'
                                                    ? Text(
                                                  "Duels   ",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                                    : Text(
                                                  "Assists",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]),
                                        ]) :
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "No Stats Available",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    )
                                  ]))),
                        ]));
                  }),
            )
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: SpinKitThreeBounce(
              color: Colors.white,
              size: 35.0,
            ),
          ));
    }
  }

  //This function gets the player information when a player is searched
  Future<String> getPlayersData(String player_name) async {
    //we have to wait to get the data so we use 'await'
    try {
      http.Response playerResponse = await http.get(
        //Uri.encodeFull removes all the dashes or extra characters present in our Uri
          Uri.encodeFull(
              "https://soccer.sportmonks.com/api/v2.0/players/search/$player_name?api_token=$SPORTMONKS_GENERAL_API_KEY"),
          headers: {
            //if your api require key then pass your key here as well e.g "key": "my-long-key"
            "api_token": SPORTMONKS_GENERAL_API_KEY
          });

      this.setState(() {
        player_data = [json.decode(playerResponse.body)];
      });
      //print(player_data);

      //Get club team and national team ids for 2 more API calls if intial call is successful
      player_club_team_id = player_data[0]["data"][0]["team_id"];
      player_national_team_id = player_data[0]["data"][0]["country_id"];
      player_id = player_data[0]["data"][0]["player_id"];
    } catch (error) {
      print('Caught error: $error');
      player_data = null;
    }

    /*
    String player_display_name = player_data[0]["data"][0]["display_name"];
    String player_birthdate = player_data[0]["data"][0]["birthdate"];
    String player_height = player_data[0]["data"][0]["height"];
    String player_image = player_data[0]["data"][0]["image_path"];

    print(player_display_name);
    print(player_birthdate);
    print(player_height);
    print(player_image);
     */

    //Get club team data
    //we have to wait to get the data so we use 'await'
    try {
      http.Response playerClubTeamResponse = await http.get(
        //Uri.encodeFull removes all the dashes or extra characters present in our Uri
          Uri.encodeFull(
              "https://soccer.sportmonks.com/api/v2.0/teams/$player_club_team_id?api_token=$SPORTMONKS_GENERAL_API_KEY&include=country,coach,venue"),
          headers: {
            //if your api require key then pass your key here as well e.g "key": "my-long-key"
            "api_token": SPORTMONKS_GENERAL_API_KEY
          });

      this.setState(() {
        player_club_team_data = [json.decode(playerClubTeamResponse.body)];
      });
      //print(player_club_team_data);

      //Get prominent vibrant colour from logo
      final PaletteGenerator generator =
      await PaletteGenerator.fromImageProvider(
        NetworkImage(player_club_team_data[0]["data"]["logo_path"]),
        size: Size(150, 150),
      );
      if (generator.vibrantColor != null) {
        backgroundTheme = generator.vibrantColor;
      } else {
        backgroundTheme = PaletteColor(Colors.blue[900], 2);
      }
    } catch (error) {
      print('Caught error: $error');
      player_club_team_data = null;
    }

    //Get national team data
    //we have to wait to get the data so we use 'await'
    try {
      http.Response playerNationalTeamResponse = await http.get(
        //Uri.encodeFull removes all the dashes or extra characters present in our Uri
          Uri.encodeFull(
              "https://soccer.sportmonks.com/api/v2.0/countries/$player_national_team_id?api_token=$SPORTMONKS_GENERAL_API_KEY"),
          headers: {
            //if your api require key then pass your key here as well e.g "key": "my-long-key"
            "api_token": SPORTMONKS_GENERAL_API_KEY
          });

      this.setState(() {
        player_national_team_data = [
          json.decode(playerNationalTeamResponse.body)
        ];
      });
      //print(player_national_team_data);
    } catch (error) {
      print('Caught error: $error');
      player_national_team_data = null;
    }

    //Get team latest season data
    //we have to wait to get the data so we use 'await'
    try {
      http.Response teamLatestSeasonResponse = await http.get(
        //Uri.encodeFull removes all the dashes or extra characters present in our Uri
          Uri.encodeFull(
              "https://football-pro.p.rapidapi.com/api/v2.0/teams/$player_club_team_id?include=activeSeasons.league"),
          headers: {
            //if your api require key then pass your key here as well e.g "key": "my-long-key"
            "x-rapidapi-host": "football-pro.p.rapidapi.com",
            "x-rapidapi-key": SPORTMONKS_FOOTBALL_PRO_API_KEY
          });
      this.setState(() {
        team_latest_season_data =
        json.decode(
            teamLatestSeasonResponse.body)["data"]["activeSeasons"]["data"];
      });
      //print(team_latest_season_data);
      for (int i = 0; i < team_latest_season_data.length; i++) {
        if (team_latest_season_data[i]["league"]["data"]["type"] ==
            "domestic" &&
            team_latest_season_data[i]["league"]["data"]["name"] !=
                "Club Friendlies") {
          active_league_id = team_latest_season_data[i]["id"];
          active_league_name = team_latest_season_data[i]["name"] + " " +
              team_latest_season_data[i]["league"]["data"]["name"];
          active_league_logo =
          team_latest_season_data[i]["league"]["data"]["logo_path"];
          //print(active_league_id);
          //print(active_league_name);
          //print(active_league_logo);
          break;
        }
      }
    } catch (error) {
      print('Caught error: $error');
      team_latest_season_data = null;
    }

    //Get player latest season data
    //we have to wait to get the data so we use 'await'
    try {
      http.Response playerLatestSeasonResponse = await http.get(
        //Uri.encodeFull removes all the dashes or extra characters present in our Uri
          Uri.encodeFull(
            //only works for premier league:
              "https://soccer.sportmonks.com/api/v2.0/players/$player_id?api_token=$SPORTMONKS_GENERAL_API_KEY&include=stats:filter(season_id|$active_league_id)"),
          headers: {
            //if your api require key then pass your key here as well e.g "key": "my-long-key"
            "api_token": SPORTMONKS_GENERAL_API_KEY
          });

      this.setState(() {
        player_latest_season_data = [
          json.decode(playerLatestSeasonResponse.body)
        ];
      });
      //print(player_latest_season_data);
    } catch (error) {
      print('Caught error: $error');
      player_latest_season_data = null;
    }

    return "Success!";
  }
}
