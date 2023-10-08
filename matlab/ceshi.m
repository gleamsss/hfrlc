strCell = cell(5, 1);
strCell{1}='a';
strCell{2}='ab';
strCell{3}='abc';
strCell{4}='abcd';
strCell{5}='abcde';

size(strCell{5})
% 输出cell数组中的内容
for i = 1:length(strCell)
    strCell{i}
end
