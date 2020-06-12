import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:intl/date_symbol_data_local.dart'; //for date locale
import 'package:instant/instant.dart';

import 'PlayersPage.dart';
import 'package:sports_news_app/youtube_api/screens/home_screen.dart';
import 'package:sports_news_app/data_keys.dart';

class HomePage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() =>
      new HomePageState(); //sets the state of the class
}

class HomePageState extends State<HomePage> {
  bool loaded = false;
  List raw_data;
  List news_data;

  Icon customIcon = Icon(Icons.search, color: Colors.black);
  final TextEditingController _filter = new TextEditingController();

  Widget customSearchBar = Text(
    "Footy Hub",
    style: TextStyle(color: Colors.black, fontSize: 30.0),
  );

  @override
  void initState() {
    super.initState();
    waitForData();
  }

  void waitForData() async {
    await getScoresData();
    await getLatestNews();
    loaded = true;
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Color(0xffF3F3F3);
    final Color primaryColor = Color(0xffE70F0B);

    var titleTextStyle = TextStyle(
      color: Colors.black87,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
    var teamNameTextStyle = TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade800,
    );

    if (loaded == true) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: customSearchBar,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  setState(() {
                    if (this.customIcon.icon == Icons.search) {
                      this.customIcon = Icon(Icons.cancel, color: Colors.black);
                      this.customSearchBar = TextField(
                          controller: _filter,
                          //DON'T THINK THIS IS NEEDED
                          //change the properties of the textfield:
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PlayersPage(value)));
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "type player name:",
                            // hintStyle: TextStyle(fontSize: 16.0, color: Colors.redAccent)
                          ),
                          style:
                          TextStyle(color: Colors.black, fontSize: 16.0));
                    } else {
                      this.customIcon = Icon(Icons.search, color: Colors.black);
                      this.customSearchBar = Text(
                        "Footy Hub",
                        style: TextStyle(color: Colors.black, fontSize: 30.0),
                      );
                    }
                  });
                },
                icon: customIcon),
            IconButton(
                icon: Icon(Icons.refresh, color: Colors.blue),
                onPressed: waitForData),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            /*
            IconButton(
                icon: Icon(Icons.refresh, color: Colors.blue),
                onPressed: waitForData),
             */
            const SizedBox(height: 5.0),
            Card(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.green,
                  ),
                  child: Text(
                    "LATEST MATCHES",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
            const SizedBox(height: 5.0),
            raw_data[0]["data"].length != 0
                ? new ListView.builder(
              //remove scrollability from inner listview - ct like its part of outer list view:
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:
              raw_data == null ? 0 : raw_data[0]["data"].length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        //Spacer(),
                        raw_data[0]["data"][index]["time"]["status"] ==
                            "LIVE" ||
                            raw_data[0]["data"][index]["time"]
                            ["status"] ==
                                "HT"
                            ? Container(
                            height: 32.0,
                            width: 32.0,
                            padding: const EdgeInsets.all(10.0),
                            decoration: new BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(25.0),
                              color: Colors.green,
                            ),
                            child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: <Widget>[
                                  raw_data[0]["data"][index]["time"]
                                  ["status"] ==
                                      "LIVE"
                                      ? Text(
                                    raw_data[0]["data"][index]
                                    ["time"]["minute"]
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.0,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                      : Text(
                                    raw_data[0]["data"][index]
                                    ["time"]["status"]
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9.0,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ]))
                            : Container(
                          height: 32.0,
                          width: 32.0,
                          padding: const EdgeInsets.all(10.0),
                          decoration: new BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(25.0),
                            color: Colors.grey,
                          ),
                          child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  raw_data[0]["data"][index]["time"]
                                  ["status"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ]),
                        ),
                        Spacer(),
                        Image.network(
                            raw_data[0]["data"][index]["localTeam"]
                            ["data"]["logo_path"],
                            width: 25,
                            height: 25),
                        Spacer(),
                        SizedBox(
                          width: 60,
                          child: Text(
                            raw_data[0]["data"][index]["localTeam"]
                            ["data"]["name"]
                                .toString(),
                            style: teamNameTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                        raw_data[0]["data"][index]["time"]["status"] !=
                            "NS"
                            ? Row(children: [
                          SizedBox(
                            width: 30,
                            child: Text(
                              raw_data[0]["data"][index]["scores"]
                              ["localteam_score"]
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "-",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                            child: Text(
                              raw_data[0]["data"][index]["scores"]
                              ["visitorteam_score"]
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ])
                            : Row(children: [
                          SizedBox(
                            width: 70,
                            child: Text(
                              DateFormat.jm().format(
                                  DateFormat("hh:mm:ss").parse(
                                      raw_data[0]["data"][index]
                                      ["time"]
                                      ["starting_at"]["time"])),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ]),
                        Spacer(),
                        SizedBox(
                          width: 60,
                          child: Text(
                            raw_data[0]["data"][index]["visitorTeam"]
                            ["data"]["name"]
                                .toString(),
                            style: teamNameTextStyle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Spacer(),
                        Image.network(
                            raw_data[0]["data"][index]["visitorTeam"]
                            ["data"]["logo_path"],
                            width: 25,
                            height: 25),
                        Spacer(),
                        Spacer(),
                      ],
                    ),
                  ),
                );
              },
            )
                : new Container(
              //height: 100,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "NO GAMES CURRENTLY IN SCHEDULE",
                    style: teamNameTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Divider(),
            const SizedBox(height: 20.0),
            Card(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.orange,
                  ),
                  child: Text(
                    "BREAKING NEWS",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
            const SizedBox(height: 5.0),
            GestureDetector(
              onTap: () => _launchURL(news_data[0]["articles"][0]["url"]),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    news_data[0]["articles"][0]["urlToImage"]),
                                fit: BoxFit.cover,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            news_data[0]["articles"][0]["title"],
                            style: titleTextStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                news_data[0]["articles"][0]["publishedAt"]
                                    .substring(0, 10) +
                                    ", " +
                                    DateFormat.jm().format(
                                        DateFormat("hh:mm:ss").parse(
                                            dateTimeToZone(
                                                zone: "EST",
                                                datetime: DateTime.parse(
                                                    news_data[0]["articles"]
                                                    [0]["publishedAt"]))
                                                .toString()
                                                .substring(11, 19))) +
                                    " EST",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Football",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                    Positioned(
                      top: 190,
                      left: 20.0,
                      child: Container(
                        color: Colors.green,
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "LIVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Divider(),
            const SizedBox(height: 10.0),
            ListView.builder(
              //remove scrollability from inner listview - ct like its part of outer list view:
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                news_data == null ? 0 : news_data[0]["articles"].length - 1,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    onTap: () =>
                        _launchURL(news_data[0]["articles"][index + 1]["url"]),
                    contentPadding: EdgeInsets.only(
                        top: 15.0, right: 15.0, bottom: 10.0, left: 10.0),
                    title: Text(
                      news_data[0]["articles"][index + 1]["title"],
                      style: titleTextStyle,
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(news_data[0]["articles"][index + 1]
                      ["publishedAt"]
                          .substring(0, 10) +
                          ", " +
                          DateFormat.jm().format(DateFormat("hh:mm:ss").parse(
                              dateTimeToZone(
                                  zone: "EST",
                                  datetime: DateTime.parse(news_data[0]
                                  ["articles"][index + 1]
                                  ["publishedAt"]))
                                  .toString()
                                  .substring(11, 19))) +
                          " EST"),
                    ),
                    trailing: Container(
                      width: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: NetworkImage(news_data[0]["articles"]
                            [index + 1]["urlToImage"]),
                            fit: BoxFit.cover,
                          )),
                    ),
                  );
                }),
            const SizedBox(height: 10.0),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: bgColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey.shade700,
          currentIndex: 0,
          elevation: 0,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.listAlt),
              title: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Icon(
                  FontAwesomeIcons.solidCircle,
                  size: 8.0,
                  color: primaryColor,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.film),
              title: Text(""),
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
        ), //
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: SpinKitRing(
              color: Colors.white,
              size: 50.0,
            ),
          ));
    }
  }

  void onTabTapped(int index) {
    //print(index);
    setState(() {
      if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }

  //This function gets the latest matches information
  Future<String> getScoresData() async {
    try {
      http.Response response = await http.get(
        //Uri.encodeFull removes all the dashes or extra characters present in our Uri
          Uri.encodeFull(
              "https://football-pro.p.rapidapi.com/api/v2.0/livescores?tz=Canada/Eastern&markets=1&include=localTeam,visitorTeam&leagues=8,564,384,82,301,390"),
          //prem, la liga, seria a, bundes, ligue 1
          //https://football-pro.p.rapidapi.com/api/v2.0/livescores?tz=Canada/Eastern&markets=1&include=localTeam,visitorTeam&leagues=8,564,384,82,301 //prem, la liga, seria a, bundes, ligue 1, coppa italia
          //https://football-pro.p.rapidapi.com/api/v2.0/fixtures/date/2020-5-27?tz=Canada/Eastern&markets=1&include=localTeam,visitorTeam&leagues=8,82 - scores by date
          //https://football-pro.p.rapidapi.com/api/v2.0/livescores/now?markets=1&include=localTeam,visitorTeam&leagues=8,564,384,82,301) - live scores
          headers: {
            //if your api require key then pass your key here as well e.g "key": "my-long-key"
            "x-rapidapi-host": "football-pro.p.rapidapi.com",
            "x-rapidapi-key": SPORTMONKS_FOOTBALL_PRO_API_KEY
          });
      this.setState(() {
        raw_data = [json.decode(response.body)];
      });
      //print(raw_data);
    } catch (error) {
      print('Caught error: $error');
      raw_data = null;
    }

    return "Success!";
  }

  //This function gets the latest matches information
  Future<String> getLatestNews() async {
    try {
      http.Response response = await http.get(
        //Uri.encodeFull removes all the dashes or extra characters present in our Uri
        Uri.encodeFull(
            "http://newsapi.org/v2/everything?q=premier-league&sources=bbc-news&from=2020-05-25&sortBy=publishedAt&apiKey=$NEWSAPI_KEY"),
      );
      this.setState(() {
        news_data = [json.decode(response.body)];
      });
      //print(news_data);
      //print(news_data[0]["articles"].length);
    } catch (error) {
      print('Caught error: $error');
      news_data = null;
    }

    return "Success!";
  }
}
