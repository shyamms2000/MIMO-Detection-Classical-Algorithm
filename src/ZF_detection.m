function xHat = ZF_detection(y, H)
%�����Ĺ��ܣ�ʹ��ZF��ⷽ���������ΪnT�ķ����ź�����
%������������(1) ����H��ZF�˲�����õ�W_ZF
%          (2) ��������y���W_ZF
%������ʹ�ã�xHat = ZF_detection(y, H)
%���룺
%     y     :  �����ź�����
%     H     :  nR x nT ���ŵ�����
%�����
%     xHat  :  ZF���ķ����ź���������
%���ӣ�xHat = ZF_detection(y, H)

%����:             zhangcheng
%��������:          2019-10-30
%����������:       2019-10-30

W_ZF = inv(H'*H)*H';  
xHat = W_ZF*y;

end