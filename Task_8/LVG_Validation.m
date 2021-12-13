clear all;
load data_lvq_A.mat;
load data_lvq_B.mat;

learningRate = 0.01;
n_folds = 10;
training_errors = zeros(1,n_folds);
test_errors = zeros(1,n_folds);

matA = matA(randperm(size(matA,1)),:);
matB = matB(randperm(size(matB,1)),:);

for i = 1:n_folds
    n_per_fold = length(matA) / n_folds;
    AData = cat(1,matA(1:(i-1)*n_per_fold,:),matA(i*n_per_fold:length(matA),:));
    BData = cat(1,matB(1:(i-1)*n_per_fold,:),matB(i*n_per_fold:length(matB),:));
    ATest = matA((i-1)*n_per_fold+1:i*n_per_fold,:);
    BTest = matB((i-1)*n_per_fold+1:i*n_per_fold,:);
    [training_errors(i), test_errors(i)] = VQL(AData,BData,2, 1,learningRate, ATest, BTest);
end


bar(training_errors);
yline(mean(test_errors),'-','Mean test errors','LineWidth',2);
text(1:length(training_errors),training_errors,num2str(training_errors'),'vert','bottom','horiz','center'); 
xlabel('k') 
ylabel('Error in %') 
box off
test_errors
mean(test_errors)


function [training_error, test_error] = VQL(matA,matB,n_prototypesA, n_prototypesB,learningRate, ATest, BTest)
    lowestError = inf;
    noChange = 0;
    maxEpochs = 300;
    allData = cat(1,matA,matB);
    [prototypesA, prototypesB] =  initPrototypes(n_prototypesA, n_prototypesB, allData );
    for i=1:maxEpochs
        for j=1:length(matA)
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
        for j=1:length(matB)
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

        error = calculateError(prototypesA,prototypesB,matA,matB);
 
        if error < lowestError
            lowestError = error;
            noChange = 0;
        else
            noChange = noChange +1;
        end
        if noChange > 30
            break
        end
    end
    training_error = round( (calculateError(prototypesA,prototypesB, matA, matB) / (length(matA) + length(matB)) ) * 100 , 2);
    test_error = round((calculateError(prototypesA,prototypesB, ATest, BTest) / (length(ATest) + length(ATest)) ) * 100 , 2);
end

function error = calculateError(prototypesA,prototypesB,dataA,dataB)
    error = 0;
    for i=1:length(dataA)
        [class,~] = classClosedPrototype(dataA(i,:),prototypesA,prototypesB);
        if class == 'B'
            error = error + 1;
        end
    end 
    for i=1:length(dataB)
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

%}









