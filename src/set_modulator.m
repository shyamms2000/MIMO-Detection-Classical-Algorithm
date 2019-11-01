function [nBps, M] = set_modulator(modulation)
%�����Ĺ��ܣ����ݸ����˵��Ʒ�ʽ������Ʒ��ű������͵��ƽ���
%����������������ϸ��
%������ʹ�ã�[nBps, M] = set_modulator(modulation)
%���룺
%     modulation: ���Ʒ�ʽ
%�����
%     nBps: ÿ�����Ʒ��ŵı�����
%     M   : ���ƽ���
%���ӣ�[nBps, M]=set_modulator('16QAM');

%����:             zhangcheng
%��������:          2019-10-28
%����������:       2019-10-28
global symbolIndexBpsk;
global mapBpsk;
global symbolIndexQpsk;
global mapQpsk;
global symbolIndexQam16;
global mapQam16;
global symbolIndexQam64;
global mapQam64;
global symbolIndexQam256;
global mapQam256;
global symbolIndexQam1024;
global mapQam1024;

switch(modulation)
    case 'BPSK'
        nBps = 1;
        M = 2;
        indexGrayBpsk = csvread('../inputData/BPSK.csv');
        symbolIndexBpsk = indexGrayBpsk(:,1);
        mapBpsk = indexGrayBpsk(:,2);
    case 'QPSK'
        nBps = 2;
        M = 4;
        indexGrayQpsk = csvread('../inputData/QPSK.csv');
        symbolIndexQpsk = indexGrayQpsk(:,1);
        mapQpsk = indexGrayQpsk(:,2);
    case '16QAM'
        nBps = 4;
        M = 16;
        indexGrayQam16 = csvread('../inputData/QAM16.csv');
        symbolIndexQam16 = indexGrayQam16(:,1);
        mapQam16 = indexGrayQam16(:,2);
    case '64QAM'
        nBps = 6;
        M = 64;
        indexGrayQam64 = csvread('../inputData/QAM64.csv');
        symbolIndexQam64 = indexGrayQam64(:,1);
        mapQam64 = indexGrayQam64(:,2);
    case '256QAM'
        nBps = 8;
        M = 256;
        indexGrayQam256 = csvread('../inputData/QAM256.csv');
        symbolIndexQam256 = indexGrayQam256(:,1);
        mapQam256 = indexGrayQam256(:,2);
    case '1024QAM'
        nBps = 10;
        M = 1024;
        indexGrayQam1024 = csvread('../inputData/QAM1024.csv');
        symbolIndexQam1024 = indexGrayQam1024(:,1);
        mapQam1024 = indexGrayQam1024(:,2);
    otherwise
        error('Unimplemented modulation');
end
end