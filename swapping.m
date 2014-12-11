%BEAR
%source = imread('/home/smparker/course/cs2951b/source_01.jpg');
%target = imread('/home/smparker/course/cs2951b/target_01.jpg');


%BALLOON
%source = imread('/home/smparker/course/cs2951b/onion.JPG');
%target = imread('/home/smparker/course/cs2951b/hotairballoon.JPG');

%bearfish
%source = imread('/home/smparker/course/cs2951b/bird.jpeg');
%target = imread('/home/smparker/course/cs2951b/bearfish.jpeg');

%resize
%deltx = size(source,2) - size(target,2);
%delty = size(source,1) - size(target,1);

%VASE
source = imread('/home/smparker/course/cs2951b/vasescale.jpg');
target = imread('/home/smparker/course/cs2951b/coffeetable.jpg');

%if abs(deltx) > abs(delty)
%    if deltx < 0
%        target = imresize(target, [NaN, abs(deltx)]);
%    else
%        source = imresize(source, [NaN, deltx]);
%    end
%else
%    if delty <0
%        target = imresize(target, [abs(delty), NaN]);
%    else
%        source = imresize(source, [delty, NaN]);
%    end
%end

[mask_source, mask_source_box] = mask_gen_interactive(source);
mask_source = single(mask_source);

[mask_target, mask_target_box] = mask_gen_interactive(target);
mask_target = single(mask_target);


figure, imshow(swap(source, mask_source, mask_source_box, target, mask_target, mask_target_box));



