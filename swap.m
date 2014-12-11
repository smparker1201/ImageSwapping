function [swapped_im] = swap(source_im, source_mask, source_box, target_im, target_mask, target_box)
%Given an image and a mask which is the same size as the image, delete the
%object within the mask and fill hole with image content to make it easy to
%blend an object on top of it. 

%delete old target object from image
target_bounds = align(source_box, target_box, size(target_im));
mask = source_mask(source_box(3):source_box(4), source_box(1):source_box(2));
source = source_im(source_box(3):source_box(4), source_box(1):source_box(2), :);

inpaint_mask = subtract_masks(target_mask, target_bounds, mask);


if length(size(source_im)) == 3 && length(size(target_im)) ==3
    masked_target_im = uint8(cat(3, inpaint(target_im(:, :, 1), inpaint_mask), inpaint(target_im(:, :, 2), inpaint_mask), inpaint(target_im(:, :, 3), inpaint_mask)));
    target = masked_target_im(target_bounds(3):target_bounds(4), target_bounds(1): target_bounds(2), :);
    [ch1, A] = poisson_blending(source(:,:,1), target(:,:,1), mask, NaN);
    ch2 = poisson_blending(source(:,:,2), target(:,:,2), mask, A);
    ch3 = poisson_blending(source(:,:,3), target(:,:,3), mask, A);
    final_image = cat(3, ch1, ch2, ch3);
    
else
    masked_target_im = single(target_im) .* (~target_mask);
    target = masked_target_im(target_bounds(3):target_bounds(4), target_bounds(1): target_bounds(2));
    final_image = poisson_blending(source, target, mask, NaN);
end

masked_target_im(target_bounds(3):target_bounds(4), target_bounds(1):target_bounds(2), :) = final_image;

swapped_im = masked_target_im;
%todo inpainting
%imshow(swapped_im);

end



function coors = align(sourceb, targetb, target_size)

target_center = [targetb(5), targetb(6)];
source_center = [sourceb(5), sourceb(6)];

x1 = target_center(1) - (source_center(1) - sourceb(1));
x2 = target_center(1) + (sourceb(2)-source_center(1));
y1 = target_center(2) - (source_center(2) - sourceb(3));
y2 = target_center(2) + (sourceb(4)-source_center(2));

if x1 < 1
   x2 = x2 + (1 - x1);
   assert(x2 <= target_size(2), 'Target object too large');
   x1 = 1; 
end

if x2 > target_size(2)
   x1 = x1 - (x2 - target_size(2)); 
   assert(x1 >= 1, 'Target object too large');
   x2 = target_size(2);
    
end

if y1 < 1
   y2 = y2 + (1 - y1);
   assert(y2 <= target_size(1), 'Target object too large');
   y1 = 1; 
end

if y2 > target_size(1) 
   y1 = y1 - (y2 - target_size(1)); 
   assert(y1 >= 1, 'Target object too large');
   y2 = target_size(1);
end

coors = [x1, x2, y1, y2];
end