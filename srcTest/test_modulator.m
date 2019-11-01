% test_modulator.m
% ���ܣ�����modulator��demodulator����ȷ��
% ������
% ����:             zhangcheng
% ��������:          2019-10-29
% ����������:       2019-10-29
clc;
clear;
close all;

% ��������
EbNoTotal = [0:2:20].';                 % Eb/N0
frameLength = 1000;                     % ÿ��֡�ķ��Ÿ���
packetNumber = 10;                      % �������
targetNeb = 500;                        % Ŀ����������
modulation = 'BPSK';                   % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
nT = 4;                                 % ����������Ŀ
nR = 4;                                 % ����������Ŀ

% ��ͬ����㷨�µ�������
nEbNo = length(EbNoTotal);
ber_ML = zeros(nEbNo,1);                % ��ͬ�������ML�㷨��BER
ber_ZF = zeros(nEbNo,1);                % ��ͬ�������ZF�㷨��BER
ber_MMSE = zeros(nEbNo,1);              % ��ͬ�������MMSEL�㷨��BER
ber_ZF_SNR_OSIC = zeros(nEbNo,1);       % ��ͬ�������ZF-SNR-OSIC�㷨��BER
ber_MMSE_SINR_OSIC = zeros(nEbNo,1);    % ��ͬ�������MMSE-SINR-OSIC�㷨��BER
marker = ['-*';'-d';'-s';'->';'-o'];    % ��ͬ�㷨��BER���ߵı��
nMarker = length(marker);               % �㷨��������Ŀ

% ������Ʊ������͵��ƽ���
[nBps, M] = set_modulator(modulation);  % nBps: 1--BPSK��2--QPSK��4--16QAM��6--64QAM��8--256QAM��10--1024QAM
% M   : ���ƽ���
% ����BER
nErrorBitsSystem = zeros(1, nEbNo);
nErrorBits = zeros(1, nEbNo);
nTotalBits = zeros(1, nEbNo);
for iEbNo = 1 : nEbNo
    EbNo = EbNoTotal(iEbNo);
    
    snr_dB = EbNo + 10*log10(nBps);
    
    for iPacket = 1:packetNumber
        txBits = randi([0,1], nT, frameLength*nBps);                       % ����nBps��֡����������������
        rxBitSystem = zeros(size(txBits));
        txSymbol = zeros(nT, frameLength);                                 % ���ƺ��ÿ֡����
        txSymbolSystem = zeros(nT, frameLength);                          % qammod���������ķ���
        for iNT = 1:nT
            txSymbolSystem(iNT,:) = qammod(txBits(iNT, :).', M, 'InputType', 'bit', 'UnitAveragePower',true);
            txSymbol(iNT,:) = modulator(txBits(iNT, :), modulation);
        end
        sumError = sum(sum(abs(txSymbol-txSymbolSystem).^2));
        if sumError<0.001
            fprintf('%f: modulator is good.\n', sumError);
        else
            fprintf('%f: modulator is bad.\', sumError);
        end
        
        rxSymbol = txSymbol;                                    % ��������
        rxSymbolSystem = txSymbolSystem;                        % ��������
        rxBits = zeros(nT, size(rxSymbol,2)*nBps);              % ��ӳ����bit
        rxBitsSystem = zeros(nT, size(rxSymbol,2)*nBps);        % ϵͳ������ӳ����bit
        for iNT = 1:nT
            rxBitsSystemArray = qamdemod(rxSymbolSystem(iNT,:), M, 'OutputType', 'bit', 'UnitAveragePower',true);
            rxBitsSystem(iNT,:) = rxBitsSystemArray(:);
            
            rxBits(iNT,:) = demodulator(rxSymbol(iNT,:), modulation);
        end
        nTotalBits(iEbNo) = nTotalBits(iEbNo) + frameLength*nBps;
        nErrorBitsFrameSystem = sum(sum(txBits~=rxBitsSystem));
        nErrorBitsSystem(iEbNo) = nErrorBitsSystem(iEbNo) + nErrorBitsFrameSystem;
        
        nErrorBitsFrame = sum(sum(txBits~=rxBits));
        nErrorBits(iEbNo) = nErrorBits(iEbNo) + nErrorBitsFrame;
    end
end
