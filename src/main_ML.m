% main_ML.m
% ���ܣ�ʵ��MIMO�źŵ�ML�㷨������
% ������
% ����:             zhangcheng
% ��������:          2019-10-31
% ����������:       2019-10-31
clc;
clear;
close all;

tic;

% ��������
EbNoTotal = [0:2:30].';                 % Eb/N0
frameLength = 1000;                    % ÿ��֡�ķ��Ÿ���
packetNumber = 10;                     % �������
targetNeb = 500;                        % Ŀ����������
targetBer = 1e-5;                       % Ŀ��BER
modulation = '64QAM';                    % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1022QAM
nT = 4;                                 % ����������Ŀ
nR = 4;                                 % 

% ��ͬ����㷨�µ�������
nEbNo = length(EbNoTotal);
ber_ML = zeros(nEbNo,1);                % ��ͬ�������ML�㷨��BER
marker = ['-*'];                        % ��ͬ�㷨��BER���ߵı��
nMarker = length(marker);               % �㷨��������Ŀ

% ����BER
nTotalBits = zeros(1, nEbNo);           % ��ͬEbNo���з���ķ��ͱ�������
nErrorBits_ML = zeros(1, nEbNo);        % ��ͬEbNo���з���ML�������������

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
        for iframeLength = 1:frameLength
            rxSymbol_ML(:,iframeLength) = ML_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength), M);
        end
        
        % MIMO�������ӳ��
        rxBits_ML = zeros(nT, frameLength*nBps);
        for iNT = 1:nT
            rxBits_ML(iNT, :) = demodulating(rxSymbol_ML(iNT, :), modulation);
        end
        nErrorBitsFrame_ML = sum(sum(rxBits_ML~=txBits));                 % ML���һ֡�Ĵ��������
        
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps*nT;
        nErrorBits_ML(iEbNo) = nErrorBits_ML(iEbNo) + nErrorBitsFrame_ML;
        if(nErrorBits_ML(iEbNo) > targetNeb)
            break;
        end
    end
    ber_ML(iEbNo) =  nErrorBits_ML(iEbNo)/nTotalBits(iEbNo);
%     if(ber_ML(iEbNo) < targetBer)                         % parfor������
%         break;
%     end 
end

% �������е�����
save(['..\outputData\','ML_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat']);
timeML = toc
%% BER����
% modulation = 'BPSK';                    % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
% nT = 8;                                 % ����������Ŀ
% nR = 8;                                 % ����������Ŀ

load(['..\outputData\','ML_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat'])
figure
semilogy(EbNoTotal, ber_ML, marker(1,:));
grid on;
xlabel('E_b/N_o(dB)');
ylabel('BER');
title(['MIMO detection: ', modulation]);
legend(['ML','(',num2str(nT),'x',num2str(nR),')']);