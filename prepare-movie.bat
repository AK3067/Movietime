@echo off
REM Drag your movie file onto this file. It cuts the film into small pieces
REM (so each file is far below GitHub's 100 MB limit) and shrinks it.
REM Needs ffmpeg:  winget install ffmpeg   (then restart this window)

if "%~1"=="" (
  echo Drag a movie file onto prepare-movie.bat
  pause
  exit /b
)

set "NAME=%~n1"
set "NAME=%NAME: =-%"
mkdir "movies\%NAME%" 2>nul

ffmpeg -i "%~1" -c:v libx264 -crf 28 -preset medium -vf "scale=-2:480" -force_key_frames "expr:gte(t,n_forced*6)" -c:a aac -b:a 96k -f hls -hls_time 30 -hls_playlist_type vod -hls_segment_filename "movies\%NAME%\seg_%%04d.ts" "movies\%NAME%\index.m3u8"

echo.
echo Done. Now add this to movies.json:
echo   { "title": "%NAME%", "file": "movies/%NAME%/index.m3u8" }
echo Then upload the movies folder with GitHub Desktop or git (not the website).
pause
