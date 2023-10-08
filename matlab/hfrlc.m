%x = [1 2 3 4 5];
%y = [6 7 8 9 10];
%save('mydata.mat', 'x', 'y');
mydata=load('dw8192.mat');
fields =fieldnames(mydata);
disp(fields);
mydata.x
