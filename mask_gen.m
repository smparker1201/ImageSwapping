function [mask_im, mask_box] = mask_gen_auto(segments, source)
%generates a  binary mask based on a set of line segments

segment_inds = [1:length(segments)];
x = segments(mod(segment_inds, 2) == 1);
y = segments(mod(segment_inds, 2) == 0);

mask_im = roipoly(source, y, x);
minx = min(xi) -2;
maxx = max(xi) + 2;
miny = min(yi) -2;
maxy = max(yi) + 2;

if minx < 1
   maxx = maxx + (1 - minx);
   assert(maxx <= size(source, 2), 'object too large');
   minx = 1; 
end

if maxx > size(source, 2)
   minx = minx - (maxx - size(source, 2)); 
   assert(minx >= 1, 'object too large');
   maxx = size(source, 2);
    
end

if miny < 1
   maxy = maxy + (1 - miny);
   assert(maxy <= size(source, 1), 'object too large');
   miny = 1; 
end

if maxy > size(source, 1)
   miny = miny - (maxy - size(source, 1)); 
   assert(miny >= 1, 'object too large');
   maxy = size(source, 1);
end

mask_box = [minx, maxx, miny, maxy, int16(floor(mean([minx, maxx]))), int16(floor(mean([miny, maxy])))];

end

