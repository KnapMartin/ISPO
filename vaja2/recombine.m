function [all_recombined_chromosomes] = recombine(selected_chromosomes, parent_children_ratio)
%enotoèkovno križanje
%izmed izbrancev sta nakljuèno izbrana dva razlièna starša, ki sta nato na
%nakljuènem mestu razrezana ter zamenjana

selected_chromosomes_idx = 1:1:length(selected_chromosomes(:,1)); %vektor indeksov kromosomov

all_recombined_chromosomes = [];
for i = 1:round(length(selected_chromosomes(:,1))*parent_children_ratio/2)
    parents = [];
    recombined_chromosomes = [];
    %nakljuèen izbor dveh razliènih staršev
    while (1)
        random_parent_idx1 = ceil(rand(1)*length(selected_chromosomes(:,1)));
        random_parent_idx2 = ceil(rand(1)*length(selected_chromosomes(:,1)));
        if (random_parent_idx1 ~= random_parent_idx2)
            parents(1) = random_parent_idx1;
            parents(2) = random_parent_idx2;
            break
        end
    end
    %nakljuèen izbor mesta reza
    chromosome_cut_index = ceil(rand(1)*length(selected_chromosomes(1,:)));
    %tvorba otroka z menjavo kromosomov na mestih reza
    recombined_chromosomes(1,:) = [selected_chromosomes(parents(1), 1:chromosome_cut_index), selected_chromosomes(parents(2), chromosome_cut_index+1:length(selected_chromosomes(1,:)))];
    recombined_chromosomes(2,:) = [selected_chromosomes(parents(2), 1:chromosome_cut_index), selected_chromosomes(parents(1), chromosome_cut_index+1:length(selected_chromosomes(1,:)))];
    all_recombined_chromosomes = [all_recombined_chromosomes; recombined_chromosomes];
end
end