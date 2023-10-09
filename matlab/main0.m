file=cell(8,1);
file{1}='dw8192.mat';   %max=40.5641    min= -58.2743  shape=8192*8192 
file{2}='epb1.mat';     %max=0.1450     min= -0.0592
file{3}='psmigr_2.mat'; %max=0.7531     min=  0
file{4}='raefsky1.mat'; %max=1          min= -0.6124
file{5}='scircuit.mat'; %max=21967      min= -8214.9
file{6}='t2d_q9.mat';   %max=3.6100     min= -0.5856
file{7}='torso2.mat';   %max=4.7106     min= -3.9199
file{8}='conf5_0-4x4-10.mat';%fushu
compressibility=[];
filename=file{6};
xishu=256.0;
h = waitbar(0,'压缩中，请稍等...');
for i=1:1
    waitbar(i,h,sprintf('第几个：%d/%d',i,7));
    compressibility(i)=top(file{i});
end
close(h);
disp('compressibility = ');
disp(compressibility);
function [compressibility]=top(filename)
    [shape,matrix]=get_matrix(filename);
    disp('matrix(1,:)');
    disp(matrix(1,:));
    disp('shape');
    disp(shape);
    ma=max(matrix(:))
    mi=min(matrix(:))
    compressibility=hfrlc(shape,matrix);
    %disp(compressibility);
end

function [shape,data]=get_matrix(filename)
    % input is sparse matrix 's filename 
    % output is matrix shape and data
    message=load(filename);
    data=message.Problem.A;
    shape=size(data);
end

function [hex_num]=quantify(float_num)
    %input is double float data
    %output is 16bit data
    float_num=float_num*xishu;
    int_num=round(float_num);
    % 将浮点数转换为16进制字符串
    [high,weight]=size(int_num);
    vector_hex_num = dec2hex(int_num);
    %disp('vector_hex_num shape');
    %disp(size(vector_hex_num));
    hex_num=[];
    for i =1:weight
        hex_num=[hex_num,vector_hex_num(i,:)];
    end
    %disp('hex_num shape');
    %disp(size(hex_num));
end

function [compressibility]=hfrlc(shape,sparse_matrix)
    % input is sparse_matrix 
    % output is compressibility
    % 创建一个动态的cell数组，包含不同长度的字符串
    high=shape(1);
    weight=shape(2);
    newcode_len=[];
    %vector_int=cell(high,1);
    %vector_hfrlc=cell(high, 1);
    h = waitbar(0,'压缩中，请稍等...');
    for i=1:high
        vector = [];
        waitbar(i/high,h,sprintf('进度：%f%%',i*100/high));
        vector=sparse_matrix(i,:);
        vector=full(vector);
        vector_int=quantify(vector);
        vector_hfrlc=yasuo(vector_int);
        tempshape=size(vector_hfrlc);
        newcode_len(i)=tempshape(2);
    end
    close(h);
    sum(newcode_len)
    prod(shape)
    compressibility=sum(newcode_len)*1.0/(prod(shape));
    
end

function [newcode]=yasuo(oldcode)
    %input is oldcode that with many zeros
    %output is newcode that with little zeros
    length=size(oldcode);
    length=length(2);
    count=0;
    newcode='';
    for i=1:length
        if oldcode(i)=='0';
            count=count+1;
        else oldcode(i)~='0';
            if count~=0;
                s=['0' , sprintf('%04x',count)];
                newcode=[newcode , s];
                count=0;
            end
            newcode=[newcode , oldcode(i)];
        end
    end
    if count~=0;
        s=['0' , sprintf('%04x',count)];
        newcode=[newcode , s];
        count=0;
    end
    newcode=[newcode , '00000'];%休止符
end

