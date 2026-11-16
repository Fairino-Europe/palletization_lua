----------------------------------------------------
-- variant 10
-- count 2 x 4 x 4
-- size, gap, pallet_offset from HMI
-- labels on side x y
----------------------------------------------------
preprocess = 0
template = 2
pick_point = 1
----------------------------------------------------
hmi_size_x = 290
hmi_size_y = 380
hmi_size_z = 290
----------------------------------------------------
hmi_gap_x = 0
hmi_gap_y = 0
hmi_gap_z = 0
----------------------------------------------------
hmi_count_x = 2
hmi_count_y = 4
hmi_count_z = 4
----------------------------------------------------
hmi_count_x1 = 0
hmi_count_y1 = 0
hmi_count_z1 = 0
----------------------------------------------------
hmi_pallet_offset_x = 0
hmi_pallet_offset_y = 45
hmi_pallet_offset_z = 0
----------------------------------------------------
hmi_partition_offset_x = 1
hmi_partition_offset_y = 1
hmi_partition_offset_z = 0
----------------------------------------------------
size_x = hmi_size_x
size_y = hmi_size_y
size_z = hmi_size_z
----------------------------------------------------
gap_x = hmi_gap_x
gap_y = hmi_gap_y
gap_z = hmi_gap_z
----------------------------------------------------
count_x = 2
count_y = 4
count_z = hmi_count_z
----------------------------------------------------
count_x1 = 0
count_y1 = 0
shift_x1 = 0
shift_y1 = 0
----------------------------------------------------
pallet_size_x = 800
pallet_size_y = 1200
pallet_offset_x = hmi_pallet_offset_x
pallet_offset_y = hmi_pallet_offset_y
pallet_offset_z = hmi_pallet_offset_z
pallet_center_x = 1
pallet_center_y = 1
----------------------------------------------------
partition_offset_x = hmi_partition_offset_x
partition_offset_y = hmi_partition_offset_y
partition_offset_z = hmi_partition_offset_z
----------------------------------------------------
pallet_seq_L = { 7, 5, 3, 1, 6, 4, 2, 0 }
pallet_seq_R = { 6, 4, 2, 0, 7, 5, 3, 1 }
d = size_y - size_x
extra_gap_x = { 0, 0, 0, d, 0, d, 0, d, 0, 0 }
extra_gap_y = { 0, 0, 0, -d, 0, -d, 0, -d, 0 }
extra_rot_z = { 180, 270, 180, 0, 180, 0, 90, 0 }
layer_rot = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
pallet_seq_L_rot = { 6, 4, 2, 0, 7, 5, 3, 1 }
pallet_seq_R_rot = { 7, 5, 3, 1, 6, 4, 2, 0 }
----------------------------------------------------
push_x_L = 20
push_y_L = 20
push_x_R = 20
push_y_R = 20
----------------------------------------------------