% main_ZF.m
% ���ܣ�ʵ��MIMO�źŵ�ZF�㷨������
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
packetNumber = 100;                    % �������
targetNeb = 1000;                        % Ŀ����������
targetBer = 1e-5;                       % Ŀ��BER
modulation = 'QPSK';                    % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
nT = 4;                                 % ����������Ŀ
nR = 4;                                 % ����������Ŀ

% ��ͬ����㷨�µ�������
nEbNo = length(EbNoTotal);
ber_ZF = zeros(nEbNo,1);                % ��ͬ�������ZF�㷨��BER
marker = ['-*'];                        % ��ͬ�㷨��BER���ߵı��
nMarker = length(marker);               % �㷨��������Ŀ

% ����BER
nTotalBits = zeros(1, nEbNo);           % ��ͬEbNo���з���ķ��ͱ�������
nErrorBits_ZF = zeros(1, nEbNo);        % ��ͬEbNo���з���ZF�������������

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
        [rxSymbol, H, noisePower] = channel_accurate_static(txSymbol, nT, nR, snrLiner);
        
        % MIMO�źż��
        rxSymbol_ZF = zeros(nT, frameLength);                             % ZF������ź�
        for iframeLength = 1:frameLength
            rxSymbol_ZF(:,iframeLength) = ZF_detection(rxSymbol(:, iframeLength), H(:,:,iframeLength));
        end
        
        % MIMO�������ӳ��
        rxBits_ZF = zeros(nT, frameLength*nBps);
        for iNT = 1:nT
            rxBits_ZF(iNT, :) = demodulating(rxSymbol_ZF(iNT, :), modulation);
        end
        nErrorBitsFrame_ZF = sum(sum(rxBits_ZF~=txBits));                 % ZF���һ֡�Ĵ��������
        
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps*nT;
        nErrorBits_ZF(iEbNo) = nErrorBits_ZF(iEbNo) + nErrorBitsFrame_ZF;
        if(nErrorBits_ZF(iEbNo) > targetNeb)
            break;
        end
    end
    ber_ZF(iEbNo) =  nErrorBits_ZF(iEbNo)/nTotalBits(iEbNo);
%     if(ber_ZF(iEbNo) < targetBer)                         % parfor������
%         break;
%     end
end

% �������е�����
save(['..\outputDataTest\accurateStaticChannel\','ZF_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat']);
toc;
%% BER����
% modulation = 'BPSK';                    % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
% nT = 2;                                 % ����������Ŀ
% nR = 2;                                 % ����������Ŀ

load(['..\outputDataTest\accurateStaticChannel\','ZF_',modulation, '_nT_', num2str(nT), '_nR_', num2str(nR), '.mat'])
figure
semilogy(EbNoTotal, ber_ZF, marker(1,:));
grid on;
xlabel('E_b/N_o(dB)');
ylabel('BER');
title(['MIMO detection: ', modulation]);
legend(['ZF','(',num2str(nT),'x',num2str(nR),')']);