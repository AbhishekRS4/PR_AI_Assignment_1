clear all;
load data_lvq_A.mat;
load data_lvq_B.mat;

learningRate = 0.01;
global experiment_number;
experiment_number = 1;

Errors_1_1 = VQL(matA,matB,1, 1,learningRate);
experiment_number = experiment_number + 1;
Errors_1_2 = VQL(matA,matB,1, 2,learningRate);
experiment_number = experiment_number + 1;
Errors_2_1 = VQL(matA,matB,2, 1,learningRate);
experiment_number = experiment_number + 1;
Errors_2_2 = VQL(matA,matB,2, 2,learningRate);
experiment_number = experiment_number + 1;

figure(experiment_number);
plot(1:length(Errors_1_1),Errors_1_1);
hold on
plot(1:length(Errors_1_2),Errors_1_2);
hold on
plot(1:length(Errors_2_1),Errors_2_1);
hold on
plot(1:length(Errors_2_2),Errors_2_2);
hold on


legend('One A-prototype, One B-Prototype','One A-prototype, Two B-Prototype','Two A-prototype, One B-Prototype','Two A-prototype, Two B-Prototype');
hold off

function errors = VQL(matA,matB,n_prototypesA, n_prototypesB,learningRate)
    lowestError = inf;
    noChange = 0;
    maxEpochs = 300;
    n_prototypesA
    n_prototypesB
    errors = [];
    allData = cat(1,matA,matB);
    [prototypesA, prototypesB] =  initPrototypes(n_prototypesA, n_prototypesB, allData );
    for i=1:maxEpochs
        for j=1:100
            [class,index] =  classClosedPrototype(matA(j,:),prototypesA,prototypesB);
            if class == 'A'
                direction = matA(j,:) - prototypesA(index,:);
                direction = direction / norm(direction);
                prototypesA(index,:) = prototypesA(index,:) + learningRate*direction; 
            else
                direction = prototypesB(index,:) - matB(j,:);
                direction = direction / norm(direction);
                prototypesB(index,:) = prototypesB(index,:) + learningRate*direction; 
            end   
        end
        for j=1:100
            [class,index] =  classClosedPrototype(matB(j,:),prototypesA,prototypesB);
            if class == 'B'
                direction = matB(j,:) - prototypesB(index,:);
                direction = direction / norm(direction);
                prototypesB(index,:) = prototypesB(index,:) + learningRate*direction; 
            else
                direction = prototypesA(index,:) - matB(j,:);
                direction = direction / norm(direction);
                prototypesA(index,:) = prototypesA(index,:) + learningRate*direction; 
            end   
        end
        errors(i) = calculateError(prototypesA,prototypesB,matA,matB) / 200;
        if errors(i) < lowestError
            lowestError = errors(i);
            noChange = 0;
        else
            noChange = noChange +1;
        end
        if noChange > 30
            break
        end
    end

    showScatterGraph(matA,matB,prototypesA,prototypesB);
end
function showScatterGraph(matA,matB,prototypesA,prototypesB)
    classAtrue_x= [];
    classAfalse_x = [];
    classBtrue_x = [];
    classBfalse_x = [];
    classAtrue_y = [];
    classAfalse_y = [];
    classBtrue_y = [];
    classBfalse_y = [];
    for j=1:100
        [class,~] =  classClosedPrototype(matA(j,:),prototypesA,prototypesB);
        if class == 'A'
            classAtrue_x(end+1) = matA(j,1);
            classAtrue_y(end+1) = matA(j,2);
        else
            classAfalse_x(end+1) = matA(j,1);
            classAfalse_y(end+1) = matA(j,2);
        end   
    end
    for j=1:100
        [class,~] =  classClosedPrototype(matB(j,:),prototypesA,prototypesB);
        if class == 'A'
            classBfalse_x(end+1) = matB(j,1);
            classBfalse_y(end+1) = matB(j,2);
        else
            classBtrue_x(end+1) = matB(j,1);
            classBtrue_y(end+1) = matB(j,2);
        end      
    end
    
    global experiment_number
    figure(experiment_number);
    scatter(classAtrue_x, classAtrue_y,'MarkerFaceColor',[1 0 0]);
    hold on
    scatter(classAfalse_x, classAfalse_y,'d','MarkerFaceColor',[1 0 0]);
    hold on
    scatter(classBfalse_x, classBfalse_y,'MarkerFaceColor',[0 0 1]);
    hold on
    scatter(classBtrue_x, classBtrue_y,'d','MarkerFaceColor',[0 0 1]);
    hold on
    
    scatter(prototypesA(:,1),prototypesA(:,2),150,'MarkerEdgeColor',[0 0 0],...
                  'MarkerFaceColor',[1 0 0],...
                  'LineWidth',3)
    hold on
    scatter(prototypesB(:,1),prototypesB(:,2),150,'d','MarkerEdgeColor',[0 0 0],...
                  'MarkerFaceColor',[0 0 1],...
                  'LineWidth',3)
    xlabel('Epoch')
    ylabel('E')
    legend('class A classified as A', 'class A classified as B','class B classified as A','class B classified as B','Prototypes for class A', 'Prototypes for class B')
    hold off
end

function error = calculateError(prototypesA,prototypesB,dataA,dataB)
    error = 0;
    for i=1:100
        [class,~] = classClosedPrototype(dataA(i,:),prototypesA,prototypesB);
        if class == 'B'
            error = error + 1;
        end
    end 
    for i=1:100
        [class,~] = classClosedPrototype(dataB(i,:),prototypesA,prototypesB);
        if class == 'A'
            error = error + 1;
        end
    end 
end

function [class,index] = classClosedPrototype(point,prototypesA,prototypesB)
    minDistance = inf;
    for i=1:size(prototypesA)
        if norm(prototypesA(i,:)-point) < minDistance
            minDistance = norm(prototypesA(i,:)-point);
            class = 'A';
            index = i;
        end
    end
    for i=1:size(prototypesB)
        if norm(prototypesB(i,:)-point) < minDistance
            minDistance = norm(prototypesB(i,:)-point);
            class = 'B';
            index=i;
        end
    end
end

function [prototypesA, prototypesB] =  initPrototypes(n_prototypesA, n_prototypesB, allData)
    prototypesA = [0 0];
    prototypesB = [0 0];

    mean_x = mean(allData(:,1));
    mean_y = mean(allData(:,2));
    se_x = std(allData(:,1)) / sqrt(length(allData(:,1)));
    se_y = std(allData(:,2)) / sqrt(length(allData(:,2)));
    for i=1:n_prototypesA
        prototypesA(i,1) = mean_x + se_x*randn();
        prototypesA(i,2) = mean_y + se_y*randn();
    end
    for i=1:n_prototypesB
        prototypesB(i,1) = mean_x + se_x*randn();
        prototypesB(i,2) = mean_y + se_y*randn();
    end
end









