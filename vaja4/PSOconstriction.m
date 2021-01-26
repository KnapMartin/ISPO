function [gbest, fg_best] = PSOconstriction(net, training_pop, training_pop_target, num_of_iter, c1, c2, print_complete)
%PSO s faktorjem omejitve
%PSO optimizacija ute�i nevronske mre�e

num_of_parts = round(10 + 2*sqrt(size(training_pop,1)));

%omejevanje obmo�ja/hitrosti
x_max = 9;
x_min = -x_max;
x_range = x_max - x_min;
v_max = x_range/5; v_min = -v_max;

net_weights = getwb(net);
num_of_net_weights = size(net_weights, 1);

%inicializacija pozicije ter hitrosti delcev
part_pos = rand(num_of_parts, num_of_net_weights)*x_range - x_max;
part_vel = rand(num_of_parts, num_of_net_weights)*v_max;
%imamo 21 delcev, vsak ima 97 ute�i

pbest = zeros(num_of_parts, num_of_net_weights);
f_best = [];
for i = 1:num_of_parts
    net = setwb(net, part_pos(i,:));
    yest = net(training_pop);
    %mse cenilnka: (mse_calc = sum((yest-targets).^2)/length(yest))
    mse = sum((yest - training_pop_target).^2)/length(yest); %min -> najbolj�i delec
    f_best = [f_best, mse];%vrednost krit. funk. za vsak delec 
    pbest(i, :) = part_pos(i, :);
end

%pbest - pozicije vseh delcev
%f_best - vrednosti krit. funk.
%gbest - pozicija najbolj�ega delca
%fg_best - vrednost krit. funk. najbolj�ega delca

[fg_best, index_best] = min(f_best);
gbest = pbest(index_best, :); %pozicija najbolj�ega delca

%konec pso inicializacije, za�etek iteriranja
%c1 - faktor pospe�evanja
%c2 - faktor pospe�evanja v roj
fi = c1 + c2;
kappa = 2/abs(2 - fi -sqrt(fi*(fi - 4)));

if (fi < 4)
    disp('Podaj ve�ja c1 in c2 (c1 + c2 > 4)!');
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
        %�e poz izven dop. obmo�ja -> delec na mejo, hitrost na ni�
        %�e vel izven dop. obmo�ja -> hitrost na ni�
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
        %ra�unanje krit. funk za vsak delec
        net = setwb(net, part_pos(i, :));
        yest = net(training_pop);
        fitness(i) = sum((yest - training_pop_target).^2)/length(yest);        
        
        %�e je krit. funk. delca bolj�a od obstoje�e jo zamenjaj
        %zamenjaj tudi njegovo najbolj�o pozicijo
        if (fitness(i) < f_best(i))
            f_best(i) = fitness(i);
            pbest(i, :) = part_pos(i, :);
        end           
    end
    
    %izlo�evanje delca z najbolj�o pozicijo oz. vrednosjo krit. funk
    if (min(f_best) < fg_best)
        [fg_best, index_best] = min(f_best);
        gbest = pbest(index_best, :);
    end
    if (print_complete == 1)
        complete = (j/num_of_iter)*100;
        fprintf('Dokon�ano: %2.1f %%\n', complete);
    end
end
end