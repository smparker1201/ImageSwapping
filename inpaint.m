function inpainted = inpaint(image, mask)
%performs inpainting to fix mismatches in swapped object outlines

%make mask to create holes in the image
inds = find(mask);
mask = ~mask;
image = uint8(single(image).*mask);
compare = uint8(zeros(size(image)));
prev = compare;

while ~isequal(uint8(image-prev), compare)
   prev = image;
   temp = imfilter(prev, fspecial('gaussian', [10,10], 10));
   image(inds) = temp(inds);
end

inpainted = imfilter(image, fspecial('gaussian'));
inpainted = image;


end

