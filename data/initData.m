clear;clc;
radio = 0.4;                      % ͨ�Ű뾶
anchor = [-0.3, -0.3, 0.3, 0.3; -0.3, 0.3, -0.3, 0.3];  % 4 ��ê��������Ҫ�ֶ����ã������ĸ�����
sensors = -0.5 + 1.0*rand(20,2);       % ���ɢ��δ֪�ڵ�

% ����ê�������Χ��δ֪�ڵ�ľ���
netsa = zeros(4,20);
for i = 1 :4
    for j = 1:20
        dist = norm([sensors(j,1) sensors(j,2)]-[anchor(1,i) anchor(2,i)]);
        if(dist < radio)
            netsa(i,j) = dist;        % ��¼ͨ�Ű뾶�ڵ��ھӽڵ�
        end
    end
end

% ����δ֪�ڵ�֮��ľ���
netss = zeros(20,20);
for i = 1:20
    for j = 1:20
        dist = norm([sensors(j,1) sensors(j,2)]-[sensors(i,1) sensors(i,2)]); 
        if(dist < radio)
            netss(i,j) = dist;
        end
    end
end

% % ��ͼ�鿴
% plot(anchor(1,:),anchor(2,:), '*r');    % ��ê��
% hold on;
% plot(sensors(:,1),sensors(:,2),'ob');     % ��δ֪�ڵ������
% legend('�ο��ڵ�','δ֪�ڵ�')

