--------------------------------------------
-- L side labels
--------------------------------------------
-- preprocessing
function preprocess()
  -- generate angles - rotate odd rows
  for i = 0,count_y-1 do
    extra_rot_z[i * count_x + count_x - 1 + 1] = 270
  end
  -- generate sequence
  for i = 0,count_x-1 do
    for j = 0,count_y-1 do
      pallet_seq_L[i * count_y + j + 1] = (count_y - 1 - j) * count_x + count_x - 1 - i
      pallet_seq_R[i * count_y + j + 1] = (count_y - 1 - j) * count_x + i
    end
  end
end
