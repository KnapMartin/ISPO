function [all_recombined_chromosomes] = recombine(selected_chromosomes, parent_children_ratio)
%enoto�kovno kri�anje
%izmed izbrancev sta naklju�no izbrana dva razli�na star�a, ki sta nato na
%naklju�nem mestu razrezana ter zamenjana

selected_chromosomes_idx = 1:1:length(selected_chromosomes(:,1)); %vektor indeksov kromosomov

all_recombined_chromosomes = [];
for i = 1:round(length(selected_chromosomes(:,1))*parent_children_ratio/2)
    parents = [];
    recombined_chromosomes = [];
    %naklju�en izbor dveh razli�nih star�ev
    while (1)
        random_parent_idx1 = ceil(rand(1)*length(selected_chromosomes(:,1)));
        random_parent_idx2 = ceil(rand(1)*length(selected_chromosomes(:,1)));
        if (random_parent_idx1 ~= random_parent_idx2)
            parents(1) = random_parent_idx1;
            parents(2) = random_parent_idx2;
            break
        end
    end
    %naklju�en izbor mesta reza
    chromosome_cut_index = ceil(rand(1)*length(selected_chromosomes(1,:)));
    %tvorba otroka z menjavo kromosomov na mestih reza
    recombined_chromosomes(1,:) = [selected_chromosomes(parents(1), 1:chromosome_cut_index), selected_chromosomes(parents(2), chromosome_cut_index+1:length(selected_chromosomes(1,:)))];
    recombined_chromosomes(2,:) = [selected_chromosomes(parents(2), 1:chromosome_cut_index), selected_chromosomes(parents(1), chromosome_cut_index+1:length(selected_chromosomes(1,:)))];
    all_recombined_chromosomes = [all_recombined_chromosomes; recombined_chromosomes];
end
end