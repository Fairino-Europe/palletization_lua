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
  count_l = count_x * count_y + count_x1 * count_y1
  count_p = count_l * count_z
  -- calculate coordinates
  pos_x = 0
  pos_y = 0
  psize_x = 0
  psize_y = 0
  pos_y_max = 0
  for j = 0,count_y-1 do
    pos_x = 0
    for i = 0,count_x-1 do
      index = j * count_x + i
      p_rot_z = extra_rot_z[index + 1]
      p_pick_p = 1
      if (p_rot_z == 0 or p_rot_z == 180) then
        p_offset_x = pos_x + size_x / 2
        p_offset_y = pos_y + size_y / 2
        pos_x = pos_x + size_x + gap_x
        pos = pos_y + size_y + gap_y
        if (pos > pos_y_max) then pos_y_max = pos end
        if (p_rot_z == 180) then
            p_pick_p = 2
            p_rot_z = 0
        end
      elseif (p_rot_z == 90 or p_rot_z == 270) then
        p_offset_x = pos_x + size_y / 2
        p_offset_y = pos_y + size_x / 2
        pos_x = pos_x + size_y + gap_x
        pos = pos_y + size_x + gap_y
        if (pos > pos_y_max) then pos_y_max = pos end
        if (p_rot_z == 270) then
            p_pick_p = 2
            p_rot_z = 90
        end
      end
      if (pick_point == 3) then
         p_pick_p = p_pick_p + 2
      end
      P_pallet_coord_tmp[index] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = 0, rot_z = p_rot_z, pick_p = p_pick_p }
    end
    pos = pos_x - gap_x
    if (pos > psize_x) then psize_x = pos end
    pos_y = pos_y_max
  end
  psize_y = pos_y - gap_y
  -- secondary pattern
  pos_y = shift_y1
  pos_y_max = shift_y1
  for j = 0,count_y1-1 do
    pos_x = shift_x1
    for i = 0,count_x1-1 do
      index = count_x * count_y + j * count_x1 + i
      p_rot_z = extra_rot_z[index + 1]
      p_pick_p = 1
      if (p_rot_z == 0 or p_rot_z == 180) then
        p_offset_x = pos_x + size_x / 2
        p_offset_y = pos_y + size_y / 2
        pos_x = pos_x + size_x + gap_x
        pos = pos_y + size_y + gap_y
        if (pos > pos_y_max) then pos_y_max = pos end
        if (p_rot_z == 180) then
            p_pick_p = 2
            p_rot_z = 0
        end
      elseif (p_rot_z == 90 or p_rot_Z == 270) then
        p_offset_x = pos_x + size_y / 2
        p_offset_y = pos_y + size_x / 2
        pos_x = pos_x + size_y + gap_x
        pos = pos_y + size_x + gap_y
        if (pos > pos_y_max) then pos_y_max = pos end
        if (p_rot_z == 270) then
            p_pick_p = 2
            p_rot_z = 90
        end
      end
      if (pick_point == 3) then
         p_pick_p = p_pick_p + 2
      end
      P_pallet_coord_tmp[index] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = 0, rot_z = p_rot_z, pick_p = p_pick_p }
    end
    pos = pos_x - gap_x
    if (pos > psize_x) then psize_x = pos end
    pos_y = pos_y_max
  end
  pos = pos_y - gap_y
  if (pos > psize_y) then psize_y = pos end
  -- calculater center
  if (pallet_center_x > 0) then
    pallet_center_x = (pallet_size_x - psize_x) / 2
  end
  if (pallet_center_y > 0) then
    pallet_center_y = (pallet_size_y - psize_y) / 2
  end
  pick_p_swap = { 2, 1, 4, 3 }
  -- apply sequence
  for l = 0,count_z - 1 do
    for i = 0,count_l - 1 do
      if (layer_rot[l + 1] == 180) then
        -- left pallet
        index = pallet_seq_L_rot[i + 1]
        p_offset_x = pallet_offset_x + pallet_center_x + psize_x - (P_pallet_coord_tmp[index].offset_x + extra_gap_x[index + 1])
        p_offset_y = pallet_offset_y + pallet_center_y + psize_y - (P_pallet_coord_tmp[index].offset_y + extra_gap_y[index + 1])
        p_offset_z = pallet_offset_z + size_z + l * (size_z + gap_z)
        p_rot_z = P_pallet_coord_tmp[index].rot_z
        p_pick_p = pick_p_swap[P_pallet_coord_tmp[index].pick_p] -- swap
        P_pallet_coord_L[l * count_l + i] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
        -- right pallet
        index = pallet_seq_R_rot[i + 1]
        p_offset_x = pallet_size_x - (pallet_offset_x + pallet_center_x + psize_x - (P_pallet_coord_tmp[index].offset_x + extra_gap_x[index + 1]))
        p_offset_y = pallet_size_y - (pallet_offset_y + pallet_center_y + psize_y - (P_pallet_coord_tmp[index].offset_y + extra_gap_y[index + 1]))
        p_offset_z = pallet_offset_z + size_z + l * (size_z + gap_z)
        p_rot_z = P_pallet_coord_tmp[index].rot_z
        p_pick_p = P_pallet_coord_tmp[index].pick_p
        P_pallet_coord_R[l * count_l + i] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
      elseif (layer_rot[l + 1] == 1) then
        -- left pallet
        index = pallet_seq_L_rot[i + 1]
        p_offset_x = pallet_offset_x + pallet_center_x + psize_x - (P_pallet_coord_tmp[index].offset_x + extra_gap_x[index + 1])
        p_offset_y = pallet_offset_y + pallet_center_y + P_pallet_coord_tmp[index].offset_y + extra_gap_y[index + 1]
        p_offset_z = pallet_offset_z + size_z + l * (size_z + gap_z)
        p_rot_z = P_pallet_coord_tmp[index].rot_z
        if (p_rot_z == 90) then
          p_pick_p = pick_p_swap[P_pallet_coord_tmp[index].pick_p] -- swap
        else
          p_pick_p = P_pallet_coord_tmp[index].pick_p
        end
        P_pallet_coord_L[l * count_l + i] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
        -- right pallet
        index = pallet_seq_R_rot[i + 1]
        p_offset_x = pallet_size_x - (pallet_offset_x + pallet_center_x + psize_x - (P_pallet_coord_tmp[index].offset_x + extra_gap_x[index + 1]))
        p_offset_y = pallet_size_y - (pallet_offset_y + pallet_center_y + P_pallet_coord_tmp[index].offset_y + extra_gap_y[index + 1])
        p_offset_z = pallet_offset_z + size_z + l * (size_z + gap_z)
        p_rot_z = P_pallet_coord_tmp[index].rot_z
        if (p_rot_z == 90) then
          p_pick_p = P_pallet_coord_tmp[index].pick_p
        else
          p_pick_p = pick_p_swap[P_pallet_coord_tmp[index].pick_p] -- swap
        end
        P_pallet_coord_R[l * count_l + i] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
      else
        -- left pallet
        index = pallet_seq_L[i + 1]
        p_offset_x = pallet_offset_x + pallet_center_x + P_pallet_coord_tmp[index].offset_x + extra_gap_x[index + 1]
        p_offset_y = pallet_offset_y + pallet_center_y + P_pallet_coord_tmp[index].offset_y + extra_gap_y[index + 1]
        p_offset_z = pallet_offset_z + size_z + l * (size_z + gap_z)
        p_rot_z = P_pallet_coord_tmp[index].rot_z
        p_pick_p = P_pallet_coord_tmp[index].pick_p
        P_pallet_coord_L[l * count_l + i] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
        -- right pallet
        index = pallet_seq_R[i + 1]
        p_offset_x = pallet_size_x - (pallet_offset_x + pallet_center_x + P_pallet_coord_tmp[index].offset_x + extra_gap_x[index + 1])
        p_offset_y = pallet_size_y - (pallet_offset_y + pallet_center_y + P_pallet_coord_tmp[index].offset_y + extra_gap_y[index + 1])
        p_offset_z = pallet_offset_z + size_z + l * (size_z + gap_z)
        p_rot_z = P_pallet_coord_tmp[index].rot_z
        p_pick_p = pick_p_swap[P_pallet_coord_tmp[index].pick_p] -- swap
        P_pallet_coord_R[l * count_l + i] = { offset_x = p_offset_x, offset_y = p_offset_y, offset_z = p_offset_z, rot_z = p_rot_z, pick_p = p_pick_p }
      end
    end
  end
end
