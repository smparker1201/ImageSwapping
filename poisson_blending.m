function [filled, A] = poisson_blending(source, target, mask, A)
%UNTITLED Summary of this function goes here
%   assumes target is a cropped portion of full target image with the same
% dimensions as source and mask. 
source = single(source);
target = single(target);

%apply mask and filters
inds = transpose(find(mask));
laplacian_filter = [0, 1, 0; 1, -4, 1; 0, 1, 0];
filtered_source = imfilter(source, laplacian_filter);
target(inds) = 0;

%these will be the solutions to the systems of equations taking into
%account all known values
updated_source = filtered_source - (mask.*(imfilter(target, laplacian_filter)));

%righthand side of system
b = double(updated_source(inds));

%number of pixels to fill
num_pix = length(inds);

if isnan(A)
    %2xnum_pix subscripts
    subs = subscript(inds, size(mask, 1));

    right = index([subs(1,:)+1; subs(2,:)], size(mask,1));
    left = index([subs(1, :)-1; subs(2,:)], size(mask,1));
    top = index([subs(1,:); subs(2,:)+1], size(mask,1));
    bot = index([subs(1, :); subs(2,:)-1], size(mask,1));

    fin = [left,right,top,bot];
    pixel_cols = [1:num_pix, 1:num_pix, 1:num_pix, 1:num_pix];
    [membs, inds_indices] = ismember(fin,inds);

    %Create sparse matrix
    sparse_i = pixel_cols(membs);
    sparse_j = inds_indices(find(inds_indices));
    sparse_s = ones(size(sparse_i));
    sparse_matrix = sparse(sparse_i, sparse_j, sparse_s, num_pix, num_pix);
    A = (sparse_matrix + sparse(diag(-4*ones(1, num_pix))));
end
x = full(A \ sparse(transpose(b)));

%clamping
x(x<0) = 0;
x(x>255) = 255;

target(inds) = x;
filled = uint8(target);

end

%where M is from MxN matrix
function sub = subscript(ind_vec, M)
    sub = [rem(ind_vec-1, M)+1; floor((ind_vec-1)/M)+1];
end

function ind = index(sub_vec, M)
    ind = (sub_vec(1,:) + (sub_vec(2,:)-1)*M);
end
