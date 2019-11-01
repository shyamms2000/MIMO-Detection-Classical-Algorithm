function z = computeHardInt(y, M)
%�����Ĺ��ܣ����ݵ��ƽ�������������Ŷ�Ӧ�ĸ������ʮ������
%������������
%������ʹ�ã�z = computeHardInt(y, M)
%���룺
%     y : ���ݷ�������
%     M : ���ƽ���
%�����
%     z : ��ӳ���ĸ������Ӧ��ʮ������

%���ӣ�z = computeHardInt(y, 16)

%����:             zhangcheng
%��������:          2019-10-29
%����������:       2019-10-29

sqrtM = sqrt(M);
z = zeros(size(y));

% ��y��ʵ��ӳ�䵽[0, sqrtM-1]
rIndex = round((real(y)+(sqrtM-1))./2);
rIndex(rIndex < 0) = 0;
rIndex(rIndex > (sqrtM-1)) = sqrtM-1;

% ��y���鲿ӳ�䵽[0, sqrtM-1]
iIndex = round((imag(y)+(sqrtM-1))./2);
iIndex(iIndex < 0) = 0;
iIndex(iIndex > (sqrtM-1)) = sqrtM-1;

% �������������������Ӧ�ĸ������ʮ������
z(:) = sqrtM*rIndex + sqrtM-iIndex-1;
end