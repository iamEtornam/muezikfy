import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:muezikfy/shared_widgets/song_list_tile.dart';
import 'package:muezikfy/shared_widgets/status_friends_widget.dart';
import 'package:sample_data/sample_data.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ScrollController _scrollController = ScrollController();
  UniqueKey _listViewKey = UniqueKey();
  bool isSelected;
  int _currentIndex;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MUEZIKFY',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: (){

          })
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              'what are your friends listening to?',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(fontWeight: FontWeight.normal),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              top: 6,
            ),
            child: SizedBox(
              height: 110,
              width: size.width,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) => StatusFriendsWidget(
                      avatar: kidsAvatar(), name: userName())),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              'Songs',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          ListView.separated(
              key: _listViewKey,
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(16, 10, 16, 24),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return SongListTile(
                  songCover: 'assets/pop_smoke_album.png',
                  isSelected: _isThisCitizenSelected(index),
                  onTap: () => _tapped(index),
                );
              },
              separatorBuilder: (_, __) => SizedBox(
                    height: 20,
                  ),
              itemCount: 20)
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: ()=> Navigator.pushNamed(context, '/playingView'),
        onVerticalDragStart: (details) => Navigator.pushNamed(context, '/playingView'),
        child: Hero(
          tag: 'to_playing',
          child: Container(
            padding: EdgeInsets.all(10),
            width: size.width,
            height: 90,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.orangeAccent.withOpacity(.5),
                  Colors.orangeAccent.withOpacity(.5),
                  Colors.orangeAccent.withOpacity(.5),
                  Colors.orange.withOpacity(.5),
                  Colors.orangeAccent.withOpacity(.5),
                ])),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/pop_smoke.jpeg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width - 245,
                      height: 20,
                      child: Marquee(
                        text: 'The Bother man',
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        blankSpace: 100.0,
                        velocity: 100.0,
                        pauseAfterRound: Duration(seconds: 1),
                        accelerationDuration: Duration(seconds: 1),
                        accelerationCurve: Curves.linear,
                        decelerationDuration: Duration(milliseconds: 500),
                        decelerationCurve: Curves.easeOut,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      'Pop Smoke',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.skip_previous_rounded), onPressed: () {}),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 45,
                        height: 45,
                        child: Icon(
                          Icons.pause,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.deepOrangeAccent.withOpacity(.5),
                                  Colors.deepOrangeAccent.withOpacity(.5),
                                  Colors.deepOrangeAccent,
                                  Colors.deepOrange,
                                ])),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.skip_next), onPressed: () {}),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isThisCitizenSelected(int index) {
    if (_currentIndex == null) {
      return false;
    }

    if (_currentIndex == index) {
      return true;
    }

    return false;
  }

  void _tapped(int index) {
    _currentIndex = index;
    _listViewKey =
        UniqueKey(); //to force a redraw without keeping the settings in memory

    setState(() {
      //update UI
    });
  }
}
