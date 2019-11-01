% main.m
% ���ܣ�ʵ�־����MIMO�źż�����
% ��������Ҫ����ML�㷨��ZF�㷨��MMSE�㷨��ZF-SNR-OSIC�㷨��MMSE-SINR-OSIC�㷨
% ����:             zhangcheng
% ��������:          2019-10-27
% ����������:       2019-10-31
clc;
clear;
close all;

tic;

% ��������
EbNoTotal = [0:2:30].';                 % Eb/N0
frameLength = 1000;                       % ÿ��֡�ķ��Ÿ���
packetNumber = 10;                    % �������
targetNeb = 500;                        % Ŀ����������
modulation = 'BPSK';                    % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
nT = 8;                                 % ����������Ŀ
nR = 8;                                 % ����������Ŀ

% ��ͬ����㷨�µ�������
nEbNo = length(EbNoTotal);
ber_ML = zeros(nEbNo,1);                % ��ͬ�������ML�㷨��BER
ber_ZF = zeros(nEbNo,1);                % ��ͬ�������ZF�㷨��BER
ber_MMSE = zeros(nEbNo,1);              % ��ͬ�������MMSEL�㷨��BER
ber_ZF_SNR_OSIC = zeros(nEbNo,1);       % ��ͬ�������ZF-SNR-OSIC�㷨��BER
ber_MMSE_SINR_OSIC = zeros(nEbNo,1);    % ��ͬ�������MMSE-SINR-OSIC�㷨��BER
marker = ['-*';'-d';'-s';'->';'-o'];    % ��ͬ�㷨��BER���ߵı��
nMarker = length(marker);               % �㷨��������Ŀ

% ����BER
nTotalBits = zeros(1, nEbNo);           % ��ͬEbNo���з���ķ��ͱ�������
nErrorBits_ML = zeros(1, nEbNo);        % ��ͬEbNo���з���ML�������������
nErrorBits_ZF = zeros(1, nEbNo);        % ��ͬEbNo���з���ZF�������������
nErrorBits_MMSE = zeros(1, nEbNo);      % ��ͬEbNo���з���MMSE�������������

parfor iEbNo = 1 : nEbNo
    % ������Ʊ������͵��ƽ���
    [nBps, M] = set_modulator(modulation);  % nBps: 1--BPSK��2--QPSK��4--16QAM��6--64QAM��8--256QAM��10--1024QAM
    % M   : ���ƽ���
    EbNo = EbNoTotal(iEbNo);
    snrdB = EbNo + 10*log10(nBps);
    snrLiner = 10^(snrdB/10);
    
    % ��֡���з��ͺͽ���
    for iPacket = 1:packetNumber
        % MIMO������ӳ��
        txBits = randi([0,1], nT, frameLength*nBps);                       % ����nBps��֡����������������
        txSymbol = zeros(nT, frameLength);                                 % ���ƺ��ÿ֡����
        for iNT = 1:nT
            txSymbol(iNT,:) = modulating(txBits(iNT, :), modulation);
        end
        [rxSymbol, H, noisePower] = channel(txSymbol, nT, nR, snrLiner);
        
        % MIMO�źż��
        rxSymbol_ML = zeros(nT, frameLength);                             % ML������ź�
        rxSymbol_ZF = zeros(nT, frameLength);                             % ZF������ź�
        rxSymbol_MMSE = zeros(nT, frameLength);                           % MMSE������ź�
        for iframeLength = 1:frameLength
            rxSymbol_ML(:,iframeLength) = ML_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength), M);
            rxSymbol_ZF(:,iframeLength) = ZF_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength));
            rxSymbol_MMSE(:,iframeLength) = MMSE_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength),noisePower);
        end
        
        % MIMO�������ӳ��
        rxBits_ML = zeros(nT, frameLength*nBps);
        rxBits_ZF = zeros(nT, frameLength*nBps);
        rxBits_MMSE = zeros(nT, frameLength*nBps);
        for iNT = 1:nT
            rxBits_ML(iNT, :) = demodulating(rxSymbol_ML(iNT, :), modulation);
            rxBits_ZF(iNT, :) = demodulating(rxSymbol_ZF(iNT, :), modulation);
            rxBits_MMSE(iNT, :) = demodulating(rxSymbol_MMSE(iNT, :), modulation);
        end
        nErrorBitsFrame_ML = sum(sum(rxBits_ML~=txBits));               % ML���һ֡�Ĵ��������
        nErrorBitsFrame_ZF = sum(sum(rxBits_ZF~=txBits));               % ZF���һ֡�Ĵ��������
        nErrorBitsFrame_MMSE = sum(sum(rxBits_MMSE~=txBits));           % MMSE���һ֡�Ĵ��������
        
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps*nT;
        nErrorBits_ML(iEbNo) = nErrorBits_ML(iEbNo) + nErrorBitsFrame_ML;
        nErrorBits_ZF(iEbNo) = nErrorBits_ZF(iEbNo) + nErrorBitsFrame_ZF;
        nErrorBits_MMSE(iEbNo) = nErrorBits_MMSE(iEbNo) + nErrorBitsFrame_MMSE;
    end
    ber_ML(iEbNo) =  nErrorBits_ML(iEbNo)/nTotalBits(iEbNo);
    ber_ZF(iEbNo) =  nErrorBits_ZF(iEbNo)/nTotalBits(iEbNo);
    ber_MMSE(iEbNo) =  nErrorBits_MMSE(iEbNo)/nTotalBits(iEbNo);
end

% �������е�����
save(['detection_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat']);

toc;
%% BER����
modulation = 'BPSK';                    % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
nT = 8;                                 % ����������Ŀ
nR = 8;                                 % ����������Ŀ

load(['detection_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat'])
figure
semilogy(EbNoTotal, ber_ML, marker(1,:));
grid on;
xlabel('E_b/N_o(dB)');
ylabel('BER');
title(['MIMO detection: ', modulation]);
hold on;
semilogy(EbNoTotal, ber_ZF, marker(2,:));
grid on;
semilogy(EbNoTotal, ber_MMSE, marker(3,:));
grid on;
legend(['ML','(',num2str(nT),'x',num2str(nR),')'], ['ZF','(',num2str(nT),'x',num2str(nR),')'],['MMSE','(',num2str(nT),'x',num2str(nR),')']);