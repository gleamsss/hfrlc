file{1}='epb1.mat';     %max=0.1450     min= -0.0592
file{2}='psmigr_2.mat'; %max=0.7531     min=  0
file{3}='raefsky1.mat'; %max=1          min= -0.6124
file{4}='t2d_q9.mat';   %max=3.6100     min= -0.5856
file{5}='torso2.mat';   %max=4.7106     min= -3.9199
filename=file{5};
[shape,matrix]=get_matrix(filename);
[data,indices,indptr]=makecsr(matrix);
zijie1=1;
zijie2=1;
zijie3=1;
fprintf('CSR---size(data) = %d %d\n',size(data));
fprintf('CSR---size(indices) = %d %d\n',size(indices));
fprintf('CSR---size(indptr) = %d %d\n',size(indptr));

if max(indices)<65536
    zijie2=2;
elseif max(indices)<1048576
    zijie2=3;
else
    zijie2=4;
end

if max(indptr)<65536
    zijie3=2;
elseif max(indptr)<1048576
    zijie3=3;
else
    zijie3=4;
end
max(indices)
max(indptr)
temp1=size(data)
temp2=size(indices)
temp3=size(indptr)
zijie1
zijie2
zijie3
sumByte=temp1(1)*zijie1 + temp2(1)*zijie2 + temp3(2)*zijie3

function [shape,data]=get_matrix(filename)
    % input is sparse matrix 's filename 
    % output is matrix shape and data
    message=load(filename);
    data=message.Problem.A;
    shape=size(data);
end
function [data,indices,indptr]=makecsr(matrix)
    %input is sparse matrix
    %output is CSR of sparse matrix
    [col,row,data]=find(matrix);
    indices=col;
    line_num=[];
    '--------------------------------------------------------'
    %h = waitbar(0,'CSR压缩中，请稍等...');
    shape=size(matrix)
    for i=1:shape(1)
        %waitbar(i,h,sprintf('第几行：%d/%d',i,shape(1)));
        line_num(i)=nnz(matrix(i,:));
    end
    %close(h);
    temp=0;
    for i=1:shape(1)
        indptr(i)=temp;
        temp=temp+line_num(i);
    end
end
