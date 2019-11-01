function y = MRC(x,snr,nR)
% MRC.m
% ���ܣ�ʵ��MRC����
% ���룺
%  x    :   ��������
%  snr  :   ����ȣ��Ƕ���ֵ��
%  nR   :   ����������
% �����
%  y    :   ��������

%���ߣ�      zhang cheng
%�������ڣ�   2019-10-01
%���������ڣ�2019-10-06

% ����
frameLength = length(x);

%***********************************************************************
%                           ��������������
% % �����ŵ��ͼ�������
% H = (randn(frameLength,nR)+1j*randn(frameLength,nR))/sqrt(2);
% noise = (randn(frameLength,nR)+1j*randn(frameLength,nR))/snr/sqrt(2);  %
% 
% % ����
% r = zeros(frameLength, nR);         
% for iNr = 1:nR
%     r(:,iNr) = H(:,iNr).*x + noise;
% end
%***********************************************************************

% ���Ͳ���
x_M = repmat(x, [1, nR]);

% �����ŵ��ͼ�������
H = (randn(frameLength,nR)+1j*randn(frameLength,nR))/sqrt(2);       % �����ŵ�
s = H.*x_M;                                                         % �źŲ���
averagePower = mean(mean(abs(s).^2));                               % ���н������ߵ�ƽ������
noisePower = averagePower/snr;                                      % ��������
noise = sqrt(noisePower)*(randn(frameLength,nR)+...                 % ��������
    1j*randn(frameLength,nR))/sqrt(2);
% 
% noise = zeros(frameLength,nR);                                      % ���ڲ���
% ���ղ���
r = s + noise;

% �����ŵ�����
Habs = sum(abs(H).^2,2);
y = sum(r.*conj(H),2)./Habs;
% y = sum(r.*conj(H),2)
end