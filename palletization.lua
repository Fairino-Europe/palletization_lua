----------------------------------------------------
-- Palletization
-- version: 4.0-1
-- date: 11.2.2026
----------------------------------------------------
dofile("/fruser/config.lua")
safe_lift_z = 0
----------------------------------------------------
-- Setup function
function setup()
  SetUserVal(user_P_mode, 0)
  SetUserVal(user_P_side, 0)
  SetUserVal(user_P_index_L, 0)
  SetUserVal(user_P_index_R, 0)
end
----------------------------------------------------
-- Init function
function init()
  SetOaccScale(80)
  -- reset tool outputs
  SetToolDO(0,0,0,0)
  SetToolDO(1,0,0,0)
  -- reset valves
--  SetDO(0,0,0,0)
  SetDO(4,0,0,0)
  SetDO(6,0,0,0)
  -- stop pump
  SetDO(3,0,0,0)
  -- stop conveyor
--  SetDO(5,0,0,0)
  -- reset status
  SetDO(11,0,0,0)
  SetDO(12,0,0,0)
  -- reset side
  P_side = 0
  SetUserVal(user_P_side, 0)
  SetUserVal(user_P_side_mb, 0)
  -- use last mode
  P_mode = GetUserVal(user_P_mode)
  SetUserVal(user_P_mode_mb, 0)
  variant_select(P_mode)
  -- load indexes
  P_index_L = GetUserVal(user_P_index_L)
  P_index_R = GetUserVal(user_P_index_R)
  -- safe move home
  x, y, z, rx, ry, rz = GetActualTCPPose()
  if (type(y) == "number") then
    if (y < -400) then
      update_zone(1)
      PTP(safe_L1, 25, -1, 0)
    end
    if (y > 400) then
      update_zone(2)
      PTP(safe_R1, 25, -1, 0)
    end
  end
  PTP(home1,25,-1,0)
  -- reset flag
  SetUserVal(user_flag,0)
  SetUserVal(user_latch,0)
end
----------------------------------------------------
-- Init function
function variant_select(variant)
  name = "/fruser/variant"..variant..".lua"
  dofile(name)
  name = "/fruser/preprocess"..preprocess..".lua"
  dofile(name)
  preprocess()
  name = "/fruser/template"..template..".lua"
  dofile(name)
  fill_pallet_coord()
  SetUserVal(user_P_count_l, count_l)
  SetUserVal(user_P_count_p, count_p)
 --   setup pressure
--   SetAO(1,pressre,0)
end
----------------------------------------------------
-- update_zone function
function update_zone(zone)
  if (zone == 1) then
    SetDO(14,0,0,0)
    SetDO(15,0,0,0)
  elseif (zone == 2) then
    SetDO(14,1,0,0)
    SetDO(15,1,0,0)
  end
end
----------------------------------------------------
-- pick wait function
function pick_wait()
  -- wait object
  while GetUserVal(user_flag) ~= 4 do
    WaitMs(100)
  end
  -- wait open gripper
--  WaitToolDI(1,1,0,2)
  -- check valve open
  WaitDI(5,1,0,2)
  -- check object present
  WaitDI(4,0,0,2)
end
----------------------------------------------------
-- Pick function
function pick(index, side)
  offset_x = 0
  offset_y = 0
  offset_z = 0
  offset_z = size_z - gripper_pick_z
  if (side == 1) then
    pick_p = P_pallet_coord_L[index].pick_p
  elseif (side == 2) then
    pick_p = P_pallet_coord_R[index].pick_p
  end
-- double vaccum gripper - 180, 0 deg
  if (pick_p == 1 or pick_p == 2) then
    offset_x = - size_y / 2 + gripper_width / 2
    offset_y = size_x / 2 - gripper_length / 2
-- double vacuum gripper - 90, 270 deg
  elseif (pick_p == 3 or pick_p == 4) then
    offset_x = - size_x / 2 + gripper_length / 2
    offset_y = size_y / 2 - gripper_width / 2
  end
  offset_z_up = offset_z + size_z + 100
::pick_C::
  if (pick_p == 1) then
    Lin(pick1, 100, 10, 0, 1, offset_x, offset_y, offset_z_up, 0, 0, 0)
    pick_wait()
    -- pump start
    SetDO(3,1,0,0)
    Lin(pick1, 100, -1, 0, 1, offset_x, offset_y, offset_z, 0 ,0 ,0)
    SetDO(4,1,0,0)
    WaitMs(1000)
    Lin(pick1, 25, -1, 0, 1, offset_x, offset_y, offset_z_up, 0 ,0 ,0)
  elseif (pick_p == 2) then
    Lin(pick2, 100, 10, 0, 1, offset_x, offset_y, offset_z_up, 0, 0, 0)
    pick_wait()
    -- pump start
    SetDO(3,1,0,0)
    Lin(pick2, 100, -1, 0, 1, offset_x, offset_y, offset_z, 0 ,0 ,0)
    SetDO(4,1,0,0)
    WaitMs(1000)
    Lin(pick2, 25, -1, 0, 1, offset_x, offset_y, offset_z_up, 0 ,0 ,0)
  elseif (pick_p == 3) then
    Lin(pick3, 100, 10, 0, 1, offset_x, offset_y, offset_z_up, 0, 0, 0)
    pick_wait()
    -- pump start
    SetDO(3,1,0,0)
    Lin(pick3, 100, -1, 0, 1, offset_x, offset_y, offset_z, 0 ,0 ,0)
    SetDO(4,1,0,0)
    WaitMs(1000)
    Lin(pick3, 25, -1, 0, 1, offset_x, offset_y, offset_z_up, 0 ,0 ,0)
  elseif (pick_p == 4) then
    Lin(pick4, 100, 10, 0, 1, offset_x, offset_y, offset_z_up, 0, 0, 0)
    pick_wait()
    -- pump start
    SetDO(3,1,0,0)
    Lin(pick4, 100, -1, 0, 1, offset_x, offset_y, offset_z, 0 ,0 ,0)
    SetDO(4,1,0,0)
    WaitMs(1000)
    Lin(pick4, 25, -1, 0, 1, offset_x, offset_y, offset_z_up, 0 ,0 ,0)
  end
  -- check holding
--  if (GetToolDI(0,0) == 1) or (GetToolDI(1,0) == 1) then
--  if (GetToolDI(1,0) == 1) then
--  if (GetToolAI(0,0) > 45 or GetDI(4,0) == 0) then
  if (GetDI(4,0) == 0) then
    -- led yellow
    SetDO(11,1,0,0)
    -- beep
    SetDO(12,1,0,0)
    WaitMs(2000)
    SetDO(12,0,0,0)
--    SetToolDO(0,0,0,0)
    SetDO(4,0,0,0)
    WaitDI(4,0,0,2)
    SetDO(11,0,0,0)
    goto pick_C 
  end
  SetUserVal(user_flag,0)
end
----------------------------------------------------
-- Touch function
function touch_func(step_z, max_z)
  x, y, z, rx, ry, rz = GetActualTCPPose()
  offset_z = 0
  while (GetToolDI(0, 0) == 0 and offset_z < max_z and offset_z > -max_z) do
      offset_z = offset_z + step_z
      ServoCart(0, x, y, z + offset_z, rx, ry, rz, 0, 0, 0, 0, 0, 0, 100, 100, 0.001, 0, 0)
      WaitMs(1)
  end
  WaitMs(500)
  return GetToolDI(0,0)
end
----------------------------------------------------
-- Paper pick function
function ppick(side)
  offset_x = -10
  offset_y = 0
  offset_z = 0
  max_z = 100
  offset_z_up = offset_z + max_z
  offset_z_safe = 300 
  offset_z_lift = 700 
  if (side == 1) then
    PTP(ppick_L1, 100, 1000, 1, offset_x, offset_y, offset_z_safe, 0, 0, 0)
    PTP(ppick_L1, 100, 1000, 1, offset_x, offset_y, offset_z_up, 0, 0, 0)
  elseif (side == 2) then
    PTP(ppick_R1, 100, 1000, 1, offset_x, offset_y, offset_z_safe, 0, 0, 0)
    PTP(ppick_R1, 100, 1000, 1, offset_x, offset_y, offset_z_up, 0, 0, 0)
  end
  -- pump start
  SetDO(3,1,0,0)
  while (touch_func(-0.1, max_z) == 0) do
    -- led yellow
    SetDO(11,1,0,0)
    -- beep
    SetDO(12,1,0,0)
    if (side == 1) then
      Lin(ppick_L1, 100, -1, 0, 1, offset_x, offset_y, offset_z_up ,0 ,0 ,0)
    elseif (side == 2) then
      Lin(ppick_R1, 100, -1, 0, 1, offset_x, offset_y, offset_z_up ,0 ,0 ,0)
    end
    WaitMs(1000)
    SetDO(12,0,0,0)
    Pause(0)
    SetDO(11,0,0,0)
  end
  -- enable vacuum
--  SetToolDO(1,1,0,0)
  SetDO(4,1,0,0)
  WaitMs(500)
  if (side == 1) then
    Lin(ppick_L1, 10, 10, 0, 1, offset_x, offset_y, offset_z_up, 0, ppick_angle, 0)
    Lin(ppick_L1, 100, 10, 0, 1, offset_x, offset_y, offset_z_lift, 0, ppick_angle, 0)
    Lin(ppick_L1, 100, -1, 0, 1, offset_x + 400, offset_y, offset_z_lift, 0, ppick_angle, 0)
  elseif (side == 2) then
    Lin(ppick_R1, 10, 10, 0, 1, offset_x, offset_y, offset_z_up, 0, ppick_angle ,0)
    Lin(ppick_R1, 100, 10, 0, 1, offset_x, offset_y, offset_z_lift, 0, ppick_angle ,0)
    Lin(ppick_R1, 100, -1, 0, 1, offset_x + 400, offset_y, offset_z_lift, 0, ppick_angle, 0)
  end
end
----------------------------------------------------
-- Place function
function place(index, side)
  offset_x = 0
  offset_y = 0
  offset_z = 5
  if (side == 1) then
    offset_x = offset_x + P_pallet_coord_L[index].offset_x
    offset_y = offset_y + P_pallet_coord_L[index].offset_y
    offset_z = offset_z + P_pallet_coord_L[index].offset_z
    rot_z = P_pallet_coord_L[index].rot_z
  elseif (side == 2) then
    offset_x = offset_x + P_pallet_coord_R[index].offset_x
    offset_y = offset_y + P_pallet_coord_R[index].offset_y
    offset_z = offset_z + P_pallet_coord_R[index].offset_z
    rot_z = P_pallet_coord_R[index].rot_z
  end
  offset = offset_x
  offset_z_up = offset_z + size_z + 50
  if (side == 1) then
    offset_x = offset_y
    offset_y = -offset
    if (offset_z_up < 1000) then
--      PTP(place_L1, 100, 1000, 1, offset_x - push_y_L, offset_y + push_x_L, offset_z_up, 0, 0, rot_z)
      Lin(place_L1, 100, 10, 0, 1, offset_x - push_y_L, offset_y + push_x_L, offset_z_up, 0, 0, rot_z)
      Lin(place_L1, 50, 10, 0, 1, offset_x - push_y_L, offset_y + push_x_L, offset_z + 10, 0, 0, rot_z)
      Lin(place_L1, 25, 10, 0, 1, offset_x, offset_y, offset_z, 0, 0, rot_z)
    else
--      PTP(place_L2, 100, 1000, 1, offset_x - push_y_L, offset_y + push_x_L, offset_z_up - 1000, 0, 0, rot_z)
      Lin(place_L2, 100, 10, 0, 1, offset_x - push_y_L, offset_y + push_x_L, offset_z_up - 1000, 0, 0, rot_z)
      Lin(place_L2, 50, 10, 0, 1, offset_x - push_y_L, offset_y + push_x_L, offset_z - 1000 + 10, 0, 0, rot_z)
      Lin(place_L2, 25, 10, 0, 1, offset_x, offset_y, offset_z - 1000, 0, 0, rot_z)
    end
  elseif (side == 2) then
    offset_x = pallet_size_y - offset_y
    offset_y = offset
    if (offset_z_up < 1000) then
--      PTP(place_R1, 100, 1000, 1, offset_x - push_y_R, offset_y - push_x_R, offset_z_up, 0, 0, rot_z)
      Lin(place_R1, 100, 10, 0, 1, offset_x - push_y_R, offset_y - push_x_R, offset_z_up, 0, 0, rot_z)
      Lin(place_R1, 50, 10, 0, 1, offset_x - push_y_R, offset_y - push_x_R, offset_z + 10, 0, 0, rot_z)
      Lin(place_R1, 25, 10, 0, 1, offset_x, offset_y, offset_z, 0, 0, rot_z)
    else
--      PTP(place_R2, 100, 1000, 1, offset_x - push_y_R, offset_y - push_x_R, offset_z_up - 1000, 0, 0, rot_z)
      Lin(place_R2, 100, 10, 0, 1, offset_x - push_y_R, offset_y - push_x_R, offset_z_up - 1000, 0, 0, rot_z)
      Lin(place_R2, 50, 10, 0, 1, offset_x - push_y_R, offset_y - push_x_R, offset_z - 1000 + 10, 0, 0, rot_z)
      Lin(place_R2, 25, 10, 0, 1, offset_x, offset_y, offset_z - 1000, 0, 0, rot_z)
    end
  end
    -- release
--  SetToolDO(0,0,0,0)
--  SetDO(3,0,0,0)
  SetDO(4,0,0,0)
  SetDO(6,1,0,0)
  WaitMs(500)
  SetDO(6,0,0,0)
  -- wait gripper open
--  WaitToolDI(1,1,0,2)
--  WaitToolAI(0,0,45,0,2)
  if (side == 1) then
    if (offset_z_up < 1000) then
      Lin(place_L1, 50, -1, 0, 1, offset_x, offset_y, offset_z_up, 0 , 0, rot_z)
    else
      Lin(place_L2, 50, -1, 0, 1, offset_x, offset_y, offset_z_up - 1000, 0 , 0, rot_z)
    end
  elseif (side == 2) then
    if (offset_z_up < 1000) then
      Lin(place_R1, 50, -1, 0, 1, offset_x, offset_y, offset_z_up, 0 , 0, rot_z)
    else
      Lin(place_R2, 50, -1, 0, 1, offset_x, offset_y, offset_z_up - 1000, 0 , 0, rot_z)
    end
  end
end
----------------------------------------------------
-- Paper place function
function pplace(index, side)
  offset_x = pallet_size_y - pplace_offset_y - partition_offset_y
  if pplace_offset_x_L >= 0 then
-- left alligned
    offset_y_L = pplace_offset_x_L - pallet_size_x + partition_offset_x
  else
-- right alligned
    offset_y_L = pplace_offset_x_L - partition_offset_x
  end
  if pplace_offset_x_R >= 0 then
-- left alligned
    offset_y_R = pplace_offset_x_R + partition_offset_x
  else
-- right alligned
    offset_y_R = pplace_offset_x_R + pallet_sie_x - partition_offset_x
  end
  offset_z = 0
  index_z = math.floor(index / count_l)
-- double vaccum gripper
  rot_z = 0
-- single vacuum gripper
--  rot_z = -90
  offset_z = offset_z + index_z * size_z
  offset_z_up = offset_z + 50
  if (side == 1) then
    Lin(place_L1, 100, 10, 0, 1, offset_x, offset_y_L, offset_z_up, 0, 0, rot_z)
    Lin(place_L1, 50, 10, 0, 1, offset_x, offset_y_L, offset_z, 0, 0, rot_z)
  elseif (side == 2) then
    Lin(place_R1, 100, 10, 0, 1, offset_x, offset_y_R, offset_z_up, 0, 0, rot_z)
    Lin(place_R1, 50, 10, 0, 1, offset_x, offset_y_R, offset_z, 0, 0, rot_z)
  end
  -- release
  SetDO(4,0,0,0)
  SetDO(6,1,0,0)
  WaitMs(500)
  SetDO(6,0,0,0)
  if (side == 1) then
    Lin(place_L1, 50, 10, 0, 1, offset_x, offset_y_L, offset_z_up, 0, 0, rot_z)
  elseif (side == 2) then
    Lin(place_R1, 50, 10, 0, 1, offset_x, offset_y_R, offset_z_up, 0, 0, rot_z)
  end
end
----------------------------------------------------
-- Main program
init()
while (1) do
  P_mode_mb = GetUserVal(user_P_mode_mb)
  P_side_mb = GetUserVal(user_P_side_mb)
  P_side = GetUserVal(user_P_side)
  P_index_L = GetUserVal(user_P_index_L)
  PP_index_L = GetUserVal(user_PP_index_L)
  P_index_R = GetUserVal(user_P_index_R)
  PP_index_R = GetUserVal(user_PP_index_R)
  PL_state = GetUserVal(user_PL_state)
  PR_state = GetUserVal(user_PR_state)
  -- if requested new P_mode and palletes empty or mode not selected
  if (P_mode_mb > 0) then
    if (P_mode == 0 or (P_index_L == 0  and P_index_R == 0)) then
      P_mode = P_mode_mb
      SetUserVal(user_P_mode, P_mode)
      variant_select(P_mode)
    end
    SetUserVal(user_P_mode_mb, 0)
  end
  -- if requested pallet and pallet not full and pallet present then swap
  if (P_side_mb == 1) then
--    if (P_index_L < count_p and GetDI(0,0) == 1 and GetDI(1,0) == 1) then
    if (P_index_L < count_p and PL_state == 1) then
      P_side = P_side_mb
      SetUserVal(user_P_side, P_side)
    end
    SetUserVal(user_P_side_mb, 0)
  elseif (P_side_mb == 2) then
--    if (P_index_R < count_p and GetDI(2,0) == 1 and GetDI(3,0) == 1) then
    if (P_index_R < count_p and PR_state == 1) then
      P_side = P_side_mb
      SetUserVal(user_P_side, P_side)
    end
    SetUserVal(user_P_side_mb, 0)
  end
  flag = GetUserVal(user_flag)
  safe_lift_z = 0
  safe_rot_z = 0
  if (P_side == 0) then
    WaitMs(100)
--      update_zone(P_side)
  elseif (P_side == 1) then
    update_zone(P_side)
    P_height_L = math.floor(P_index_L / count_l) * size_z
    if (P_height_L < 1000) then safe_lift_z = -500 end
    -- update PP_index
    if (PP_index_L < 0) then
      PP_index_L = math.floor((P_index_L + count_l - 1) / count_l) * count_l
      SetUserVal(user_PP_index_L, PP_index_L)
    end
    -- check paper
    if (partition_offset_x > 0 and P_height_L < 1300 and PP_index_L == P_index_L) then
      if (P_index_L > 0) then
        ppick(P_side)
        pplace(P_index_L, P_side)
        PTP(safe_L1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, safe_rot_z)
        PTP(home1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, 0)
      end
      PP_index_L = PP_index_L + count_l
      SetUserVal(user_PP_index_L, PP_index_L)
    end
    if (flag == 4) then
      pick(P_index_L, P_side)
      PTP(home1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, 0)
      PTP(safe_L1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, safe_rot_z)
      place(P_index_L, P_side)
      PTP(safe_L1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, safe_rot_z)
      P_index_L = P_index_L + 1
      SetUserVal(user_P_index_L, P_index_L)
      PTP(home1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, 0)
      -- last layer
      if (P_index_L == count_p) then
        -- pump stop
        SetDO(3,0,0,0)
        P_side = -1
      end
    else
      -- pump stop
      SetDO(3,0,0,0)
    end
  elseif (P_side == 2) then
    update_zone(P_side)
    P_height_R = math.floor(P_index_R / count_l) * size_z
    if (P_height_R < 1000) then safe_lift_z = -500 end
    -- update PP_index
    if (PP_index_R < 0) then
      PP_index_R = math.floor((P_index_R + count_l - 1) / count_l) * count_l
      SetUserVal(user_PP_index_R, PP_index_R)
    end
    -- check paper
    if (partition_offset_x > 0 and P_height_R < 1300 and PP_index_R == P_index_R) then
      if (P_index_R > 0) then
        ppick(P_side)
        pplace(P_index_R, P_side)
        PTP(safe_R1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, safe_rot_z)
        PTP(home1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, 0)
      end
      PP_index_R = PP_index_R + count_l
      SetUserVal(user_PP_index_R, PP_index_R)
    end
    if (flag == 4) then
      pick(P_index_R, P_side)
      PTP(home1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, 0)
      PTP(safe_R1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, safe_rot_z)
      place(P_index_R, P_side)
      PTP(safe_R1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, safe_rot_z)
      P_index_R = P_index_R + 1
      SetUserVal(user_P_index_R, P_index_R)
      PTP(home1, 100, 1000, 1, 0, 0, safe_lift_z, 0, 0, 0)
      -- last layer
      if (P_index_R == count_p) then
        -- pump stop
        SetDO(3,0,0,0)
        P_side = -1
      end
    else
      -- pump stop
      SetDO(3,0,0,0)
    end
  end
  -- auto select pallete if empty and present
  if (P_side < 0) then
--    if (P_index_L == 0 and GetDI(0,0) == 1 and GetDI(1,0) == 1) then
    if (P_index_L == 0 and PL_state == 1) then
      P_side = 1
      SetUserVal(user_P_side, P_side)
--    elseif (P_index_R == 0 and GetDI(2,0) == 1 and GetDI(3,0) == 1) then
    elseif (P_index_R == 0 and PR_state == 1) then
      P_side = 2
      SetUserVal(user_P_side, P_side)
    else
      P_side = 0
      SetUserVal(user_P_side, P_side)
    end
  end
end
