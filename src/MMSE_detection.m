function xHat = MMSE_detection(y, H, noisePower)
%�����Ĺ��ܣ�ʹ��MMSE��ⷽ���������ΪnT�ķ����ź�����
%������������(1) ����H��MMSE�˲�����õ�W_ZF
%          (2) ��������y���W_ZF
%������ʹ�ã�xHat = ZF_detection(y, H)
%���룺
%     y         :  �����ź�����
%     H         :  nR x nT ���ŵ�����
%     noisePower:  �����ź�������ƽ������
%�����
%     xHat      :  MMSE���ķ����ź���������
%���ӣ�xHat = MMSE_detection(y, H, noisePower)

%����:             zhangcheng
%��������:          2019-10-31
%����������:       2019-10-31

nT = size(H,2);                                 % ����������
W_MMSE = inv(H'*H+noisePower*eye(nT))*H';    
xHat = W_MMSE*y;

end