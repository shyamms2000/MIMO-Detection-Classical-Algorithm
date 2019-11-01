% main.m
% ���ܣ��Ƚ�siso��1x2MRC��1x4MRC��2x1Alamouti��2x2Alamouti�µ�BER����

clc;
clear;
close all;

% ��������
EbN0Total = [0:2:20].';             % Eb/N0
frameLength = 1000;                 % ÿ��֡�ķ��Ÿ���
packetNumber = 1000;                 % �������
marker = ['-*';'-d';'-s';'->';'-o'];% ��ͬ�����BER���ߵı��
targetNeb = 500;
modulation = '1024QAM';                 % ���Ʒ�ʽ:BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM

% ������Ʊ������͵��ƽ���
[nBps, M] = set_modulator(modulation);  % nBps: 1--BPSK��2--QPSK��4--16QAM��6--64QAM��8--256QAM��10--1024QAM
% M   : ���ƽ���

% ��ͬ�������µ�BER
nEbN0 = length(EbN0Total);          % Eb/N0����
nMarker = length(marker);           % nMarker�����

% ϵͳ���ƽ������
ber_SISO = zeros(nEbN0,1);          % siso��BER
ber_MRC12 = zeros(nEbN0,1);         % MRC12��BER
ber_MRC14 = zeros(nEbN0,1);         % MRC14��BER
ber_Alamouti21 = zeros(nEbN0,1);    % Alamouti21��BER
ber_Alamouti22 = zeros(nEbN0,1);    % Alamouti22��BER

% �Զ�����ƽ������
ber_SISO_custom = zeros(nEbN0,1);          % siso��BER
ber_MRC12_custom = zeros(nEbN0,1);         % MRC12��BER
ber_MRC14_custom = zeros(nEbN0,1);         % MRC14��BER
ber_Alamouti21_custom = zeros(nEbN0,1);    % Alamouti21��BER
ber_Alamouti22_custom = zeros(nEbN0,1);    % Alamouti22��BER

ber_AWGN_theoretical = zeros(nEbN0,1);  % ���۵�AWGN�ŵ���BER
ber_SISO_theoretical = zeros(nEbN0,1);  % ���۵�����˥��SISO��BER
ber_MRC12_theoretical = zeros(nEbN0,1); % ���۵�����˥��MRC12��BER
ber_MRC14_theoretical = zeros(nEbN0,1); % ���۵�����˥��MRC14��BER

% ����BER
for iEbN0 = 1:nEbN0
    EbN0 = EbN0Total(iEbN0);
    nErrorBits = zeros(1,length(marker));
    nTotalBits = zeros(1,length(marker));
    
    nErrorBits_custom = zeros(1,length(marker));
    nTotalBits_custom = zeros(1,length(marker));
    for iCase = 1:nMarker
        for iPacket = 1:packetNumber
            txNumber = randi([0,1],frameLength*nBps,1);
            txNumber_custom = txNumber;
            if contains(modulation, 'PSK')
                txSymbol = pskmod(txNumber, M, 0, 'gray');
                txSymbol_custom = modulator(txNumber_custom, modulation);
            elseif contains(modulation, 'QAM')
                txSymbol = qammod(txNumber, M, 'InputType', 'bit', 'UnitAveragePower', true);
                txSymbol_custom = modulating(txNumber, modulation);
            end
            snr_dB = 10*log10(nBps)+EbN0;
            snr_linear = 10^(snr_dB/10);
            
            if iCase == 1
                nT = 1;             % ����������
                nR = 1;             % ����������
                rxSymbol = SISO(txSymbol, snr_linear);
                rxSymbol_custom = SISO(txSymbol_custom, snr_linear);
            elseif iCase == 2
                nT = 1;             % ����������
                nR = 2;             % ����������
                rxSymbol = MRC(txSymbol, snr_linear,nR);
                rxSymbol_custom = MRC(txSymbol_custom, snr_linear,nR);
            elseif iCase == 3
                nT = 1;             % ����������
                nR = 4;             % ����������
                rxSymbol = MRC(txSymbol, snr_linear,nR);
                rxSymbol_custom = MRC(txSymbol_custom, snr_linear,nR);
            elseif iCase == 4
                nT = 2;             % ����������
                nR = 1;             % ����������
                rxSymbol = Alamouti(txSymbol, snr_linear,nT,nR);
                rxSymbol_custom = Alamouti(txSymbol_custom, snr_linear,nT,nR);
            else
                nT = 2;             % ����������
                nR = 2;             % ����������
                rxSymbol = Alamouti(txSymbol, snr_linear,nT,nR);
                rxSymbol_custom = Alamouti(txSymbol_custom, snr_linear,nT,nR);
            end
            % ���
            if contains(modulation, 'PSK')
                rxNumber = pskdemod(rxSymbol, M, 0, 'gray');
                rxNumber_custom = demodulator(rxSymbol_custom, modulation);
            elseif contains(modulation, 'QAM')
                rxNumber = qamdemod(rxSymbol, M, 'OutputType', 'bit','UnitAveragePower', true);
                rxNumber_custom = demodulating(rxSymbol_custom, modulation);
            end
            
            % ����һ֡�Ĵ��������
            txBit = de2bi(txNumber, nBps);
            rxBit = de2bi(rxNumber, nBps);
            nErrorBitsFrame = sum(sum(txBit~=rxBit));
            nErrorBits(iCase) = nErrorBits(iCase)+nErrorBitsFrame;
            nTotalBits(iCase) = nTotalBits(iCase) + frameLength*nBps;
            
            txBit_custom = de2bi(txNumber_custom, nBps);
            rxBit_custom = de2bi(rxNumber_custom, nBps);
            nErrorBitsFrame_custom = sum(sum(txBit_custom~=rxBit_custom));
            nErrorBits_custom(iCase) = nErrorBits_custom(iCase)+nErrorBitsFrame_custom;
            nTotalBits_custom(iCase) = nTotalBits_custom(iCase) + frameLength*nBps;
            if(nErrorBits(iCase) > targetNeb)
                break;
            end
        end
    end
    ber_SISO(iEbN0) = nErrorBits(1)/nTotalBits(1);
    ber_MRC12(iEbN0) = nErrorBits(2)/nTotalBits(2);
    ber_MRC14(iEbN0) = nErrorBits(3)/nTotalBits(3);
    ber_Alamouti21(iEbN0) = nErrorBits(4)/nTotalBits(4);
    ber_Alamouti22(iEbN0) = nErrorBits(5)/nTotalBits(5);
    
    ber_SISO_custom(iEbN0) = nErrorBits_custom(1)/nTotalBits_custom(1);
    ber_MRC12_custom(iEbN0) = nErrorBits_custom(2)/nTotalBits_custom(2);
    ber_MRC14_custom(iEbN0) = nErrorBits_custom(3)/nTotalBits_custom(3);
    ber_Alamouti21_custom(iEbN0) = nErrorBits_custom(4)/nTotalBits_custom(4);
    ber_Alamouti22_custom(iEbN0) = nErrorBits_custom(5)/nTotalBits_custom(5);
end
%% BER����
% MRC
figure;
semilogy(EbN0Total, ber_SISO_custom, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12_custom, marker(2,:));
semilogy(EbN0Total, ber_MRC14_custom, marker(3,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)');
% MRC vs Alamouti
figure;
semilogy(EbN0Total, ber_SISO_custom, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12_custom, marker(2,:));
semilogy(EbN0Total, ber_MRC14_custom, marker(3,:));
semilogy(EbN0Total, ber_Alamouti21_custom, marker(4,:));
semilogy(EbN0Total, ber_Alamouti22_custom, marker(5,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)', 'Alamouti(2x1)', 'Alamouti(2x2)');

% MRC
figure;
semilogy(EbN0Total, ber_SISO, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12, marker(2,:));
semilogy(EbN0Total, ber_MRC14, marker(3,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)');
% MRC vs Alamouti
figure;
semilogy(EbN0Total, ber_SISO, marker(1,:));
hold on;
semilogy(EbN0Total, ber_MRC12, marker(2,:));
semilogy(EbN0Total, ber_MRC14, marker(3,:));
semilogy(EbN0Total, ber_Alamouti21, marker(4,:));
semilogy(EbN0Total, ber_Alamouti22, marker(5,:));
grid on;
xlabel('E_b/N_0(dB)');
ylabel('BER');
legend('SISO', 'MRC(1x2)', 'MRC(1x4)', 'Alamouti(2x1)', 'Alamouti(2x2)');

% if modulation == 'PSK'
%     ber_AWGN_theoretical = berawgn(EbN0Total, 'psk', M);
%     ber_SISO_theoretical = berawgn(EbN0Total, 'psk', 1);
%     ber_MRC12_theoretical = berfading(EbN0Total, 'psk', M, 2);
%     ber_MRC14_theoretical = berfading(EbN0Total, 'psk', M, 4);
% elseif modulation == 'QAM'
%     ber_AWGN_theoretical = berawgn(EbN0Total, 'qam', M);
%     ber_SISO_theoretical = berfading(EbN0Total, 'qam', M, 1);
%     ber_MRC12_theoretical = berfading(EbN0Total, 'qam', M, 2);
%     ber_MRC14_theoretical = berfading(EbN0Total, 'qam', M, 4);
% end
% semilogy(EbN0Total, ber_AWGN_theoretical, '-^');
% semilogy(EbN0Total, ber_SISO_theoretical, '-v');
% semilogy(EbN0Total, ber_MRC12_theoretical, '-p');
% semilogy(EbN0Total, ber_MRC14_theoretical, '-h');
% legend('SISO', 'MRC(1x2)', 'MRC(1x4)', 'Alamouti(2x1)', 'Alamouti(2x2)','AWGN theoretical','SISO theoretical', 'MRC12 theoretical', 'MRC14 theoretical','Location','best');