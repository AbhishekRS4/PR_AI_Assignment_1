minHD = 1;
ID = 0;
test = load('testperson.mat');
test_iris = test.iriscode;
for i = 1:20
    p = person(i).iriscode;
    for r = 1:20
        counter = 0;
        HD = 0;
        for j = 1:30;
            if(test_iris(j)==2)
                counter = counter + 1;
            else
                HD = HD + xor(test_iris(j), p(r,j));
            end
        end
        HD = HD/(30-counter);
        if(HD < minHD)
            minHD = HD;
            ID = i;
        end
    end
end
minHD
ID

