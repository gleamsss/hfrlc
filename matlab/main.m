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
h = waitbar(0,'压缩中，请稍等...');
for i=5:5
    waitbar(i,h,sprintf('第几个：%d/%d',i,7));
    compressibility(i)=top(file{i});
end
close(h);
function [compressibility]=top(filename)
    [shape,matrix]=get_matrix(filename);
    disp('matrix(1,:)');
    disp(matrix(1,:));
    disp('shape');
    disp(shape);
    ma=max(matrix(:))
    mi=min(matrix(:))
    numNonZero=nnz(matrix(:))
    xishudu=numNonZero*100/prod(shape);
    fprintf('稀疏度= %f%%',xishudu);
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
<<<<<<< HEAD
    %float_num=float_num*256.0*64;
=======
    %float_num=float_num*256.0*32;
>>>>>>> 563fff3353a1748134b94b1570e612a14d15f62d
    int_num=round(float_num);
    % 将浮点数转换为16进制字符串
    [high,weight]=size(int_num);
    
    vector_hex_num=dec2hex(int_num,4);
    vector_hex_num=string(vector_hex_num);
    hex_num=strcat(vector_hex_num{:});
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
    fprintf('压缩后需要的存储空间 %d Byte \n',sum(newcode_len)/2.0);
    fprintf('压缩前需要的存储空间 %d Byte \n',2*prod(shape));
    compressibility=(sum(newcode_len)/2.0)*100.0/(2*(prod(shape)));
    fprintf('compressibility=%f%% \n',compressibility);
    
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
                s=['0' , sprintf('%05x',count)];
                newcode=[newcode , s];
                count=0;
            end
            newcode=[newcode , oldcode(i)];
        end
    end
    if count~=0;
        s=['0' , sprintf('%05x',count)];
        newcode=[newcode , s];
        count=0;
    end
    newcode=[newcode , '000000'];%休止符
end


