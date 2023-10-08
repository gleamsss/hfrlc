file=cell(8,1);
file{1}='dw8192.mat';
file{2}='conf5_0-4x4-10.mat';%fushu
file{3}='epb1.mat';
file{4}='psmigr_2.mat';
file{5}='raefsky1.mat';
file{6}='scircuit.mat';%太大
file{7}='t2d_q9.mat';
file{8}='torso2.mat';%太大
compressibility=[];
filename=file{6};
compressibility(1)=top(filename)
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
    float_num=float_num*256.0;
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
    vector = [];
    %vector_int=cell(high,1);
    %vector_hfrlc=cell(high, 1);
    h = waitbar(0,'压缩中，请稍等...');
    for i=1:high
        waitbar(i/high,h,sprintf('进度：%f%%',i*100/high));
        vector(i,:)=sparse_matrix(i,:);
        quantify(vector(i,:));
        vector_int{i}=quantify(vector(i,:));
        temp_vector_int=[];
        temp_vector_int=vector_int{i};
        temp_vector_int=full(temp_vector_int);
        vector_hfrlc{i}=yasuo(temp_vector_int);
        tempshape=size(vector_hfrlc{i});
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

