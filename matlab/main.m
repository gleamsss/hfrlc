[shape,matrix]=get_matrix('dw8192.mat')
function [shape,data]=get_matrix(filename)
    % input is sparse matrix 's filename 
    % output is matrix shape and data
    message=load(filename);
    data=message.Problem.A;
    shape=size(data);
end
