# 🚀 Enhanced Communication System GUI — MATLAB

<p align="center">
  <img src="https://img.shields.io/badge/MATLAB-R2018a+-orange?style=for-the-badge&logo=mathworks" />
  <img src="https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Language-MATLAB-red?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge" />
</p>

> **A vivid, experiment-ready sandbox for digital communications** — modulation, channel simulation, error control coding, live signal plots, audio I/O, session logging, and auto-optimization, all in a single MATLAB GUI.

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Features at a Glance](#-features-at-a-glance)
- [Repository Structure](#-repository-structure)
- [Requirements](#-requirements)
- [Installation & Quick Start](#-installation--quick-start)
- [GUI Walkthrough](#-gui-walkthrough)
  - [Transmission Control Panel](#transmission-control-panel)
  - [Metrics & Output Panel](#metrics--output-panel)
  - [Real-Time Signal Analysis Plots](#real-time-signal-analysis-plots)
- [Signal Processing Pipeline](#-signal-processing-pipeline)
  - [Transmitter Chain](#transmitter-chain)
  - [Channel Models](#channel-models)
  - [Receiver Chain](#receiver-chain)
- [Modulation Schemes](#-modulation-schemes)
- [Error Control Coding](#-error-control-coding)
- [Pulse Shaping Filters](#-pulse-shaping-filters)
- [Performance Metrics](#-performance-metrics)
- [Analysis & Logging Tools](#-analysis--logging-tools)
- [Audio I/O](#-audio-io)
- [Customization & Theming](#-customization--theming)
- [Suggested Experiments](#-suggested-experiments)
- [Troubleshooting](#-troubleshooting)
- [Extending the Project](#-extending-the-project)
- [Known Limitations](#-known-limitations)
- [License](#-license)
- [Acknowledgements](#-acknowledgements)

---

## 🌐 Overview

The **Enhanced Communication System GUI** is a comprehensive, interactive MATLAB application designed for learning, teaching, and rapid prototyping in **digital communications**. It implements an end-to-end communication chain — from text/audio input through modulation, channel simulation, and error correction, all the way back to a decoded output — and visualizes every step in real time.

The primary file, `enhanced_co_message_gui.m` (1,864 lines), launches a feature-rich MATLAB figure window that lets you:

- Type or **record** a message
- Select a **modulation scheme**, **channel model**, and **ECC layers**
- Simulate the full **digital communication pipeline** in one click
- Watch **waveform, constellation, spectrum, and eye diagrams** update live
- Monitor **BER, throughput, delay, SNR, Eb/N0, RX power, and quality** scores
- **Export** session logs to CSV, XLSX, or MAT

It is built entirely with base MATLAB graphics — no Simulink, no external UI frameworks.

---

## ✨ Features at a Glance

| Category | What's Included |
|---|---|
| **Modulations** | BPSK, QPSK, 8-PSK, 16-QAM, 64-QAM, 256-QAM, OFDM |
| **Channel Models** | AWGN, Rayleigh, Rician, Nakagami, Multi-path |
| **Error Coding** | CRC (checksum), Hamming (parity), Interleaver, Turbo (repetition) |
| **Pulse Shaping** | None, RRC, Gaussian, Hamming window, Blackman window |
| **Live Plots** | Waveform, Constellation, Power Spectral Density, Eye Diagram |
| **Metrics** | BER, Throughput, Delay, CRC status, Eb/N0, Est. SNR, RX Power, Quality (0–100) |
| **Audio I/O** | Mic recording (5 s), WAV/MP3 playback & save, basic VAD stub |
| **File I/O** | Load `.txt`, `.csv`, `.mat`, `.wav`, `.mp3`; export logs to CSV/XLSX/MAT |
| **UX Extras** | Status LED, animated progress bar, color themes, rainbow LED effect, auto-optimizer |
| **Analytics** | BER vs SNR curves, modulation-usage pie, per-channel BER bars, stats dashboard |

---

## 📁 Repository Structure

```
Enhanced-Communication-System-GUI-MATLAB-/
│
├── enhanced_co_message_gui.m    ← ✅ Main GUI (recommended, most feature-complete, 1864 lines)
├── enhanced_c_message_gui.m     ← Earlier iteration
├── enhanced_message_gui.m       ← Base/minimal version
│
├── README.md
└── LICENSE                      ← Apache-2.0
```

> **Start with `enhanced_co_message_gui.m`** — it contains all features described in this document.

---

## 📦 Requirements

| Requirement | Details |
|---|---|
| **MATLAB** | R2018a or newer (tested with base MATLAB) |
| **Communications Toolbox** | Required for `de2bi` / `bi2de` — or substitute with custom bit-packing functions |
| **Audio Device** | Microphone & speakers for record/playback features |
| **OS** | Windows, macOS, or Linux (any MATLAB-supported platform) |

> No Simulink license is needed. All signal processing uses base MATLAB and standard graphics.

---

## 🚀 Installation & Quick Start

**1. Clone the repository**
```bash
git clone https://github.com/n00rtahsin/Enhanced-Communication-System-GUI-MATLAB-.git
```

**2. Add to MATLAB path**
```matlab
addpath('path/to/Enhanced-Communication-System-GUI-MATLAB-')
```

**3. Launch the GUI**
```matlab
enhanced_co_message_gui
```

**4. Run your first simulation** — recommended baseline:
- Message: `Hello World`
- SNR: `20 dB`
- Modulation: `QPSK`
- Channel: `AWGN`
- Pulse: `None`
- ECC: all off
- Click **🚀 TRANSMIT**

You will immediately see the waveform, constellation, spectrum, and eye diagram plots update, and all metrics populate in the output panel.

---

## 🖥️ GUI Walkthrough

The GUI is organized into three main regions:

```
┌─────────────────────────────────────────────────────────────────┐
│  🎛️  TRANSMISSION CONTROL      │  📊  METRICS & OUTPUT           │
│  (left top panel)               │  (right top panel)              │
├─────────────────────────────────────────────────────────────────┤
│                   📈  REAL-TIME SIGNAL ANALYSIS                  │
│    🌊 Waveform      │  ⭐ Constellation                          │
│    📊 Spectrum      │  👁️  Eye Diagram                           │
└─────────────────────────────────────────────────────────────────┘
```

A **status LED** (top-right) shows: `● READY` → `🚀 Transmitting...` → `✅ Complete` / `❌ Error`.

---

### Transmission Control Panel

| Control | Description |
|---|---|
| **💬 Message** | Text field — type any string to transmit |
| **🔊 SNR (dB) slider** | Adjustable from −10 dB to +50 dB |
| **📡 Modulation** | Dropdown: BPSK / QPSK / 8-PSK / 16-QAM / 64-QAM / 256-QAM / OFDM |
| **🌊 Channel** | Dropdown: AWGN / Rayleigh / Rician / Nakagami / Multi-path |
| **🛡️ CRC** | Toggle CRC checksum encoding/verification |
| **⚡ Hamming** | Toggle Hamming parity coding |
| **🔀 Interleave** | Toggle block interleaver |
| **🚀 Turbo Code** | Toggle repetition-based Turbo coding |
| **📊 Pulse** | Dropdown: None / RRC / Gaussian / Hamming / Blackman |
| **⚡ Power slider** | Scale TX amplitude (0.1× to 2.0×) |
| **🚀 TRANSMIT** | Run the full TX → Channel → RX pipeline |
| **🎤 RECORD** | Capture 5 seconds of microphone audio → message field |
| **📁 LOAD** | Import `.txt`, `.csv`, `.mat`, `.wav`, or `.mp3` |
| **🧹 CLEAR** | Reset plots, metrics, and received text |
| **💾 EXPORT** | Save current log as CSV / XLSX / MAT |
| **⚙️ ADV** | Advanced settings dialog (e.g., change sample rate `currentFs`) |

---

### Metrics & Output Panel

| Element | Description |
|---|---|
| **📨 Received** | Decoded text output from the receiver |
| **📊 BER** | Bit Error Rate (color-coded: green < 10⁻⁴, yellow < 10⁻², red otherwise) |
| **⚡ Throughput** | Effective data rate in bits/second |
| **⏱️ Delay** | End-to-end processing delay in milliseconds |
| **🛡️ CRC Status** | Pass / Fail / N/A |
| **📡 Eb/N0** | Energy-per-bit to noise ratio (dB), computed as SNR + 10·log₂(M) |
| **📶 Est. SNR** | SNR estimated from the received signal |
| **⚡ RX Power** | Received signal power in dBW |
| **⭐ Quality** | Composite quality score 0–100 (BER score + SNR score) |
| **Progress bar** | Animated status messages for each pipeline stage |

**Secondary buttons:**

| Button | Action |
|---|---|
| **🔊 PLAY** | Playback last recorded/loaded audio |
| **💾 SAVE** | Save audio as WAV/MP3 |
| **🔬 ANALYZE** | Open multi-panel BER analysis figure |
| **📋 LOG** | Open sortable session log table |
| **📊 STATS** | Open stats dashboard (totals, averages, min/max) |
| **🎨 THEME** | Cycle through color themes |
| **🌈 EFFECTS** | Trigger rainbow LED effect on status indicators |
| **🎯 AUTO** | Auto-optimizer — adjusts SNR & modulation from session history |

---

### Real-Time Signal Analysis Plots

All four plots use a dark-themed `[0.05 0.05 0.1]` background and update every time you click TRANSMIT.

| Plot | What It Shows |
|---|---|
| **🌊 Waveform** | TX signal (blue) and RX signal (pink) overlaid in the time domain |
| **⭐ Constellation** | RX symbols (scatter) overlaid with reference constellation points |
| **📊 Spectrum** | Power Spectral Density (PSD) of the received signal, normalized frequency |
| **👁️ Eye Diagram** | Eye diagram constructed from RX signal assuming `sps = 4` (visual comparison only) |

---

## 🔧 Signal Processing Pipeline

### Transmitter Chain

```
Input Text / Audio
       │
       ▼
  messageToBinary()       — UTF-8 bytes → bit stream
       │
       ▼  (optional, in order)
  applyTurboCode()        — Repetition coding (doubles bit stream)
  applyHamming()          — Appends parity bit
  applyCRC()              — Appends 8-bit checksum
  interleave()            — Block interleaver (block size = 16)
       │
       ▼
  modulateSignal()        — Maps bits → complex symbols
       │
       ▼  (optional)
  applyPulseShaping()     — Upsampling + windowed filter
       │
       ▼
  powerLevel scaling      — Scales amplitude by √power
       │
       ▼
  simulateChannel()       — Adds fading and/or AWGN
```

### Channel Models

| Model | Implementation Detail |
|---|---|
| **AWGN** | Complex Gaussian noise added at specified SNR |
| **Rayleigh** | Sample-by-sample complex Gaussian fading + AWGN |
| **Rician** | K-factor = 3 LOS component + scattered component + AWGN |
| **Nakagami** | Shape parameter m = 1.5, scale ω = 1 (Gamma-distributed magnitude) + AWGN |
| **Multi-path** | 3 paths at delays [0, 2, 5] samples, gains [1.0, 0.5, 0.2] + AWGN |

### Receiver Chain

```
  rxSig
    │
    ▼
  demodulateSignal()      — Symbol decisions → integer indices
    │
    ▼
  convertToRxBinary()     — Indices → bit stream via de2bi
    │
    ▼  (reverse order of TX)
  deinterleave()
  checkCRC()              — Returns Pass / Fail status
  correctHamming()
  correctTurboCode()
    │
    ▼
  binaryToText()          — Bits → printable ASCII characters
    │
    ▼
  Metrics calculation
  (BER, Throughput, Delay, Eb/N0, Est. SNR, RX Power, Quality)
```

---

## 📡 Modulation Schemes

| Scheme | M | Bits/Symbol (k) | Constellation |
|---|---|---|---|
| **BPSK** | 2 | 1 | ±1 on real axis |
| **QPSK** | 4 | 2 | 4-point phase-shift, normalized to 1/√2 |
| **8-PSK** | 8 | 3 | 8 equal-phase points on unit circle |
| **16-QAM** | 16 | 4 | 4×4 rectangular grid, normalized to 1/√10 |
| **64-QAM** | 64 | 6 | 8×8 rectangular grid, normalized to 1/√42 |
| **256-QAM** | 256 | 8 | 16×16 rectangular grid, normalized to 1/√170 |
| **OFDM** | — | — | 64 subcarriers, QPSK per subcarrier, CP length = 16 |

Eb/N0 is automatically computed as `SNR_dB + 10·log₁₀(log₂(M))`.

---

## 🛡️ Error Control Coding

> ⚠️ **Important:** All ECC implementations in this project are **didactic placeholders**, not standards-compliant encoders. They are designed to illustrate the concept of layered protection and pipeline structure. Replace with real encoders for research-grade results.

| Layer | TX Function | RX Function | Method Used |
|---|---|---|---|
| **Turbo** | `applyTurboCode()` | `correctTurboCode()` | Bit repetition (doubles data) |
| **Hamming** | `applyHamming()` | `correctHamming()` | Single parity-bit append |
| **CRC** | `applyCRC()` | `checkCRC()` | 8-bit byte checksum |
| **Interleaver** | `interleave()` | `deinterleave()` | Block permutation, pattern `mod(i×7, 16)+1` |

Coding layers are applied in the order: **Turbo → Hamming → CRC → Interleave** during TX, and reversed during RX.

---

## 📊 Pulse Shaping Filters

All pulse shapes use upsampling (`sps = 4`) followed by convolution with the selected window/filter:

| Filter | Approach |
|---|---|
| **None** | No upsampling; modulated symbols passed directly |
| **RRC** | Upsample × 4, apply `ones(1,sps)/sps` moving-average (approximation) |
| **Gaussian** | Upsample × 4, convolve with `exp(-t²/0.5)` Gaussian kernel |
| **Hamming** | Upsample × 4, convolve with `hamming(4×sps)` window |
| **Blackman** | Upsample × 4, convolve with `blackman(4×sps)` window |

---

## 📈 Performance Metrics

| Metric | Formula |
|---|---|
| **BER** | `errors / total_bits` (compared to original TX bit stream) |
| **Throughput** | `total_bits / (delay_ms / 1000)` bits/second |
| **Delay** | `toc × 1000` ms (wall-clock time of pipeline) |
| **Eb/N0** | `SNR_dB + 10·log₁₀(log₂(M))` dB |
| **Est. SNR** | `10·log₁₀(signal_power / noise_power)` from differential variance |
| **RX Power** | `10·log₁₀(mean(|rxSig|²))` dBW |
| **Quality** | BER score (10–50) + SNR score (0–50), capped at 100 |

**Quality scoring:**

| BER Range | BER Score | Overall Quality |
|---|---|---|
| < 10⁻⁶ | 50 | Excellent (≥70) |
| 10⁻⁶ – 10⁻⁴ | 40 | Good (50–70) |
| 10⁻⁴ – 10⁻² | 30 | Fair (30–50) |
| 10⁻² – 10⁻¹ | 20 | Poor (10–30) |
| > 10⁻¹ | 10 | Very Poor (<30) |

---

## 📋 Analysis & Logging Tools

### 🔬 BER Analyzer
Clicking **🔬 ANALYZE** opens a 4-panel figure built from the current session log:
- **BER vs SNR** — semi-logarithmic plot per modulation
- **Modulation Usage** — pie chart of which schemes were used
- **Channel-wise Average BER** — bar chart per channel type
- **Throughput vs SNR** — scatter plot, color-coded by BER magnitude

### 📋 Session Log Viewer
The **📋 LOG** button opens a table with one row per TRANSMIT click, showing:
`Time | Message | SNR | Modulation | Channel | BER | Throughput | Delay | CRC | Status`

### 📊 Stats Dashboard
The **📊 STATS** button shows aggregate statistics:
- Total transmissions & success rate
- Average / min / max BER
- Average SNR, throughput, and delay

### 💾 Export
The **💾 EXPORT** button saves the full log in your choice of:
- `.csv` — comma-separated, importable into Excel or Python
- `.xlsx` — formatted spreadsheet
- `.mat` — MATLAB workspace variable

---

## 🎤 Audio I/O

| Feature | Details |
|---|---|
| **🎤 RECORD** | 5-second microphone capture at `currentFs` (default 8000 Hz, 16-bit mono) |
| **VAD stub** | Envelope-detection-based voice activity detection; produces a text placeholder in the message box |
| **📁 LOAD audio** | Accepts `.wav` or `.mp3`; stereo files are mixed down to mono |
| **🔊 PLAY** | Plays back `audioData` through the system's default audio output |
| **💾 SAVE audio** | Writes `audioData` to `.wav` or `.mp3` |
| **⚙️ ADV** | Change `currentFs` to any supported sample rate |

> The "speech-to-text" feature is a simple envelope-detection stub, not a real ASR system. It is intended as a placeholder for integration with MATLAB's `voiceActivityDetector` or external ASR APIs.

---

## 🎨 Customization & Theming

The GUI uses a fully programmatic color scheme defined in the `colors` struct:

```matlab
colors.primary   = [0.2 0.6 1.0]   % Electric blue
colors.secondary = [1.0 0.3 0.6]   % Hot pink
colors.success   = [0.2 0.9 0.4]   % Bright green
colors.warning   = [1.0 0.8 0.2]   % Golden yellow
colors.danger    = [1.0 0.3 0.3]   % Vibrant red
colors.purple    = [0.7 0.3 1.0]   % Electric purple
colors.cyan      = [0.2 0.9 0.9]   % Bright cyan
colors.orange    = [1.0 0.6 0.2]   % Vibrant orange
colors.panelBg   = [0.1 0.1 0.2]   % Dark blue panel
colors.textBg    = [0.15 0.15 0.25]% Input background
```

- **🎨 THEME** — cycles through preset color themes at runtime
- **🌈 EFFECTS** — triggers a rainbow animation across the status LED and metric tiles
- **🎯 AUTO** — the auto-optimizer scans session history to suggest the best SNR and modulation combination

To create a custom theme, modify the `colors` struct values at the top of the `transmitMessage` callback or externalize them into a config struct.

---

## 🧪 Suggested Experiments

Use these step-by-step experiments to explore digital communication concepts:

**Experiment 1 — Baseline**
> AWGN + QPSK + SNR 20 dB + No ECC + No pulse shaping
> → Observe near-perfect BER and clean 4-point constellation.

**Experiment 2 — SNR sweep**
> Keep all settings fixed; drag the SNR slider from 0 → 30 dB.
> → Watch BER drop and eye diagram open up.

**Experiment 3 — Fading channels**
> Switch channel from AWGN → Rayleigh → Rician → Nakagami.
> → Compare constellation scatter and BER at the same SNR.

**Experiment 4 — Modulation order**
> Step through BPSK → QPSK → 16-QAM → 64-QAM → 256-QAM.
> → Observe how required SNR increases as constellation density grows.

**Experiment 5 — ECC layers**
> Enable CRC + Interleaver; compare BER with and without.
> → Note CRC status changes; check BER improvement.

**Experiment 6 — Pulse shaping**
> Enable RRC then Gaussian at low SNR.
> → Compare spectral efficiency in the Spectrum plot.

**Experiment 7 — OFDM vs single-carrier**
> Switch from QPSK to OFDM; apply Multi-path channel.
> → Observe OFDM's robustness to multi-path in constellation and BER.

**Experiment 8 — Session analysis**
> Run 10+ transmissions with varying settings.
> → Click 🔬 ANALYZE to view BER vs SNR trends and modulation usage breakdown.

---

## 🛠️ Troubleshooting

| Symptom | Likely Cause | Fix |
|---|---|---|
| **No decoded text / "Short data"** | Very low SNR, aggressive fading, or demo ECC corrupting bits | Raise SNR to ≥ 15 dB, switch to AWGN, disable some ECC layers |
| **Constellation looks smeared** | Low SNR or aggressive channel | Raise SNR, switch to AWGN, reduce ECC layers |
| **Eye diagram always messy** | Eye diagram assumes `sps=4` with no timing recovery | Use it comparatively between runs, not as an absolute measure |
| **`de2bi` / `bi2de` not found** | Communications Toolbox not installed | Install Communications Toolbox **or** replace with: `de2bi(x,k) = dec2bin(x,k)-'0'` and `bi2de(x) = bin2dec(num2str(x))` |
| **Audio recording fails** | Mic permissions or no audio device | Check OS audio permissions; verify default input device |
| **GUI window too small** | Screen resolution | Drag to resize — the GUI uses normalized units throughout |
| **Very slow on long messages** | Per-symbol loop in demodulation | Vectorize the `demodulateSignal` inner loop or shorten the message |

---

## 🧩 Extending the Project

The codebase is structured as one large MATLAB function with nested helper functions, making it straightforward to swap components:

**Better ECC:**
- Replace `applyHamming` / `correctHamming` with a true (7,4) Hamming encoder and syndrome decoder
- Replace `applyCRC` / `checkCRC` with CRC-8, CRC-16, or CRC-32 using MATLAB's `crc.detector`
- Replace `applyTurboCode` with a real rate-1/2 convolutional + interleaved Turbo code

**Better channel estimation:**
- Add pilot-aided channel estimation and zero-forcing equalization in the OFDM receiver
- Implement minimum mean-square error (MMSE) equalizers for flat fading channels

**Better modulation:**
- Implement Gray coding for all QAM sizes
- Add soft-decision demodulation (LLRs) for use with soft-input decoders

**Better synchronization:**
- Add Gardner or Mueller-Müller timing error detector
- Implement frequency offset estimation and correction

**Better ASR:**
- Replace the VAD stub with MATLAB's `speechClient` or an HTTP call to an ASR API

**Standalone app:**
- Use MATLAB App Designer to rebuild the GUI with proper component management and figure packaging
- Compile with `mcc` to distribute without a MATLAB license

---

## ⚠️ Known Limitations

- All ECC implementations are **demo/placeholder** grade — not standards-compliant
- The `demodulateSignal` function uses a **per-sample loop** which is slow for long messages; vectorization is recommended for production use
- The eye diagram uses an **assumed `sps=4`** with no symbol-timing recovery, so it is only meaningful for relative comparison
- The "speech-to-text" feature is a **stub** — it does not perform real ASR
- OFDM uses **no channel estimation or equalization**, so performance degrades sharply under fading

---

## 📄 License

This project is released under the **Apache License 2.0**.

```
Copyright 2024 n00rtahsin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0
```

See the [LICENSE](LICENSE) file for full terms. Apache 2.0 includes an explicit patent grant, making it suitable for academic and commercial derivative work.

---

## 🙌 Acknowledgements

Designed for **teaching, demonstration, and rapid experimentation** in digital communications — built entirely with MATLAB UI & base graphics, with optional Communications Toolbox helpers.

Concepts implemented are drawn from standard digital communications theory as covered in:
- Proakis & Salehi, *Digital Communications*, 5th ed.
- Haykin, *Communication Systems*, 4th ed.
- Sklar, *Digital Communications: Fundamentals and Applications*, 2nd ed.

---

<p align="center">Made with 💙 in MATLAB — Happy experimenting! 📡</p>
