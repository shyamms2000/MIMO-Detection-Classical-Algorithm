function [constellation, averagePower] = getConstellation(M)
%�����Ĺ��ܣ����ݸ����ĵ��ƽ��������һ��QAM������
%������������(1) M������Ϊ2^nBps, ����nBps����Ϊ1���ߴ��ڵ���2��ż��
%          (2) ���ɹ�һ��������ӳ���
%������ʹ�ã�constellation = getConstellation(M)
%���룺
%     M             : QAM���ƽ���

%�����
%     constellation : MQAM��Ӧ���������
%���ӣ�constellation = getConstellation(16)

%����:             zhangcheng
%��������:          2019-10-29
%����������:       2019-10-30

if M ==2
    constellation = exp(1j*[-pi, 0]);
    averagePower = ( (5*M/4) - 1 ) * 2/3;
else
    sqrtM = sqrt(M);                                                        % ����QAM��Ӧ��ÿ�л���ÿ�еĵ���
    constellation = zeros(M,1);                                             % �������
    xPoints = -(sqrtM-1) : 2 : (sqrtM-1);                                   % ������I·����
    yPoints = (sqrtM-1) : -2 : -(sqrtM-1);                                  % ������Q·����
    x = repmat(xPoints, sqrtM, 1);
    y = repmat(yPoints.', sqrtM, 1);
    constellation(:) = complex(x(:), y);                                    % QPSK�Ĺ�һ��������(����->�£��ٴ���->��)
    averagePower = (M - 1) * 2/3;
end