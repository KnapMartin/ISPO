function [gbest, fg_best] = PSOconstriction(net, training_pop, training_pop_target, num_of_iter, c1, c2, print_complete)
%PSO s faktorjem omejitve
%PSO optimizacija uteži nevronske mreže

num_of_parts = round(10 + 2*sqrt(size(training_pop,1)));

%omejevanje obmoèja/hitrosti
x_max = 9;
x_min = -x_max;
x_range = x_max - x_min;
v_max = x_range/5; v_min = -v_max;

net_weights = getwb(net);
num_of_net_weights = size(net_weights, 1);

%inicializacija pozicije ter hitrosti delcev
part_pos = rand(num_of_parts, num_of_net_weights)*x_range - x_max;
part_vel = rand(num_of_parts, num_of_net_weights)*v_max;
%imamo 21 delcev, vsak ima 97 uteži

pbest = zeros(num_of_parts, num_of_net_weights);
f_best = [];
for i = 1:num_of_parts
    net = setwb(net, part_pos(i,:));
    yest = net(training_pop);
    %mse cenilnka: (mse_calc = sum((yest-targets).^2)/length(yest))
    mse = sum((yest - training_pop_target).^2)/length(yest); %min -> najboljši delec
    f_best = [f_best, mse];%vrednost krit. funk. za vsak delec 
    pbest(i, :) = part_pos(i, :);
end

%pbest - pozicije vseh delcev
%f_best - vrednosti krit. funk.
%gbest - pozicija najboljšega delca
%fg_best - vrednost krit. funk. najboljšega delca

[fg_best, index_best] = min(f_best);
gbest = pbest(index_best, :); %pozicija najboljšega delca

%konec pso inicializacije, zaèetek iteriranja
%c1 - faktor pospeševanja
%c2 - faktor pospeševanja v roj
fi = c1 + c2;
kappa = 2/abs(2 - fi -sqrt(fi*(fi - 4)));

if (fi < 4)
    disp('Podaj veèja c1 in c2 (c1 + c2 > 4)!');
    pause;
end

for j = 1:num_of_iter
    for i = 1:num_of_parts
        random_vel1 = rand(1, num_of_net_weights)*x_range - x_max;%dela bolje
        random_vel2 = rand(1, num_of_net_weights)*x_range - x_max;
        %random_vel1 = rand(1, num_of_net_weights);
        %random_vel2 = rand(1, num_of_net_weights);
        
        part_vel(i, :) = kappa*(part_vel(i, :) + c1*random_vel1.*(pbest(i, :) - part_pos(i, :)) + c2*random_vel2.*(gbest - part_pos(i, :)));
        part_pos(i, :) = part_pos(i, :) + part_vel(i, :);
        %èe poz izven dop. obmoèja -> delec na mejo, hitrost na niè
        %èe vel izven dop. obmoèja -> hitrost na niè
        for k = 1:num_of_net_weights
            %omejitev pozicije
            if (part_pos(i, k) > x_max)
                part_pos(i, k) = x_max/2;
                part_vel(i, k) = 0;
            end
            if (part_pos(i, k) < x_min)
                part_pos(i, k) = x_min/2;
                part_vel(i, k) = 0;
            end
            %omejitev hitrosti
            if (part_vel(i, k) > v_max)
                part_vel(i, k) = 0;
            end
            if (part_vel(i, k) < v_min)
                part_vel(i, k) = 0;
            end
        end
        %raèunanje krit. funk za vsak delec
        net = setwb(net, part_pos(i, :));
        yest = net(training_pop);
        fitness(i) = sum((yest - training_pop_target).^2)/length(yest);        
        
        %èe je krit. funk. delca boljša od obstojeèe jo zamenjaj
        %zamenjaj tudi njegovo najboljšo pozicijo
        if (fitness(i) < f_best(i))
            f_best(i) = fitness(i);
            pbest(i, :) = part_pos(i, :);
        end           
    end
    
    %izloèevanje delca z najboljšo pozicijo oz. vrednosjo krit. funk
    if (min(f_best) < fg_best)
        [fg_best, index_best] = min(f_best);
        gbest = pbest(index_best, :);
    end
    if (print_complete == 1)
        complete = (j/num_of_iter)*100;
        fprintf('Dokonèano: %2.1f %%\n', complete);
    end
end
end