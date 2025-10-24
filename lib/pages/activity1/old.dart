
  /* TODO
  REFACTOR ALL OF THIS
  Widget buildMainPlayer(AppSizes sizes,
      {required bool alwaysShowList, required bool isWide}) {
    return Container(
      decoration: BoxDecoration(
        gradient: ColorPalette.musicPlayerGradient,
      ),
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Container(color: Colors.transparent)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 200.0),
                            width: double.infinity,
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: (isWide)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: sizes.coverSize,
                                        width: sizes.coverSize,
                                        child: SongCover(
                                          song: songs.isNotEmpty
                                              ? songs[_currentIndex]
                                              : null,
                                          size: sizes.coverSize,
                                        ),
                                      ),
                                      SizedBox(
                                          height: (sizes.screenHeight * 0.02)
                                              .clamp(5.0, 15.0)),
                                      SongDetails(
                                        song: songs.isNotEmpty
                                            ? songs[_currentIndex]
                                            : null,
                                      ),
                                    ],
                                  )
                                : (_showSongList && alwaysShowList)
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: sizes.smallCoverSize,
                                            width: sizes.smallCoverSize,
                                            child: SongCover(
                                              song: songs.isNotEmpty
                                                  ? songs[_currentIndex]
                                                  : null,
                                              size: sizes.smallCoverSize,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 4),
                                                SongDetails(
                                                  song: songs.isNotEmpty
                                                      ? songs[_currentIndex]
                                                      : null,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: sizes.coverSize,
                                            width: sizes.coverSize,
                                            child: SongCover(
                                              song: songs.isNotEmpty
                                                  ? songs[_currentIndex]
                                                  : null,
                                              size: sizes.coverSize,
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  (sizes.screenHeight * 0.02)
                                                      .clamp(5.0, 15.0)),
                                          SongDetails(
                                            song: songs.isNotEmpty
                                                ? songs[_currentIndex]
                                                : null,
                                          ),
                                        ],
                                      ),
                          ),
                        ),
                        if (_showSongList && alwaysShowList && !isWide)
                          Container(
                            height: sizes.songListHeight,
                            color: Colors.transparent,
                            child: SongListPage(
                              songs: songs,
                              onSongTap: _playSong,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PlayerControls(
                                isPlaying: _isPlaying,
                                isShuffle: _isShuffle,
                                showSongList: _showSongList,
                                playSong: _playSong,
                                nextSong: _nextSong,
                                previousSong: _prevSong,
                                togglePlayPause: _togglePlayPause,
                                shuffleSong: () =>
                                    setState(() => _isShuffle = !_isShuffle),
                                toggleSongList: () =>
                                    setState(() => _showSongList = !_showSongList),
                                position: _position,
                                duration: _duration,
                                onSeek: (pos) async =>
                                    await _audioPlayer.seek(pos),
                                loopMode: _loopMode,
                                toggleLoopMode: _toggleLoopMode,
                              ),
                              SizedBox(
                                  height: (sizes.screenHeight * 0.01)
                                      .clamp(5.0, 15.0)),
                              PlayerControlsSecondary(
                                showSongList: _showSongList,
                                toggleSongList: () =>
                                    setState(() => _showSongList = !_showSongList),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isWide)
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  color: Colors.transparent,
                  child: SongListPage(
                    songs: songs,
                    onSongTap: _playSong,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  */
