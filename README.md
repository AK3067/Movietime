# Two Seats – watch a film together

A tiny website for two people. One opens a room, sends a link, and both watch the
same film with play / pause / skip kept in sync. Films live inside this repository.

## Add your film

1. Put the video in the `movies/` folder (MP4, H.264 video + AAC audio plays everywhere).
2. Add it to `movies.json`:

```json
[
  { "title": "Our Film", "year": 2024, "file": "movies/our-film.mp4", "note": "Movie night" }
]
```

### Big film (for example 1 GB)

GitHub refuses any single file over **100 MB**, and the repository/site should stay under about **1 GB**, so a 1 GB film has to be shrunk **and** cut into small pieces. The site plays this format (HLS) with a normal seek bar over the whole film.

1. Install ffmpeg once: open PowerShell and run `winget install ffmpeg`. Close and reopen the window.
2. Drag your film onto **`prepare-movie.bat`**. It creates `movies/<name>/index.m3u8` plus many small `seg_0001.ts` files (about 30 seconds each, 480p). A 2-hour film usually ends up around 300-500 MB.
3. Add it to `movies.json`:

```json
{ "title": "Our Film", "file": "movies/our-film/index.m3u8" }
```

4. Upload with **GitHub Desktop** or git (`git add . && git commit -m film && git push`). The website upload page only takes 25 MB per file and 100 files at a time, so it is not suitable.

For higher quality change `scale=-2:480` to `scale=-2:720` and `-crf 28` to `-crf 30` in the .bat file, but check the total stays below about 800 MB.

### Small film (under 100 MB)

Use one MP4 file:

```bash
ffmpeg -i original.mkv -c:v libx264 -crf 26 -preset slow -vf scale=-2:720 \
       -c:a aac -b:a 128k -movflags +faststart movies/our-film.mp4
```

Only upload films you have the right to share.

## Publish

1. Push everything to a GitHub repository.
2. **Settings → Pages → Deploy from a branch → `main` / root.**
3. Open `https://YOUR-NAME.github.io/YOUR-REPO/`.

## Use

1. Choose a film and press **Open the room**.
2. Copy or share the ticket link. Keep your page open.
3. Your partner opens the link and presses **Take your seat**.

Both people can play, pause and skip. Chat is built in.

## How the "same scene" sync works

- **Shared clock.** The guest measures its clock offset to the host with ping/pong messages (like NTP) and keeps the fastest sample. Both browsers then agree on "now" within a few milliseconds.
- **One shared state.** The session is described by `{playing, position, reference time}`. Both browsers compute where the film should be *right now* from it, so both land on the same frame.
- **Scheduled start.** When anyone presses play or skips, both browsers seek and start at the same future moment (about 0.4-1.5 s later, depending on ping) instead of "as soon as the message arrives".
- **Drift correction, twice a second.** Small drift: playback speed is nudged by up to 6 % (not noticeable). Drift over 0.4 s: jump to the right spot.
- **Buffering hold.** If one person's film stalls, both pause; when they are ready again, both restart together.
- **Live readout.** The status pill shows ping and how many milliseconds you are off from your partner. **Sync everyone to my scene** forces both to your position.
- Video files are streamed from the repository to each browser; only tiny control messages go between the two browsers (WebRTC via PeerJS). The guest can only load films listed in `movies.json`.

## Talk while you watch (voice only)

- The browser asks for microphone permission when you open or join a room. There is **no camera**.
- Press the **Mic** button to mute. The button turns **red** and the page switches to **movie-only** (black background, just the film). Two buttons float on the film: a **red "Muted"** button (show the controls again, stay muted) and a **green "Unmute"** button (undo everything). A full-screen button is next to it. Buttons fade when idle and wake when you touch or move over the film.
- The **Mic** button mutes and unmutes you. The **Voice** slider sets your partner's voice volume, and a light shows when they are speaking.
- If you block the mic you can still hear your partner; allow it in the browser and tap the button again.
- **Use headphones.** Without them, the film's sound comes out of the speakers and goes back into the mic. Echo cancellation is on, but headphones are still best.
- The site must be on **https** (GitHub Pages is) for the browser to allow microphone access.

## Layout

Phone: film on top, everything else stacked below. Laptop (wide screens): big film on the left, side panel (ticket, voice, film picker, chat) on the right.

## Test locally

```bash
python3 -m http.server 8000
```

Open http://localhost:8000 in two browser windows (use the ticket link in the second).

## Troubleshooting

- **"Room is closed":** the host closed the page. Open a new room and send the new link.
- **Can't connect on some networks (strict corporate/mobile NAT):** free WebRTC needs a TURN server there. Add one in the `new Peer(...)` calls with `config: { iceServers: [...] }`.
- **Film won't play:** re-encode as H.264/AAC MP4 (command above).
