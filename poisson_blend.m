function filled = poisson_blend(source, target, mask)
%UNTITLED Summary of this function goes here
%   assumes target is a cropped portion of full target image with the same
% dimensions as source and mask. 

laplacian_filter = [0, 1, 0; 1, -4, 1; 0, 1, 0];
filtered_source = imfilter(source, laplacian_filter);
masked_target = target.*(~mask);
%these will be the solutions to the systems of equations taking into
%account all known values
updated_source = filtered_source - (mask.*(imfilter(masked_target, laplacian_filter)));
b = reshape(updated_source, [1, size(updated_source,1)*size(updated_source, 2)])
%non-zero vals
inds = find(mask);
num_pix = length(inds);
keyset = {inds};
valset = [1:num_pix];
%map from indicies from mask to indices in sparse matrix
map = containers.Map(keyset, valset);

%TODO: create sparse i and sparse j to finish poisson blending
sparse_i = [];
sparse_j = [];
%NOTE: look at arrayfun which applys a function to every element in an
%array


sparse_s = ones(size(sparse_i));
sparse_matrix = sparse(sparse_i, sparse_j, sparse_s, num_pix, num_pix);
x = sparse_matrix/b;


end

%where M is from MxN matrix
function sub = subscript(ind, M)
    sub = [rem(index-1, M)+1, floor(index/M)+1]
end

function ind = index(sub, M)
    ind = (sub(1) + (sub(2)-1)*M)
end
