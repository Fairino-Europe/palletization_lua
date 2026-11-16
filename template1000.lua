--------------------------------------------
-- pick1 point
-- for 0 and 180 deg
--
-- pick2 point
-- for 90 and 270 deg
--
-- pick3 point
-- for 0 and 180 deg input 90 deg`
--
-- pick4 point
-- for 90 and 270 deg input 90 deg
--
P_pallet_coord_tmp = {}
P_pallet_coord_L = {}
P_pallet_coord_R = {}
--------------------------------------------
-- paletization table
function fill_pallet_coord()
  count_l = count_x * count_y
  count_p = count_l * count_z
  -- copy coordinates
  for l = 0,count_z - 1 do
    for i = 0,count_l - 1 do
      index = l * count_l + i
      -- left pallet
      p_offset_x = pallet_offset_x + box_coord_L[index].offset_x
      p_offset_y = pallet_offset_y + box_coord_L[index].offset_y
      p_offset_z = pallet_offset_z + box_coord_L[index].offset_z
      p_rot_z = box_coord_L[index].rot_z
      p_pick_p = 1
      if (p_rot_z == 180) then
        p_pick_p = 2
        p_rot_z = 0
      elseif (p_rot_z == 270) then
        p_pick_p = 2
        p_rot_z = 90
      end
      P_pallet_coord_L[index] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
      -- right pallet
      p_offset_x = pallet_size_x - (pallet_offset_x + box_coord_R[index].offset_x)
      p_offset_y = pallet_size_y - (pallet_offset_y + box_coord_R[index].offset_y)
      p_offset_z = pallet_offset_z + box_coord_R[index].offset_z
      p_rot_z = box_coord_R[index].rot_z
      p_pick_p = 2
      if (p_rot_z == 180) then
        p_pick_p = 1
        p_rot_z = 0
      elseif (p_rot_z == 270) then
        p_pick_p = 1
        p_rot_z = 90
      end
      P_pallet_coord_R[index] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
    end
  end
end
