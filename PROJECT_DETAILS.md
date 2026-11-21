# Project Details: Two Seats – Watch a Film Together

## 1. Project Overview & Idea
**Two Seats** is a lightweight, zero-backend, peer-to-peer web application designed for two people to watch movies together remotely in absolute synchronization. 

Users can:
1. Host a session with one click and generate a unique "Ticket" invite link.
2. Share the ticket link with their partner.
3. Stream video smoothly directly from the static web host using HTTP Live Streaming (HLS).
4. Synchronize video playback (play, pause, seek, drift correction) with millisecond-accuracy.
5. Communicate seamlessly via built-in real-time peer-to-peer voice chat and text messages.

## 2. Core Architecture
- **Static Hosting**: GitHub Pages (no dedicated server, serverless and free forever).
- **Media Delivery**: HLS (HTTP Live Streaming) chunked `.ts` segments (each < 3MB) indexed via `index.m3u8` to bypass GitHub's 100MB single-file limit and avoid large buffer freezes.
- **Peer-to-Peer Communication**: WebRTC mediated through PeerJS for signaling, real-time data channel messages, and voice stream audio.
- **Time Synchronization (NTP-style)**:
  - High-frequency ping/pong latency measurement to establish a shared reference clock.
  - State vector `{ playing, position, referenceTime }` computed continuously.
  - Scheduled playback triggers (initiating action 0.4–1.5s in the future so both clients start simultaneously).
  - Micro-drift rate adjustment (±6% speed tweak) to prevent noticeable frame skips.

## 3. Basic Features & Capabilities
- **HLS Video Streaming**: Smooth seeking across the entire timeline without loading massive files in memory.
- **Synchronized Playback Controls**: Shared play/pause/scrub with automatic buffer holds when either peer is lagging.
- **Voice Calling**: Low-latency microphone audio with acoustic echo cancellation, partner volume slider, and speaker activity indicators.
- **Movie-Only Mode**: Distraction-free full-screen mode that mutes and fades UI elements, waking only on mouse movement or touch.
- **In-Room Chat**: Real-time text messaging alongside the film.
- **Direct Sync Button**: "Sync everyone to my scene" button for manual alignment.

## 4. Innovative Ideas for Future Evolution
- 💡 **Floating Reaction Emojis**: Tap quick reactions (❤️, 😂, 😱, 🍿) that float upwards on both viewers' screens in real-time.
- 💡 **Dual Subtitle Track Support (.vtt)**: Independent subtitle selection for each viewer with custom font size and synchronization offset.
- 💡 **Theater Lighting Ambient Glow**: Dynamic canvas-based ambient glow matching average video edge colors against the dark theater background.
- 💡 **Smart Bandwidth Degrader**: Automatically switches audio to low-bitrate Opus and pauses video when high packet loss is detected on mobile networks.
- 💡 **Memory Timestamp & Resume**: LocalStorage bookmarking so pairs can resume exactly where they left off if disconnected.
