function [modSymbol, modTable] = modulating(bitSequence, modulation)
%�����Ĺ��ܣ��Ա������а������ĵ��Ʒ�ʽ����������ӳ��
%������������(1) ʶ����Ʒ�ʽmodulation
%          (2) ���ɹ�һ��������ӳ���
%          (3) ��ÿ�����ŵı�����Ϊ��Ԫ����������ӳ��
%������ʹ�ã�[modSymbol, modTable] = modulator(bitSequence, modulation)
%���룺
%     bitSequence: ������������bit����
%     modulation : ���Ʒ�ʽ��BPSK��QPSK��16QAM��64QAM��256QAM��1024QAM
%�����
%     modSymbol: ���ƺ�ķ���
%     modTable : ������ӳ���
%���ӣ�[modSymbol, modTable] = modulator(bitSequence, '16QAM')

%����:             zhangcheng
%��������:          2019-10-28
%����������:       2019-10-29

global symbolIndexBpsk;
global symbolIndexQpsk;
global symbolIndexQam16;
global symbolIndexQam64;
global symbolIndexQam256;
global symbolIndexQam1024;

nBitSequence = length(bitSequence);

% BPSK
if strcmp(modulation, 'BPSK')
    nBps = 1;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % BPSK�������
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % ԭʼ������ת��ΪnBps x (nBitSequence/nBps)�ľ���������������ʾһ��������
    binNumber = inp;                                                        % nBps�����ض�����ӳ���Ӧ��ʮ������
    grayNumber = symbolIndexBpsk(binNumber+1);                              % nBps�����ظ�����ӳ���Ӧ��ʮ������
    modSymbol = modTable(grayNumber+1);                                     % nBps�����ظ�����ӳ���Ӧ��������
    modSymbol = modSymbol(:);                                               % ת��Ϊ������
    
    % QPSK
elseif strcmp(modulation, 'QPSK')   
    nBps = 2;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % QPSK�������
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % ԭʼ������ת��ΪnBps x (nBitSequence/nBps)�ľ���������������ʾһ��������
    binNumber = [2 1]*inp;                                                  % nBps�����ض�����ӳ���Ӧ��ʮ������
    grayNumber = symbolIndexQpsk(binNumber+1);                              % nBps�����ظ�����ӳ���Ӧ��ʮ������
    modSymbol = modTable(grayNumber+1);                                     % nBps�����ظ�����ӳ���Ӧ��������
    
    % 16QAM
elseif strcmp(modulation, '16QAM')
    nBps = 4;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 16�������
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % ԭʼ������ת��ΪnBps x (nBitSequence/nBps)�ľ���������������ʾһ��������
    binNumber = [8 4 2 1]*inp;                                              % nBps�����ض�����ӳ���Ӧ��ʮ������
    grayNumber = symbolIndexQam16(binNumber+1);                             % nBps�����ظ�����ӳ���Ӧ��ʮ������
    modSymbol = modTable(grayNumber+1);                                     % nBps�����ظ�����ӳ���Ӧ��������
    
    % 64QAM
elseif strcmp(modulation, '64QAM')
    nBps = 6;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 64�������
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % ԭʼ������ת��ΪnBps x (nBitSequence/nBps)�ľ���������������ʾһ��������
    binNumber = [32 16 8 4 2 1]*inp;                                        % nBps�����ض�����ӳ���Ӧ��ʮ������
    grayNumber = symbolIndexQam64(binNumber+1);                             % nBps�����ظ�����ӳ���Ӧ��ʮ������
    modSymbol = modTable(grayNumber+1);                                     % nBps�����ظ�����ӳ���Ӧ��������
    
    % 256QAM
elseif strcmp(modulation, '256QAM')
    nBps = 8;                                                               % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 256�������
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % ԭʼ������ת��ΪnBps x (nBitSequence/nBps)�ľ���������������ʾһ��������
    binNumber = [128 64 32 16 8 4 2 1]*inp;                                 % nBps�����ض�����ӳ���Ӧ��ʮ������
    grayNumber = symbolIndexQam256(binNumber+1);                            % nBps�����ظ�����ӳ���Ӧ��ʮ������
    modSymbol = modTable(grayNumber+1);                                     % nBps�����ظ�����ӳ���Ӧ��������
    
    % 1024QAM
elseif strcmp(modulation, '1024QAM')
    nBps = 10;                                                              % ÿ�����ŵı�����
    M = 2^nBps;                                                             % ���ƽ���
    [constellation, averagePower] = getConstellation(M);                    
    modTable = constellation./sqrt(averagePower);                           % 1024�������
    inp = reshape(bitSequence, nBps, nBitSequence/nBps);                    % ԭʼ������ת��ΪnBps x (nBitSequence/nBps)�ľ���������������ʾһ��������
    binNumber = [512 256 128 64 32 16 8 4 2 1]*inp;                         % nBps�����ض�����ӳ���Ӧ��ʮ������
    grayNumber = symbolIndexQam1024(binNumber+1);                           % nBps�����ظ�����ӳ���Ӧ��ʮ������
    modSymbol = modTable(grayNumber+1);                                     % nBps�����ظ�����ӳ���Ӧ��������
else
    error('Unimplemented modulation');
end
end