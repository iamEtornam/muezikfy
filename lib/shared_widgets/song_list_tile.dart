import 'package:flutter/material.dart';
import 'package:muezikfy/utilities/custom_colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListTile extends StatefulWidget {
  final int? songCover;
  final String songTitle;
  final String songArtise;
  final String songDuration;
  final Function onTap;
  final bool isSelected;
  final bool isPlaying;
  const SongListTile({
    Key? key,
    required this.isSelected,
    required this.isPlaying,
    required this.onTap,
    this.songCover,
    required this.songTitle,
    required this.songArtise,
    required this.songDuration,
  }) : super(key: key);

  @override
  _SongListTileState createState() => _SongListTileState();
}

class _SongListTileState extends State<SongListTile> {
  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _tileColor(buildContext))),
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
                    child: Stack(
                      children: [
                        QueryArtworkWidget(
                          id: widget.songCover ?? 0,
                          type: ArtworkType.AUDIO,
                          size: 60,
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          color: Theme.of(buildContext)
                              .scaffoldBackgroundColor
                              .withOpacity(.3),
                          child: Icon(
                            widget.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: colorMain,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(buildContext).size.width - 210,
                        child: Text(
                          widget.songTitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(buildContext)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(buildContext).size.width - 210,
                        child: Text(
                          widget.songArtise,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(buildContext)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.songDuration,
                style: Theme.of(buildContext)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _tileColor(BuildContext buildContext) {
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
        Theme.of(buildContext).scaffoldBackgroundColor,
        Theme.of(buildContext).scaffoldBackgroundColor
      ];
    }
  }
}
