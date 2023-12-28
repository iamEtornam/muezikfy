import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:muezikfy/models/song.dart';
import 'package:muezikfy/providers/auth_provider.dart';
import 'package:muezikfy/utilities/ui_util.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListTile extends StatefulWidget {
  final Song song;
  final Function onTap;
  final bool isSelected;
  final bool isPlaying;
  final AuthProvider authProvider;
  const SongListTile({
    super.key,
    required this.isSelected,
    required this.isPlaying,
    required this.onTap,
    required this.song,
    required this.authProvider,
  });

  @override
  State<SongListTile> createState() => _SongListTileState();
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
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: QueryArtworkWidget(
                              id: widget.song.iId!,
                              type: ArtworkType.AUDIO,
                              size: 60,
                              nullArtworkWidget:
                                  CachedNetworkImage(imageUrl: defaultArtWork),
                              errorBuilder: (p0, p1, p2) {
                                return CachedNetworkImage(
                                    imageUrl: defaultArtWork);
                              },
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            color: Theme.of(buildContext)
                                .scaffoldBackgroundColor
                                .withOpacity(.3),
                            child: widget.isSelected
                                ? Icon(
                                    widget.authProvider.audioPlayer.isStopped()
                                        ? Icons.stop
                                        : widget.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(buildContext).size.width - 210,
                        child: Text(
                          widget.song.title ?? 'Unknown',
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
                          widget.song.artist ?? 'Unknown',
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
              const SizedBox(
                width: 10,
              ),
              StreamBuilder<Duration>(
                  stream: widget.authProvider.audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    final currentDuration = (widget.isSelected)
                        ? parseToMinutesSeconds(
                            snapshot.data?.inMilliseconds ?? 0)
                        : parseToMinutesSeconds(widget.song.duration ?? 0);
                    return Text(
                      currentDuration,
                      style: Theme.of(buildContext)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    );
                  }),
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
