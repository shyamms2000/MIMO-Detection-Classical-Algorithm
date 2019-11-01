function xHat = ML_detection(y, H, M)
%�����Ĺ��ܣ�ʹ��ML��ⷽ���������ΪnT�ķ����ź�����
%������������(1) ������Ҫ�����ķ�������������ҵ���������µķ�������
%          (2) ����ʵ�ʽ���������ٶ�����������Ӧ�Ľ�������֮���2-������С�ҵ���������
%������ʹ�ã�xHat = ML_detection(y, H)
%���룺
%     y     :  �����ź�����
%     H     :  nR x nT ���ŵ�����
%     M     :  ���ƽ���

%�����
%     xHat  :  ML���ķ����ź���������
%���ӣ�xHat = ML_detection(y, H, M)

%����:             zhangcheng
%��������:          2019-10-30
%����������:       2019-10-30

% ����ML����״̬��
nT = size(H,2);                                 % ����������
nCondition = M^nT;                              % �����ź����������������
index = [0:nCondition-1].';                     % ����������index
conditionIndex = dec2pAry(index, nT, M).';      % ת��ΪnT x M^nT�ľ���, ÿ��Ԫ�ض���һ��M���Ƶ���
[constellation, averagePower] = getConstellation(M);
modTable = constellation./sqrt(averagePower);   % BPSK�������
idealTxSymbol = modTable(conditionIndex+1);     % ����ÿ��Ԫ�صõ���Ӧ��������

% ������������
distanceSuare = zeros(nCondition, 1);
for iCondition = 1:nCondition
    distanceSuare(iCondition) = sum((y - H*idealTxSymbol(:, iCondition)).*conj(y - H*idealTxSymbol(:, iCondition)));
end
[~, minIndex] = min(distanceSuare);             % �ҵ�distanceSuare����Сֵ��λ��
xHat = idealTxSymbol(:, minIndex);
end