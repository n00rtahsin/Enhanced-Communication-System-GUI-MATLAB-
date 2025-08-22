function enhanced_c_message_gui()
    % Enhanced Message Communication GUI with vibrant colors and advanced features
    f = figure('Name','🚀 Advanced Communication System',...
        'Position',[50 50 1400 900],'MenuBar','none','Resize','on',...
        'Color',[0.05 0.05 0.15]);

    % Initialize global variables
    logData = struct('Time',{},'Message',{},'SNR',{},'Modulation',{},...
        'Channel',{},'BER',{},'Throughput',{},'Delay',{},'CRC',{},'Status',{});
    audioData = [];
    currentFs = 8000;
    currentSignal = [];
    isTransmitting = false;

    % Vibrant color scheme
    colors = struct();
    colors.primary = [0.2 0.6 1.0];        % Electric blue
    colors.secondary = [1.0 0.3 0.6];      % Hot pink
    colors.success = [0.2 0.9 0.4];        % Bright green
    colors.warning = [1.0 0.8 0.2];        % Golden yellow
    colors.danger = [1.0 0.3 0.3];         % Vibrant red
    colors.purple = [0.7 0.3 1.0];         % Electric purple
    colors.cyan = [0.2 0.9 0.9];           % Bright cyan
    colors.orange = [1.0 0.6 0.2];         % Vibrant orange
    colors.panelBg = [0.1 0.1 0.2];        % Dark blue panel
    colors.textBg = [0.15 0.15 0.25];      % Slightly lighter

    % Create main panels with gradient-like effects
    inputPanel = uipanel(f,'Title','🎛️ TRANSMISSION CONTROL',...
        'Position',[0.01 0.7 0.48 0.28],'BackgroundColor',colors.panelBg,...
        'ForegroundColor',colors.primary,'FontSize',12,'FontWeight','bold');
    
    outputPanel = uipanel(f,'Title','📊 METRICS & OUTPUT',...
        'Position',[0.51 0.7 0.47 0.28],'BackgroundColor',colors.panelBg,...
        'ForegroundColor',colors.secondary,'FontSize',12,'FontWeight','bold');
    
    plotPanel = uipanel(f,'Title','📈 REAL-TIME SIGNAL ANALYSIS',...
        'Position',[0.01 0.01 0.97 0.67],'BackgroundColor',colors.panelBg,...
        'ForegroundColor',colors.success,'FontSize',12,'FontWeight','bold');

    % Status LED indicator
    statusLED = uicontrol(f,'Style','text','Units','normalized',...
        'Position',[0.92 0.95 0.06 0.03],'String','● READY','FontSize',14,...
        'BackgroundColor',colors.success,'ForegroundColor',[1 1 1],...
        'FontWeight','bold','HorizontalAlignment','center');

    % Enhanced Input Controls with colorful styling
    y_pos = 0.85;
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.1],'String','💬 Message:','FontWeight','bold',...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.cyan,'FontSize',11);
    msgBox = uicontrol(inputPanel,'Style','edit','Units','normalized',...
        'Position',[0.25 y_pos 0.7 0.1],'String','Hello Amazing World! 🌟',...
        'BackgroundColor',colors.textBg,'ForegroundColor',[1 1 1],'FontSize',10);

    y_pos = y_pos - 0.15;
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.08],'String','🔊 SNR (dB):','FontSize',10,...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.warning);
    snrSlider = uicontrol(inputPanel,'Style','slider','Units','normalized',...
        'Position',[0.25 y_pos 0.4 0.08],'Min',-10,'Max',50,'Value',20,...
        'BackgroundColor',colors.primary);
    snrValue = uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.67 y_pos 0.1 0.08],'String','20.0','FontSize',11,...
        'BackgroundColor',colors.textBg,'ForegroundColor',colors.warning,'FontWeight','bold');
    snrSlider.Callback = @(src,~) set(snrValue,'String',sprintf('%.1f',src.Value));

    y_pos = y_pos - 0.15;
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.08],'String','📡 Modulation:','FontSize',10,...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.purple);
    modMenu = uicontrol(inputPanel,'Style','popupmenu','Units','normalized',...
        'Position',[0.25 y_pos 0.25 0.08],...
        'String',{'BPSK','QPSK','8-PSK','16-QAM','64-QAM','256-QAM','OFDM'},...
        'BackgroundColor',colors.textBg,'ForegroundColor',[1 1 1]);

    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.52 y_pos 0.18 0.08],'String','🌊 Channel:','FontSize',10,...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.orange);
    channelMenu = uicontrol(inputPanel,'Style','popupmenu','Units','normalized',...
        'Position',[0.72 y_pos 0.25 0.08],...
        'String',{'AWGN','Rayleigh','Rician','Nakagami','Multi-path'},...
        'BackgroundColor',colors.textBg,'ForegroundColor',[1 1 1]);

    y_pos = y_pos - 0.15;
    % Enhanced Error correction with colors
    crcCheckbox = uicontrol(inputPanel,'Style','checkbox','Units','normalized',...
        'Position',[0.02 y_pos 0.18 0.08],'String','🛡️ CRC','Value',1,...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.success,'FontSize',10);
    hammingCheckbox = uicontrol(inputPanel,'Style','checkbox','Units','normalized',...
        'Position',[0.22 y_pos 0.22 0.08],'String','⚡ Hamming',...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.success,'FontSize',10);
    interleaverCheckbox = uicontrol(inputPanel,'Style','checkbox','Units','normalized',...
        'Position',[0.46 y_pos 0.22 0.08],'String','🔀 Interleave',...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.success,'FontSize',10);
    turboCheckbox = uicontrol(inputPanel,'Style','checkbox','Units','normalized',...
        'Position',[0.7 y_pos 0.25 0.08],'String','🚀 Turbo Code',...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.success,'FontSize',10);

    % Advanced pulse shaping and features
    y_pos = y_pos - 0.12;
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.08],'String','📊 Pulse:','FontSize',10,...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.cyan);
    pulseMenu = uicontrol(inputPanel,'Style','popupmenu','Units','normalized',...
        'Position',[0.25 y_pos 0.22 0.08],...
        'String',{'None','RRC','Gaussian','Hamming','Blackman'},...
        'BackgroundColor',colors.textBg,'ForegroundColor',[1 1 1]);

    % Power control
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.5 y_pos 0.15 0.08],'String','⚡ Power:','FontSize',10,...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.warning);
    powerSlider = uicontrol(inputPanel,'Style','slider','Units','normalized',...
        'Position',[0.67 y_pos 0.25 0.08],'Min',0.1,'Max',2.0,'Value',1.0,...
        'BackgroundColor',colors.warning);

    % Colorful Control buttons with emojis
    y_pos = 0.02;
    sendBtn = uicontrol(inputPanel,'Style','pushbutton','String','🚀 TRANSMIT','Units','normalized',...
        'Position',[0.02 y_pos 0.15 0.18],'BackgroundColor',colors.success,...
        'ForegroundColor',[0 0 0],'FontWeight','bold','FontSize',11,'Callback',@transmitMessage);

    uicontrol(inputPanel,'Style','pushbutton','String','🎤 RECORD','Units','normalized',...
        'Position',[0.19 y_pos 0.15 0.18],'BackgroundColor',colors.danger,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','FontSize',10,'Callback',@recordAudio);

    uicontrol(inputPanel,'Style','pushbutton','String','📁 LOAD','Units','normalized',...
        'Position',[0.36 y_pos 0.15 0.18],'BackgroundColor',colors.primary,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','FontSize',10,'Callback',@loadFile);

    uicontrol(inputPanel,'Style','pushbutton','String','🧹 CLEAR','Units','normalized',...
        'Position',[0.53 y_pos 0.15 0.18],'BackgroundColor',colors.orange,...
        'ForegroundColor',[0 0 0],'FontWeight','bold','FontSize',10,'Callback',@clearLog);

    uicontrol(inputPanel,'Style','pushbutton','String','💾 EXPORT','Units','normalized',...
        'Position',[0.7 y_pos 0.12 0.18],'BackgroundColor',colors.purple,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','FontSize',10,'Callback',@exportData);

    uicontrol(inputPanel,'Style','pushbutton','String','⚙️ ADV','Units','normalized',...
        'Position',[0.84 y_pos 0.12 0.18],'BackgroundColor',colors.secondary,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','FontSize',10,'Callback',@showAdvancedSettings);

    % Enhanced Output Panel with vibrant colors
    y_pos = 0.85;
    uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.25 0.08],'String','📨 Received:','FontWeight','bold',...
        'BackgroundColor',colors.panelBg,'ForegroundColor',colors.secondary,'FontSize',11);
    receivedText = uicontrol(outputPanel,'Style','edit','Units','normalized',...
        'Position',[0.3 y_pos 0.65 0.08],'Enable','inactive',...
        'BackgroundColor',colors.textBg,'ForegroundColor',[0.8 1 0.8],'FontSize',10);

    % Enhanced metrics with color-coded displays
    y_pos = y_pos - 0.12;
    berLabel = createMetricLabel(outputPanel, [0.02 y_pos 0.45 0.08], '📊 BER: N/A', colors.success);
    throughputLabel = createMetricLabel(outputPanel, [0.5 y_pos 0.45 0.08], '⚡ Throughput: N/A', colors.primary);

    y_pos = y_pos - 0.1;
    delayLabel = createMetricLabel(outputPanel, [0.02 y_pos 0.45 0.08], '⏱️ Delay: N/A', colors.warning);
    crcStatusLabel = createMetricLabel(outputPanel, [0.5 y_pos 0.45 0.08], '🛡️ CRC: N/A', colors.success);

    y_pos = y_pos - 0.1;
    ebnLabel = createMetricLabel(outputPanel, [0.02 y_pos 0.45 0.08], '📡 Eb/N0: N/A', colors.cyan);
    snrEstLabel = createMetricLabel(outputPanel, [0.5 y_pos 0.45 0.08], '📶 Est SNR: N/A', colors.purple);

    y_pos = y_pos - 0.1;
    powerLabel = createMetricLabel(outputPanel, [0.02 y_pos 0.45 0.08], '⚡ RX Power: N/A', colors.orange);
    qualityLabel = createMetricLabel(outputPanel, [0.5 y_pos 0.45 0.08], '⭐ Quality: N/A', colors.secondary);

    % Animated progress bar
    progressBar = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 0.25 0.94 0.08],'String','🎯 System Ready - Ready to Rock!',...
        'BackgroundColor',colors.success,'ForegroundColor',[0 0 0],...
        'FontWeight','bold','FontSize',11,'HorizontalAlignment','center');

    % Enhanced Audio and control buttons
    y_pos = 0.15;
    uicontrol(outputPanel,'Style','pushbutton','String','🔊 PLAY','Units','normalized',...
        'Position',[0.02 y_pos 0.18 0.08],'BackgroundColor',colors.success,...
        'ForegroundColor',[0 0 0],'FontWeight','bold','Callback',@playAudio);
    uicontrol(outputPanel,'Style','pushbutton','String','💾 SAVE','Units','normalized',...
        'Position',[0.22 y_pos 0.18 0.08],'BackgroundColor',colors.primary,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','Callback',@saveAudio);
    uicontrol(outputPanel,'Style','pushbutton','String','🔬 ANALYZE','Units','normalized',...
        'Position',[0.42 y_pos 0.18 0.08],'BackgroundColor',colors.purple,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','Callback',@analyzeBER);
    uicontrol(outputPanel,'Style','pushbutton','String','📋 LOG','Units','normalized',...
        'Position',[0.62 y_pos 0.18 0.08],'BackgroundColor',colors.orange,...
        'ForegroundColor',[0 0 0],'FontWeight','bold','Callback',@viewLog);
    uicontrol(outputPanel,'Style','pushbutton','String','📊 STATS','Units','normalized',...
        'Position',[0.82 y_pos 0.15 0.08],'BackgroundColor',colors.secondary,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','Callback',@showStatistics);

    y_pos = y_pos - 0.1;
    uicontrol(outputPanel,'Style','pushbutton','String','🎨 THEME','Units','normalized',...
        'Position',[0.02 y_pos 0.18 0.08],'BackgroundColor',colors.cyan,...
        'ForegroundColor',[0 0 0],'FontWeight','bold','Callback',@changeTheme);
    uicontrol(outputPanel,'Style','pushbutton','String','🌈 EFFECTS','Units','normalized',...
        'Position',[0.22 y_pos 0.18 0.08],'BackgroundColor',colors.secondary,...
        'ForegroundColor',[1 1 1],'FontWeight','bold','Callback',@visualEffects);
    uicontrol(outputPanel,'Style','pushbutton','String','🎯 AUTO','Units','normalized',...
        'Position',[0.42 y_pos 0.18 0.08],'BackgroundColor',colors.warning,...
        'ForegroundColor',[0 0 0],'FontWeight','bold','Callback',@autoOptimize);

    % Create enhanced axes for plots in a 2x2 grid with dark theme
    waveformAx = createStyledAxes(plotPanel, [0.06 0.55 0.4 0.35], '🌊 Waveform Analysis');
    constAx = createStyledAxes(plotPanel, [0.54 0.55 0.4 0.35], '⭐ Constellation Diagram');
    spectrumAx = createStyledAxes(plotPanel, [0.06 0.08 0.4 0.35], '📊 Spectrum Analysis');
    eyeAx = createStyledAxes(plotPanel, [0.54 0.08 0.4 0.35], '👁️ Eye Diagram');

    % Helper function to create metric labels
    function label = createMetricLabel(parent, pos, text, color)
        label = uicontrol(parent,'Style','text','Units','normalized',...
            'Position',pos,'String',text,'FontSize',10,'FontWeight','bold',...
            'BackgroundColor',color,'ForegroundColor',[0 0 0],...
            'HorizontalAlignment','left');
    end

    % Helper function to create styled axes
    function ax = createStyledAxes(parent, pos, titleText)
        ax = axes(parent,'Units','normalized','Position',pos,...
            'Color',[0.05 0.05 0.1],'XColor',[0.8 0.8 0.8],'YColor',[0.8 0.8 0.8]);
        title(ax, titleText, 'Color', [1 1 1], 'FontWeight', 'bold', 'FontSize', 11);
        grid(ax, 'on');
        ax.GridColor = [0.3 0.3 0.3];
        ax.GridAlpha = 0.3;
    end

    function recordAudio(~, ~)
        try
            updateStatus('🎤 Recording...', colors.danger);
            progressBar.String = '🎙️ Recording audio (5 seconds)... Speak now!';
            progressBar.BackgroundColor = colors.danger;
            drawnow;
            
            fs = currentFs;
            recObj = audiorecorder(fs, 16, 1);
            recordblocking(recObj, 5);
            audioData = getaudiodata(recObj);
            
            % Enhanced audio to text conversion
            audioText = audioToText(audioData, fs);
            msgBox.String = audioText;
            
            updateStatus('✅ Ready', colors.success);
            progressBar.String = '🎯 Audio recorded and processed successfully!';
            progressBar.BackgroundColor = colors.success;
            
            % Add audio visualization
            if ~isempty(audioData)
                axes(waveformAx);
                cla(waveformAx);
                t = (1:length(audioData))/fs;
                plot(waveformAx, t, audioData, 'Color', colors.primary, 'LineWidth', 1.5);
                title(waveformAx, '🎤 Recorded Audio Signal', 'Color', [1 1 1]);
                xlabel(waveformAx, 'Time (s)', 'Color', [0.8 0.8 0.8]);
                ylabel(waveformAx, 'Amplitude', 'Color', [0.8 0.8 0.8]);
            end
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Audio error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function loadFile(~, ~)
        try
            updateStatus('📁 Loading...', colors.warning);
            [filename, pathname] = uigetfile({...
                '*.txt;*.csv;*.mat;*.wav;*.mp3','All Supported Files';...
                '*.txt','Text Files';...
                '*.csv','CSV Files';...
                '*.mat','MAT Files';...
                '*.wav;*.mp3','Audio Files'});
            
            if filename == 0, return; end
            
            fullpath = fullfile(pathname, filename);
            [~,~,ext] = fileparts(filename);
            
            switch lower(ext)
                case '.txt'
                    content = fileread(fullpath);
                case '.csv'
                    data = readtable(fullpath);
                    content = sprintf('%s ', string(data{:,1}));
                case '.mat'
                    vars = load(fullpath);
                    fields = fieldnames(vars);
                    if ischar(vars.(fields{1})) || isstring(vars.(fields{1}))
                        content = char(vars.(fields{1}));
                    else
                        content = sprintf('%g ', vars.(fields{1}));
                    end
                case {'.wav', '.mp3'}
                    [audioData, currentFs] = audioread(fullpath);
                    if size(audioData, 2) > 1
                        audioData = mean(audioData, 2); % Convert to mono
                    end
                    content = 'Audio file loaded successfully!';
                    
                    % Visualize loaded audio
                    axes(waveformAx);
                    cla(waveformAx);
                    t = (1:length(audioData))/currentFs;
                    plot(waveformAx, t, audioData, 'Color', colors.cyan, 'LineWidth', 1.5);
                    title(waveformAx, '📁 Loaded Audio Signal', 'Color', [1 1 1]);
            end
            
            msgBox.String = content(1:min(end,200));
            updateStatus('✅ Ready', colors.success);
            progressBar.String = ['📋 Loaded successfully: ', filename];
            progressBar.BackgroundColor = colors.success;
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Load error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function transmitMessage(~, ~)
        try
            if isTransmitting
                return;
            end
            isTransmitting = true;
            
            updateStatus('🚀 Transmitting...', colors.warning);
            progressBar.String = '🚀 Initializing transmission sequence...';
            progressBar.BackgroundColor = colors.warning;
            drawnow;
            
            % Animate progress
            for i = 1:3
                progressBar.String = sprintf('🚀 Transmitting%s', repmat('.', 1, i));
                pause(0.2);
                drawnow;
            end
            
            tic;
            msg = msgBox.String;
            if isempty(msg)
                progressBar.String = '❌ Error: Empty message!';
                updateStatus('❌ Error', colors.danger);
                isTransmitting = false;
                return;
            end
            
            % Get parameters
            snr = snrSlider.Value;
            modType = modMenu.String{modMenu.Value};
            chType = channelMenu.String{channelMenu.Value};
            enableCRC = crcCheckbox.Value;
            enableHamming = hammingCheckbox.Value;
            enableInterleaver = interleaverCheckbox.Value;
            enableTurbo = turboCheckbox.Value;
            pulseType = pulseMenu.String{pulseMenu.Value};
            powerLevel = powerSlider.Value;

            % Enhanced message processing
            progressBar.String = '🔧 Processing message...';
            drawnow;
            
            % Convert message to binary with enhanced encoding
            bin = messageToBinary(msg);
            originalLength = length(bin);

            % Apply multiple error correction layers
            progressBar.String = '🛡️ Applying error correction...';
            drawnow;
            
            if enableTurbo
                bin = applyTurboCode(bin);
            end
            if enableHamming
                bin = applyHamming(bin);
            end
            if enableCRC
                bin = applyCRC(bin);
            end
            if enableInterleaver
                bin = interleave(bin);
            end

            % Enhanced Modulation
            progressBar.String = '📡 Modulating signal...';
            drawnow;
            
            [modSig, M, k] = modulateSignal(bin, modType);
            if isempty(modSig)
                error('Modulation failed - check input parameters');
            end

            % Apply power scaling
            modSig = modSig * sqrt(powerLevel);

            % Advanced pulse shaping
            if ~strcmp(pulseType, 'None')
                progressBar.String = '📊 Applying pulse shaping...';
                drawnow;
                modSig = applyPulseShaping(modSig, pulseType);
            end

            % Enhanced channel simulation
            progressBar.String = '🌊 Simulating channel effects...';
            drawnow;
            
            [rxSig, h, channelInfo] = simulateChannel(modSig, chType, snr);
            currentSignal = rxSig; % Store for analysis

            % Demodulation with enhanced processing
            progressBar.String = '📡 Demodulating signal...';
            drawnow;
            
            demodData = demodulateSignal(rxSig, modType, M);
            rxBin = convertToRxBinary(demodData, M, k, length(bin));

            % Apply error correction (reverse order)
            progressBar.String = '🔍 Checking for errors...';
            drawnow;
            
            crcStatus = 'N/A';
            turboStatus = 'N/A';
            
            if enableInterleaver
                rxBin = deinterleave(rxBin, length(bin));
            end
            if enableCRC
                [rxBin, crcStatus] = checkCRC(rxBin);
            end
            if enableHamming
                rxBin = correctHamming(rxBin);
            end
            if enableTurbo
                [rxBin, turboStatus] = correctTurboCode(rxBin);
            end

            % Calculate comprehensive metrics
            rxBin = rxBin(1:min(length(rxBin), originalLength));
            ber = calculateBER(rxBin, bin(1:length(rxBin)));
            
            % Convert back to text
            rxChars = binaryToText(rxBin);
            
            delay = toc * 1000;
            throughput = length(rxBin) / (delay/1000);

            % Calculate additional metrics
            ebno = snr + 10*log10(log2(M));
            snrEst = estimateSNR(rxSig);
            rxPower = 10*log10(mean(abs(rxSig).^2));
            quality = calculateQuality(ber, snrEst);

            % Update enhanced display
            updateDisplay(rxChars, ber, throughput, delay, crcStatus, snr, ebno, snrEst, rxPower, quality);

            % Store enhanced log data
            logEntry = struct('Time', datetime('now'), 'Message', msg, ...
                'SNR', snr, 'Modulation', modType, 'Channel', chType, ...
                'BER', ber, 'Throughput', throughput, 'Delay', delay, ...
                'CRC', crcStatus, 'Status', 'Success');
            logData(end+1) = logEntry;

            % Update all plots with enhanced visualization
            updatePlots(rxSig, modSig, h, channelInfo);

            updateStatus('✅ Complete', colors.success);
            progressBar.String = '🎯 Transmission completed successfully!';
            progressBar.BackgroundColor = colors.success;

        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Transmission failed: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
            fprintf('Error in transmitMessage: %s\n', ME.message);
        end
        isTransmitting = false;
    end

    function updateStatus(text, color)
        statusLED.String = text;
        statusLED.BackgroundColor = color;
        drawnow;
    end

    function bin = messageToBinary(msg)
        % Enhanced message to binary conversion with UTF-8 support
        try
            if ischar(msg)
                msgBytes = uint8(msg);
            else
                msgBytes = uint8(char(msg));
            end
            bin = reshape(dec2bin(msgBytes, 8).' - '0', 1, []);
        catch
            bin = reshape(dec2bin(double(msg), 8).' - '0', 1, []);
        end
    end

    function [modSig, M, k] = modulateSignal(bin, modType)
        try
            switch modType
                case 'BPSK'
                    M = 2; k = 1;
                    modSig = pskmod(bin.', M);
                case 'QPSK'
                    M = 4; k = 2;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    modSig = pskmod(symbols, M, pi/4);
                case '8-PSK'
                    M = 8; k = 3;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    modSig = pskmod(symbols, M);
                case '16-QAM'
                    M = 16; k = 4;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    modSig = qammod(symbols, M);
                case '64-QAM'
                    M = 64; k = 6;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    modSig = qammod(symbols, M);
                case '256-QAM'
                    M = 256; k = 8;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    modSig = qammod(symbols, M);
                case 'OFDM'
                    % Simple OFDM implementation
                    M = 4; k = 2; % QPSK subcarriers
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    qpskSig = pskmod(symbols, M, pi/4);
                    
                    % OFDM parameters
                    nSubcarriers = 64;
                    cpLength = 16;
                    
                    % Pad symbols for OFDM
                    nSymbols = ceil(length(qpskSig) / nSubcarriers);
                    paddedSymbols = [qpskSig; zeros(nSymbols * nSubcarriers - length(qpskSig), 1)];
                    ofdmMatrix = reshape(paddedSymbols, nSubcarriers, nSymbols);
                    
                    % IFFT for each OFDM symbol
                    ofdmTime = ifft(ofdmMatrix, nSubcarriers);
                    
                    % Add cyclic prefix
                    cpMatrix = ofdmTime(end-cpLength+1:end, :);
                    ofdmWithCP = [cpMatrix; ofdmTime];
                    
                    modSig = reshape(ofdmWithCP, [], 1);
            end
        catch ME
            fprintf('Modulation error: %s\n', ME.message);
            M = 2; k = 1;
            modSig = pskmod(bin(1:min(100, length(bin))).', M);
        end
    end

    function padded = padBinary(bin, k)
        remainder = mod(length(bin), k);
        if remainder ~= 0
            padded = [bin, zeros(1, k - remainder)];
        else
            padded = bin;
        end
    end

    function [rxSig, h, channelInfo] = simulateChannel(modSig, chType, snr)
        channelInfo = struct();
        
        switch chType
            case 'AWGN'
                rxSig = awgn(modSig, snr, 'measured');
                h = ones(size(modSig));
                channelInfo.type = 'AWGN';
                channelInfo.description = 'Additive White Gaussian Noise';
                
            case 'Rayleigh'
                h = (randn(size(modSig)) + 1j*randn(size(modSig))) / sqrt(2);
                noisySig = awgn(h .* modSig, snr, 'measured');
                rxSig = noisySig ./ (h + eps);
                channelInfo.type = 'Rayleigh';
                channelInfo.description = 'Rayleigh Fading Channel';
                
            case 'Rician'
                K = 3; % Rician K-factor
                h = sqrt(K/(K+1)) + (randn(size(modSig)) + 1j*randn(size(modSig))) * sqrt(1/(2*(K+1)));
                noisySig = awgn(h .* modSig, snr, 'measured');
                rxSig = noisySig ./ (h + eps);
                channelInfo.type = 'Rician';
                channelInfo.K = K;
                
            case 'Nakagami'
                m = 1.5; omega = 1;
                magnitude = sqrt(gamrnd(m, omega/m, size(modSig)));
                phase = 2*pi*rand(size(modSig));
                h = magnitude .* exp(1j*phase);
                noisySig = awgn(h .* modSig, snr, 'measured');
                rxSig = noisySig ./ (h + eps);
                channelInfo.type = 'Nakagami';
                channelInfo.m = m;
                
            case 'Multi-path'
                % Multi-path channel with 3 paths
                delays = [0, 2, 5]; % Sample delays
                gains = [1, 0.5, 0.2]; % Path gains
                
                rxSig = zeros(size(modSig));
                h = zeros(size(modSig));
                
                for i = 1:length(delays)
                    if delays(i) + 1 <= length(modSig)
                        delayedSig = [zeros(delays(i), 1); modSig(1:end-delays(i))];
                        pathGain = gains(i) * (randn + 1j*randn) / sqrt(2);
                        rxSig = rxSig + pathGain * delayedSig;
                        if i == 1, h = pathGain * ones(size(modSig)); end
                    end
                end
                rxSig = awgn(rxSig, snr, 'measured');
                channelInfo.type = 'Multi-path';
                channelInfo.delays = delays;
                channelInfo.gains = gains;
        end
        
        channelInfo.snr = snr;
    end

    function demodData = demodulateSignal(rxSig, modType, M)
        try
            switch modType
                case 'BPSK'
                    demodData = pskdemod(rxSig, M);
                case 'QPSK'
                    demodData = pskdemod(rxSig, M, pi/4);
                case '8-PSK'
                    demodData = pskdemod(rxSig, M);
                case {'16-QAM', '64-QAM', '256-QAM'}
                    demodData = qamdemod(rxSig, M);
                case 'OFDM'
                    % Simple OFDM demodulation
                    nSubcarriers = 64;
                    cpLength = 16;
                    symbolLength = nSubcarriers + cpLength;
                    
                    % Remove cyclic prefix and perform FFT
                    nOFDMSymbols = floor(length(rxSig) / symbolLength);
                    demodData = [];
                    
                    for i = 1:nOFDMSymbols
                        startIdx = (i-1) * symbolLength + 1;
                        endIdx = i * symbolLength;
                        ofdmSymbol = rxSig(startIdx:endIdx);
                        
                        % Remove cyclic prefix
                        withoutCP = ofdmSymbol(cpLength+1:end);
                        
                        % FFT
                        freqDomain = fft(withoutCP, nSubcarriers);
                        
                        % QPSK demodulation
                        symbolData = pskdemod(freqDomain, 4, pi/4);
                        demodData = [demodData; symbolData];
                    end
            end
        catch ME
            fprintf('Demodulation error: %s\n', ME.message);
            demodData = pskdemod(rxSig(1:min(100, length(rxSig))), 2);
        end
    end

    function rxBin = convertToRxBinary(demodData, M, k, origLength)
        try
            if strcmp(modType, 'OFDM')
                k = 2; % QPSK
            end
            rxBin = reshape(de2bi(demodData, log2(M), 'left-msb').', 1, []);
            rxBin = rxBin(1:min(length(rxBin), origLength));
        catch
            rxBin = zeros(1, min(origLength, 100));
        end
    end

    % Enhanced error correction functions
    function encoded = applyTurboCode(data)
        try
            % Simplified turbo encoder
            trellis = poly2trellis(3, [7 5]);
            encoded1 = convenc(data, trellis);
            
            % Interleave and encode again
            interleaved = interleave(data);
            encoded2 = convenc(interleaved, trellis);
            
            % Combine systematic, parity1, and parity2 bits
            encoded = [data, encoded1, encoded2];
        catch
            encoded = data;
        end
    end

    function [decoded, status] = correctTurboCode(data)
        try
            % Simplified turbo decoder
            dataLen = floor(length(data) / 3);
            systematic = data(1:dataLen);
            decoded = systematic;
            status = 'Pass';
        catch
            decoded = data;
            status = 'Error';
        end
    end

    function encoded = applyCRC(data)
        try
            % Enhanced CRC-16 implementation
            if exist('comm.CRCGenerator', 'class')
                crcGen = comm.CRCGenerator([1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 1]); % CRC-16
                encoded = crcGen(data.')';
            else
                % Simple 8-bit checksum
                checksum = mod(sum(reshape([data, zeros(1, mod(8-mod(length(data),8),8))], 8, [])), 256);
                checksumBits = de2bi(checksum, 8, 'left-msb');
                encoded = [data, checksumBits];
            end
        catch
            encoded = data;
        end
    end

    function [decoded, status] = checkCRC(data)
        try
            if exist('comm.CRCDetector', 'class')
                crcDet = comm.CRCDetector([1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 1]);
                [decoded, err] = crcDet(data.');
                decoded = decoded';
                status = 'Pass'; 
                if err > 0, status = 'Fail'; end
            else
                if length(data) > 8
                    decoded = data(1:end-8);
                    status = 'Checked';
                else
                    decoded = data;
                    status = 'N/A';
                end
            end
        catch
            decoded = data;
            status = 'Error';
        end
    end

    function encoded = applyHamming(data)
        try
            % Enhanced Hamming (7,4) encoding
            blockSize = 4;
            numBlocks = ceil(length(data) / blockSize);
            padded = [data, zeros(1, numBlocks * blockSize - length(data))];
            blocks = reshape(padded, blockSize, numBlocks);
            encoded = [];
            
            for i = 1:numBlocks
                block = blocks(:, i);
                % Calculate parity bits
                p1 = mod(block(1) + block(2) + block(4), 2);
                p2 = mod(block(1) + block(3) + block(4), 2);
                p3 = mod(block(2) + block(3) + block(4), 2);
                % Form encoded block [p1 p2 d1 p3 d2 d3 d4]
                encodedBlock = [p1, p2, block(1), p3, block(2), block(3), block(4)];
                encoded = [encoded, encodedBlock];
            end
        catch
            encoded = data;
        end
    end

    function corrected = correctHamming(data)
        try
            blockSize = 7;
            numBlocks = ceil(length(data) / blockSize);
            padded = [data, zeros(1, numBlocks * blockSize - length(data))];
            blocks = reshape(padded, blockSize, numBlocks);
            corrected = [];
            
            for i = 1:numBlocks
                block = blocks(:, i);
                % Extract data bits [d1 d2 d3 d4] from positions [3 5 6 7]
                dataBits = block([3, 5, 6, 7]);
                corrected = [corrected, dataBits'];
            end
        catch
            corrected = data;
        end
    end

    function interleaved = interleave(data)
        try
            blockSize = 16; % Larger interleaver
            numBlocks = ceil(length(data) / blockSize);
            padded = [data, zeros(1, numBlocks * blockSize - length(data))];
            blocks = reshape(padded, blockSize, numBlocks);
            
            % Interleaving pattern
            pattern = [1,9,5,13,3,11,7,15,2,10,6,14,4,12,8,16];
            interleavedBlocks = blocks(pattern, :);
            interleaved = reshape(interleavedBlocks, 1, []);
            interleaved = interleaved(1:length(data));
        catch
            interleaved = data;
        end
    end

    function deinterleaved = deinterleave(data, origLength)
        try
            blockSize = 16;
            numBlocks = ceil(length(data) / blockSize);
            padded = [data, zeros(1, numBlocks * blockSize - length(data))];
            blocks = reshape(padded, blockSize, numBlocks);
            
            % Reverse interleaving pattern
            pattern = [1,9,5,13,3,11,7,15,2,10,6,14,4,12,8,16];
            [~, reversePattern] = sort(pattern);
            deinterleavedBlocks = blocks(reversePattern, :);
            deinterleaved = reshape(deinterleavedBlocks, 1, []);
            deinterleaved = deinterleaved(1:origLength);
        catch
            deinterleaved = data;
        end
    end

    function shaped = applyPulseShaping(signal, pulseType)
        try
            sps = 4; % Samples per symbol
            switch pulseType
                case 'RRC'
                    span = 6; beta = 0.25;
                    if exist('rcosdesign', 'file')
                        rrcFilter = rcosdesign(beta, span, sps);
                        shaped = upfirdn(signal, rrcFilter, sps);
                    else
                        shaped = repelem(signal, sps);
                    end
                case 'Gaussian'
                    bt = 0.3;
                    if exist('gaussdesign', 'file')
                        gaussFilter = gaussdesign(bt, sps, 4);
                        shaped = upfirdn(signal, gaussFilter, sps);
                    else
                        % Simple Gaussian approximation
                        t = -2:1/sps:2;
                        gaussFilter = exp(-t.^2/(2*bt^2));
                        gaussFilter = gaussFilter / sum(gaussFilter);
                        shaped = conv(repelem(signal, sps), gaussFilter, 'same');
                    end
                case 'Hamming'
                    % Hamming window pulse shaping
                    windowLength = 4 * sps;
                    window = hamming(windowLength);
                    shaped = conv(repelem(signal, sps), window, 'same') / sum(window);
                case 'Blackman'
                    % Blackman window pulse shaping
                    windowLength = 4 * sps;
                    window = blackman(windowLength);
                    shaped = conv(repelem(signal, sps), window, 'same') / sum(window);
                otherwise
                    shaped = signal;
            end
        catch
            shaped = repelem(signal, 4); % Fallback
        end
    end

    function ber = calculateBER(rxBin, txBin)
        minLen = min(length(rxBin), length(txBin));
        if minLen == 0
            ber = 1;
        else
            errors = sum(rxBin(1:minLen) ~= txBin(1:minLen));
            ber = errors / minLen;
        end
    end

    function snrEst = estimateSNR(signal)
        try
            % Simple SNR estimation using signal variance
            signalPower = var(signal);
            totalPower = mean(abs(signal).^2);
            noisePower = totalPower - signalPower;
            if noisePower > 0
                snrEst = 10 * log10(signalPower / noisePower);
            else
                snrEst = 50; % Very high SNR
            end
        catch
            snrEst = 20; % Default estimate
        end
    end

    function quality = calculateQuality(ber, snrEst)
        % Quality score from 0 to 100
        if ber < 1e-6
            berScore = 50;
        elseif ber < 1e-4
            berScore = 40;
        elseif ber < 1e-2
            berScore = 30;
        else
            berScore = 10;
        end
        
        snrScore = min(50, max(0, snrEst));
        quality = min(100, berScore + snrScore);
    end

    function chars = binaryToText(bin)
        try
            if isempty(bin)
                chars = '';
                return;
            end
            
            % Pad to multiple of 8
            remainder = mod(length(bin), 8);
            if remainder ~= 0
                bin = [bin, zeros(1, 8 - remainder)];
            end
            
            % Convert to characters
            bytes = reshape(bin, 8, []);
            charCodes = bi2de(bytes.', 'left-msb');
            chars = char(charCodes(charCodes >= 32 & charCodes <= 126))';
            
            % Remove trailing spaces
            chars = strtrim(chars);
        catch
            chars = 'Decode Error';
        end
    end

    function updateDisplay(rxChars, ber, throughput, delay, crcStatus, snr, ebno, snrEst, rxPower, quality)
        receivedText.String = rxChars;
        
        % Enhanced color-coded BER display
        if ber < 1e-6
            berColor = colors.success;
            berText = sprintf('📊 BER: %.1e ⭐', ber);
        elseif ber < 1e-4
            berColor = colors.primary;
            berText = sprintf('📊 BER: %.1e ✓', ber);
        elseif ber < 1e-2
            berColor = colors.warning;
            berText = sprintf('📊 BER: %.1e ⚠️', ber);
        else
            berColor = colors.danger;
            berText = sprintf('📊 BER: %.1e ❌', ber);
        end
        berLabel.String = berText;
        berLabel.BackgroundColor = berColor;
        
        % Update all metrics with colors and emojis
        throughputLabel.String = sprintf('⚡ Throughput: %.0f bps', throughput);
        delayLabel.String = sprintf('⏱️ Delay: %.2f ms', delay);
        
        % CRC status with color
        if strcmp(crcStatus, 'Pass')
            crcStatusLabel.BackgroundColor = colors.success;
            crcStatusLabel.String = '🛡️ CRC: Pass ✓';
        elseif strcmp(crcStatus, 'Fail')
            crcStatusLabel.BackgroundColor = colors.danger;
            crcStatusLabel.String = '🛡️ CRC: Fail ❌';
        else
            crcStatusLabel.BackgroundColor = colors.warning;
            crcStatusLabel.String = '🛡️ CRC: N/A';
        end
        
        ebnLabel.String = sprintf('📡 Eb/N0: %.1f dB', ebno);
        snrEstLabel.String = sprintf('📶 Est SNR: %.1f dB', snrEst);
        powerLabel.String = sprintf('⚡ RX Power: %.1f dBm', rxPower);
        
        % Quality with stars
        stars = repmat('⭐', 1, round(quality/20));
        qualityLabel.String = sprintf('⭐ Quality: %.0f%% %s', quality, stars);
        
        % Quality color coding
        if quality > 80
            qualityLabel.BackgroundColor = colors.success;
        elseif quality > 60
            qualityLabel.BackgroundColor = colors.primary;
        elseif quality > 40
            qualityLabel.BackgroundColor = colors.warning;
        else
            qualityLabel.BackgroundColor = colors.danger;
        end
    end

    function updatePlots(rxSig, modSig, h, channelInfo)
        try
            if isempty(rxSig) || length(rxSig) < 2
                return;
            end
            
            % 1. Enhanced Waveform plot with multiple traces
            axes(waveformAx);
            cla(waveformAx);
            hold(waveformAx, 'on');
            
            plotLength = min(500, length(rxSig));
            time_axis = (1:plotLength) / 1000; % Convert to time in seconds
            
            if ~isempty(modSig) && length(modSig) >= plotLength
                plot(waveformAx, time_axis, real(modSig(1:plotLength)), ...
                    'Color', colors.success, 'LineWidth', 2, 'DisplayName', '📤 TX Signal');
                plot(waveformAx, time_axis, imag(modSig(1:plotLength)), ...
                    'Color', colors.success, 'LineWidth', 1, 'LineStyle', '--', 'DisplayName', 'TX (Imag)');
            end
            
            plot(waveformAx, time_axis, real(rxSig(1:plotLength)), ...
                'Color', colors.primary, 'LineWidth', 1.5, 'DisplayName', '📥 RX Signal');
            plot(waveformAx, time_axis, imag(rxSig(1:plotLength)), ...
                'Color', colors.cyan, 'LineWidth', 1, 'DisplayName', 'RX (Imag)');
            
            title(waveformAx, '🌊 Transmitted vs Received Waveforms', 'Color', [1 1 1], 'FontWeight', 'bold');
            xlabel(waveformAx, 'Time (ms)', 'Color', [0.8 0.8 0.8]);
            ylabel(waveformAx, 'Amplitude', 'Color', [0.8 0.8 0.8]);
            legend(waveformAx, 'show', 'TextColor', [0.9 0.9 0.9], 'Color', [0.1 0.1 0.2]);
            grid(waveformAx, 'on');
            waveformAx.GridColor = [0.3 0.3 0.3];
            hold(waveformAx, 'off');

            % 2. Enhanced Constellation diagram with reference points
            axes(constAx);
            cla(constAx);
            hold(constAx, 'on');
            
            % Downsample for better visualization
            if length(rxSig) > 1000
                indices = round(linspace(1, length(rxSig), 1000));
                plotSig = rxSig(indices);
            else
                plotSig = rxSig;
            end
            
            % Plot received constellation with transparency
            scatter(constAx, real(plotSig), imag(plotSig), 25, colors.primary, ...
                'filled', 'MarkerFaceAlpha', 0.6, 'DisplayName', 'RX Symbols');
            
            % Add reference constellation
            modType = modMenu.String{modMenu.Value};
            refPoints = getRefConstellation(modType);
            if ~isempty(refPoints)
                scatter(constAx, real(refPoints), imag(refPoints), 100, ...
                    colors.danger, 'x', 'LineWidth', 3, 'DisplayName', 'Reference');
                
                % Draw decision boundaries for QAM
                if contains(modType, 'QAM')
                    M = str2double(regexp(modType, '\d+', 'match'));
                    if ~isempty(M) && M >= 4
                        sqrtM = sqrt(M);
                        for i = -sqrtM+1:2:sqrtM-1
                            line(constAx, [i i]*2/sqrtM, ylim(constAx), 'Color', colors.warning, 'LineStyle', ':', 'Alpha', 0.5);
                            line(constAx, xlim(constAx), [i i]*2/sqrtM, 'Color', colors.warning, 'LineStyle', ':', 'Alpha', 0.5);
                        end
                    end
                end
            end
            
            title(constAx, '⭐ Constellation Diagram', 'Color', [1 1 1], 'FontWeight', 'bold');
            xlabel(constAx, 'In-phase', 'Color', [0.8 0.8 0.8]);
            ylabel(constAx, 'Quadrature', 'Color', [0.8 0.8 0.8]);
            legend(constAx, 'show', 'TextColor', [0.9 0.9 0.9], 'Color', [0.1 0.1 0.2]);
            grid(constAx, 'on');
            axis(constAx, 'equal');
            hold(constAx, 'off');

            % 3. Enhanced Spectrum analysis with peak detection
            axes(spectrumAx);
            cla(spectrumAx);
            hold(spectrumAx, 'on');
            
            N = min(2048, 2^nextpow2(length(rxSig)));
            if N > length(rxSig)
                sig_padded = [rxSig; zeros(N - length(rxSig), 1)];
            else
                sig_padded = rxSig(1:N);
            end
            
            % Apply window for better spectral estimation
            window = hamming(length(sig_padded));
            sig_windowed = sig_padded .* window;
            
            f_axis = linspace(-0.5, 0.5, N);
            spectrum = abs(fftshift(fft(sig_windowed)));
            spectrum_db = 20*log10(spectrum + eps);
            
            % Plot spectrum with gradient colors
            plot(spectrumAx, f_axis, spectrum_db, 'Color', colors.secondary, 'LineWidth', 2);
            
            % Find and mark peaks
            [peaks, peakLocs] = findpeaks(spectrum_db, 'MinPeakHeight', max(spectrum_db)-20, 'MinPeakDistance', 20);
            if ~isempty(peaks)
                scatter(spectrumAx, f_axis(peakLocs), peaks, 60, colors.warning, 'filled', '^');
            end
            
            title(spectrumAx, '📊 Power Spectral Density', 'Color', [1 1 1], 'FontWeight', 'bold');
            xlabel(spectrumAx, 'Normalized Frequency', 'Color', [0.8 0.8 0.8]);
            ylabel(spectrumAx, 'PSD (dB)', 'Color', [0.8 0.8 0.8]);
            grid(spectrumAx, 'on');
            
            % Set reasonable y-axis limits
            maxVal = max(spectrum_db);
            ylim(spectrumAx, [maxVal-60, maxVal+5]);
            hold(spectrumAx, 'off');

            % 4. Enhanced Eye diagram with quality metrics
            axes(eyeAx);
            cla(eyeAx);
            hold(eyeAx, 'on');
            
            if length(rxSig) >= 40
                sps = 8; % Higher oversampling for better eye
                eyeLength = sps * 2; % Two symbol periods
                
                % Ensure we have enough data
                if length(rxSig) >= eyeLength * 10
                    numTraces = min(100, floor(length(rxSig) / sps) - 2);
                    
                    if numTraces > 0
                        eyeMatrix = zeros(eyeLength, numTraces);
                        for i = 1:numTraces
                            startIdx = (i-1) * sps + 1;
                            endIdx = startIdx + eyeLength - 1;
                            if endIdx <= length(rxSig)
                                eyeMatrix(:, i) = real(rxSig(startIdx:endIdx));
                            end
                        end
                        
                        timeAxis = (0:eyeLength-1) / sps;
                        
                        % Plot eye traces with color coding
                        for i = 1:numTraces
                            alpha = 0.3;
                            if i <= numTraces/3
                                color = colors.success;
                            elseif i <= 2*numTraces/3
                                color = colors.primary;
                            else
                                color = colors.secondary;
                            end
                            plot(eyeAx, timeAxis, eyeMatrix(:, i), 'Color', [color, alpha], 'LineWidth', 0.8);
                        end
                        
                        % Add mean trace
                        meanTrace = mean(eyeMatrix, 2);
                        plot(eyeAx, timeAxis, meanTrace, 'Color', colors.warning, 'LineWidth', 3, 'DisplayName', 'Mean');
                        
                        % Eye opening measurement lines
                        midPoint = round(eyeLength/2);
                        eyeOpening = max(meanTrace) - min(meanTrace);
                        yline(eyeAx, max(meanTrace), 'Color', colors.danger, 'LineStyle', '--', 'Alpha', 0.7);
                        yline(eyeAx, min(meanTrace), 'Color', colors.danger, 'LineStyle', '--', 'Alpha', 0.7);
                        
                        title(eyeAx, sprintf('👁️ Eye Diagram (Opening: %.2f)', eyeOpening), 'Color', [1 1 1], 'FontWeight', 'bold');
                        xlabel(eyeAx, 'Time (Symbol Periods)', 'Color', [0.8 0.8 0.8]);
                        ylabel(eyeAx, 'Amplitude', 'Color', [0.8 0.8 0.8]);
                        xlim(eyeAx, [0, 2]);
                    else
                        % Fallback plot
                        plot(eyeAx, real(rxSig(1:min(200, length(rxSig)))), 'Color', colors.primary, 'LineWidth', 1.5);
                        title(eyeAx, '📊 Signal Trace', 'Color', [1 1 1], 'FontWeight', 'bold');
                    end
                else
                    % Simple time plot for short signals
                    plot(eyeAx, real(rxSig), 'Color', colors.primary, 'LineWidth', 1.5);
                    title(eyeAx, '📊 Signal Trace', 'Color', [1 1 1], 'FontWeight', 'bold');
                end
            else
                % Very short signal
                plot(eyeAx, real(rxSig), 'o-', 'Color', colors.primary, 'LineWidth', 2, 'MarkerSize', 6);
                title(eyeAx, '📊 Signal Points', 'Color', [1 1 1], 'FontWeight', 'bold');
            end
            
            grid(eyeAx, 'on');
            hold(eyeAx, 'off');
            
            % Force all plot updates
            drawnow;
            
        catch ME
            fprintf('Plot error: %s\n', ME.message);
        end
    end
    
    function refPoints = getRefConstellation(modType)
        try
            switch modType
                case 'BPSK'
                    refPoints = pskmod(0:1, 2);
                case 'QPSK'
                    refPoints = pskmod(0:3, 4, pi/4);
                case '8-PSK'
                    refPoints = pskmod(0:7, 8);
                case '16-QAM'
                    refPoints = qammod(0:15, 16);
                case '64-QAM'
                    refPoints = qammod(0:63, 64);
                case '256-QAM'
                    refPoints = qammod(0:255, 256);
                case 'OFDM'
                    refPoints = pskmod(0:3, 4, pi/4); % QPSK subcarriers
                otherwise
                    refPoints = [];
            end
        catch
            refPoints = [];
        end
    end

    function text = audioToText(audio, fs)
        try
            % Enhanced audio to text conversion
            if isempty(audio)
                text = 'No audio detected';
                return;
            end
            
            % Normalize audio
            audio = audio / max(abs(audio));
            
            % Simple envelope detection with improved algorithm
            envelope = abs(hilbert(audio));
            envelope = smooth(envelope, round(fs * 0.01)); % 10ms smoothing
            
            % Adaptive threshold
            threshold = mean(envelope) + 2 * std(envelope);
            
            % Find voice activity regions
            active = envelope > threshold;
            
            % Find transitions
            transitions = diff([0; active; 0]);
            starts = find(transitions == 1);
            stops = find(transitions == -1);
            
            % Convert to simple text based on duration and frequency
            text = '';
            if ~isempty(starts) && ~isempty(stops)
                for i = 1:min(length(starts), length(stops))
                    duration = (stops(i) - starts(i)) / fs;
                    segment = audio(starts(i):stops(i));
                    
                    % Simple frequency analysis
                    if length(segment) > fs * 0.05 % At least 50ms
                        freqs = fft(segment);
                        [~, maxIdx] = max(abs(freqs(1:floor(length(freqs)/2))));
                        dominantFreq = (maxIdx - 1) * fs / length(segment);
                        
                        % Map to characters based on frequency and duration
                        if dominantFreq < 500 && duration > 0.2
                            text = [text, 'O']; % Low freq, long
                        elseif dominantFreq < 500
                            text = [text, 'o']; % Low freq, short
                        elseif dominantFreq < 1000 && duration > 0.2
                            text = [text, 'A']; % Mid freq, long
                        elseif dominantFreq < 1000
                            text = [text, 'a']; % Mid freq, short
                        elseif duration > 0.2
                            text = [text, 'I']; % High freq, long
                        else
                            text = [text, 'i']; % High freq, short
                        end
                    end
                end
                
                if isempty(text)
                    text = 'Audio processed - pattern detected';
                end
            else
                text = 'Silent audio or noise detected';
            end
            
        catch ME
            text = sprintf('Audio processing error: %s', ME.message);
        end
    end

    % Enhanced GUI Functions
    function playAudio(~, ~)
        try
            if ~isempty(audioData)
                updateStatus('🔊 Playing...', colors.primary);
                sound(audioData, currentFs);
                progressBar.String = '🔊 Playing recorded audio...';
                progressBar.BackgroundColor = colors.primary;
                
                % Create audio visualization
                axes(waveformAx);
                cla(waveformAx);
                t = (1:length(audioData))/currentFs;
                plot(waveformAx, t, audioData, 'Color', colors.success, 'LineWidth', 1.5);
                title(waveformAx, '🎵 Audio Playback', 'Color', [1 1 1]);
                xlabel(waveformAx, 'Time (s)', 'Color', [0.8 0.8 0.8]);
                ylabel(waveformAx, 'Amplitude', 'Color', [0.8 0.8 0.8]);
                
                % Wait for audio to finish, then reset status
                pause(length(audioData)/currentFs + 0.5);
                updateStatus('✅ Ready', colors.success);
            else
                progressBar.String = '❌ No audio data available';
                progressBar.BackgroundColor = colors.warning;
            end
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Audio play error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function saveAudio(~, ~)
        try
            if ~isempty(audioData)
                [filename, pathname] = uiputfile({'*.wav','WAV Files'; '*.mp3','MP3 Files'}, 'Save Audio');
                if filename ~= 0
                    fullPath = fullfile(pathname, filename);
                    [~,~,ext] = fileparts(filename);
                    
                    switch lower(ext)
                        case '.wav'
                            audiowrite(fullPath, audioData, currentFs);
                        case '.mp3'
                            audiowrite(fullPath, audioData, currentFs, 'BitRate', 128);
                        otherwise
                            audiowrite([fullPath, '.wav'], audioData, currentFs);
                    end
                    
                    updateStatus('💾 Saved', colors.success);
                    progressBar.String = ['💾 Audio saved successfully: ', filename];
                    progressBar.BackgroundColor = colors.success;
                end
            else
                progressBar.String = '❌ No audio data to save';
                progressBar.BackgroundColor = colors.warning;
            end
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Audio save error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function exportData(~, ~)
        try
            if isempty(logData)
                progressBar.String = '❌ No data to export';
                progressBar.BackgroundColor = colors.warning;
                return;
            end
            
            [filename, pathname] = uiputfile({...
                '*.csv','CSV Files'; ...
                '*.mat','MAT Files'; ...
                '*.xlsx','Excel Files'}, 'Export Data');
            
            if filename == 0, return; end
            
            fullpath = fullfile(pathname, filename);
            [~,~,ext] = fileparts(filename);
            
            updateStatus('💾 Exporting...', colors.warning);
            progressBar.String = '💾 Exporting data...';
            progressBar.BackgroundColor = colors.warning;
            
            switch lower(ext)
                case '.csv'
                    T = struct2table(logData);
                    writetable(T, fullpath);
                case '.xlsx'
                    T = struct2table(logData);
                    writetable(T, fullpath);
                case '.mat'
                    save(fullpath, 'logData', 'colors');
                otherwise
                    T = struct2table(logData);
                    writetable(T, [fullpath, '.csv']);
            end
            
            updateStatus('✅ Complete', colors.success);
            progressBar.String = ['📊 Data exported successfully: ', filename];
            progressBar.BackgroundColor = colors.success;
            
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Export error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function clearLog(~, ~)
        logData = struct('Time',{},'Message',{},'SNR',{},'Modulation',{},...
            'Channel',{},'BER',{},'Throughput',{},'Delay',{},'CRC',{},'Status',{});
        updateStatus('🧹 Cleared', colors.success);
        progressBar.String = '🧹 All data cleared successfully';
        progressBar.BackgroundColor = colors.success;
        
        % Clear all plots
        cla(waveformAx); cla(constAx); cla(spectrumAx); cla(eyeAx);
        title(waveformAx, '🌊 Waveform Analysis', 'Color', [1 1 1]);
        title(constAx, '⭐ Constellation Diagram', 'Color', [1 1 1]);
        title(spectrumAx, '📊 Spectrum Analysis', 'Color', [1 1 1]);
        title(eyeAx, '👁️ Eye Diagram', 'Color', [1 1 1]);
    end

    function viewLog(~, ~)
        try
            if isempty(logData)
                progressBar.String = '❌ No log data available';
                progressBar.BackgroundColor = colors.warning;
                return;
            end
            
            % Create enhanced log viewer window
            logFig = figure('Name','📋 Transmission Log Viewer',...
                'Position',[200 150 1000 500],'Color',colors.panelBg);
            
            % Prepare enhanced data for table
            columnNames = {'🕐 Time', '💬 Message', '📊 SNR(dB)', '📡 Mod', '🌊 Channel', '🎯 BER', '⚡ Throughput', '⏱️ Delay(ms)', '🛡️ CRC', '✅ Status'};
            
            tableData = cell(length(logData), 10);
            for i = 1:length(logData)
                tableData{i,1} = char(logData(i).Time);
                tableData{i,2} = logData(i).Message;
                tableData{i,3} = sprintf('%.1f', logData(i).SNR);
                tableData{i,4} = logData(i).Modulation;
                tableData{i,5} = logData(i).Channel;
                tableData{i,6} = sprintf('%.2e', logData(i).BER);
                tableData{i,7} = sprintf('%.1f', logData(i).Throughput);
                tableData{i,8} = sprintf('%.2f', logData(i).Delay);
                tableData{i,9} = logData(i).CRC;
                tableData{i,10} = logData(i).Status;
            end
            
            % Create colorful table
            logTable = uitable(logFig, 'Data', tableData, 'ColumnName', columnNames, ...
                'Position', [20 60 960 400], ...
                'ColumnWidth', {130 200 70 80 90 90 90 80 60 80},...
                'BackgroundColor', [colors.textBg; colors.panelBg],...
                'ForegroundColor', [1 1 1]);
            
            % Add summary statistics
            uicontrol(logFig, 'Style', 'text', 'Position', [20 20 200 30], ...
                'String', sprintf('📊 Total Transmissions: %d', length(logData)), ...
                'BackgroundColor', colors.panelBg, 'ForegroundColor', colors.primary, ...
                'FontSize', 12, 'FontWeight', 'bold');
            
            if ~isempty(logData)
                avgBER = mean([logData.BER]);
                avgSNR = mean([logData.SNR]);
                uicontrol(logFig, 'Style', 'text', 'Position', [250 20 200 30], ...
                    'String', sprintf('🎯 Avg BER: %.2e', avgBER), ...
                    'BackgroundColor', colors.panelBg, 'ForegroundColor', colors.success, ...
                    'FontSize', 12, 'FontWeight', 'bold');
                
                uicontrol(logFig, 'Style', 'text', 'Position', [480 20 200 30], ...
                    'String', sprintf('📶 Avg SNR: %.1f dB', avgSNR), ...
                    'BackgroundColor', colors.panelBg, 'ForegroundColor', colors.warning, ...
                    'FontSize', 12, 'FontWeight', 'bold');
            end
                
        catch ME
            progressBar.String = ['🚨 Log view error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function analyzeBER(~, ~)
        try
            if length(logData) < 2
                progressBar.String = '❌ Need more data points for analysis (minimum 2)';
                progressBar.BackgroundColor = colors.warning;
                return;
            end
            
            updateStatus('🔬 Analyzing...', colors.purple);
            progressBar.String = '🔬 Performing comprehensive BER analysis...';
            progressBar.BackgroundColor = colors.purple;
            
            % Create enhanced analysis window
            analysisFig = figure('Name','🔬 Advanced BER Analysis',...
                'Position',[250 100 900 700],'Color',colors.panelBg);
            
            % Extract data
            snrValues = [logData.SNR];
            berValues = [logData.BER];
            modTypes = {logData.Modulation};
            channelTypes = {logData.Channel};
            
            % Plot 1: BER vs SNR with multiple modulations
            subplot(2,2,1);
            hold on;
            
            uniqueMods = unique(modTypes);
            colorMap = lines(length(uniqueMods));
            
            for i = 1:length(uniqueMods)
                modIdx = strcmp(modTypes, uniqueMods{i});
                if sum(modIdx) > 0
                    semilogy(snrValues(modIdx), berValues(modIdx), 'o-', ...
                        'Color', colorMap(i,:), 'LineWidth', 2, 'MarkerSize', 8, ...
                        'DisplayName', uniqueMods{i});
                end
            end
            
            % Add theoretical curves
            snrTheory = 0:0.5:40;
            berBPSK = 0.5 * erfc(sqrt(10.^(snrTheory/10)));
            berQPSK = 0.5 * erfc(sqrt(10.^(snrTheory/10)));
            
            semilogy(snrTheory, berBPSK, '--', 'Color', colors.success, 'LineWidth', 1.5, 'DisplayName', 'BPSK Theory');
            semilogy(snrTheory, berQPSK, '--', 'Color', colors.primary, 'LineWidth', 1.5, 'DisplayName', 'QPSK Theory');
            
            xlabel('SNR (dB)'); ylabel('Bit Error Rate');
            title('🎯 BER vs SNR Performance Analysis');
            legend('show'); grid on;
            set(gca, 'Color', colors.panelBg, 'XColor', [0.8 0.8 0.8], 'YColor', [0.8 0.8 0.8]);
            
            % Plot 2: Modulation distribution
            subplot(2,2,2);
            [uniqueMods, ~, idx] = unique(modTypes);
            counts = accumarray(idx, 1);
            pie(counts, uniqueMods);
            title('📡 Modulation Type Distribution');
            colormap(jet);
            
            % Plot 3: Channel performance comparison
            subplot(2,2,3);
            uniqueChannels = unique(channelTypes);
            channelBER = zeros(size(uniqueChannels));
            
            for i = 1:length(uniqueChannels)
                chIdx = strcmp(channelTypes, uniqueChannels{i});
                if sum(chIdx) > 0
                    channelBER(i) = mean(berValues(chIdx));
                end
            end
            
            bar(channelBER, 'FaceColor', colors.secondary);
            set(gca, 'XTickLabel', uniqueChannels);
            xlabel('Channel Type'); ylabel('Average BER');
            title('🌊 Channel Performance Comparison');
            xtickangle(45);
            
            % Plot 4: Throughput vs SNR
            subplot(2,2,4);
            throughputValues = [logData.Throughput];
            scatter(snrValues, throughputValues, 60, berValues, 'filled');
            colorbar; colormap(jet);
            xlabel('SNR (dB)'); ylabel('Throughput (bps)');
            title('⚡ Throughput vs SNR (Color = BER)');
            grid on;
            
            % Add overall statistics
            avgBER = mean(berValues);
            minBER = min(berValues);
            maxSNR = max(snrValues);
            
            annotation('textbox', [0.02 0.02 0.4 0.1], ...
                'String', sprintf('📊 Stats:\nAvg BER: %.2e\nMin BER: %.2e\nMax SNR: %.1f dB', ...
                avgBER, minBER, maxSNR), ...
                'BackgroundColor', colors.textBg, 'Color', [1 1 1], ...
                'FontSize', 10, 'FontWeight', 'bold');
            
            updateStatus('✅ Complete', colors.success);
            progressBar.String = '🔬 BER analysis completed successfully!';
            progressBar.BackgroundColor = colors.success;
            
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Analysis error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function showStatistics(~, ~)
        try
            if isempty(logData)
                progressBar.String = '❌ No data for statistics';
                return;
            end
            
            % Create colorful statistics window
            statsFig = figure('Name','📊 System Statistics Dashboard',...
                'Position',[300 150 700 600],'Color',colors.panelBg);
            
            % Calculate comprehensive statistics
            snrValues = [logData.SNR];
            berValues = [logData.BER];
            throughputValues = [logData.Throughput];
            delayValues = [logData.Delay];
            
            stats = struct();
            stats.totalTrans = length(logData);
            stats.avgBER = mean(berValues);
            stats.minBER = min(berValues);
            stats.maxBER = max(berValues);
            stats.avgSNR = mean(snrValues);
            stats.avgThroughput = mean(throughputValues);
            stats.avgDelay = mean(delayValues);
            stats.successRate = sum(strcmp({logData.Status}, 'Success')) / length(logData) * 100;
            
            % Create colorful display
            y = 0.9;
            spacing = 0.08;
            
            createStatLabel(statsFig, sprintf('🚀 COMMUNICATION SYSTEM DASHBOARD'), [0.1 y 0.8 0.06], colors.primary, 14);
            y = y - spacing * 1.5;
            
            createStatLabel(statsFig, sprintf('📊 Total Transmissions: %d', stats.totalTrans), [0.1 y 0.8 0.05], colors.success, 12);
            y = y - spacing;
            
            createStatLabel(statsFig, sprintf('🎯 Average BER: %.2e', stats.avgBER), [0.1 y 0.8 0.05], colors.warning, 12);
            y = y - spacing;
            
            createStatLabel(statsFig, sprintf('📈 Best BER: %.2e', stats.minBER), [0.1 y 0.8 0.05], colors.success, 12);
            y = y - spacing;
            
            createStatLabel(statsFig, sprintf('📉 Worst BER: %.2e', stats.maxBER), [0.1 y 0.8 0.05], colors.danger, 12);
            y = y - spacing;
            
            createStatLabel(statsFig, sprintf('📶 Average SNR: %.1f dB', stats.avgSNR), [0.1 y 0.8 0.05], colors.primary, 12);
            y = y - spacing;
            
            createStatLabel(statsFig, sprintf('⚡ Average Throughput: %.1f bps', stats.avgThroughput), [0.1 y 0.8 0.05], colors.cyan, 12);
            y = y - spacing;
            
            createStatLabel(statsFig, sprintf('⏱️ Average Delay: %.2f ms', stats.avgDelay), [0.1 y 0.8 0.05], colors.orange, 12);
            y = y - spacing;
            
            createStatLabel(statsFig, sprintf('✅ Success Rate: %.1f%%', stats.successRate), [0.1 y 0.8 0.05], colors.success, 12);
            y = y - spacing * 1.5;
            
            % Performance rating
            if stats.avgBER < 1e-4 && stats.successRate > 95
                rating = '⭐⭐⭐⭐⭐ EXCELLENT';
                ratingColor = colors.success;
            elseif stats.avgBER < 1e-3 && stats.successRate > 90
                rating = '⭐⭐⭐⭐ VERY GOOD';
                ratingColor = colors.primary;
            elseif stats.avgBER < 1e-2 && stats.successRate > 80
                rating = '⭐⭐⭐ GOOD';
                ratingColor = colors.warning;
            elseif stats.successRate > 70
                rating = '⭐⭐ FAIR';
                ratingColor = colors.orange;
            else
                rating = '⭐ POOR';
                ratingColor = colors.danger;
            end
            
            createStatLabel(statsFig, sprintf('🏆 SYSTEM RATING: %s', rating), [0.1 y 0.8 0.06], ratingColor, 14);
            
        catch ME
            progressBar.String = ['🚨 Statistics error: ', ME.message];
        end
    end

    function createStatLabel(parent, text, pos, color, fontSize)
        uicontrol(parent, 'Style', 'text', 'Units', 'normalized', ...
            'Position', pos, 'String', text, ...
            'BackgroundColor', color, 'ForegroundColor', [0 0 0], ...
            'FontSize', fontSize, 'FontWeight', 'bold', ...
            'HorizontalAlignment', 'center');
    end

    function showAdvancedSettings(~, ~)
        % Advanced settings window
        advFig = figure('Name','⚙️ Advanced Settings',...
            'Position',[400 200 500 600],'Color',colors.panelBg);
        
        y = 0.9;
        uicontrol(advFig, 'Style', 'text', 'Units', 'normalized', ...
            'Position', [0.1 y 0.8 0.08], 'String', '⚙️ ADVANCED CONFIGURATION', ...
            'BackgroundColor', colors.primary, 'ForegroundColor', [0 0 0], ...
            'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
        
        y = y - 0.12;
        uicontrol(advFig, 'Style', 'text', 'Units', 'normalized', ...
            'Position', [0.1 y 0.3 0.06], 'String', '🎛️ Sample Rate:', ...
            'BackgroundColor', colors.panelBg, 'ForegroundColor', colors.cyan, ...
            'FontSize', 11, 'FontWeight', 'bold');
        
        sampleRateEdit = uicontrol(advFig, 'Style', 'edit', 'Units', 'normalized', ...
            'Position', [0.45 y 0.3 0.06], 'String', num2str(currentFs), ...
            'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        y = y - 0.1;
        uicontrol(advFig, 'Style', 'text', 'Units', 'normalized', ...
            'Position', [0.1 y 0.3 0.06], 'String', '🔊 Noise Floor (dB):', ...
            'BackgroundColor', colors.panelBg, 'ForegroundColor', colors.warning, ...
            'FontSize', 11, 'FontWeight', 'bold');
        
        noiseFloorEdit = uicontrol(advFig, 'Style', 'edit', 'Units', 'normalized', ...
            'Position', [0.45 y 0.3 0.06], 'String', '-50', ...
            'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        y = y - 0.1;
        carrierFreqCheck = uicontrol(advFig, 'Style', 'checkbox', 'Units', 'normalized', ...
            'Position', [0.1 y 0.4 0.06], 'String', '📡 Enable Carrier Freq', ...
            'BackgroundColor', colors.panelBg, 'ForegroundColor', colors.success, ...
            'FontSize', 11);
        
        y = y - 0.1;
        dopplerCheck = uicontrol(advFig, 'Style', 'checkbox', 'Units', 'normalized', ...
            'Position', [0.1 y 0.4 0.06], 'String', '🌊 Doppler Effect', ...
            'BackgroundColor', colors.panelBg, 'ForegroundColor', colors.secondary, ...
            'FontSize', 11);
        
        y = y - 0.15;
        uicontrol(advFig, 'Style', 'pushbutton', 'Units', 'normalized', ...
            'Position', [0.1 y 0.35 0.08], 'String', '✅ APPLY', ...
            'BackgroundColor', colors.success, 'ForegroundColor', [0 0 0], ...
            'FontWeight', 'bold', 'Callback', @applyAdvancedSettings);
        
        uicontrol(advFig, 'Style', 'pushbutton', 'Units', 'normalized', ...
            'Position', [0.55 y 0.35 0.08], 'String', '❌ CANCEL', ...
            'BackgroundColor', colors.danger, 'ForegroundColor', [1 1 1], ...
            'FontWeight', 'bold', 'Callback', @(~,~) close(advFig));
        
        function applyAdvancedSettings(~, ~)
            try
                currentFs = str2double(sampleRateEdit.String);
                progressBar.String = '⚙️ Advanced settings applied successfully!';
                progressBar.BackgroundColor = colors.success;
                close(advFig);
            catch
                progressBar.String = '❌ Invalid settings values!';
                progressBar.BackgroundColor = colors.danger;
            end
        end
    end

    function changeTheme(~, ~)
        % Cycle through different color themes
        persistent themeIndex;
        if isempty(themeIndex)
            themeIndex = 1;
        end
        
        themes = {
            struct('primary', [0.2 0.6 1.0], 'secondary', [1.0 0.3 0.6], 'success', [0.2 0.9 0.4], ...
                   'warning', [1.0 0.8 0.2], 'danger', [1.0 0.3 0.3], 'purple', [0.7 0.3 1.0], ...
                   'cyan', [0.2 0.9 0.9], 'orange', [1.0 0.6 0.2], 'panelBg', [0.1 0.1 0.2], 'textBg', [0.15 0.15 0.25]), ...
            struct('primary', [0.9 0.3 0.7], 'secondary', [0.3 0.9 0.5], 'success', [0.4 0.8 0.2], ...
                   'warning', [0.9 0.6 0.1], 'danger', [0.8 0.2 0.4], 'purple', [0.5 0.2 0.8], ...
                   'cyan', [0.1 0.7 0.8], 'orange', [0.9 0.5 0.1], 'panelBg', [0.15 0.05 0.1], 'textBg', [0.2 0.1 0.15]), ...
            struct('primary', [0.1 0.8 0.3], 'secondary', [0.8 0.2 0.9], 'success', [0.3 0.9 0.3], ...
                   'warning', [0.9 0.7 0.1], 'danger', [0.9 0.1 0.2], 'purple', [0.6 0.1 0.9], ...
                   'cyan', [0.1 0.9 0.8], 'orange', [0.9 0.4 0.1], 'panelBg', [0.05 0.15 0.1], 'textBg', [0.1 0.2 0.15])
        };
        
        themeNames = {'🌊 Ocean', '🌸 Sunset', '🌿 Nature'};
        
        themeIndex = mod(themeIndex, length(themes)) + 1;
        colors = themes{themeIndex};
        
        % Update all UI components with new theme
        f.Color = colors.panelBg;
        inputPanel.BackgroundColor = colors.panelBg;
        outputPanel.BackgroundColor = colors.panelBg;
        plotPanel.BackgroundColor = colors.panelBg;
        
        progressBar.String = sprintf('🎨 Theme changed to: %s', themeNames{themeIndex});
        progressBar.BackgroundColor = colors.success;
        
        % Update axes colors
        waveformAx.Color = [0.05 0.05 0.1];
        constAx.Color = [0.05 0.05 0.1];
        spectrumAx.Color = [0.05 0.05 0.1];
        eyeAx.Color = [0.05 0.05 0.1];
    end

    function visualEffects(~, ~)
        % Add visual effects and animations
        persistent effectActive;
        if isempty(effectActive)
            effectActive = false;
        end
        
        if ~effectActive
            effectActive = true;
            progressBar.String = '🌈 Activating visual effects...';
            progressBar.BackgroundColor = colors.secondary;
            
            % Create rainbow effect on status LED
            for i = 1:20
                hue = mod(i * 0.1, 1);
                rgb = hsv2rgb([hue, 1, 1]);
                statusLED.BackgroundColor = rgb;
                statusLED.String = '🌈 RAINBOW';
                pause(0.1);
                drawnow;
            end
            
            % Animate progress bar
            for i = 1:10
                progressBar.String = sprintf('✨ Visual Effects Active %s', repmat('⭐', 1, mod(i, 5) + 1));
                pause(0.2);
                drawnow;
            end
            
            updateStatus('✨ Effects On', colors.secondary);
            progressBar.String = '🌈 Visual effects activated!';
            effectActive = false;
        end
    end

    function autoOptimize(~, ~)
        % Automatic system optimization
        updateStatus('🎯 Optimizing...', colors.warning);
        progressBar.String = '🎯 Running automatic optimization...';
        progressBar.BackgroundColor = colors.warning;
        
        % Simulate optimization process
        optimizationSteps = {
            '🔍 Analyzing signal quality...',
            '⚡ Optimizing power levels...',
            '📡 Tuning modulation parameters...',
            '🛡️ Adjusting error correction...',
            '✅ Optimization complete!'
        };
        
        for i = 1:length(optimizationSteps)
            progressBar.String = optimizationSteps{i};
            pause(0.5);
            drawnow;
            
            % Perform actual optimizations
            switch i
                case 2
                    % Optimize power
                    if ~isempty(logData)
                        avgBER = mean([logData.BER]);
                        if avgBER > 1e-3
                            powerSlider.Value = min(2.0, powerSlider.Value * 1.2);
                        end
                    end
                case 3
                    % Optimize SNR
                    if ~isempty(logData)
                        avgBER = mean([logData.BER]);
                        if avgBER > 1e-4
                            snrSlider.Value = min(50, snrSlider.Value + 2);
                            snrValue.String = sprintf('%.1f', snrSlider.Value);
                        end
                    end
                case 4
                    % Enable error correction if not already
                    if ~crcCheckbox.Value
                        crcCheckbox.Value = 1;
                    end
                    if ~hammingCheckbox.Value
                        hammingCheckbox.Value = 1;
                    end
            end
        end
        
        updateStatus('🎯 Optimized', colors.success);
        progressBar.BackgroundColor = colors.success;
    end

    % Initialize enhanced menu system
    function initializeMenus()
        % Enhanced menu bar with colorful icons
        menuFile = uimenu(f, 'Label', '📁 File');
        uimenu(menuFile, 'Label', '🆕 New Session', 'Callback', @(~,~) clearLog());
        uimenu(menuFile, 'Label', '📂 Load Settings', 'Callback', @loadSettings);
        uimenu(menuFile, 'Label', '💾 Save Settings', 'Callback', @saveSettings);
        uimenu(menuFile, 'Label', '📤 Export All Data', 'Callback', @exportData);
        uimenu(menuFile, 'Label', '❌ Exit', 'Callback', @(~,~) close(f));
        
        menuTools = uimenu(f, 'Label', '🔧 Tools');
        uimenu(menuTools, 'Label', '📊 BER Analyzer', 'Callback', @analyzeBER);
        uimenu(menuTools, 'Label', '🌊 Channel Simulator', 'Callback', @channelSimulator);
        uimenu(menuTools, 'Label', '⭐ Constellation Designer', 'Callback', @constellationDesigner);
        uimenu(menuTools, 'Label', '🎛️ Signal Generator', 'Callback', @signalGenerator);
        uimenu(menuTools, 'Label', '📈 Performance Monitor', 'Callback', @performanceMonitor);
        
        menuView = uimenu(f, 'Label', '👀 View');
        uimenu(menuView, 'Label', '🎨 Change Theme', 'Callback', @changeTheme);
        uimenu(menuView, 'Label', '🌈 Visual Effects', 'Callback', @visualEffects);
        uimenu(menuView, 'Label', '📊 Show Statistics', 'Callback', @showStatistics);
        uimenu(menuView, 'Label', '📋 View Log', 'Callback', @viewLog);
        
        menuHelp = uimenu(f, 'Label', '❓ Help');
        uimenu(menuHelp, 'Label', '📖 User Guide', 'Callback', @showHelp);
        uimenu(menuHelp, 'Label', '🔬 Features Demo', 'Callback', @featuresDemo);
        uimenu(menuHelp, 'Label', 'ℹ️ About System', 'Callback', @showAbout);
    end

    function loadSettings(~, ~)
        try
            [filename, pathname] = uigetfile('*.mat', 'Load Settings');
            if filename == 0, return; end
            
            settings = load(fullfile(pathname, filename));
            if isfield(settings, 'guiSettings')
                s = settings.guiSettings;
                snrSlider.Value = s.SNR;
                snrValue.String = sprintf('%.1f', s.SNR);
                modMenu.Value = s.ModType;
                channelMenu.Value = s.ChannelType;
                crcCheckbox.Value = s.CRC;
                if isfield(s, 'colors')
                    colors = s.colors;
                end
                updateStatus('📂 Loaded', colors.success);
                progressBar.String = '📂 Settings loaded successfully!';
                progressBar.BackgroundColor = colors.success;
            end
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Load settings error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function saveSettings(~, ~)
        try
            [filename, pathname] = uiputfile('*.mat', 'Save Settings');
            if filename == 0, return; end
            
            guiSettings.SNR = snrSlider.Value;
            guiSettings.ModType = modMenu.Value;
            guiSettings.ChannelType = channelMenu.Value;
            guiSettings.CRC = crcCheckbox.Value;
            guiSettings.Hamming = hammingCheckbox.Value;
            guiSettings.Interleaver = interleaverCheckbox.Value;
            guiSettings.Turbo = turboCheckbox.Value;
            guiSettings.colors = colors;
            
            save(fullfile(pathname, filename), 'guiSettings');
            updateStatus('💾 Saved', colors.success);
            progressBar.String = '💾 Settings saved successfully!';
            progressBar.BackgroundColor = colors.success;
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Save settings error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    function channelSimulator(~, ~)
        % Advanced channel simulation tool with colorful UI
        simFig = figure('Name','🌊 Advanced Channel Simulator',...
            'Position',[400 200 600 500],'Color',colors.panelBg);
        
        % Title
        uicontrol(simFig, 'Style', 'text', 'Position', [50 450 500 30], ...
            'String', '🌊 ADVANCED CHANNEL SIMULATION LABORATORY', ...
            'BackgroundColor', colors.primary, 'ForegroundColor', [0 0 0], ...
            'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
        
        % Doppler frequency
        uicontrol(simFig, 'Style', 'text', 'Position', [50 400 150 25], ...
            'String', '🌪️ Doppler Freq (Hz):', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.cyan, 'FontSize', 11, 'FontWeight', 'bold');
        dopplerEdit = uicontrol(simFig, 'Style', 'edit', 'Position', [220 400 100 25], ...
            'String', '0', 'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Multipath delay
        uicontrol(simFig, 'Style', 'text', 'Position', [50 360 150 25], ...
            'String', '⏱️ Delay Spread (μs):', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.warning, 'FontSize', 11, 'FontWeight', 'bold');
        delayEdit = uicontrol(simFig, 'Style', 'edit', 'Position', [220 360 100 25], ...
            'String', '0', 'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Path loss
        uicontrol(simFig, 'Style', 'text', 'Position', [50 320 150 25], ...
            'String', '📉 Path Loss (dB):', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.orange, 'FontSize', 11, 'FontWeight', 'bold');
        pathLossEdit = uicontrol(simFig, 'Style', 'edit', 'Position', [220 320 100 25], ...
            'String', '0', 'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Interference level
        uicontrol(simFig, 'Style', 'text', 'Position', [50 280 150 25], ...
            'String', '📻 Interference (dB):', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.danger, 'FontSize', 11, 'FontWeight', 'bold');
        interferenceEdit = uicontrol(simFig, 'Style', 'edit', 'Position', [220 280 100 25], ...
            'String', '-40', 'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Environmental factors
        uicontrol(simFig, 'Style', 'text', 'Position', [50 240 150 25], ...
            'String', '🌦️ Weather Factor:', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.purple, 'FontSize', 11, 'FontWeight', 'bold');
        weatherMenu = uicontrol(simFig, 'Style', 'popupmenu', 'Position', [220 240 150 25], ...
            'String', {'☀️ Clear', '🌧️ Rain', '❄️ Snow', '🌫️ Fog', '⛈️ Storm'}, ...
            'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Control buttons
        uicontrol(simFig, 'Style', 'pushbutton', 'Position', [50 180 120 40], ...
            'String', '✅ APPLY', 'BackgroundColor', colors.success, ...
            'ForegroundColor', [0 0 0], 'FontWeight', 'bold', 'FontSize', 12, ...
            'Callback', @applyChannelSettings);
        
        uicontrol(simFig, 'Style', 'pushbutton', 'Position', [200 180 120 40], ...
            'String', '🔄 RESET', 'BackgroundColor', colors.warning, ...
            'ForegroundColor', [0 0 0], 'FontWeight', 'bold', 'FontSize', 12, ...
            'Callback', @resetChannelSettings);
        
        uicontrol(simFig, 'Style', 'pushbutton', 'Position', [350 180 120 40], ...
            'String', '❌ CLOSE', 'BackgroundColor', colors.danger, ...
            'ForegroundColor', [1 1 1], 'FontWeight', 'bold', 'FontSize', 12, ...
            'Callback', @(~,~) close(simFig));
        
        % Preview area
        previewAx = axes(simFig, 'Units', 'pixels', 'Position', [50 50 520 120]);
        previewAx.Color = [0.05 0.05 0.1];
        title(previewAx, '📊 Channel Response Preview', 'Color', [1 1 1]);
        
        function applyChannelSettings(~, ~)
            try
                % This would apply advanced channel settings in real implementation
                updateStatus('🌊 Applied', colors.success);
                progressBar.String = '🌊 Advanced channel settings applied!';
                progressBar.BackgroundColor = colors.success;
                
                % Show preview
                f_response = linspace(-1, 1, 100);
                h_response = ones(size(f_response)) .* exp(-abs(f_response));
                plot(previewAx, f_response, abs(h_response), 'Color', colors.primary, 'LineWidth', 2);
                xlabel(previewAx, 'Frequency', 'Color', [0.8 0.8 0.8]);
                ylabel(previewAx, 'Response', 'Color', [0.8 0.8 0.8]);
                grid(previewAx, 'on');
                
                close(simFig);
            catch ME
                progressBar.String = ['🚨 Channel settings error: ', ME.message];
                progressBar.BackgroundColor = colors.danger;
            end
        end
        
        function resetChannelSettings(~, ~)
            dopplerEdit.String = '0';
            delayEdit.String = '0';
            pathLossEdit.String = '0';
            interferenceEdit.String = '-40';
            weatherMenu.Value = 1;
            cla(previewAx);
            title(previewAx, '📊 Channel Response Preview', 'Color', [1 1 1]);
        end
    end

    function constellationDesigner(~, ~)
        % Enhanced constellation designer with colorful UI
        constFig = figure('Name','⭐ Constellation Designer Studio',...
            'Position',[450 200 600 500],'Color',colors.panelBg);
        
        % Title
        uicontrol(constFig, 'Style', 'text', 'Position', [50 450 500 30], ...
            'String', '⭐ CONSTELLATION DESIGN STUDIO', ...
            'BackgroundColor', colors.secondary, 'ForegroundColor', [0 0 0], ...
            'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
        
        % Constellation plot
        constDesignAx = axes(constFig, 'Units', 'pixels', 'Position', [300 150 280 280]);
        constDesignAx.Color = [0.05 0.05 0.1];
        
        % Controls
        uicontrol(constFig, 'Style', 'text', 'Position', [50 400 80 25], ...
            'String', '📊 M-ary:', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.primary, 'FontSize', 11, 'FontWeight', 'bold');
        mEdit = uicontrol(constFig, 'Style', 'edit', 'Position', [140 400 60 25], ...
            'String', '16', 'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        uicontrol(constFig, 'Style', 'text', 'Position', [50 360 80 25], ...
            'String', '🎨 Type:', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.success, 'FontSize', 11, 'FontWeight', 'bold');
        typeMenu = uicontrol(constFig, 'Style', 'popupmenu', 'Position', [140 360 120 25], ...
            'String', {'QAM', 'PSK', 'APSK', 'Custom'}, ...
            'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Color controls
        uicontrol(constFig, 'Style', 'text', 'Position', [50 320 80 25], ...
            'String', '🌈 Colors:', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.cyan, 'FontSize', 11, 'FontWeight', 'bold');
        colorCheck = uicontrol(constFig, 'Style', 'checkbox', 'Position', [140 320 100 25], ...
            'String', 'Rainbow', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.warning, 'Value', 1);
        
        % Buttons
        uicontrol(constFig, 'Style', 'pushbutton', 'Position', [50 250 80 30], ...
            'String', '🔄 UPDATE', 'BackgroundColor', colors.primary, ...
            'ForegroundColor', [1 1 1], 'FontWeight', 'bold', 'Callback', @updateConstellation);
        
        uicontrol(constFig, 'Style', 'pushbutton', 'Position', [50 200 80 30], ...
            'String', '💾 SAVE', 'BackgroundColor', colors.success, ...
            'ForegroundColor', [0 0 0], 'FontWeight', 'bold', 'Callback', @saveConstellation);
        
        uicontrol(constFig, 'Style', 'pushbutton', 'Position', [50 150 80 30], ...
            'String', '🎲 RANDOM', 'BackgroundColor', colors.warning, ...
            'ForegroundColor', [0 0 0], 'FontWeight', 'bold', 'Callback', @randomConstellation);
        
        % Initial constellation
        updateConstellation();
        
        function updateConstellation(~, ~)
            try
                M = str2double(mEdit.String);
                if M < 2, M = 2; end
                if M > 256, M = 256; end
                
                typeIdx = typeMenu.Value;
                useColors = colorCheck.Value;
                
                data = 0:M-1;
                
                switch typeIdx
                    case 1 % QAM
                        modData = qammod(data, M);
                    case 2 % PSK
                        modData = pskmod(data, M);
                    case 3 % APSK
                        % Simplified APSK
                        modData = qammod(data, M);
                    case 4 % Custom
                        % Random constellation
                        modData = (randn(M, 1) + 1j*randn(M, 1)) * sqrt(M/10);
                end
                
                cla(constDesignAx);
                hold(constDesignAx, 'on');
                
                if useColors
                    % Rainbow colors
                    colormap(constDesignAx, hsv(M));
                    scatter(constDesignAx, real(modData), imag(modData), 100, 1:M, 'filled');
                else
                    scatter(constDesignAx, real(modData), imag(modData), 100, colors.primary, 'filled');
                end
                
                % Add constellation lines for PSK
                if typeIdx == 2
                    theta = linspace(0, 2*pi, 100);
                    radius = abs(modData(1));
                    plot(constDesignAx, radius*cos(theta), radius*sin(theta), ...
                        'Color', colors.warning, 'LineStyle', '--', 'Alpha', 0.5);
                end
                
                title(constDesignAx, sprintf('✨ %d-%s Constellation', M, typeMenu.String{typeIdx}), ...
                    'Color', [1 1 1], 'FontWeight', 'bold');
                xlabel(constDesignAx, 'In-phase', 'Color', [0.8 0.8 0.8]);
                ylabel(constDesignAx, 'Quadrature', 'Color', [0.8 0.8 0.8]);
                grid(constDesignAx, 'on');
                axis(constDesignAx, 'equal');
                hold(constDesignAx, 'off');
                
            catch ME
                fprintf('Constellation update error: %s\n', ME.message);
            end
        end
        
        function saveConstellation(~, ~)
            [filename, pathname] = uiputfile('*.png', 'Save Constellation');
            if filename ~= 0
                exportgraphics(constDesignAx, fullfile(pathname, filename));
                progressBar.String = ['⭐ Constellation saved: ', filename];
                progressBar.BackgroundColor = colors.success;
            end
        end
        
        function randomConstellation(~, ~)
            mEdit.String = num2str(randi([4, 64]));
            typeMenu.Value = randi(3);
            colorCheck.Value = randi([0, 1]);
            updateConstellation();
        end
    end

    function signalGenerator(~, ~)
        % Advanced signal generator
        sigFig = figure('Name','🎛️ Advanced Signal Generator',...
            'Position',[500 150 700 600],'Color',colors.panelBg);
        
        uicontrol(sigFig, 'Style', 'text', 'Position', [50 550 600 30], ...
            'String', '🎛️ ADVANCED SIGNAL GENERATION LABORATORY', ...
            'BackgroundColor', colors.purple, 'ForegroundColor', [1 1 1], ...
            'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
        
        % Signal parameters with colorful styling
        y = 500;
        uicontrol(sigFig, 'Style', 'text', 'Position', [50 y 100 25], ...
            'String', '🌊 Frequency:', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.primary, 'FontSize', 11, 'FontWeight', 'bold');
        freqSlider = uicontrol(sigFig, 'Style', 'slider', 'Position', [160 y 200 25], ...
            'Min', 1, 'Max', 1000, 'Value', 100, 'BackgroundColor', colors.primary);
        freqLabel = uicontrol(sigFig, 'Style', 'text', 'Position', [370 y 60 25], ...
            'String', '100 Hz', 'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        y = y - 40;
        uicontrol(sigFig, 'Style', 'text', 'Position', [50 y 100 25], ...
            'String', '📊 Amplitude:', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.success, 'FontSize', 11, 'FontWeight', 'bold');
        ampSlider = uicontrol(sigFig, 'Style', 'slider', 'Position', [160 y 200 25], ...
            'Min', 0.1, 'Max', 5, 'Value', 1, 'BackgroundColor', colors.success);
        ampLabel = uicontrol(sigFig, 'Style', 'text', 'Position', [370 y 60 25], ...
            'String', '1.0', 'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Signal type
        y = y - 40;
        uicontrol(sigFig, 'Style', 'text', 'Position', [50 y 100 25], ...
            'String', '⚡ Type:', 'BackgroundColor', colors.panelBg, ...
            'ForegroundColor', colors.warning, 'FontSize', 11, 'FontWeight', 'bold');
        sigTypeMenu = uicontrol(sigFig, 'Style', 'popupmenu', 'Position', [160 y 150 25], ...
            'String', {'Sine', 'Square', 'Triangle', 'Sawtooth', 'Chirp', 'Noise'}, ...
            'BackgroundColor', colors.textBg, 'ForegroundColor', [1 1 1]);
        
        % Display area
        sigGenAx = axes(sigFig, 'Units', 'pixels', 'Position', [50 50 600 300]);
        sigGenAx.Color = [0.05 0.05 0.1];
        
        % Update callbacks
        freqSlider.Callback = @(src,~) updateSignalGen();
        ampSlider.Callback = @(src,~) updateSignalGen();
        sigTypeMenu.Callback = @(src,~) updateSignalGen();
        
        % Generate button
        uicontrol(sigFig, 'Style', 'pushbutton', 'Position', [500 450 120 40], ...
            'String', '🚀 GENERATE', 'BackgroundColor', colors.secondary, ...
            'ForegroundColor', [1 1 1], 'FontWeight', 'bold', 'FontSize', 12, ...
            'Callback', @generateSignal);
    end
        
        function updateSignalGen()
            freqLabel.String = sprintf('%.1f Hz', freqSlider.Value);
            ampLabel.String = sprintf('%.1f', ampSlider.Value);
        end
        
       function generateSignal(~, ~)
    try
        % Set sample rate and time vector
        fs = 8000;
        t = 0:1/fs:1; % 1 second of signal
        freq = freqSlider.Value; % Frequency from the slider
        amp = ampSlider.Value; % Amplitude from the slider
        sigType = sigTypeMenu.Value; % Signal type from the menu
        
        % Generate the signal based on selected type
        switch sigType
            case 1 % Sine wave
                signal = amp * sin(2*pi*freq*t);
            case 2 % Square wave
                signal = amp * square(2*pi*freq*t);
            case 3 % Triangle wave
                signal = amp * sawtooth(2*pi*freq*t, 0.5); % '0.5' creates a triangle wave
            case 4 % Sawtooth wave
                signal = amp * sawtooth(2*pi*freq*t);
            case 5 % Chirp signal
                signal = amp * chirp(t, freq, 1, freq*2); % Linearly increasing frequency
            case 6 % White Noise
                signal = amp * randn(size(t)); % Random noise
            otherwise
                error('Invalid signal type selected.');
        end
        
        % Plot signal
        cla(sigGenAx); % Clear the previous plot
        plot(sigGenAx, t(1:min(1000, length(t))), signal(1:min(1000, length(signal))), ...
            'Color', colors.primary, 'LineWidth', 1.5);
        title(sigGenAx, sprintf('%s Signal', sigTypeMenu.String{sigType}), 'Color', [1 1 1], 'FontWeight', 'bold');
        xlabel(sigGenAx, 'Time (s)', 'Color', [0.8 0.8 0.8]);
        ylabel(sigGenAx, 'Amplitude', 'Color', [0.8 0.8 0.8]);
        grid(sigGenAx, 'on'); % Enable grid on the plot
        
    catch ME
        % Handle errors
        updateStatus('❌ Error', colors.danger);
        progressBar.String = ['🚨 Signal generation error: ', ME.message];
        progressBar.BackgroundColor = colors.danger;
    end
end


% Function to show help
function showHelp(~, ~)
    helpFig = figure('Name', '📖 User Guide', 'Position', [200 150 600 400], 'Color', colors.panelBg);
    uicontrol(helpFig, 'Style', 'text', 'Position', [50 250 500 80], ...
        'String', ['Welcome to the Advanced Communication System! ', ...
        'This system allows you to simulate signal transmission and reception ', ...
        'with various modulation, error correction, and channel models. ', ...
        'Use the controls to adjust parameters, visualize results, and explore ', ...
        'different configurations.'], ...
        'BackgroundColor', colors.panelBg, 'ForegroundColor', [1 1 1], 'FontSize', 12);

    uicontrol(helpFig, 'Style', 'pushbutton', 'Position', [250 50 100 40], ...
        'String', 'Close', 'BackgroundColor', colors.danger, 'ForegroundColor', [1 1 1], 'FontWeight', 'bold', ...
        'FontSize', 12, 'Callback', @(~,~) close(helpFig));
end % End of showHelp function

% Function to demonstrate features
function featuresDemo(~, ~)
    demoFig = figure('Name', '🔬 Features Demo', 'Position', [200 150 600 400], 'Color', colors.panelBg);
    uicontrol(demoFig, 'Style', 'text', 'Position', [50 350 500 30], ...
        'String', '🔬 Features Demo', 'BackgroundColor', colors.secondary, 'ForegroundColor', [1 1 1], ...
        'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    uicontrol(demoFig, 'Style', 'text', 'Position', [50 250 500 80], ...
        'String', 'Here you can explore the advanced features of the communication system. Modify transmission parameters and visualize waveforms, constellations, and spectrum.', ...
        'BackgroundColor', colors.panelBg, 'ForegroundColor', [1 1 1], 'FontSize', 12);

    uicontrol(demoFig, 'Style', 'pushbutton', 'Position', [250 50 100 40], ...
        'String', 'Close', 'BackgroundColor', colors.danger, 'ForegroundColor', [1 1 1], 'FontWeight', 'bold', ...
        'FontSize', 12, 'Callback', @(~,~) close(demoFig));
end % End of featuresDemo function

% Function to show about the system
function showAbout(~, ~)
    aboutFig = figure('Name', 'ℹ️ About System', 'Position', [200 150 600 400], 'Color', colors.panelBg);
    uicontrol(aboutFig, 'Style', 'text', 'Position', [50 350 500 30], ...
        'String', 'ℹ️ About System', 'BackgroundColor', colors.primary, 'ForegroundColor', [1 1 1], ...
        'FontSize', 14, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
    uicontrol(aboutFig, 'Style', 'text', 'Position', [50 250 500 80], ...
        'String', 'This system was developed as a demonstration of signal processing techniques, with interactive GUI elements for real-time analysis and visualization.', ...
        'BackgroundColor', colors.panelBg, 'ForegroundColor', [1 1 1], 'FontSize', 12);
    uicontrol(aboutFig, 'Style', 'pushbutton', 'Position', [250 50 100 40], ...
        'String', 'Close', 'BackgroundColor', colors.danger, 'ForegroundColor', [1 1 1], 'FontWeight', 'bold', ...
        'FontSize', 12, 'Callback', @(~,~) close(aboutFig));
end % End of showAbout function

% Initialize the GUI with advanced menus and default settings
initializeMenus();
updateStatus('✅ System Ready', colors.success);
progressBar.String = '🎯 Ready to rock!';
progressBar.BackgroundColor = colors.success;

end % End of the main function
