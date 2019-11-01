% main_MMSE.m
% ���ܣ�ʵ��MIMO�źŵ�MMSE�㷨������
% ������
% ����:             zhangcheng
% ��������:          2019-10-21
% ����������:       2019-10-31
clc;
clear;
close all;

tic;

% ��������
EbNoTotal = [0:2:30].';                 % Eb/N0
frameLength = 10000;                       % ÿ��֡�ķ��Ÿ���
packetNumber = 100;                    % �������X
targetNeb = 1000;                        % Ŀ����������
targetBer = 1e-5;                       % Ŀ��BER
modulation = '1024QAM';                   % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
nT = 8;                                 % ����������Ŀ
nR = 8;                                 % ����������Ŀ

% ��ͬ����㷨�µ�������
nEbNo = length(EbNoTotal);
ber_MMSE = zeros(nEbNo,1);                % ��ͬ�������MMSE�㷨��BER
marker = ['-*'];                        % ��ͬ�㷨��BER���ߵı��
nMarker = length(marker);               % �㷨��������Ŀ

% ����BER
nTotalBits = zeros(1, nEbNo);           % ��ͬEbNo���з���ķ��ͱ�������
nErrorBits_MMSE = zeros(1, nEbNo);        % ��ͬEbNo���з���MMSE�������������

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
        rxSymbol_MMSE = zeros(nT, frameLength);                             % MMSE������ź�
        for iframeLength = 1:frameLength
            rxSymbol_MMSE(:,iframeLength) = MMSE_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength), noisePower);
        end
        
        % MIMO�������ӳ��
        rxBits_MMSE = zeros(nT, frameLength*nBps);
        for iNT = 1:nT
            rxBits_MMSE(iNT, :) = demodulating(rxSymbol_MMSE(iNT, :), modulation);
        end
        nErrorBitsFrame_MMSE = sum(sum(rxBits_MMSE~=txBits));                 % MMSE���һ֡�Ĵ��������
        
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps*nT;
        nErrorBits_MMSE(iEbNo) = nErrorBits_MMSE(iEbNo) + nErrorBitsFrame_MMSE;
        if(nErrorBits_MMSE(iEbNo) > targetNeb)
            break;
        end
    end
    ber_MMSE(iEbNo) =  nErrorBits_MMSE(iEbNo)/nTotalBits(iEbNo);
%     if(ber_MMSE(iEbNo) < targetBer)                         % parfor������
%         break;
%     end
end

% �������е�����
save(['..\outputData\','MMSE_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat']);
toc;
%% BER����
% modulation = 'QPSK';                    % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
% nT = 4;                                 % ����������Ŀ
% nR = 4;                                 % ����������Ŀ

% load(['..\outputData\','MMSE_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat'])
figure
semilogy(EbNoTotal, ber_MMSE, marker(1,:));
grid on;
xlabel('E_b/N_o(dB)');
ylabel('BER');
title(['MIMO detection: ', modulation]);
legend(['MMSE','(',num2str(nT),'x',num2str(nR),')']);