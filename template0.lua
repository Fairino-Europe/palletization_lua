P_pallet_coord_L = {}
P_pallet_coord_R = {}
--------------------------------------------
-- paletization table
function fill_pallet_coord()
  count_l = count_x * count_y
  count_p = count_l * count_z
  for l = 0,count_z - 1 do
    for i = 0,count_l - 1 do
      P_pallet_coord_L[l * count_l + i] = { offset_x = 0, offset_y = 0, offset_z = 0, rot_z = 0, pick_p = 0 }
      P_pallet_coord_R[l * count_l + i] = { offset_x = 0, offset_y = 0, offset_z = 0, rot_z = 0, pick_p = 0 }
    end
  end
end