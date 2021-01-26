function [centers, deviations] = GK(data, no_centers, max_no_iterations, weight_eta)
%data = [vhod', izhod']
%no_centers - inicializacija št. rojev
%weight_eta - izbira uteži
%max_no_iterations - izbira max. št. iteracij
[data_row, data_col] = size(data);
membership_matrix = rand(data_row, no_centers); %inicializacija matrike pripadnosti
membership_matrix_prev = rand(data_row, no_centers);
ro_factor = ones(1, no_centers);
ro_factor_prev = ones(1, no_centers);%izbira zaèetne vrednosti faktorja ro
weight = 2/(weight_eta - 1);

%normiranje
for i = 1:data_row
    membership_matrix(i, :) = membership_matrix(i, :)/sum(membership_matrix(i, :));
    membership_matrix_prev(i, :) = membership_matrix_prev(i, :)/sum(membership_matrix_prev(i, :));
end

centers = zeros(no_centers, 2);
fuzzy_cov_matrix = zeros(2,2,no_centers);
inner_prod_matrix = zeros(2,2,no_centers);
distances = zeros(data_row, no_centers);
for i = 1:max_no_iterations
    for j = 1:no_centers
        centers(j, :) = sum((membership_matrix(:,j).^weight_eta).*data)./sum(membership_matrix(:,j).^weight_eta);
    end
    for j = 1:no_centers
        fuzzy_cov_matrix(:,:,j) = [data(:,1) - centers(j,1), data(:,2) - centers(j, 2)]'*...
                            ([(membership_matrix_prev(:,j).^weight_eta),(membership_matrix_prev(:,j).^weight_eta)].*...
                            [data(:,1) - centers(j,1),data(:,2) - centers(j,2)]) /...
                            sum(membership_matrix_prev(:,j).^weight_eta);
%        fuzzy_cov_matrix(:,:,j) = [data(:,1) - centers(j,1), data(:,2) - centers(j, 2)]'*...
%                             ([(membership_matrix(:,j).^weight_eta),(membership_matrix(:,j).^weight_eta)].*...
%                             [data(:,1) - centers(j,1),data(:,2) - centers(j,2)]) /...
%                             sum(membership_matrix(:,j).^weight_eta);
    end
    for j = 1:no_centers
        inner_prod_matrix(:,:,j) = (ro_factor_prev(j)*det(fuzzy_cov_matrix(:,:,j))^(1/data_col))*fuzzy_cov_matrix(:,:,j)^(-1);
    end
    ro_factor_prev = ro_factor;
    for j = 1:no_centers
        ro_factor(j) = det(inner_prod_matrix(:,:,j));
    end
    for j = 1:no_centers
        for k = 1:data_row
            distances(k, j) = sqrt((data(k,:) - centers(j,:))*inner_prod_matrix(:,:,j)*(data(k,:) - centers(j,:))');
        end
    end
    membership_matrix_prev = membership_matrix;
    for j = 1:no_centers
        for k = 1:data_row
            membership_matrix(k, j) = (1/distances(k, j)^weight)/(sum((1./(distances(k, :).^weight))));
        end
    end                       
end
 
deviations = reshape(fuzzy_cov_matrix(1,1,:), [1, no_centers]);
centers = centers(:, 1);
end