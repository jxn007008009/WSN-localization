clear;clc;

%% �����������
cd data;
initData;
cd ..;

%% ǰ�ڴ���

[dim,~] = size(anchor);      % ά��
[anch, node] = size(netsa);  % ê�� anch �ͽڵ�

netss = [netss,netsa'];                        % ƴ��Ϊ  20*24                
netss = [netss;netsa,zeros(anch,anch)];        % ����    24*24

%% ��������������·��

step = zeros(anch,node+anch);                  % ��С��������
path = zeros(anch,node+anch);                  % ·������

for i = 1:anch
    for j =1:node
        if netsa(i,j) ~= 0
            step(i,j) = 1;                     % ��ê��ֱ��������δ֪�ڵ� Hop=1
        end
    end
end

s=1;         % Ϊ��ȱ�����׼��                                

while(true)
    temp = step;                                                       % ��ʱ���������ж��Ƿ�������
    for i = 1:anch                                                     % 4 ��ê��ֱ�㲥
        for j =1:(node+anch)    
            for k = 1:(node+anch)
                if step(i,j) == s && netss(j,k) ~= 0 && step(i,k) == 0 % ����δ֪�ĵ�
                    path(i,k) = j;                                     % �洢��ǰ������һ�ڵ�
                    step(i,k) = s + 1;                                 % �뵱ǰ�������ĸ�ֵ����һ��
                end
            end
        end
    end
    if isequal(temp, step)
        break;                                                         % ��С���������������ѭ��
    end
    s = s + 1;
end

for i = 1:anch
    step(i,node+i)=0;                      % �ֶ�У��
end

%% ����·��
dist = zeros(anch, node + anch);                                    

for i = 1 : anch
    for j = 1 :(node + anch)
        tmp_j = j;
        while(true)
            k = path(i, tmp_j);
            if(k == 0) 
                dist(i,j) = dist(i,j) + netsa(i,tmp_j);
                break;
            end
            dist(i,j) = dist(i, j) + netss(k, tmp_j);
            tmp_j = k;
        end
    end
end

%% ���ù��ƾ��붨λ

xy = zeros(node,dim);       % ����           

for i = 1:node
    A = zeros(anch-1,dim);
    B = zeros(anch-1,1);
    
    for j = 1 : anch-1
        for k = 1:dim
            A(j,k) = 2 * (anchor(k,j)-anchor(k,anch)); % x y z
            B(j) = B(j) + anchor(k,j)^2 - anchor(k, anch)^2;
        end
        B(j) = B(j) + dist(anch,i)^2-dist(j,i)^2;
    end
    C = A\B;
    xy(i,1) = C(1);
    xy(i,2) = C(2);
end

accuracy;  % ���㲢��ʾ��Ծ���

%% ����

for k = 1:5
     for i = 1 : node
         x = xy(i,:);
         x = fminsearch(@(x)fun(i,x,xy,anchor,netss,netsa),x);  % ��������
         xy(i,:) = x;
     end
end

 %% ���ƽ��ͼ
 
if(dim == 2)  % ��άͼ
    plot(anchor(1,:),anchor(2,:), '*r');
    hold on;
    plot(xy(:,1),xy(:,2),'ob');
    hold on;
    plot(sensors(:,1),sensors(:,2),'*g');
    legend('�ο��ڵ�����','δ֪�ڵ��������','δ֪�ڵ�ʵ������');
else          % ��άͼ
    plot3(anchor(1,:),anchor(2,:),anchor(3,:), '*b');
    hold on;
    plot3(xy(:,1),xy(:,2),xy(:,3),'or');
    %hold on;
    %plot3(sensors(:,1),sensors(:,2),sensors(:,3),'*b');
end

accuracy;  % ���㲢��ʾ��Ծ���