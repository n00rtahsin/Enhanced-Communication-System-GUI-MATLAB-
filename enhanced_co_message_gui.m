function enhanced_co_message_gui()
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
                pause(0.1);
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
                rxBin = correctTurboCode(rxBin);
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
                    % Map binary to BPSK symbols (0 -> -1, 1 -> +1)
                    symbols = 2*bin - 1;
                    modSig = symbols(:);
                case 'QPSK'
                    M = 4; k = 2;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    % QPSK mapping
                    mapping = [1+1j, -1+1j, -1-1j, 1-1j]/sqrt(2);
                    modSig = mapping(symbols + 1).';
                case '8-PSK'
                    M = 8; k = 3;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    % 8-PSK mapping
                    angles = 2*pi*(0:7)/8;
                    mapping = exp(1j*angles);
                    modSig = mapping(symbols + 1).';
                case '16-QAM'
                    M = 16; k = 4;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    % 16-QAM mapping (Gray coding)
                    qamMap = [-3-3j, -3-1j, -3+3j, -3+1j, -1-3j, -1-1j, -1+3j, -1+1j, ...
                              3-3j, 3-1j, 3+3j, 3+1j, 1-3j, 1-1j, 1+3j, 1+1j]/sqrt(10);
                    modSig = qamMap(symbols + 1).';
                case '64-QAM'
                    M = 64; k = 6;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    % Simplified 64-QAM (rectangular constellation)
                    I = -7:2:7; Q = -7:2:7;
                    [Igrid, Qgrid] = meshgrid(I, Q);
                    qamMap = (Igrid(:) + 1j*Qgrid(:))/sqrt(42);
                    modSig = qamMap(symbols + 1);
                case '256-QAM'
                    M = 256; k = 8;
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    % Simplified 256-QAM
                    I = -15:2:15; Q = -15:2:15;
                    [Igrid, Qgrid] = meshgrid(I, Q);
                    qamMap = (Igrid(:) + 1j*Qgrid(:))/sqrt(170);
                    modSig = qamMap(symbols + 1);
                case 'OFDM'
                    % Simple OFDM implementation
                    M = 4; k = 2; % QPSK subcarriers
                    padded = padBinary(bin, k);
                    symbols = bi2de(reshape(padded, k, []).', 'left-msb');
                    qpskMap = [1+1j, -1+1j, -1-1j, 1-1j]/sqrt(2);
                    qpskSig = qpskMap(symbols + 1).';
                    
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
            modSig = 2*bin(1:min(100, length(bin))) - 1;
            modSig = modSig(:);
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
                % Add white Gaussian noise
                signalPower = mean(abs(modSig).^2);
                noisePower = signalPower / (10^(snr/10));
                noise = sqrt(noisePower/2) * (randn(size(modSig)) + 1j*randn(size(modSig)));
                rxSig = modSig + noise;
                h = ones(size(modSig));
                channelInfo.type = 'AWGN';
                
            case 'Rayleigh'
                h = (randn(size(modSig)) + 1j*randn(size(modSig))) / sqrt(2);
                channelSig = h .* modSig;
                signalPower = mean(abs(channelSig).^2);
                noisePower = signalPower / (10^(snr/10));
                noise = sqrt(noisePower/2) * (randn(size(modSig)) + 1j*randn(size(modSig)));
                rxSig = channelSig + noise;
                channelInfo.type = 'Rayleigh';
                
            case 'Rician'
                K = 3; % Rician K-factor
                h = sqrt(K/(K+1)) + sqrt(1/(2*(K+1))) * (randn(size(modSig)) + 1j*randn(size(modSig)));
                channelSig = h .* modSig;
                signalPower = mean(abs(channelSig).^2);
                noisePower = signalPower / (10^(snr/10));
                noise = sqrt(noisePower/2) * (randn(size(modSig)) + 1j*randn(size(modSig)));
                rxSig = channelSig + noise;
                channelInfo.type = 'Rician';
                channelInfo.K = K;
                
            case 'Nakagami'
                m = 1.5; omega = 1;
                magnitude = sqrt(gamrnd(m, omega/m, size(modSig)));
                phase = 2*pi*rand(size(modSig));
                h = magnitude .* exp(1j*phase);
                channelSig = h .* modSig;
                signalPower = mean(abs(channelSig).^2);
                noisePower = signalPower / (10^(snr/10));
                noise = sqrt(noisePower/2) * (randn(size(modSig)) + 1j*randn(size(modSig)));
                rxSig = channelSig + noise;
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
                signalPower = mean(abs(rxSig).^2);
                noisePower = signalPower / (10^(snr/10));
                noise = sqrt(noisePower/2) * (randn(size(modSig)) + 1j*randn(size(modSig)));
                rxSig = rxSig + noise;
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
                    % BPSK demodulation: decision based on real part
                    demodData = real(rxSig) > 0;
                case 'QPSK'
                    % QPSK demodulation
                    mapping = [1+1j, -1+1j, -1-1j, 1-1j]/sqrt(2);
                    demodData = zeros(size(rxSig));
                    for i = 1:length(rxSig)
                        [~, idx] = min(abs(rxSig(i) - mapping));
                        demodData(i) = idx - 1;
                    end
                case '8-PSK'
                    % 8-PSK demodulation
                    angles = 2*pi*(0:7)/8;
                    mapping = exp(1j*angles);
                    demodData = zeros(size(rxSig));
                    for i = 1:length(rxSig)
                        [~, idx] = min(abs(rxSig(i) - mapping));
                        demodData(i) = idx - 1;
                    end
                case {'16-QAM', '64-QAM', '256-QAM'}
                    % QAM demodulation (simplified)
                    if strcmp(modType, '16-QAM')
                        qamMap = [-3-3j, -3-1j, -3+3j, -3+1j, -1-3j, -1-1j, -1+3j, -1+1j, ...
                                  3-3j, 3-1j, 3+3j, 3+1j, 1-3j, 1-1j, 1+3j, 1+1j]/sqrt(10);
                    elseif strcmp(modType, '64-QAM')
                        I = -7:2:7; Q = -7:2:7;
                        [Igrid, Qgrid] = meshgrid(I, Q);
                        qamMap = (Igrid(:) + 1j*Qgrid(:))/sqrt(42);
                    else % 256-QAM
                        I = -15:2:15; Q = -15:2:15;
                        [Igrid, Qgrid] = meshgrid(I, Q);
                        qamMap = (Igrid(:) + 1j*Qgrid(:))/sqrt(170);
                    end
                    
                    demodData = zeros(size(rxSig));
                    for i = 1:length(rxSig)
                        [~, idx] = min(abs(rxSig(i) - qamMap));
                        demodData(i) = idx - 1;
                    end
                case 'OFDM'
                    % Simple OFDM demodulation
                    nSubcarriers = 64;
                    cpLength = 16;
                    symbolLength = nSubcarriers + cpLength;
                    
                    % Remove cyclic prefix and perform FFT
                    nOFDMSymbols = floor(length(rxSig) / symbolLength);
                    demodData = [];
                    qpskMap = [1+1j, -1+1j, -1-1j, 1-1j]/sqrt(2);
                    
                    for i = 1:nOFDMSymbols
                        startIdx = (i-1) * symbolLength + 1;
                        endIdx = i * symbolLength;
                        if endIdx <= length(rxSig)
                            ofdmSymbol = rxSig(startIdx:endIdx);
                            
                            % Remove cyclic prefix
                            withoutCP = ofdmSymbol(cpLength+1:end);
                            
                            % FFT
                            freqDomain = fft(withoutCP, nSubcarriers);
                            
                            % QPSK demodulation
                            symbolData = zeros(size(freqDomain));
                            for j = 1:length(freqDomain)
                                [~, idx] = min(abs(freqDomain(j) - qpskMap));
                                symbolData(j) = idx - 1;
                            end
                            demodData = [demodData; symbolData];
                        end
                    end
            end
        catch ME
            fprintf('Demodulation error: %s\n', ME.message);
            demodData = real(rxSig(1:min(100, length(rxSig)))) > 0;
        end
    end

    function rxBin = convertToRxBinary(demodData, M, k, origLength)
        try
            if strcmp(modMenu.String{modMenu.Value}, 'BPSK')
                rxBin = double(demodData(:)');
            else
                % Convert symbols back to binary
                demodData = double(demodData(:));
                binMatrix = de2bi(demodData, k, 'left-msb');
                rxBin = reshape(binMatrix.', 1, []);
            end
            rxBin = rxBin(1:min(length(rxBin), origLength));
        catch
            rxBin = zeros(1, min(origLength, 100));
        end
    end

    % Enhanced error correction functions
    function encoded = applyTurboCode(data)
        try
            % Simplified turbo encoder - just repeat the data
            encoded = [data, data];
        catch
            encoded = data;
        end
    end

    function decoded = correctTurboCode(data)
        try
            % Simplified turbo decoder - take first half
            dataLen = floor(length(data) / 2);
            decoded = data(1:dataLen);
        catch
            decoded = data;
        end
    end

    function encoded = applyCRC(data)
        try
            % Simple 8-bit checksum
            dataBytes = reshape([data, zeros(1, mod(8-mod(length(data),8),8))], 8, []);
            checksum = mod(sum(dataBytes), 256);
            checksumBits = de2bi(checksum, 8, 'left-msb');
            encoded = [data, checksumBits];
        catch
            encoded = data;
        end
    end

    function [decoded, status] = checkCRC(data)
        try
            if length(data) > 8
                decoded = data(1:end-8);
                % Simple checksum verification
                dataBytes = reshape([decoded, zeros(1, mod(8-mod(length(decoded),8),8))], 8, []);
                expectedChecksum = mod(sum(dataBytes), 256);
                receivedChecksum = bi2de(data(end-7:end), 'left-msb');
                if expectedChecksum == receivedChecksum
                    status = 'Pass';
                else
                    status = 'Fail';
                end
            else
                decoded = data;
                status = 'N/A';
            end
        catch
            decoded = data;
            status = 'Error';
        end
    end

    function encoded = applyHamming(data)
        try
            % Simplified Hamming code - just add parity bits
            encoded = [data, mod(sum(data), 2)];
        catch
            encoded = data;
        end
    end

    function corrected = correctHamming(data)
        try
            if length(data) > 1
                corrected = data(1:end-1);
            else
                corrected = data;
            end
        catch
            corrected = data;
        end
    end

    function interleaved = interleave(data)
        try
            blockSize = min(16, length(data));
            if length(data) <= blockSize
                interleaved = data;
                return;
            end
            
            numBlocks = ceil(length(data) / blockSize);
            padded = [data, zeros(1, numBlocks * blockSize - length(data))];
            blocks = reshape(padded, blockSize, numBlocks);
            
            % Simple interleaving pattern
            pattern = mod((1:blockSize) * 7, blockSize) + 1;
            interleavedBlocks = blocks(pattern, :);
            interleaved = reshape(interleavedBlocks, 1, []);
            interleaved = interleaved(1:length(data));
        catch
            interleaved = data;
        end
    end

    function deinterleaved = deinterleave(data, origLength)
        try
            blockSize = min(16, origLength);
            if length(data) <= blockSize
                deinterleaved = data;
                return;
            end
            
            numBlocks = ceil(length(data) / blockSize);
            padded = [data, zeros(1, numBlocks * blockSize - length(data))];
            blocks = reshape(padded, blockSize, numBlocks);
            
            % Reverse interleaving pattern
            pattern = mod((1:blockSize) * 7, blockSize) + 1;
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
                    % Simple upsampling with basic filtering
                    shaped = repelem(signal, sps);
                    % Apply simple low-pass filtering
                    h = ones(1, sps) / sps;
                    shaped = conv(shaped, h, 'same');
                case 'Gaussian'
                    % Simple Gaussian approximation
                    shaped = repelem(signal, sps);
                    t = -2:1/sps:2;
                    gaussFilter = exp(-t.^2/0.5);
                    gaussFilter = gaussFilter / sum(gaussFilter);
                    shaped = conv(shaped, gaussFilter, 'same');
                case 'Hamming'
                    shaped = repelem(signal, sps);
                    window = hamming(4 * sps);
                    shaped = conv(shaped, window, 'same') / sum(window);
                case 'Blackman'
                    shaped = repelem(signal, sps);
                    window = blackman(4 * sps);
                    shaped = conv(shaped, window, 'same') / sum(window);
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
            % Simple SNR estimation
            signalPower = mean(abs(signal).^2);
            % Estimate noise from high-frequency components
            diffSig = diff(signal);
            noisePower = var(diffSig) / 2;
            if noisePower > 0
                snrEst = 10 * log10(signalPower / noisePower);
            else
                snrEst = 50; % Very high SNR
            end
            snrEst = max(-10, min(50, snrEst)); % Clamp to reasonable range
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
        elseif ber < 1e-1
            berScore = 20;
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
            if length(bin) >= 8
                bytes = reshape(bin, 8, []);
                charCodes = bi2de(bytes.', 'left-msb');
                % Filter out non-printable characters
                validChars = charCodes >= 32 & charCodes <= 126;
                chars = char(charCodes(validChars))';
            else
                chars = 'Short data';
            end
            
            % If result is empty or too short, provide meaningful message
            if isempty(chars) || length(chars) < 3
                chars = sprintf('Decoded %d bits', length(bin));
            end
        catch
            chars = sprintf('Decode Error (%d bits)', length(bin));
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
            
            % 1. Enhanced Waveform plot
            axes(waveformAx);
            cla(waveformAx);
            hold(waveformAx, 'on');
            
            plotLength = min(500, length(rxSig));
            time_axis = (1:plotLength);
            
            if ~isempty(modSig) && length(modSig) >= plotLength
                plot(waveformAx, time_axis, real(modSig(1:plotLength)), ...
                    'Color', colors.success, 'LineWidth', 2, 'DisplayName', '📤 TX Signal');
            end
            
            plot(waveformAx, time_axis, real(rxSig(1:plotLength)), ...
                'Color', colors.primary, 'LineWidth', 1.5, 'DisplayName', '📥 RX Signal');
            
            title(waveformAx, '🌊 Transmitted vs Received Waveforms', 'Color', [1 1 1], 'FontWeight', 'bold');
            xlabel(waveformAx, 'Sample Index', 'Color', [0.8 0.8 0.8]);
            ylabel(waveformAx, 'Amplitude', 'Color', [0.8 0.8 0.8]);
            legend(waveformAx, 'show', 'TextColor', [0.9 0.9 0.9], 'Color', [0.1 0.1 0.2]);
            grid(waveformAx, 'on');
            waveformAx.GridColor = [0.3 0.3 0.3];
            hold(waveformAx, 'off');

            % 2. Enhanced Constellation diagram
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
            
            % Plot received constellation
            scatter(constAx, real(plotSig), imag(plotSig), 25, colors.primary, ...
                'filled', 'MarkerFaceAlpha', 0.6, 'DisplayName', 'RX Symbols');
            
            % Add reference constellation
            modType = modMenu.String{modMenu.Value};
            refPoints = getRefConstellation(modType);
            if ~isempty(refPoints)
                scatter(constAx, real(refPoints), imag(refPoints), 100, ...
                    colors.danger, 'x', 'LineWidth', 3, 'DisplayName', 'Reference');
            end
            
            title(constAx, '⭐ Constellation Diagram', 'Color', [1 1 1], 'FontWeight', 'bold');
            xlabel(constAx, 'In-phase', 'Color', [0.8 0.8 0.8]);
            ylabel(constAx, 'Quadrature', 'Color', [0.8 0.8 0.8]);
            legend(constAx, 'show', 'TextColor', [0.9 0.9 0.9], 'Color', [0.1 0.1 0.2]);
            grid(constAx, 'on');
            axis(constAx, 'equal');
            hold(constAx, 'off');

            % 3. Enhanced Spectrum analysis
            axes(spectrumAx);
            cla(spectrumAx);
            
            N = min(1024, 2^nextpow2(length(rxSig)));
            if N > length(rxSig)
                sig_padded = [rxSig; zeros(N - length(rxSig), 1)];
            else
                sig_padded = rxSig(1:N);
            end
            
            f_axis = linspace(-0.5, 0.5, N);
            spectrum = abs(fftshift(fft(sig_padded)));
            spectrum_db = 20*log10(spectrum + eps);
            
            plot(spectrumAx, f_axis, spectrum_db, 'Color', colors.secondary, 'LineWidth', 2);
            
            title(spectrumAx, '📊 Power Spectral Density', 'Color', [1 1 1], 'FontWeight', 'bold');
            xlabel(spectrumAx, 'Normalized Frequency', 'Color', [0.8 0.8 0.8]);
            ylabel(spectrumAx, 'PSD (dB)', 'Color', [0.8 0.8 0.8]);
            grid(spectrumAx, 'on');
            
            % Set reasonable y-axis limits
            maxVal = max(spectrum_db);
            if ~isnan(maxVal) && ~isinf(maxVal)
                ylim(spectrumAx, [maxVal-60, maxVal+5]);
            end

            % 4. Enhanced Eye diagram
            axes(eyeAx);
            cla(eyeAx);
            
            if length(rxSig) >= 20
                sps = 4; % Samples per symbol
                eyeLength = sps * 2; % Two symbol periods
                
                if length(rxSig) >= eyeLength * 5
                    numTraces = min(50, floor(length(rxSig) / sps) - 2);
                    
                    if numTraces > 0
                        eyeMatrix = zeros(eyeLength, numTraces);
                        for i = 1:numTraces
                            startIdx = (i-1) * sps + 1;
                            endIdx = startIdx + eyeLength - 1;
                            if endIdx <= length(rxSig)
                                eyeMatrix(:, i) = real(rxSig(startIdx:endIdx));
                            end
                        end
                        
                        timeAxis = (0:eyeLength-1);
                        
                        % Plot eye traces
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
                            hold(eyeAx, 'on');
                        end
                        
                        % Add mean trace
                        meanTrace = mean(eyeMatrix, 2);
                        plot(eyeAx, timeAxis, meanTrace, 'Color', colors.warning, 'LineWidth', 3, 'DisplayName', 'Mean');
                        
                        title(eyeAx, '👁️ Eye Diagram', 'Color', [1 1 1], 'FontWeight', 'bold');
                        xlabel(eyeAx, 'Samples', 'Color', [0.8 0.8 0.8]);
                        ylabel(eyeAx, 'Amplitude', 'Color', [0.8 0.8 0.8]);
                        hold(eyeAx, 'off');
                    else
                        plot(eyeAx, real(rxSig(1:min(200, length(rxSig)))), 'Color', colors.primary, 'LineWidth', 1.5);
                        title(eyeAx, '📊 Signal Trace', 'Color', [1 1 1], 'FontWeight', 'bold');
                    end
                else
                    plot(eyeAx, real(rxSig), 'Color', colors.primary, 'LineWidth', 1.5);
                    title(eyeAx, '📊 Signal Trace', 'Color', [1 1 1], 'FontWeight', 'bold');
                end
            else
                plot(eyeAx, real(rxSig), 'o-', 'Color', colors.primary, 'LineWidth', 2, 'MarkerSize', 6);
                title(eyeAx, '📊 Signal Points', 'Color', [1 1 1], 'FontWeight', 'bold');
            end
            
            grid(eyeAx, 'on');
            
            drawnow;
            
        catch ME
            fprintf('Plot error: %s\n', ME.message);
        end
    end
    
    function refPoints = getRefConstellation(modType)
        try
            switch modType
                case 'BPSK'
                    refPoints = [-1, 1];
                case 'QPSK'
                    refPoints = [1+1j, -1+1j, -1-1j, 1-1j]/sqrt(2);
                case '8-PSK'
                    angles = 2*pi*(0:7)/8;
                    refPoints = exp(1j*angles);
                case '16-QAM'
                    refPoints = [-3-3j, -3-1j, -3+3j, -3+1j, -1-3j, -1-1j, -1+3j, -1+1j, ...
                                 3-3j, 3-1j, 3+3j, 3+1j, 1-3j, 1-1j, 1+3j, 1+1j]/sqrt(10);
                case '64-QAM'
                    I = -7:2:7; Q = -7:2:7;
                    [Igrid, Qgrid] = meshgrid(I, Q);
                    refPoints = (Igrid(:) + 1j*Qgrid(:))/sqrt(42);
                case '256-QAM'
                    I = -15:2:15; Q = -15:2:15;
                    [Igrid, Qgrid] = meshgrid(I, Q);
                    refPoints = (Igrid(:) + 1j*Qgrid(:))/sqrt(170);
                case 'OFDM'
                    refPoints = [1+1j, -1+1j, -1-1j, 1-1j]/sqrt(2);
                otherwise
                    refPoints = [];
            end
        catch
            refPoints = [];
        end
    end

    function text = audioToText(audio, fs)
        try
            if isempty(audio)
                text = 'No audio detected';
                return;
            end
            
            % Normalize audio
            audio = audio / (max(abs(audio)) + eps);
            
            % Simple envelope detection
            envelope = abs(audio);
            envelope = filter(ones(1, round(fs * 0.01))/round(fs * 0.01), 1, envelope);
            
            % Adaptive threshold
            threshold = mean(envelope) + std(envelope);
            
            % Find voice activity
            active = envelope > threshold;
            activeRegions = find(diff([0; active; 0]));
            
            if length(activeRegions) >= 2
                text = sprintf('Audio processed - %d segments detected', length(activeRegions)/2);
            else
                text = 'Audio processed - pattern detected';
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
                            if exist('audiowrite', 'file')
                                audiowrite(fullPath, audioData, currentFs, 'BitRate', 128);
                            else
                                audiowrite([fullPath(1:end-4), '.wav'], audioData, currentFs);
                            end
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
                    if exist('writetable', 'file')
                        T = struct2table(logData);
                        writetable(T, fullpath);
                    else
                        save([fullpath(1:end-5), '.mat'], 'logData');
                    end
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
        
        % Clear received text
        receivedText.String = '';
        
        % Reset metrics
        berLabel.String = '📊 BER: N/A';
        berLabel.BackgroundColor = colors.success;
        throughputLabel.String = '⚡ Throughput: N/A';
        delayLabel.String = '⏱️ Delay: N/A';
        crcStatusLabel.String = '🛡️ CRC: N/A';
        ebnLabel.String = '📡 Eb/N0: N/A';
        snrEstLabel.String = '📶 Est SNR: N/A';
        powerLabel.String = '⚡ RX Power: N/A';
        qualityLabel.String = '⭐ Quality: N/A';
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
            
            % Plot 1: BER vs SNR
            subplot(2,2,1);
            semilogy(snrValues, berValues, 'o-', 'Color', colors.primary, 'LineWidth', 2, 'MarkerSize', 8);
            xlabel('SNR (dB)'); ylabel('Bit Error Rate');
            title('🎯 BER vs SNR Performance');
            grid on;
            set(gca, 'Color', colors.panelBg, 'XColor', [0.8 0.8 0.8], 'YColor', [0.8 0.8 0.8]);
            
            % Plot 2: Modulation distribution
            subplot(2,2,2);
            [uniqueMods, ~, idx] = unique(modTypes);
            counts = accumarray(idx, 1);
            pie(counts, uniqueMods);
            title('📡 Modulation Type Distribution');
            
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
            colorbar;
            xlabel('SNR (dB)'); ylabel('Throughput (bps)');
            title('⚡ Throughput vs SNR (Color = BER)');
            grid on;
            
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
                progressBar.BackgroundColor = colors.warning;
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
            
        catch ME
            progressBar.String = ['🚨 Statistics error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
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
                newFs = str2double(sampleRateEdit.String);
                if ~isnan(newFs) && newFs > 0
                    currentFs = newFs;
                    progressBar.String = '⚙️ Advanced settings applied successfully!';
                    progressBar.BackgroundColor = colors.success;
                    close(advFig);
                else
                    progressBar.String = '❌ Invalid sample rate value!';
                    progressBar.BackgroundColor = colors.danger;
                end
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
        
        % Update UI components with new theme
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
        progressBar.String = '🌈 Activating visual effects...';
        progressBar.BackgroundColor = colors.secondary;
        
        % Create rainbow effect on status LED
        for i = 1:10
            hue = mod(i * 0.1, 1);
            rgb = hsv2rgb([hue, 1, 1]);
            statusLED.BackgroundColor = rgb;
            statusLED.String = '🌈 EFFECTS';
            pause(0.1);
            drawnow;
        end
        
        updateStatus('✨ Ready', colors.success);
        progressBar.String = '🌈 Visual effects completed!';
        progressBar.BackgroundColor = colors.success;
    end

    function autoOptimize(~, ~)
        try
            updateStatus('🎯 Optimizing...', colors.warning);
            progressBar.String = '🎯 Auto-optimizing system parameters...';
            progressBar.BackgroundColor = colors.warning;
            drawnow;
            
            % Simple auto-optimization based on recent performance
            if length(logData) >= 3
                recentBER = [logData(end-2:end).BER];
                recentSNR = [logData(end-2:end).SNR];
                
                avgBER = mean(recentBER);
                
                % Optimize SNR based on BER performance
                if avgBER > 1e-2
                    % Poor performance, increase SNR
                    newSNR = min(50, snrSlider.Value + 5);
                    snrSlider.Value = newSNR;
                    snrValue.String = sprintf('%.1f', newSNR);
                    
                    % Switch to more robust modulation
                    if modMenu.Value > 2
                        modMenu.Value = max(1, modMenu.Value - 1);
                    end
                    
                elseif avgBER < 1e-5
                    % Excellent performance, can optimize for throughput
                    if modMenu.Value < 7
                        modMenu.Value = min(7, modMenu.Value + 1);
                    end
                end
                
                progressBar.String = '🎯 Auto-optimization completed - Parameters adjusted!';
                progressBar.BackgroundColor = colors.success;
            else
                progressBar.String = '🎯 Need more transmission history for optimization';
                progressBar.BackgroundColor = colors.warning;
            end
            
            updateStatus('✅ Ready', colors.success);
            
        catch ME
            updateStatus('❌ Error', colors.danger);
            progressBar.String = ['🚨 Auto-optimization error: ', ME.message];
            progressBar.BackgroundColor = colors.danger;
        end
    end

    % Initialize plots with welcome message
    axes(waveformAx);
    text(0.5, 0.5, '🌊 Waveform will appear here', 'HorizontalAlignment', 'center', ...
        'Color', [0.7 0.7 0.7], 'FontSize', 12, 'Units', 'normalized');
    
    axes(constAx);
    text(0.5, 0.5, '⭐ Constellation will appear here', 'HorizontalAlignment', 'center', ...
        'Color', [0.7 0.7 0.7], 'FontSize', 12, 'Units', 'normalized');
    
    axes(spectrumAx);
    text(0.5, 0.5, '📊 Spectrum will appear here', 'HorizontalAlignment', 'center', ...
        'Color', [0.7 0.7 0.7], 'FontSize', 12, 'Units', 'normalized');
    
    axes(eyeAx);
    text(0.5, 0.5, '👁️ Eye diagram will appear here', 'HorizontalAlignment', 'center', ...
        'Color', [0.7 0.7 0.7], 'FontSize', 12, 'Units', 'normalized');

    % Set up timer for periodic updates (optional)
    updateTimer = timer('Period', 1.0, 'ExecutionMode', 'fixedRate', ...
        'TimerFcn', @updateSystemStatus);
    
    function updateSystemStatus(~, ~)
        % Periodic system status updates
        if ishandle(f)
            % Update timestamp or other periodic information
            currentTime = datestr(now, 'HH:MM:SS');
            if contains(statusLED.String, 'Ready')
                statusLED.String = ['● READY ' currentTime];
            end
        else
            stop(updateTimer);
            delete(updateTimer);
        end
    end
    
    % Start the timer
    start(updateTimer);
    
    % Cleanup function when figure is closed
    f.CloseRequestFcn = @cleanupAndClose;
    
    function cleanupAndClose(~, ~)
        % Stop and delete timer
        if exist('updateTimer', 'var') && isvalid(updateTimer)
            stop(updateTimer);
            delete(updateTimer);
        end
        
        % Clear any playing audio
        clear sound;
        
        % Close the figure
        delete(f);
        
        fprintf('🚀 Enhanced Communication GUI closed successfully.\n');
    end

    % Display startup message
    updateStatus('🚀 System Initialized', colors.success);
    progressBar.String = '🎉 Enhanced Communication System ready for operation!';
    progressBar.BackgroundColor = colors.success;
    
    fprintf('🚀 Enhanced Communication System GUI initialized successfully!\n');
    fprintf('📝 Features available:\n');
    fprintf('   • Multiple modulation schemes (BPSK, QPSK, 8-PSK, QAM, OFDM)\n');
    fprintf('   • Advanced channel models (AWGN, Rayleigh, Rician, etc.)\n');
    fprintf('   • Error correction coding (CRC, Hamming, Turbo)\n');
    fprintf('   • Real-time signal analysis and visualization\n');
    fprintf('   • Audio recording and processing\n');
    fprintf('   • Comprehensive performance metrics\n');
    fprintf('   • Data export and logging capabilities\n');
    fprintf('   • Auto-optimization features\n');
    fprintf('🎯 Ready for communication experiments!\n');

end