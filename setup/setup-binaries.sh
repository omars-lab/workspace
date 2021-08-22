#!/bin/bash

# https://github.com/ytdl-org/youtube-dl/blob/master/README.md#readme
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl

rehash
