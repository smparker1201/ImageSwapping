function mask = subtract_masks(mask_target, target_bounds, mask_source)
%finds the holes that would exist after pasting the source object
%on top of the hole of object to be swapped out. This is to be used for
%inpainting
temp_targ_mask = mask_target(target_bounds(3):target_bounds(4), target_bounds(1): target_bounds(2));
mask = (~temp_targ_mask) .* (~mask_source);
mask_target(target_bounds(3):target_bounds(4), target_bounds(1): target_bounds(2)) = ~mask;
mask = mask_target;

end

