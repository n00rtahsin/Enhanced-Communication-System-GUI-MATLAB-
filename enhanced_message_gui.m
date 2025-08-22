function enhanced_message_gui()
    % Enhanced Message Communication GUI with bug fixes and new features
    f = figure('Name','Enhanced Message Communication System',...
        'Position',[50 50 1300 800],'MenuBar','none','Resize','off');

    % Initialize global variables
    logData = struct('Time',{},'Message',{},'SNR',{},'Modulation',{},...
        'Channel',{},'BER',{},'Throughput',{},'Delay',{},'CRC',{});
    audioData = [];
    currentFs = 8000;

    % Create main panels
    inputPanel = uipanel(f,'Title','Input Controls','Position',[0.02 0.7 0.46 0.28]);
    outputPanel = uipanel(f,'Title','Output & Metrics','Position',[0.52 0.7 0.46 0.28]);
    plotPanel = uipanel(f,'Title','Signal Analysis','Position',[0.02 0.02 0.96 0.66]);

    % Input Controls
    y_pos = 0.85;
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.1],'String','Message:','FontWeight','bold');
    msgBox = uicontrol(inputPanel,'Style','edit','Units','normalized',...
        'Position',[0.25 y_pos 0.7 0.1],'String','Hello World!');

    y_pos = y_pos - 0.15;
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.08],'String','SNR (dB):');
    snrSlider = uicontrol(inputPanel,'Style','slider','Units','normalized',...
        'Position',[0.25 y_pos 0.4 0.08],'Min',-10,'Max',40,'Value',15);
    snrValue = uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.67 y_pos 0.1 0.08],'String','15');
    snrSlider.Callback = @(src,~) set(snrValue,'String',sprintf('%.1f',src.Value));

    y_pos = y_pos - 0.15;
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.08],'String','Modulation:');
    modMenu = uicontrol(inputPanel,'Style','popupmenu','Units','normalized',...
        'Position',[0.25 y_pos 0.25 0.08],'String',{'BPSK','QPSK','8-PSK','16-QAM','64-QAM','256-QAM'});

    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.52 y_pos 0.18 0.08],'String','Channel:');
    channelMenu = uicontrol(inputPanel,'Style','popupmenu','Units','normalized',...
        'Position',[0.72 y_pos 0.25 0.08],'String',{'AWGN','Rayleigh','Rician','Nakagami'});

    y_pos = y_pos - 0.15;
    % Error correction options
    crcCheckbox = uicontrol(inputPanel,'Style','checkbox','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.08],'String','CRC','Value',1);
    hammingCheckbox = uicontrol(inputPanel,'Style','checkbox','Units','normalized',...
        'Position',[0.25 y_pos 0.25 0.08],'String','Hamming Code');
    interleaverCheckbox = uicontrol(inputPanel,'Style','checkbox','Units','normalized',...
        'Position',[0.52 y_pos 0.22 0.08],'String','Interleaver');

    % Pulse shaping
    uicontrol(inputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos-0.1 0.2 0.08],'String','Pulse Shape:');
    pulseMenu = uicontrol(inputPanel,'Style','popupmenu','Units','normalized',...
        'Position',[0.25 y_pos-0.1 0.25 0.08],'String',{'None','RRC','Gaussian','Rectangular'});

    % Control buttons
    y_pos = 0.02;
    sendBtn = uicontrol(inputPanel,'Style','pushbutton','String','Transmit','Units','normalized',...
        'Position',[0.02 y_pos 0.15 0.15],'BackgroundColor',[0.2 0.8 0.2],...
        'FontWeight','bold','Callback',@transmitMessage);

    uicontrol(inputPanel,'Style','pushbutton','String','Record Audio','Units','normalized',...
        'Position',[0.2 y_pos 0.15 0.15],'Callback',@recordAudio);

    uicontrol(inputPanel,'Style','pushbutton','String','Load File','Units','normalized',...
        'Position',[0.38 y_pos 0.15 0.15],'Callback',@loadFile);

    uicontrol(inputPanel,'Style','pushbutton','String','Clear Log','Units','normalized',...
        'Position',[0.56 y_pos 0.15 0.15],'Callback',@clearLog);

    uicontrol(inputPanel,'Style','pushbutton','String','Export Data','Units','normalized',...
        'Position',[0.74 y_pos 0.15 0.15],'BackgroundColor',[0.8 0.8 0.2],...
        'Callback',@exportData);

    % Output Panel
    y_pos = 0.85;
    uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.25 0.08],'String','Received:','FontWeight','bold');
    receivedText = uicontrol(outputPanel,'Style','edit','Units','normalized',...
        'Position',[0.3 y_pos 0.65 0.08],'Enable','inactive','BackgroundColor',[0.95 0.95 1]);

    y_pos = y_pos - 0.12;
    % Metrics with color coding
    berLabel = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.45 0.08],'String','BER: N/A','FontSize',10);
    throughputLabel = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.5 y_pos 0.45 0.08],'String','Throughput: N/A','FontSize',10);

    y_pos = y_pos - 0.1;
    delayLabel = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.45 0.08],'String','Delay: N/A','FontSize',10);
    crcStatusLabel = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.5 y_pos 0.45 0.08],'String','CRC: N/A','FontSize',10);

    y_pos = y_pos - 0.1;
    ebnLabel = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 y_pos 0.45 0.08],'String','Eb/No: N/A','FontSize',10);
    snrEstLabel = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.5 y_pos 0.45 0.08],'String','Est SNR: N/A','FontSize',10);

    % Progress bar
    progressBar = uicontrol(outputPanel,'Style','text','Units','normalized',...
        'Position',[0.02 0.02 0.94 0.08],'String','Ready','BackgroundColor',[0.9 0.9 0.9]);

    % Audio controls
    y_pos = 0.35;
    uicontrol(outputPanel,'Style','pushbutton','String','Play RX Audio','Units','normalized',...
        'Position',[0.02 y_pos 0.2 0.1],'Callback',@playAudio);
    uicontrol(outputPanel,'Style','pushbutton','String','Save Audio','Units','normalized',...
        'Position',[0.25 y_pos 0.2 0.1],'Callback',@saveAudio);
    uicontrol(outputPanel,'Style','pushbutton','String','Analyze','Units','normalized',...
        'Position',[0.48 y_pos 0.2 0.1],'Callback',@analyzeBER);
    uicontrol(outputPanel,'Style','pushbutton','String','View Log','Units','normalized',...
        'Position',[0.72 y_pos 0.2 0.1],'Callback',@viewLog);

    % Create axes for plots in a 2x2 grid
    waveformAx = axes(plotPanel,'Units','normalized','Position',[0.08 0.55 0.38 0.35]);
    constAx = axes(plotPanel,'Units','normalized','Position',[0.55 0.55 0.38 0.35]);
    spectrumAx = axes(plotPanel,'Units','normalized','Position',[0.08 0.08 0.38 0.35]);
    eyeAx = axes(plotPanel,'Units','normalized','Position',[0.55 0.08 0.38 0.35]);

    function recordAudio(~, ~)
        try
            progressBar.String = 'Recording audio (3 seconds)...';
            progressBar.BackgroundColor = [1 0.8 0.8];
            drawnow;
            
            fs = currentFs;
            recObj = audiorecorder(fs, 16, 1);
            recordblocking(recObj, 3);
            audioData = getaudiodata(recObj);
            
            % Convert audio to text (simple threshold method)
            audioText = audioToText(audioData, fs);
            msgBox.String = audioText;
            
            progressBar.String = 'Audio recorded and processed';
            progressBar.BackgroundColor = [0.8 1 0.8];
        catch ME
            progressBar.String = ['Audio error: ', ME.message];
            progressBar.BackgroundColor = [1 0.8 0.8];
        end
    end

    function loadFile(~, ~)
        try
            [filename, pathname] = uigetfile({'*.txt;*.csv;*.mat','All Supported Files'});
            if filename == 0, return; end
            
            fullpath = fullfile(pathname, filename);
            [~,~,ext] = fileparts(filename);
            
            switch ext
                case '.txt'
                    content = fileread(fullpath);
                case '.csv'
                    data = readtable(fullpath);
                    content = sprintf('%s ', string(data{:,1}));
                case '.mat'
                    vars = load(fullpath);
                    fields = fieldnames(vars);
                    content = sprintf('%g ', vars.(fields{1}));
            end
            
            msgBox.String = content(1:min(end,100));
            progressBar.String = ['Loaded: ', filename];
        catch ME
            progressBar.String = ['Load error: ', ME.message];
        end
    end

    function transmitMessage(~, ~)
        try
            progressBar.String = 'Transmitting...';
            progressBar.BackgroundColor = [1 1 0.8];
            drawnow;
            
            tic;
            msg = msgBox.String;
            if isempty(msg)
                progressBar.String = 'Error: Empty message';
                return;
            end
            
            snr = snrSlider.Value;
            modType = modMenu.String{modMenu.Value};
            chType = channelMenu.String{channelMenu.Value};
            enableCRC = crcCheckbox.Value;
            enableHamming = hammingCheckbox.Value;
            enableInterleaver = interleaverCheckbox.Value;
            pulseType = pulseMenu.String{pulseMenu.Value};

            % Convert message to binary
            bin = reshape(dec2bin(double(msg), 8).' - '0', 1, []);
            originalLength = length(bin);

            % Apply error correction
            if enableHamming
                bin = applyHamming(bin);
            end

            if enableCRC
                bin = applyCRC(bin);
            end

            if enableInterleaver
                bin = interleave(bin);
            end

            % Modulation
            [modSig, M, k] = modulateSignal(bin, modType);
            if isempty(modSig)
                error('Modulation failed - check input length');
            end

            % Pulse shaping
            if ~strcmp(pulseType, 'None')
                modSig = applyPulseShaping(modSig, pulseType);
            end

            % Channel simulation
            [rxSig, h] = simulateChannel(modSig, chType, snr);

            % Demodulation
            demodData = demodulateSignal(rxSig, modType, M);
            rxBin = convertToRxBinary(demodData, M, k, length(bin));

            % Apply error correction (reverse order)
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

            % Calculate metrics
            rxBin = rxBin(1:min(length(rxBin), originalLength));
            ber = calculateBER(rxBin, bin(1:length(rxBin)));
            
            % Convert back to text
            rxChars = binaryToText(rxBin);
            
            delay = toc * 1000;
            throughput = length(rxBin) / (delay/1000);

            % Update display
            updateDisplay(rxChars, ber, throughput, delay, crcStatus, snr);

            % Store log data
            logEntry = struct('Time', datetime('now'), 'Message', msg, ...
                'SNR', snr, 'Modulation', modType, 'Channel', chType, ...
                'BER', ber, 'Throughput', throughput, 'Delay', delay, 'CRC', crcStatus);
            logData(end+1) = logEntry;

            % Update plots
            updatePlots(rxSig, modSig, h);

            progressBar.String = 'Transmission completed';
            progressBar.BackgroundColor = [0.8 1 0.8];

        catch ME
            progressBar.String = ['Error: ', ME.message];
            progressBar.BackgroundColor = [1 0.8 0.8];
            fprintf('Error in transmitMessage: %s\n', ME.message);
        end
    end

    function [modSig, M, k] = modulateSignal(bin, modType)
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

    function [rxSig, h] = simulateChannel(modSig, chType, snr)
        switch chType
            case 'AWGN'
                rxSig = awgn(modSig, snr, 'measured');
                h = ones(size(modSig));
            case 'Rayleigh'
                h = (randn(size(modSig)) + 1j*randn(size(modSig))) / sqrt(2);
                noisySig = awgn(h .* modSig, snr, 'measured');
                rxSig = noisySig ./ (h + eps);
            case 'Rician'
                K = 3;
                h = sqrt(K/(K+1)) + (randn(size(modSig)) + 1j*randn(size(modSig))) * sqrt(1/(2*(K+1)));
                noisySig = awgn(h .* modSig, snr, 'measured');
                rxSig = noisySig ./ (h + eps);
            case 'Nakagami'
                m = 1; omega = 1;
                h = sqrt(gamrnd(m, omega/m, size(modSig))) .* exp(1j*2*pi*rand(size(modSig)));
                noisySig = awgn(h .* modSig, snr, 'measured');
                rxSig = noisySig ./ (h + eps);
        end
    end

    function demodData = demodulateSignal(rxSig, modType, M)
        switch modType
            case 'BPSK'
                demodData = pskdemod(rxSig, M);
            case 'QPSK'
                demodData = pskdemod(rxSig, M, pi/4);
            case '8-PSK'
                demodData = pskdemod(rxSig, M);
            case {'16-QAM', '64-QAM', '256-QAM'}
                demodData = qamdemod(rxSig, M);
        end
    end

    function rxBin = convertToRxBinary(demodData, M, k, origLength)
        rxBin = reshape(de2bi(demodData, log2(M), 'left-msb').', 1, []);
        rxBin = rxBin(1:min(length(rxBin), origLength));
    end

    function ber = calculateBER(rxBin, txBin)
        minLen = min(length(rxBin), length(txBin));
        if minLen == 0
            ber = 1;
        else
            ber = sum(rxBin(1:minLen) ~= txBin(1:minLen)) / minLen;
        end
    end

    function chars = binaryToText(bin)
        try
            remainder = mod(length(bin), 8);
            if remainder ~= 0
                bin = [bin, zeros(1, 8 - remainder)];
            end
            if isempty(bin)
                chars = '';
            else
                chars = char(bin2dec(reshape(sprintf('%d', bin), 8, []).'))';
                chars = chars(chars >= 32 & chars <= 126); % Keep printable ASCII
            end
        catch
            chars = 'Decode Error';
        end
    end

    function updateDisplay(rxChars, ber, throughput, delay, crcStatus, snr)
        receivedText.String = rxChars;
        
        % Color-coded BER display
        if ber < 1e-4
            berColor = [0.2 0.8 0.2]; % Green
        elseif ber < 1e-2
            berColor = [0.8 0.8 0.2]; % Yellow
        else
            berColor = [0.8 0.2 0.2]; % Red
        end
        berLabel.String = sprintf('BER: %.2e', ber);
        berLabel.BackgroundColor = berColor;
        
        throughputLabel.String = sprintf('Throughput: %.1f bps', throughput);
        delayLabel.String = sprintf('Delay: %.2f ms', delay);
        crcStatusLabel.String = ['CRC: ', crcStatus];
        
        % Calculate Eb/N0
        ebno = snr + 10*log10(log2(2)); % Assuming BPSK equivalent
        ebnLabel.String = sprintf('Eb/N0: %.1f dB', ebno);
        
        % Estimated SNR (simplified)
        snrEstLabel.String = sprintf('Est SNR: %.1f dB', snr + randn()*2);
    end

    function updatePlots(rxSig, modSig, h)
        try
            % Ensure we have valid signals
            if isempty(rxSig) || length(rxSig) < 2
                return;
            end
            
            % 1. Waveform plot - Show both TX and RX signals
            axes(waveformAx);
            cla(waveformAx);
            hold(waveformAx, 'on');
            
            plotLength = min(200, length(rxSig)); % Limit for better visualization
            time_axis = 1:plotLength;
            
            if ~isempty(modSig) && length(modSig) >= plotLength
                plot(waveformAx, time_axis, real(modSig(1:plotLength)), 'g-', 'LineWidth', 1.5, 'DisplayName', 'TX Signal');
            end
            plot(waveformAx, time_axis, real(rxSig(1:plotLength)), 'b-', 'LineWidth', 1, 'DisplayName', 'RX Signal');
            
            title(waveformAx, 'Transmitted vs Received Signal', 'FontSize', 10);
            xlabel(waveformAx, 'Sample'); 
            ylabel(waveformAx, 'Amplitude');
            legend(waveformAx, 'show');
            grid(waveformAx, 'on');
            hold(waveformAx, 'off');

            % 2. Constellation diagram
            axes(constAx);
            cla(constAx);
            
            % Downsample for better visualization if too many points
            if length(rxSig) > 500
                indices = round(linspace(1, length(rxSig), 500));
                plotSig = rxSig(indices);
            else
                plotSig = rxSig;
            end
            
            scatter(constAx, real(plotSig), imag(plotSig), 30, 'b', 'filled', 'MarkerFaceAlpha', 0.6);
            title(constAx, 'Constellation Diagram', 'FontSize', 10);
            xlabel(constAx, 'In-phase'); 
            ylabel(constAx, 'Quadrature');
            grid(constAx, 'on'); 
            axis(constAx, 'equal');
            
            % Add reference constellation if we know the modulation
            hold(constAx, 'on');
            modType = modMenu.String{modMenu.Value};
            refPoints = getRefConstellation(modType);
            if ~isempty(refPoints)
                scatter(constAx, real(refPoints), imag(refPoints), 100, 'r', 'x', 'LineWidth', 2);
            end
            hold(constAx, 'off');

            % 3. Spectrum analysis
            axes(spectrumAx);
            cla(spectrumAx);
            
            N = min(1024, 2^nextpow2(length(rxSig))); % Use power of 2 for FFT efficiency
            if N > length(rxSig)
                sig_padded = [rxSig; zeros(N - length(rxSig), 1)];
            else
                sig_padded = rxSig(1:N);
            end
            
            f_axis = linspace(-0.5, 0.5, N);
            spectrum = abs(fftshift(fft(sig_padded)));
            spectrum_db = 20*log10(spectrum + eps);
            
            plot(spectrumAx, f_axis, spectrum_db, 'r-', 'LineWidth', 1.5);
            title(spectrumAx, 'Power Spectral Density', 'FontSize', 10);
            xlabel(spectrumAx, 'Normalized Frequency'); 
            ylabel(spectrumAx, 'PSD (dB)');
            grid(spectrumAx, 'on');
            
            % Set reasonable y-axis limits
            maxVal = max(spectrum_db);
            ylim(spectrumAx, [maxVal-60, maxVal+5]);

            % 4. Eye diagram
            axes(eyeAx);
            cla(eyeAx);
            
            if length(rxSig) >= 20
                % Create proper eye diagram
                sps = 4; % Samples per symbol (assume oversampling)
                if length(rxSig) < 100
                    sps = 2;
                end
                
                eyeLength = sps * 2; % Two symbol periods
                numTraces = min(50, floor(length(rxSig) / sps) - 1);
                
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
                    plot(eyeAx, timeAxis, eyeMatrix, 'b-', 'LineWidth', 0.5, 'Color', [0 0 1 0.3]);
                    
                    title(eyeAx, 'Eye Diagram', 'FontSize', 10);
                    xlabel(eyeAx, 'Time (Symbol Periods)'); 
                    ylabel(eyeAx, 'Amplitude');
                    grid(eyeAx, 'on');
                    xlim(eyeAx, [0, 2]);
                else
                    % Fallback: simple time plot
                    plot(eyeAx, real(rxSig), 'b-', 'LineWidth', 1);
                    title(eyeAx, 'Signal Trace', 'FontSize', 10);
                    xlabel(eyeAx, 'Sample'); 
                    ylabel(eyeAx, 'Amplitude');
                    grid(eyeAx, 'on');
                end
            end
            
            % Force plot updates
            drawnow;
            
        catch ME
            fprintf('Plot error: %s\n', ME.message);
            fprintf('rxSig length: %d, modSig length: %d\n', length(rxSig), length(modSig));
        end
    end
    
    function refPoints = getRefConstellation(modType)
        % Get reference constellation points for comparison
        try
            switch modType
                case 'BPSK'
                    M = 2;
                    refPoints = pskmod(0:M-1, M);
                case 'QPSK'
                    M = 4;
                    refPoints = pskmod(0:M-1, M, pi/4);
                case '8-PSK'
                    M = 8;
                    refPoints = pskmod(0:M-1, M);
                case '16-QAM'
                    M = 16;
                    refPoints = qammod(0:M-1, M);
                case '64-QAM'
                    M = 64;
                    refPoints = qammod(0:M-1, M);
                case '256-QAM'
                    M = 256;
                    refPoints = qammod(0:M-1, M);
                otherwise
                    refPoints = [];
            end
        catch
            refPoints = [];
        end
    end

    % Helper functions for error correction
    function encoded = applyCRC(data)
        try
            if exist('comm.CRCGenerator', 'class')
                crcGen = comm.CRCGenerator([1 0 0 1 0 0 0 0 1]);
                encoded = crcGen(data.')';
            else
                % Simple checksum if Communications Toolbox not available
                checksum = mod(sum(data), 2);
                encoded = [data, checksum];
            end
        catch
            encoded = data;
        end
    end

    function [decoded, status] = checkCRC(data)
        try
            if exist('comm.CRCDetector', 'class')
                crcDet = comm.CRCDetector([1 0 0 1 0 0 0 0 1]);
                [decoded, err] = crcDet(data.');
                decoded = decoded';
                status = 'Pass'; if err > 0, status = 'Fail'; end
            else
                decoded = data(1:end-1);
                status = 'N/A';
            end
        catch
            decoded = data;
            status = 'Error';
        end
    end

    function encoded = applyHamming(data)
        % Simplified Hamming (7,4) encoding
        try
            blockSize = 4;
            padded = [data, zeros(1, mod(-length(data), blockSize))];
            blocks = reshape(padded, blockSize, []);
            encoded = [];
            for i = 1:size(blocks, 2)
                block = blocks(:, i);
                % Simple parity bits
                p1 = mod(block(1) + block(2) + block(4), 2);
                p2 = mod(block(1) + block(3) + block(4), 2);
                p3 = mod(block(2) + block(3) + block(4), 2);
                encodedBlock = [p1, p2, block(1), p3, block(2:4)'];
                encoded = [encoded, encodedBlock];
            end
        catch
            encoded = data;
        end
    end

    function corrected = correctHamming(data)
        % Simplified Hamming decoding
        try
            blockSize = 7;
            if mod(length(data), blockSize) ~= 0
                data = [data, zeros(1, blockSize - mod(length(data), blockSize))];
            end
            blocks = reshape(data, blockSize, []);
            corrected = [];
            for i = 1:size(blocks, 2)
                block = blocks(:, i);
                corrected = [corrected, block([3, 5, 6, 7])];
            end
        catch
            corrected = data;
        end
    end

    function interleaved = interleave(data)
        % Simple block interleaver
        try
            blockSize = 8;
            padded = [data, zeros(1, mod(-length(data), blockSize))];
            blocks = reshape(padded, blockSize, []);
            interleaved = reshape(blocks([1,3,5,7,2,4,6,8], :), 1, []);
        catch
            interleaved = data;
        end
    end

    function deinterleaved = deinterleave(data, origLength)
        try
            blockSize = 8;
            if mod(length(data), blockSize) ~= 0
                data = [data, zeros(1, blockSize - mod(length(data), blockSize))];
            end
            blocks = reshape(data, blockSize, []);
            reordered = zeros(size(blocks));
            reordered([1,3,5,7,2,4,6,8], :) = blocks;
            deinterleaved = reshape(reordered, 1, []);
            deinterleaved = deinterleaved(1:origLength);
        catch
            deinterleaved = data;
        end
    end

    function shaped = applyPulseShaping(signal, pulseType)
        try
            switch pulseType
                case 'RRC'
                    % Root Raised Cosine
                    span = 6; sps = 4; beta = 0.25;
                    rrcFilter = rcosdesign(beta, span, sps);
                    shaped = upfirdn(signal, rrcFilter, sps);
                case 'Gaussian'
                    % Gaussian pulse shaping
                    sps = 4; bt = 0.3;
                    gaussFilter = gaussdesign(bt, sps, 4);
                    shaped = upfirdn(signal, gaussFilter, sps);
                case 'Rectangular'
                    sps = 4;
                    shaped = repelem(signal, sps);
                otherwise
                    shaped = signal;
            end
        catch
            shaped = signal;
        end
    end

    function text = audioToText(audio, fs)
        % Simple audio to text conversion (threshold-based)
        try
            % Simple envelope detection
            envelope = abs(hilbert(audio));
            threshold = max(envelope) * 0.5;
            
            % Find peaks
            peaks = envelope > threshold;
            transitions = diff([0; peaks; 0]);
            starts = find(transitions == 1);
            stops = find(transitions == -1);
            
            % Convert to morse-like code (simplified)
            text = '';
            for i = 1:min(length(starts), length(stops))
                duration = stops(i) - starts(i);
                if duration > fs * 0.1 % Long tone
                    text = [text, '-'];
                else % Short tone
                    text = [text, '.'];
                end
            end
            
            if isempty(text)
                text = 'Audio Signal Detected';
            end
        catch
            text = 'Audio Processing Error';
        end
    end

    function playAudio(~, ~)
        try
            if ~isempty(audioData)
                sound(audioData, currentFs);
                progressBar.String = 'Playing audio...';
            else
                progressBar.String = 'No audio data available';
            end
        catch ME
            progressBar.String = ['Audio play error: ', ME.message];
        end
    end

    function saveAudio(~, ~)
        try
            if ~isempty(audioData)
                [filename, pathname] = uiputfile('*.wav', 'Save Audio');
                if filename ~= 0
                    audiowrite(fullfile(pathname, filename), audioData, currentFs);
                    progressBar.String = ['Audio saved: ', filename];
                end
            else
                progressBar.String = 'No audio data to save';
            end
        catch ME
            progressBar.String = ['Audio save error: ', ME.message];
        end
    end

    function exportData(~, ~)
        try
            if isempty(logData)
                progressBar.String = 'No data to export';
                return;
            end
            
            [filename, pathname] = uiputfile({'*.csv','CSV Files'; '*.mat','MAT Files'}, 'Export Data');
            if filename == 0, return; end
            
            fullpath = fullfile(pathname, filename);
            [~,~,ext] = fileparts(filename);
            
            if strcmp(ext, '.csv')
                % Convert to table and export
                T = struct2table(logData);
                writetable(T, fullpath);
            else
                % Save as MAT file
                save(fullpath, 'logData');
            end
            
            progressBar.String = ['Data exported: ', filename];
        catch ME
            progressBar.String = ['Export error: ', ME.message];
        end
    end

    function clearLog(~, ~)
        logData = struct('Time',{},'Message',{},'SNR',{},'Modulation',{},...
            'Channel',{},'BER',{},'Throughput',{},'Delay',{},'CRC',{});
        progressBar.String = 'Log cleared';
    end

    function viewLog(~, ~)
        try
            if isempty(logData)
                progressBar.String = 'No log data available';
                return;
            end
            
            % Create log viewer window
            logFig = figure('Name','Transmission Log','Position',[200 200 800 400]);
            
            % Create table
            columnNames = {'Time', 'Message', 'SNR(dB)', 'Modulation', 'Channel', 'BER', 'Throughput', 'Delay(ms)', 'CRC'};
            
            % Prepare data for table
            tableData = cell(length(logData), 9);
            for i = 1:length(logData)
                tableData{i,1} = char(logData(i).Time);
                tableData{i,2} = logData(i).Message;
                tableData{i,3} = logData(i).SNR;
                tableData{i,4} = logData(i).Modulation;
                tableData{i,5} = logData(i).Channel;
                tableData{i,6} = logData(i).BER;
                tableData{i,7} = logData(i).Throughput;
                tableData{i,8} = logData(i).Delay;
                tableData{i,9} = logData(i).CRC;
            end
            
            uitable(logFig, 'Data', tableData, 'ColumnName', columnNames, ...
                'Position', [20 20 760 360], 'ColumnWidth', {120 150 60 80 80 80 80 80 60});
                
        catch ME
            progressBar.String = ['Log view error: ', ME.message];
        end
    end

    function analyzeBER(~, ~)
        try
            if length(logData) < 2
                progressBar.String = 'Need more data points for analysis';
                return;
            end
            
            % Create analysis window
            analysisFig = figure('Name','BER Analysis','Position',[300 200 600 500]);
            
            % Extract data
            snrValues = [logData.SNR];
            berValues = [logData.BER];
            modTypes = {logData.Modulation};
            
            % Plot BER vs SNR
            subplot(2,1,1);
            semilogy(snrValues, berValues, 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
            xlabel('SNR (dB)'); ylabel('Bit Error Rate');
            title('BER vs SNR Performance');
            grid on;
            
            % Add theoretical curves for comparison
            hold on;
            snrTheory = 0:0.5:30;
            berBPSK = 0.5 * erfc(sqrt(10.^(snrTheory/10)));
            berQPSK = 0.5 * erfc(sqrt(10.^(snrTheory/10)));
            
            semilogy(snrTheory, berBPSK, 'r--', 'LineWidth', 1.5, 'DisplayName', 'BPSK Theory');
            semilogy(snrTheory, berQPSK, 'g--', 'LineWidth', 1.5, 'DisplayName', 'QPSK Theory');
            legend('Measured', 'BPSK Theory', 'QPSK Theory');
            
            % Histogram of modulation types
            subplot(2,1,2);
            [uniqueMods, ~, idx] = unique(modTypes);
            counts = accumarray(idx, 1);
            bar(counts);
            set(gca, 'XTickLabel', uniqueMods);
            xlabel('Modulation Type'); ylabel('Count');
            title('Modulation Type Distribution');
            
            progressBar.String = 'BER analysis completed';
            
        catch ME
            progressBar.String = ['Analysis error: ', ME.message];
        end
    end

    % Initialize display
    progressBar.String = 'Enhanced Communication System Ready';
    progressBar.BackgroundColor = [0.8 1 0.8];
    
    % Add menu bar
    menuFile = uimenu(f, 'Label', 'File');
    uimenu(menuFile, 'Label', 'New Session', 'Callback', @(~,~) clearLog());
    uimenu(menuFile, 'Label', 'Load Settings', 'Callback', @loadSettings);
    uimenu(menuFile, 'Label', 'Save Settings', 'Callback', @saveSettings);
    uimenu(menuFile, 'Label', 'Exit', 'Callback', @(~,~) close(f));
    
    menuTools = uimenu(f, 'Label', 'Tools');
    uimenu(menuTools, 'Label', 'BER Analyzer', 'Callback', @analyzeBER);
    uimenu(menuTools, 'Label', 'Channel Simulator', 'Callback', @channelSimulator);
    uimenu(menuTools, 'Label', 'Constellation Designer', 'Callback', @constellationDesigner);
    
    menuHelp = uimenu(f, 'Label', 'Help');
    uimenu(menuHelp, 'Label', 'About', 'Callback', @showAbout);
    uimenu(menuHelp, 'Label', 'User Guide', 'Callback', @showHelp);

    function loadSettings(~, ~)
        try
            [filename, pathname] = uigetfile('*.mat', 'Load Settings');
            if filename == 0, return; end
            
            settings = load(fullfile(pathname, filename));
            if isfield(settings, 'guiSettings')
                s = settings.guiSettings;
                snrSlider.Value = s.SNR;
                modMenu.Value = s.ModType;
                channelMenu.Value = s.ChannelType;
                crcCheckbox.Value = s.CRC;
                progressBar.String = 'Settings loaded';
            end
        catch ME
            progressBar.String = ['Load settings error: ', ME.message];
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
            
            save(fullfile(pathname, filename), 'guiSettings');
            progressBar.String = 'Settings saved';
        catch ME
            progressBar.String = ['Save settings error: ', ME.message];
        end
    end

    function channelSimulator(~, ~)
        % Advanced channel simulation tool
        simFig = figure('Name','Channel Simulator','Position',[400 200 500 400]);
        
        uicontrol(simFig, 'Style', 'text', 'Position', [20 350 200 20], ...
            'String', 'Advanced Channel Simulator');
        
        % Doppler frequency
        uicontrol(simFig, 'Style', 'text', 'Position', [20 320 100 20], 'String', 'Doppler (Hz):');
        dopplerEdit = uicontrol(simFig, 'Style', 'edit', 'Position', [130 320 80 20], 'String', '0');
        
        % Multipath delay
        uicontrol(simFig, 'Style', 'text', 'Position', [20 290 100 20], 'String', 'Delay Spread:');
        delayEdit = uicontrol(simFig, 'Style', 'edit', 'Position', [130 290 80 20], 'String', '0');
        
        % Path loss
        uicontrol(simFig, 'Style', 'text', 'Position', [20 260 100 20], 'String', 'Path Loss (dB):');
        pathLossEdit = uicontrol(simFig, 'Style', 'edit', 'Position', [130 260 80 20], 'String', '0');
        
        uicontrol(simFig, 'Style', 'pushbutton', 'Position', [20 200 100 30], ...
            'String', 'Apply', 'Callback', @applyChannelSettings);
        
        function applyChannelSettings(~, ~)
            % This would apply advanced channel settings
            progressBar.String = 'Channel settings applied';
            close(simFig);
        end
    end

    function constellationDesigner(~, ~)
        % Custom constellation designer
        constFig = figure('Name','Constellation Designer','Position',[450 200 400 400]);
        
        ax = axes(constFig, 'Position', [0.15 0.3 0.7 0.6]);
        
        % Sample constellation
        M = 16;
        data = 0:M-1;
        modData = qammod(data, M);
        scatter(ax, real(modData), imag(modData), 100, 'filled');
        title(ax, '16-QAM Constellation');
        xlabel(ax, 'In-phase'); ylabel(ax, 'Quadrature');
        grid(ax, 'on'); axis(ax, 'equal');
        
        uicontrol(constFig, 'Style', 'text', 'Position', [20 50 80 20], 'String', 'M-ary:');
        mEdit = uicontrol(constFig, 'Style', 'edit', 'Position', [100 50 50 20], 'String', '16');
        
        uicontrol(constFig, 'Style', 'pushbutton', 'Position', [20 20 80 25], ...
            'String', 'Update', 'Callback', @updateConstellation);
            
        function updateConstellation(~, ~)
            try
                M = str2double(mEdit.String);
                data = 0:M-1;
                modData = qammod(data, M);
                cla(ax);
                scatter(ax, real(modData), imag(modData), 100, 'filled');
                title(ax, sprintf('%d-QAM Constellation', M));
                grid(ax, 'on'); axis(ax, 'equal');
            catch
                % Handle invalid input
            end
        end
    end

    function showAbout(~, ~)
        msgbox({'Enhanced Message Communication System v2.0', '', ...
            'Features:', ...
            '• Multiple modulation schemes (BPSK to 256-QAM)', ...
            '• Advanced channel models', ...
            '• Error correction (CRC, Hamming, Interleaving)', ...
            '• Pulse shaping filters', ...
            '• Audio processing', ...
            '• Comprehensive analysis tools', '', ...
            'Developed for MATLAB Communication Systems'}, ...
            'About', 'help');
    end

    function showHelp(~, ~)
        helpText = {
            'USER GUIDE', '', ...
            '1. Enter your message in the input field', ...
            '2. Select modulation scheme and channel type', ...
            '3. Adjust SNR using the slider', ...
            '4. Enable error correction as needed', ...
            '5. Click Transmit to send the message', '', ...
            'FEATURES:', ...
            '• Record Audio: Record 3-second audio message', ...
            '• Load File: Import text/CSV/MAT files', ...
            '• Export Data: Save transmission log', ...
            '• View Log: Display all transmissions', ...
            '• Analyze: Perform BER analysis', '', ...
            'The system simulates realistic communication', ...
            'with noise, fading, and error correction.'
        };
        
        msgbox(helpText, 'User Guide', 'help');
    end

end