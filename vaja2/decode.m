function [results, results_string] = decode(chromosomes)

 %dekodiranje kromosomov (funkcija(chromosomes) = results, results_string)
 %doloè num_of_chr, num_of_op iz row pa col
 [row, col] = size(chromosomes); 
 num_of_chromosomes = row;
 num_of_operations = (col - 4)/6;
 numbers = zeros(num_of_chromosomes, num_of_operations + 1);
 operations = zeros(num_of_chromosomes, num_of_operations);
 for i = 1:row
     for j = 0:num_of_operations
         num_idx1 = 1 + j*6;
         num_idx2 = 4 + j*6;
         %numbers(i, j + 1) = bi2de(chromosomes(i,num_idx1:num_idx2));
         %števke od 1 do 16, izognemo se 0, ker povzoroèa mnogo težav pri deljenju z 0 -> NaN, Inf
         numbers(i, j + 1) = 1 + bi2de(chromosomes(i,num_idx1:num_idx2)); 
     end
     for j = 0:num_of_operations - 1 
         op_idx1 = 5 + j*6;
         op_idx2 = op_idx1 + 1;
         operations(i, j + 1) = bi2de(chromosomes(i,op_idx1:op_idx2));
     end
 end
 
 [row_op, col_op] = size(operations);
 %operations_string = zeros(row_op, col_op);
 for i = 1:row_op
     for j = 1:col_op
         if (operations(i, j)==0)
             operations_string(i, j) = "+";
         end
         if (operations(i, j)==1)
             operations_string(i, j) = "-";
         end
         if (operations(i, j)==2)
             operations_string(i, j) = "*";
         end
         if (operations(i, j)==3)
             operations_string(i, j) = "/";
         end
     end
 end

for i = 1:num_of_chromosomes
    new_str_col(i,:) = " ";
end

operations_string = [operations_string new_str_col];
 
results = [];
res_string = strings(1);
 for i = 1:row
     k = 0;
     for j = 1:num_of_operations + 1
         res_string = res_string + num2str(numbers(i,j)) + operations_string(i,j);
         k = k + 1;
         if (k == num_of_operations + 1)
             results(i) = str2num(res_string);
             results_string(i) = res_string;
             clear res_string
             res_string = strings(1);
         end
     end
 end

end

%IGNORIRAJ
%PREJ V GLAVNEM PROGRAMU
%  %dekodiranje kromosomov (funkcija(chromosomes) = results, results_string)
%  %doloè num_of_chr, num_of_op iz row pa col
%  [row, col] = size(chromosomes);
%  num_of_chromosomes = row;
%  num_of_operations = (col - 4)/6;
%  numbers = zeros(num_of_chromosomes, num_of_operations + 1);
%  operations = zeros(num_of_chromosomes, num_of_operations);
%  for i = 1:row
%      for j = 0:num_of_operations
%          num_idx1 = 1 + j*6;
%          num_idx2 = 4 + j*6;
%          numbers(i, j + 1) = bi2de(chromosomes(i,num_idx1:num_idx2));
%      end
%      for j = 0:num_of_operations - 1 
%          op_idx1 = 5 + j*6;
%          op_idx2 = op_idx1 + 1;
%          operations(i, j + 1) = bi2de(chromosomes(i,op_idx1:op_idx2));
%      end
%  end
%  
%  [row_op, col_op] = size(operations);
%  %operations_string = zeros(row_op, col_op);
%  for i = 1:row_op
%      for j = 1:col_op
%          if (operations(i, j)==0)
%              operations_string(i, j) = "+";
%          end
%          if (operations(i, j)==1)
%              operations_string(i, j) = "-";
%          end
%          if (operations(i, j)==2)
%              operations_string(i, j) = "*";
%          end
%          if (operations(i, j)==3)
%              operations_string(i, j) = "/";
%          end
%      end
%  end
% 
% 
% for i = 1:num_of_chromosomes
%     new_str_col(i,:) = " ";
% end
% operations_string = [operations_string new_str_col];
%  
% results = [];
%  for i = 1:row
%      k = 0;
%      for j = 1:num_of_operations + 1
%          string = string + num2str(numbers(i,j)) + operations_string(i,j);
%          k = k + 1;
%          if (k == num_of_operations + 1)
%              results(i) = str2num(string);
%              results_string(i) = string;
%              clear string
%          end
%      end
%  end
%  
%  disp(results)
%  disp(results_string)
