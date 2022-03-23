% Another solution
% function [result] = ComputeAdjacency(x, csvFilePath)
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
%     inputArray = csvread(csvFilePath);
%     disp('inputArray =');
%     disp(inputArray);
%     if x == 4
%         [newArray, result] = bwlabel(inputArray, 4);
%         disp('newArray =');
%         disp(newArray);
%     else 
%         [newArray, result] = bwlabel(inputArray, 8);
%         disp('newArray =');
%         disp(newArray);
%     end
% end


function [ result ] = ComputeAdjacency( x,csvFilePath )
    data=csvread(csvFilePath);
    disp("inputArray=");
    disp(data);
    if (x == 4)    
        connectivity = 4;
    else
        connectivity = 8;
    end

    [x1,y1] = size(data);
    data = [zeros(1,y1+2);[zeros(x1,1) data zeros(x1,1)]];
    [x1,y1] = size(data);

    newArray = zeros(size(data));
    nextlabel = 1;
    linked = [];

    for i = 2:x1                       % for each row
        for j = 2:y1-1                 % for each column
            if data(i,j) ~= 0         % not background
                % find binary value of neighbours
                if (connectivity == 8)
                    neighboursearch = [data(i-1,j-1), data(i-1,j), data(i-1,j+1),data(i,j-1)];
                elseif (connectivity == 4)
                    neighboursearch = [data(i-1,j),data(i,j-1)];
                end

                % search for neighbours with binary value 1
                [~,n,neighbours] = find(neighboursearch==1);

                % if no neighbour is allready labeled: assign new label
                if isempty(neighbours)
                    linked{nextlabel} = nextlabel;
                    newArray(i,j) = nextlabel;
                    nextlabel = nextlabel+1;                

                % if neighbours is labeled: pick the lowest label and store the
                % connected labels in "linked"
                else
                    if (connectivity == 8)
                        neighboursearch_label = [newArray(i-1,j-1), newArray(i-1,j), newArray(i-1,j+1),newArray(i,j-1)];
                    elseif (connectivity == 4)
                        neighboursearch_label = [newArray(i-1,j), newArray(i,j-1)];
                    end
                    L = neighboursearch_label(n);
                    newArray(i,j) = min(L);
                    for k = 1:length(L)
                        label = L(k);
                        linked{label} = unique([linked{label} L]);
                    end                
                end
            end
        end
    end

    % remove the previous expansion of the image
    newArray = newArray(2:end,2:end-1);


    change2 = 1;
    while change2 == 1
        change = 0;
        for i = 1:length(linked)
            for j = 1:length(linked)
                if i ~= j
                    if sum(ismember(linked{i},linked{j}))>0 && sum(ismember(linked{i},linked{j})) ~= length(linked{i})
                        change = 1;
                        linked{i} = union(linked{i},linked{j});
                        linked{j} = linked{i};
                    end
                end
            end
        end

        if change == 0
            change2 = 0;
        end

    end

    % removing redundant links
    linked = unique(cellfun(@num2str,linked,'UniformOutput',false));
    linked = cellfun(@str2num,linked,'UniformOutput',false);

    K = length(linked);
    templabels = newArray;
    newArray = zeros(size(newArray));

    % label linked labels with a single label
    for k = 1:K
        for l = 1:length(linked{k})
            newArray(templabels == linked{k}(l)) = k;
        end
    end
        disp("newArray=");
        disp(newArray);
        result=k;

end