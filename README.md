🚀 Enhanced Communication System GUI (MATLAB)

A vivid, experiment-ready sandbox for digital comms: modulation, channels, error control, live plots, audio I/O, logging, and auto-tuning.

🧭 Overview

enhanced_co_message_gui.m launches a modern MATLAB GUI to type or record a message, simulate a full digital communication chain, and visualize what happens—waveform, constellation, spectrum, and eye diagram—while reporting BER, throughput, delay, SNR/Eb/N0, power, and quality. It also supports data export, audio save/playback, themes, visual effects, and auto-optimization.

✨ Key Features

Modulations: BPSK, QPSK, 8-PSK, 16/64/256-QAM, simple OFDM (QPSK subcarriers, CP).

Channels: AWGN, Rayleigh, Rician, Nakagami, simple Multi-path.

Error Control (demo-grade): CRC (checksum-style), Hamming (parity-style), Turbo (repetition) + Interleaver.

Pulse Shaping: RRC/Gaussian/Hamming/Blackman (upsampling+filtering approximations).

Audio I/O: 5-sec mic recording → envelope detection “speech-to-text” stub; play & save WAV/MP3.

Live Analytics: BER, throughput, delay, CRC status, Eb/N0, SNR(est), RX power, quality (0–100).

Plots: Waveform (TX/RX), Constellation (RX + reference), Spectrum (PSD), Eye diagram (from RX).

UI/UX: Status LED, progress messages, colorful themes, effects, advanced settings, logs & stats dashboards.

Logging & Export: CSV/XLSX/MAT export; in-app table viewer with summaries.

📦 Requirements

MATLAB R2018a+ (tested with base MATLAB)

Communications Toolbox (for de2bi/bi2de; if unavailable, swap with custom bit mapping)

Audio device (for recording/playback)

No other toolboxes strictly required; plots use base graphics.

🚀 Quick Start

Clone/Copy the file into a folder on your MATLAB path.

Run in MATLAB:

enhanced_co_message_gui


In the GUI:

Type a message (or click 🎤 RECORD to capture 5 s of audio).

Pick SNR, Modulation, Channel, Pulse, and any coding checkboxes.

Click 🚀 TRANSMIT to simulate; watch plots and metrics update.

Use 📊 STATS, 📋 LOG, 💾 EXPORT as needed.

🎮 Controls & Buttons

Input panel

💬 Message: text to send (auto-filled after recording or loading).

🔊 SNR(dB) slider: −10 to 50 dB.

📡 Modulation: BPSK/QPSK/8-PSK/16-QAM/64-QAM/256-QAM/OFDM.

🌊 Channel: AWGN/Rayleigh/Rician/Nakagami/Multi-path.

🛡️ CRC, ⚡ Hamming, 🔀 Interleave, 🚀 Turbo Code: enable demo ECC layers.

📊 Pulse: None/RRC/Gaussian/Hamming/Blackman.

⚡ Power: scales TX amplitude.

🚀 TRANSMIT: run full pipeline.

🎤 RECORD: 5 s mic capture → simple VAD → text stub to message box.

📁 LOAD: import .txt/.csv/.mat or .wav/.mp3 (mono mixdown).

🧹 CLEAR: reset plots, metrics, and received text.

💾 EXPORT: save log as CSV/XLSX/MAT.

⚙️ ADV: change sample rate (currentFs).

Output panel

📨 Received: decoded text summary.

Metric tiles: BER, Throughput, Delay, CRC, Eb/N0, Est SNR, RX Power, Quality.

🔊 PLAY / 💾 SAVE audio, 🔬 ANALYZE (BER plots), 📋 LOG (table view), 📊 STATS (dashboard).

🎨 THEME (cycle presets), 🌈 EFFECTS (LED rainbow), 🎯 AUTO (tweak SNR & modulation from history).

Plots (2×2)

🌊 Waveform (TX & RX overlays)

⭐ Constellation (RX + reference points)

📊 Spectrum (PSD, normalized frequency)

👁️ Eye diagram (built from RX, sps=4)

🔧 Processing Pipeline (TX→RX)

Message → Binary (UTF-8 bytes → bits)

ECC (optional): Turbo(rep) → Hamming(parity) → CRC(checksum) → Interleave

Modulation: PSK/QAM mapping (OFDM packs QPSK onto subcarriers + CP)

Pulse shaping (optional): upsample & filter

Channel: add fading/noise (per selection)

Demod: symbol decisions → bits; De-interleave → CRC check → Hamming/Turbo decode

Metrics: BER vs original, Throughput (bits/sec), Delay (ms), SNR(est), Eb/N0, RX power, Quality

RX Text: bits → printable ASCII (sanitized)

⚠️ Note: ECC implementations are didactic placeholders (not standards-compliant). Replace with real encoders/decoders for research-grade results.

⚙️ Important Parameters (code)

currentFs (default 8000 Hz) — adjustable in ⚙️ ADV.

OFDM: nSubcarriers = 64, cpLength = 16 (in-code).

Eye diagram: sps = 4 (assumed for visualization only).

📊 Analysis Tools

🔬 BER Analysis:

BER vs SNR (semi-log)

Modulation usage pie

Channel-wise avg BER bars

Throughput vs SNR (color = BER)

📋 Log Viewer: sortable table with Time, SNR, Mod, Channel, BER, Throughput, Delay, CRC, Status + summary.

📊 Stats Dashboard: totals, average BER/SNR/throughput/delay, min/max BER, success rate.

🛠️ Troubleshooting

No decoded text / “Short data”: Low SNR, aggressive channel, or demo ECC mangling → reduce channel severity, raise SNR, disable some ECC layers.

Constellation looks smeared: Lower Pulse shaping, raise SNR, switch to AWGN for baseline.

Eye diagram messy: It’s a visual heuristic based on assumed sps; not symbol-timing synchronized. Use it comparatively across runs.

Missing de2bi/bi2de: Install Communications Toolbox or swap with custom bit-packing.

Audio errors: Check mic permissions; re-select default input device in OS.

🧩 Extending the Project

Replace demo ECC with real CRC-x, (7,4) Hamming, Convolutional/Turbo/LDPC.

Add channel estimators, equalizers, timing/frequency sync.

Implement Gray-coded QAM for all sizes + soft decisions.

True pulse shaping with matched filters & symbol-rate timing recovery.

Richer VAD/ASR for audioToText.




Start with AWGN, QPSK, SNR=20 dB, Pulse=None, no ECC → TRANSMIT.

Add Rayleigh; compare BER, constellation, and eye.

Try 16-QAM; observe required SNR jump.

Enable Interleave + CRC; note BER change and CRC status.

Run 🔬 ANALYZE to see BER vs SNR trends across runs.




(Use Apache-2.0 if you want an explicit patent grant.)

🙌 Credits

Designed for teaching, demos, and rapid experimentation in digital communications—built entirely with MATLAB UI & base graphics, with optional Comms Toolbox helpers. Enjoy exploring the signal chain!
