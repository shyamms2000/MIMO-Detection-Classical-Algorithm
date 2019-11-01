function y = SISO(x,snr)
% SISO.m
% ���ܣ�ʵ��SISO����
% ���룺
%  x    :   ��������
%  snr  :   ����ȣ��Ƕ���ֵ��
% �����
%  y    :   ��������

%���ߣ�      zhang cheng
%�������ڣ�   2019-10-01
%���������ڣ�2019-10-06

frameLength = length(x);

%**************************************************************************
%                                 ������
% % �����ŵ��ͼ�������
% H = (randn(frameLength,1)+1j*randn(frameLength,1))/sqrt(2);
% noise = (randn(frameLength,1)+1j*randn(frameLength,1))/sqrt(snr)/sqrt(2);
% 
% % �����ź�
% r = H.*x + noise;
%**************************************************************************

% �����ŵ��ͼ�������
H = (randn(frameLength,1)+1j*randn(frameLength,1))/sqrt(2);         % �����ŵ�
s = H.*x;                                                           % �źŲ���
averagePower = mean(abs(s).^2);                                     % ���н������ߵ�ƽ������
noisePower = averagePower/snr;                                      % ��������
noise = sqrt(noisePower)*(randn(frameLength,1)+...                  % ��������
    1j*randn(frameLength,1))/sqrt(2);

% ���ղ���
% noise = zeros(frameLength,1);                                       % ����ʹ��
r = s + noise;

% ��������о����ź�
y_H = conj(H).*r;

% �����ŵ�����
Habs = sum(abs(H).^2,2);
y = y_H./Habs;
end