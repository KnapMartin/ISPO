function [recombined_chromosomes] = mutate(recombined_chromosomes, mutation_chance)

%vsak bit vsakega kromosoma ima verjetnost mutacije
%to smo dosegli z funkcijo rand, ki ima enakomerno porazdelitev
%tako prepreèimo stagnacijo populacije oz. prepreèimo da bi ostali v
%lokalnemu minimumu kriterijske funkcije
for j = 1:length(recombined_chromosomes(:,1))
    for k = 1:length(recombined_chromosomes(1,:))
        RNG = rand(1);
        if (RNG <= mutation_chance)
            %èe je pogoj za mutacijo izpolnjen se izvede invertacija bita
            if (recombined_chromosomes(j, k) == 0)
                recombined_chromosomes(j, k) = 1;
            end
            if (recombined_chromosomes(j, k) == 1)
                recombined_chromosomes(j, k) = 0;
            end
        end
    end
end

end