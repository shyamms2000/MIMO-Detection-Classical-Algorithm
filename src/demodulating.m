function outBits = demodulating(inDataNormal, modulation)
%�����Ĺ��ܣ����������ݰ��������ӳ�������Ӧ��������
%������������(1) ʶ����Ʒ�ʽmodulation
%          (2) ������inData���һ��
%          (3) ��inData�����������ҵ���Ӧ�ĸ�����
%          (4) ��������ת��Ϊ�������벢ͬʱ���������������õ�outBits
%������ʹ�ã�outBits = demodulator(inData, modulation, modTable)
%���룺
%     inData:       ���������������
%     modulation :  ���Ʒ�ʽ��BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
%     modTable:     ��modulation��Ӧ���������
%�����
%     outBits: ��ӳ��֮��ı������ݣ���������
%���ӣ�[modSymbol, modTable] = modulator(inData, '4QAM', [-1+i; -1])

%����:             zhangcheng
%��������:          2019-10-28
%����������:       2019-10-29

% BPSK
global mapQpsk;
global mapQam16;
global mapQam64;
global mapQam256;
global mapQam1024;

nInDataNormal = length(inDataNormal);           % �������ݵĳ���

if strcmp(modulation, 'BPSK')
    nBps = 1;                                                               % ÿ�����ŵı�����
    outBits = zeros(nInDataNormal*nBps, 1);                                 % ���bit
    outBits(real(inDataNormal)<0 ) = 0;
    outBits(real(inDataNormal)>0 ) = 1;
    
    % QPSK
elseif strcmp(modulation, 'QPSK')
    nBps = 2;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    outBits = zeros(nInDataNormal*nBps, 1);                                 % ���bit
    inData = inDataNormal*sqrt(2);                                          % ��һ����������ת��Ϊ��������������
    inNumber = computeHardInt(inData, M);                                   % inDataNormal��Ӧ�ĸ������ʮ������
    outNumber = mapQpsk(inNumber+1);                                        % inDataNormal��Ӧ�Ķ��������ʮ������
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % ת��Ϊ������
    
    % 16QAM
elseif strcmp(modulation, '16QAM')
    nBps = 4;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    outBits = zeros(nInDataNormal*nBps, 1);                                 % ���bit
    inData = inDataNormal*sqrt(10);                                         % ��һ����������ת��Ϊ��������������
    inNumber = computeHardInt(inData, M);                                   % inDataNormal��Ӧ�ĸ������ʮ������
    outNumber = mapQam16(inNumber+1);                                       % inDataNormal��Ӧ�Ķ��������ʮ������
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % ת��Ϊ������
    
    % 64QAM
elseif strcmp(modulation, '64QAM')
    nBps = 6;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    outBits = zeros(nInDataNormal*nBps, 1);                                 % ���bit
    inData = inDataNormal*sqrt(42);                                         % ��һ����������ת��Ϊ��������������
    inNumber = computeHardInt(inData, M);                                   % inDataNormal��Ӧ�ĸ������ʮ������
    outNumber = mapQam64(inNumber+1);                                       % inDataNormal��Ӧ�Ķ��������ʮ������
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % ת��Ϊ������
    
    % 256QAM
elseif strcmp(modulation, '256QAM')
    nBps = 8;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    outBits = zeros(nInDataNormal*nBps, 1);                                 % ���bit
    inData = inDataNormal*sqrt(170);                                        % ��һ����������ת��Ϊ��������������
    inNumber = computeHardInt(inData, M);                                   % inDataNormal��Ӧ�ĸ������ʮ������
    outNumber = mapQam256(inNumber+1);                                      % inDataNormal��Ӧ�Ķ��������ʮ������
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % ת��Ϊ������
    
    % 1024QAM
elseif strcmp(modulation, '1024QAM')
    nBps = 10;                                                              % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    outBits = zeros(nInDataNormal*nBps, 1);                                 % ���bit
    inData = inDataNormal*sqrt(682);                                        % ��һ����������ת��Ϊ��������������
    inNumber = computeHardInt(inData, M);                                   % inDataNormal��Ӧ�ĸ������ʮ������
    outNumber = mapQam1024(inNumber+1);                                     % inDataNormal��Ӧ�Ķ��������ʮ������
    outBitsTemp = dec2pAry(outNumber, nBps, 2);
    outBits(:) = outBitsTemp.';                                             % ת��Ϊ������
else
    error('Unimplemented modulation');
end
end