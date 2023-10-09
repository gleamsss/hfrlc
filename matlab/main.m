filename='dw8192.mat'
[shape,matrix]=get_matrix(filename);
matrix(1,:)
a=full(matrix(1,:));
a=a*256*2;
a=round(a);
answer=dec2hex(a,4);
answer(1,:)
answer(2,:)
answer(3,:)
function [shape,data]=get_matrix(filename)
    % input is sparse matrix 's filename 
    % output is matrix shape and data
    message=load(filename);
    data=message.Problem.A;
    shape=size(data);
end
