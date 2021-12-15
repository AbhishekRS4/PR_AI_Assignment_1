% compute set S
SH_distances = zeros(1000,1);
 
for idx = 1:1000
    
    % generate a random person number
    random_person = int32(1 + 19*rand(1,1));
    name_person = sprintf('person%02d.mat',random_person);
    % load the files
    person = load(name_person);
    person_codes = person.iriscode;
    
    % generate two different random row numbers
    random_row_1 = int32(1 + 19*rand(1,1));
    random_row_2 = int32(1 + 19*rand(1,1));
    while random_row_1 == random_row_2
        random_row_2 = int32(1 + 19*rand(1,1));
    end
    
    % calculate the HD
    SH_distances(idx) = sum(xor(person_codes(random_row_1,:), person_codes(random_row_2,:)))/30;
    
end

% compute set D
DH_distances = zeros(1000,1);
 
for idx = 1:1000
    
    % generate two different random person numbers
    random_person1 = int32(1 + 19*rand(1,1));
    random_person2 = int32(1 + 19*rand(1,1));
    while random_person1 == random_person2
        random_person2 = int32(1 + 19*rand(1,1));
    end
    
    name_person1 = sprintf('person%02d.mat',random_person1);
    % load the files
    person1 = load(name_person1);
    person1_codes = person1.iriscode;
    
    name_person2 = sprintf('person%02d.mat',random_person2);
    % load the files
    person2 = load(name_person2);
    person2_codes = person2.iriscode;
    
    % generate two random row numbers
    random_row_person_1 = int32(1 + 19*rand(1,1));
    random_row_person_2 = int32(1 + 19*rand(1,1));
    
    % calculate the HD
    DH_distances(idx) = sum(xor(person1_codes(random_row_person_1,:), person2_codes(random_row_person_2,:)))/30;
    
end

% plot the distances in the same histogram
h1 = histogram(SH_distances, 'BinWidth', 0.03);
hold on
h2 = histogram(DH_distances, 'BinWidth', 0.03);
title('Similar HDs compared to Different HDs');
legend('Similar HDs', 'Different HDs');
xlabel('Distance');
ylabel('Frequency');
