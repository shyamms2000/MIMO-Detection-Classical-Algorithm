function [y, H, noisePower] = channel_accurate_static(x, nT, nR, snr)
%�����Ĺ��ܣ����������źźͷ��ͺͽ����������������ź�ͨ��MIMO�ŵ����
%������������(1) �ŵ��Ƕ���ͬ�ֲ���׼��̬����˥���ŵ����������߻�����ɺͽ������߻������
%������ʹ�ã�y = channel(x)
%���룺
%     x       : �����ź�
%     nT      : ����������Ŀ
%     nR      : ����������Ŀ
%     snr     : ���������
%�����
%     y       : ͨ���ŵ��������ź�
%     H       : һ֡�����е��ŵ�����    
%���ӣ�[y, H] = channel_accurate_static(x, 4, 4, 10)

%����:             zhangcheng
%��������:          2019-10-30
%����������:       2019-10-30

nFrameLength = size(x, 2);

% ����ͬ�ֲ������ŵ�
Hw = (randn(nR, nT, nFrameLength)+1j*randn(nR, nT, nFrameLength))./sqrt(2); 

% % ����˺ͽ��ն˿ռ���������
% rhoTx = 0.2;
% rhoRx = 0.6;
% theta = pi/2;
% Rtx = zeros(nT, nT);
% Rrx = zeros(nR, nR);
% 
% % ����˵Ŀռ���ؾ���
% for iNT = 1:nT
%     for jNT = 1:nT
%         if iNT <= jNT
%             Rtx(iNT, jNT) = (rhoTx*exp(1j*theta))^(jNT-iNT);
%         else
%             Rtx(iNT, jNT) = conj((rhoTx*exp(1j*theta))^(iNT-jNT));
%         end
%     end
% end
% 
% % ���ն˵Ŀռ���ؾ���
% for iNR = 1:nR
%     for jNR = 1:nR
%         if iNR <= jNR
%             Rrx(iNR, jNR) = (rhoRx*exp(1j*theta))^(jNR-iNR);
%         else
%             Rrx(iNR, jNR) = conj((rhoRx*exp(1j*theta))^(iNR-jNR));
%         end
%     end
% end
% H = zeros(nR, nT, nFrameLength);
% for iFrameLength = 1:nFrameLength
%     % ע�������ƽ������sqrtm, ��ÿ��Ԫ����ƽ������sqrt
%     H(:,:,iFrameLength) = sqrtm(Rrx)*Hw(:,:,iFrameLength)*sqrtm(Rtx);   
% end

H = Hw;             % ׼��̬�ŵ�

% ���ɽ����ź�
r = zeros(nR, nFrameLength);
for iFrameLength = 1:nFrameLength
    r(:,iFrameLength) = H(:,:,iFrameLength)*x(:,iFrameLength);
end

% ���Ը�˹������
rxAveragePower = mean(mean(abs(r).^2));
noisePower = rxAveragePower/snr;
noise = sqrt(noisePower)*(randn(nR, nFrameLength)+1j*randn(nR, nFrameLength))./sqrt(2);

% ����ź�
y = r+noise;
end