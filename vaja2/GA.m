clc; clear all; format long;

%zgradba kromosoma
%kromosom = [cifra,op,cifra,op,cifra...]
%št. števk = št operacij + 1
%operacije so kodirane z 2 bitoma: 00+ 01- 10* 11/ oz. v dec 0+ 1- 2* 3/
%števke so kodirane s 4 biti kar na da 16 razliènih števk (1 - 16)

%DELOVANJE PROGRAMA
%1. generacija nakljuènih kromosomov
%2. v glavni zanki programa se nato dekodira nakljuène kromosome v
%rezultate
%3. doloèanje kriterijske funkcije
%4. izbira polovice "dobrih" kromosomov za rekombinacijo
%5. rekombinacija
%6. mutacija
%7. postopek se ponovi pri toèki 2 dokler ne dosežemo rezultata

generation = 1;
num_of_chromosomes = 100;%število mora biti deljivo z 2
num_of_operations = input('Podaj število operacij: \n');
result_number = input('Podaj rezultat: \n');

%generacija zaèetnih nakljuènih kromosomov
chromosomes = [];
for i = 1:num_of_chromosomes
    for j = 1:(4 + 6*num_of_operations)
        chromosomes(i, j) = round(rand);
    end
end

finish = 0;
while (1)
    %klicanje funkcije decode, ki kot argument sprejme matriko kromosomov
    %ter vrne rezultate prej nakljuèno generiranih izrazov (kromosomov)
    %terizraze same v obliki stringov
    [results, results_string] = decode(chromosomes);
    
    %izraèun kriterijske funkcije kot absolutna razlika željenega rezultata
    %ter doblejnih rezultatov
    crit_func = abs(results - result_number); 
    
    %izpis v primeru, da najdemo izraz, ki je skladen z željeno rešitvijo
    for j = 1:length(crit_func)
        if (crit_func(j) == 0)
            fprintf("Do rezultata ")
            fprintf(results_string(j))
            fprintf(" = %2.2f smo prišli v %d generacijah.\n", result_number, generation)
            finish = 1;
            break
        end
    end
    if (finish == 1)
        break
    end
    
    %izraèun inverza kriterijske funkcije (fitness) ter vsote njenih
    %elementov
    crit_func_inv = 1./abs(results - result_number);
    crit_func_inv_sum = sum(crit_func_inv);
    
    %Izbira staršev z metodo ruletnega kolesa
    %Izbrana je polovica "najboljših" kormosomov
    %Rezultat so indeksi izbranih kormosomov
    %Indeks izbranega kromosoma se ne ponovi veè kot enkrat
    
    %izraèun se izvede tako, da se doloèi nakljuèen fitness
    %nato se sešteva fitness prispevke posameznih kromosomov ter izbere
    %tistega, ki preseže nakljuèno doloèen fitness
    acceptance = 0.5;
    selection_num = round(num_of_chromosomes*acceptance);
    selected_chromosomes_index = [];
    j = 1;
    while (j < selection_num + 1)
        random_fitness = rand(1)*crit_func_inv_sum;
        
        for k = 1:length(crit_func)
            fitness_sum = sum(crit_func_inv(1:k));
            %if (fitness_sum > random_fitness);
            if ((fitness_sum >= random_fitness) & (0 == sum(ismember(selected_chromosomes_index, k))))
                selected_chromosomes_index(j) = k;
                j = j + 1;
                break
            end
        end
    end
         
    %matrika izbrancev
    selected_chromosomes = [];
    for j = 1:length(selected_chromosomes_index)
        selected_chromosomes(j,:) = chromosomes(selected_chromosomes_index(j),:);
    end
                     
    %križanje izbrancev - enotoèkovno križanje
    %izmed izbrancev sta nakljuèno izbrana dva razlièna starša, ki sta nato na
    %nakljuènem mestu razrezana ter zamenjana
    %funkcija sprejme matriko izbranih kromosomov ter štvilo otrok, ki jih
    %želimo od para staršev
    recombined_chromosomes = recombine(selected_chromosomes, 7);
        
    %vsak bit vsakega kromosoma ima verjetnost mutacije
    %to smo dosegli z funkcijo rand, ki ima enakomerno porazdelitev
    %tako prepreèimo stagnacijo populacije oz. prepreèimo da bi ostali v
    %lokalnemu minimumu kriterijske funkcije
    mutated_chromosomes = mutate(recombined_chromosomes, 0.01);
                  
    chromosomes = mutated_chromosomes;
    
    if (generation > 1000)
        fprintf("Meja iteriranja je dosežena.\n")
        break
    end
       
    generation = generation + 1; 
end
        