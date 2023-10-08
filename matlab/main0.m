filename='dw8192.mat';
%fields_dw8192=fieldnames(message_dw8192);
%disp(fields_dw8192);
%message_dw8192.Problem

[shape,matrix]=get_matrix(filename);
disp('matrix(1,:)');
disp(matrix(1,:));
disp('shape');
disp(shape);
matrix=full(matrix);
max=max(matrix(:))
min=min(matrix(:))
compressibility=hfrlc(shape,matrix);
%disp(compressibility);

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
    vector = [];
    vector_int=cell(high,1);
    vector_hfrlc=cell(high, 1);
    h = waitbar(0,'压缩中，请稍等...');
    for i=1:high
        waitbar(i/high,h,sprintf('进度：%f%%',i/high));
        vector(i,:)=sparse_matrix(i,:);
        quantify(vector(i,:));
        vector_int{i}=quantify(vector(i,:));
        
       
        vector_hfrlc{i}=yasuo(vector_int{i});
    end
    close(h);
    compressibility=prod(size(vector_hfrlc))*1.0/(prod(shape)*4)
    
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

