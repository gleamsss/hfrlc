%定义自变量W，S，P
%W取值1-10000 S取值0.01-0.1 P取值0.01-0.1 
%w=linspace(1,10000,100);
%s=linspace(0.01,1,100);
%p=linspace(0.01,1,100);
%[W,S,P]=meshgrid(w,s,p);

% 使用3D图形绘制结果
% 定义 w、s、p 和 f 的数据
w = linspace(1, 1000, 100);  % 创建一个包含 100 个点的 w 范围
s = linspace(0.01, 1, 100);  % 创建一个包含 100 个点的 s 范围
p = linspace(0.01, 1, 100);  % 创建一个包含 100 个点的 p 范围

% 创建一个网格，以便计算 f 的值 f=f(w,s,p)
[W, S, P] = meshgrid(w, s, p);

% 计算函数 f(w, s, p) 的值，%f=(W*S+3*W*P)/(8*W*S+4);
F = (W.*S+3.*W.*P)./(W.*8.*S+4);

% 将四维数据映射到三维空间中
% 以下示例使用点的大小来表示 F 的值
point_size = 20 * F / max(F(:));  % 根据 f 的值计算点的大小

% 使用 scatter3 函数创建散点图
figure;
scatter3(W(:), S(:), P(:), point_size(:), F(:), 'filled');
title('HFRLC/CSR的效率比');
xlabel('W轴-矩阵行数');
ylabel('S轴-稀疏度');
zlabel('P轴-出现连续0概率');
colorbar;  % 添加颜色图例
