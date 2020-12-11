import 'package:flutter/material.dart';
import 'package:sample_data/sample_data.dart';

class SongListTile extends StatefulWidget {
  final String songCover;
  final String songTitle;
  final String songArtise;
  final String songDuration;
  final Function onTap;
  final bool isSelected;
  const SongListTile({
    Key key,
    @required this.isSelected,
    @required this.onTap,@required this.songCover, this.songTitle, this.songArtise, this.songDuration,
  }) : super(key: key);

  @override
  _SongListTileState createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  UniqueKey _uniqueKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _uniqueKey,
      onTap: () => widget.onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _tileColor())),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      widget.songCover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'The Woo year',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Pope Smoke',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Row(
                children: [
                  Text(
                    '4:19',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(Icons.play_arrow)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _tileColor() {
    if (widget.isSelected) {
      return [
        Colors.orangeAccent.withOpacity(.5),
        Colors.orangeAccent.withOpacity(.5),
        Colors.orange.withOpacity(.5),
        Colors.orange.withOpacity(.5),
        Colors.orangeAccent.withOpacity(.5),
      ];
    } else {
      return [
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).scaffoldBackgroundColor
      ];
    }
  }
}
