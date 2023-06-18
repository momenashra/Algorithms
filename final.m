%%initialization 
generations=100;
population=6;
gens=4;
crossover_rate=0.25;
disp("*********************************start*************************************");
chromosme = [2     5    17     1
            10     4    13    14
            12     5    23     2
            20     4    13    14
            10     5    18     3
            20     1    10     6];
            chromosme=randi([0, 30], population, gens);
plt=[];
generations_loop=[];
for loop=1:generations
            a=chromosme(:, 1)';
            b=chromosme(:, 2)';
            c=chromosme(:, 3)';
            d=chromosme(:, 4)';
            F_obj=abs((a + 2*b + 3*c + 4*d) - 30)';
            %%
            %SELECTION
            fitness=1./(1+F_obj(:,1));
            total=sum(fitness);
            p=fitness./total;
            commulated=zeros(1,population);
            %roulette wheel
            for i = 1:length(p)
                z=0;
                for j=1:i
                 z=z+(p(j));
                end
                commulated(i) =z ;
            end
            commulated=commulated';
            R = rand(population, 1);
%           R=[0.201, 0.284,0.099,0.822,0.398,0.501]';
            new_c=zeros(population,gens);
            for i = 1:population
                    for j = 1:population
                        if ((j+1<population+1))
                           if R(i)>commulated(j) && R(i)<commulated(j+1)
                              new_c(i,:)=chromosme(j+1,:);
                              break;
                           end
                        new_c(i,:)=chromosme(1,:); 
                        else
                            new_c(i,:)=chromosme(1,:) ;
                        end
                    end
            
            end
            % select Chromosome 
            chromosme=new_c;
%%
            %cross over
            k = 1;
            numParents=0
%            generate random number 
            R=rand(population,1)
%           R=[0.191,0.259,0.760,0.006,0.159,0.340];
            parents=[];
            chrom_number=[];
             %First we generate a random number R as the number of population.
             %Chromosome k will be selected as a parent if R[k]<Ïc 
            while k < population
                if R(k) < crossover_rate
                    parent = chromosme(k,:);
                    parents = [parents; chromosme(k,:)]; 
                    disp(['Selected Chromosome ', num2str(k), ' as parent']);
                    chrom_number = [chrom_number; k]; 
                    numParents=numParents+1;
            
                end
                k = k + 1;
            end
            
            %we make crossover in circular way 1->4 4->5  5->1
            
            crossover_point=randi([1, gens-1],1,numParents);
%           crossover_point=[1,1,2];
            
            offsprings=zeros(numParents,gens);
%            we make crossover in circular way 1->4 4->5  5->1
            for i = 1:numParents
                parent1 = parents(i, :);
                parent2 = parents(mod(i, numParents)+1, :);
                
                offsprings(i, :) = [parent1(1:crossover_point(i)), parent2(crossover_point(i)+1:end)];
                chromosme(chrom_number(i),:)=offsprings(i, :);
            end    
            %%
            %mutation
            mutation_rate=0.1;
            total_gen = gens *population;
            number_of_mutations=floor(total_gen*mutation_rate);
            mutation_number=randi([0,30 ],number_of_mutations,1);
%           mutation_number=[2,5];
            mut_pos=randi([1,total_gen],number_of_mutations,1);
%           mut_pos=[12,18];
            mut_chr=ceil(mut_pos./4);
            mut_gen_reversed=mut_chr.*gens-mut_pos;
            mut_gen=4-mut_gen_reversed;
            for z=1:number_of_mutations
                chromosme(mut_chr(z),mut_gen(z))=mutation_number(z);
            end
            a=chromosme(:, 1)';
            b=chromosme(:, 2)';
            c=chromosme(:, 3)';
            d=chromosme(:, 4)';
            Z_obj=abs((a + 2.*b + 3.*c + 4.*d)-30)
            plt(loop) = [min(Z_obj)];
            generations_loop(loop)=[loop];
            
end

% Plot the vector
figure;
plot(generations_loop, plt);  % Plot with blue color and circle markers

% Add labels and title to the plot
xlabel('Generation');
ylabel('Min cost');
titleString = ['Loop over ', num2str(generations),' Generations'];
title(titleString);
