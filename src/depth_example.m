function depth_example2()
    %% Create all objects to be used in this file
    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    % Make Colorizer object to prettify depth output
    colorizer = realsense.colorizer();
    % Create a config object to specify configuration of pipeline
    cfg = realsense.config();

    
    %% Set configuration and start streaming with configuration
    % Stream options are in stream.m
    streamType = realsense.stream('depth');
    % Format options are in format.m
    formatType = realsense.format('Distance');
    % Enable default depth
    cfg.enable_stream(streamType,formatType);
    % Enable color stream
    streamType = realsense.stream('color');
    formatType = realsense.format('rgb8');
    cfg.enable_stream(streamType,formatType);
    
    % Start streaming on an arbitrary camera with chosen settings
    profile = pipe.start();

    %% Acquire and Set device parameters 
    % Get streaming device's name
    dev = profile.get_device();    
    name = dev.get_info(realsense.camera_info.name);

    % Access Depth Sensor
    depth_sensor = dev.first('depth_sensor');

    % Access RGB Sensor
    rgb_sensor = dev.first('roi_sensor');
    
    % Find the mapping from 1 depth unit to meters, i.e. 1 depth unit =
    % depth_scaling meters.
    depth_scaling = depth_sensor.get_depth_scale();

    % Set the control parameters for the depth sensor
    % See the option.m file for different settable options that are visible
    % to you in the viewer. 
    optionType = realsense.option('visual_preset');
    % Set parameters to the midrange preset. See for options:
    % https://intelrealsense.github.io/librealsense/doxygen/rs__option_8h.html#a07402b9eb861d1defe57dbab8befa3ad
    depth_sensor.set_option(optionType,9);

    % Set autoexposure for RGB sensor
    optionType = realsense.option('enable_auto_exposure');
    rgb_sensor.set_option(optionType,1);
    optionType = realsense.option('enable_auto_white_balance');
    rgb_sensor.set_option(optionType,1);    
    
    %% Align the color frame to the depth frame and then get the frames
    % Get frames. We discard the first couple to allow
    % the camera time to settle
    for i = 1:5
        fs = pipe.wait_for_frames();
    end
    
    % Alignment
    align_to_depth = realsense.align(realsense.stream.depth);
    fs = align_to_depth.process(fs);

    % Stop streaming
    pipe.stop();

    %% Depth Post-processing
    % Select depth frame
    depth = fs.get_depth_frame();
    width = depth.get_width();
    height = depth.get_height();
    
    % Decimation filter of magnitude 2
%     dec = realsense.decimation_filter(2);
%     depth = dec.process(depth);

    % Spatial Filtering
    % spatial_filter(smooth_alpha, smooth_delta, magnitude, hole_fill)
    spatial = realsense.spatial_filter(.5,20,2,0);
    depth_p = spatial.process(depth);

    % Temporal Filtering
    % temporal_filter(smooth_alpha, smooth_delta, persistence_control)
    temporal = realsense.temporal_filter(.13,20,3);
    depth_p = temporal.process(depth_p);
    
    %% Color Post-processing
    % Select color frame
    color = fs.get_color_frame();    
    
    %% Colorize and display depth frame
    % Colorize depth frame
    depth_color = colorizer.colorize(depth_p);

    % Get actual data and convert into a format imshow can use
    % (Color data arrives as [R, G, B, R, G, B, ...] vector)fs
    data = depth_color.get_data();
    img = permute(reshape(data',[3,depth_color.get_width(),depth_color.get_height()]),[3 2 1]);

    % Display image
%     save img
    imshow(img);
    title(sprintf("Colorized depth frame from %s", name));

    %% Display RGB frame
    % Get actual data and convert into a format imshow can use
    % (Color data arrives as [R, G, B, R, G, B, ...] vector)fs
    data2 = color.get_data();
    im = permute(reshape(data2',[3,color.get_width(),color.get_height()]),[3 2 1]);
    color.get_width()
    color.get_height()
    size(im)

    % Display image
    figure;
%     save im
    imshow(im);
    title(sprintf("Color RGB frame from %s", name));

    %% Depth frame without colorizing    
    % Convert depth values to meters
   
    data3 = depth_scaling * single(depth_p.get_data());

    %Arrange data in the right image format
    ig = permute(reshape(data3',[width,height]),[2 1]);
    
    % Scale depth values to [0 1] for display
%     save ig
    figure;
    imshow(mat2gray(ig));
    
%% Processing RGB Image - Lab 7
BW = imbinarize(im); % Binarizing the given rgb image
figure; % Displaying Binarized Image along with original rgb image
imshowpair(im,BW,'montage');
title('RGB Image & its binarized version');
len = size(BW); % Size of image
BW2 = ~(BW(:,:,1) & BW(:,:,2) & BW(:,:,3)); % This expression is used to assign the color black to the background that white part in the rgb image. And it assigns white to the non-white part in the rgb image. This is done to differentiate the background with the objects in the scene.
BW3 = BW2;
figure; % Displaying the obtained black and white image that differentiates background from objects
imshow(BW3);
title('Inverted Binarized Image');
cc8 = bwconncomp(BW3); % This function finds all the connected components, i.e., objects in the scene and stores the pixel indices for each object
remove_idx = []; % This array will contain the pixel indices of those objects which are not cube
% Filtering out stuff other than cubes
for i = 1:length(cc8.PixelIdxList)
    if (length(cc8.PixelIdxList{i}) < 200) || (length(cc8.PixelIdxList{i}) > 2000) % For any object containing less than 200 pixels or more than 2000 pixels, they cannot be cubes. So indices of those pixels are added to remove_idx
        remove_idx(end + 1) = i;
    end
end
for i=1:length(remove_idx)
    BW2(cc8.PixelIdxList{remove_idx(i)}) = 0; % Setting the value of the pixel indices corresponding to non-cube objects to 0, i.e. turning them black which is equivalent to removing them.
end
figure;
imshowpair(BW3, BW2, 'montage'); % Displaying Black & White image after removing the non-cube objects
title('Before & After');
cc8 = bwconncomp(BW2); % Finding the connected components in the new image so that we only have the information of cubes stored
BW4 = BW2;
object_info = struct; % Making a structure that contains all the information from our image processing
object_info.Index_data = cc8.PixelIdxList; % Object Indices 
object_info.rgb_image = im2double(im); % RGB Image
object_info.depth_info_cm = ig*100; % Depth Info in cm
object_info.red_val = zeros(1,length(object_info.Index_data)); % Avg Red for each obj
object_info.green_val = zeros(1,length(object_info.Index_data)); % Avg Green for each obj
object_info.blue_val = zeros(1,length(object_info.Index_data)); % Avg Blue for each obj
object_info.red_val_max = zeros(1,length(object_info.Index_data)); % Max Red for each obj
object_info.green_val_max = zeros(1,length(object_info.Index_data)); % Max Green for each obj
object_info.blue_val_max = zeros(1,length(object_info.Index_data)); % Max Blue for each obj
object_info.top_data = object_info.Index_data; % Indices for top faces of each object
object_info.top_data_width = object_info.Index_data; % x Indices for top faces of each object
object_info.top_data_column = object_info.Index_data; % y Indices for top faces of each object
object_info.no_top_data = object_info.Index_data; % This will store all the indices of the object that is not a top face pixel
object_info.center_x = zeros(1, length(object_info.Index_data)); % x value of the center pixel of each object
object_info.center_y = zeros(1, length(object_info.Index_data)); % y value of the center pixel of each object
object_info.red_val_bin = zeros(1,length(object_info.Index_data)); % A Binary array telling whether each object contains red color or not
object_info.green_val_bin = zeros(1,length(object_info.Index_data)); % A Binary array telling whether each object contains green color or not
object_info.blue_val_bin = zeros(1,length(object_info.Index_data)); % A Binary array telling whether each object contains blue color or not
object_info.depth_val = zeros(1,length(object_info.Index_data));
for i = 1:length(object_info.Index_data) % Looping over each object
    arr = []; % This array contains those pixels of an object whose depth value is non-zero
    for j = 1:length(object_info.Index_data{i})
        if object_info.depth_info_cm(object_info.Index_data{i}(j)) ~= 0
            arr(end +1) = object_info.depth_info_cm(object_info.Index_data{i}(j));
        end
    end
    counts = hist(arr, 10); % A Histogram is generated on the pixels having non-zero depth values
    th = min(arr) + (otsuthresh(counts)*(max(arr) - min(arr))); % Determining threshold for top face detection using otsu algorithm
    object_info.depth_val(i) = th;
    r = 0;
    l = 0;
    for j = 1:length(object_info.Index_data{i})
        
        if object_info.depth_info_cm(object_info.Index_data{i}(j)) > th % Separating top face indices using this condition
            BW4(object_info.Index_data{i}(j)) = 0;
            object_info.top_data{i}(j-r) = [];
            r = r + 1;
        else
            object_info.no_top_data{i}(j-l) = [];
            l = l + 1;
        end
    end
end

for i = 1:length(object_info.top_data)
    object_info.top_data_column{i} = floor(object_info.top_data{i} ./ len(1)) + 1;
    object_info.top_data_width{i} = mod(object_info.top_data{i}, len(1));
    object_info.center_x(i) = floor(mean(object_info.top_data_width{i})); % Calculating x value of Center pixel
    object_info.center_y(i) = floor(mean(object_info.top_data_column{i}));% Calculating y value of Center pixel
    BW4(object_info.center_x(i), object_info.center_y(i)) = 0;  % Setting color for center value to be black so that it is visible
end
figure;
imshowpair(BW2, BW4, 'montage'); % Showing the objects with both top face and non-top face pixels and objects with only top face pixels 
title('Face top detection');
avg_th = 0.3; % Threshold for average RGB value
max_th = 0.4; % Threshold for maximum RGB value
for k = 1:length(object_info.top_data_width) % Looping for every object
    % Finding the average and maximum values
    val_r = 0;
    val_g = 0;
    val_b = 0;
    max_r = -inf;
    max_g = -inf;
    max_b = -inf;
    for i = 1:length(object_info.top_data_width{k})
            if (object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),1) > max_r)
                max_r = object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),1);
            end
            if (object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),2) > max_g)
                max_g = object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),2);
            end
            if (object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),3) > max_b)
                max_b = object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),3);
            end
            val_r = val_r + object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),1);
            val_g = val_g + object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),2);
            val_b = val_b + object_info.rgb_image(object_info.top_data_width{k}(i),object_info.top_data_column{k}(i),3);
    end
    object_info.red_val(k) = val_r / length(object_info.top_data_width{k});
    object_info.green_val(k) = val_g / length(object_info.top_data_width{k});
    object_info.blue_val(k)= val_b / length(object_info.top_data_width{k});
    object_info.red_val_max(k) = max_r;
    object_info.green_val_max(k) = max_g;
    object_info.blue_val_max(k) = max_b;
    % Setting RGB values if the required thresholds are met
    if object_info.red_val(k) >= avg_th && object_info.red_val_max(k) > max_th 
        object_info.red_val_bin(k) = 1;
    end
    if object_info.green_val(k) >= avg_th && object_info.green_val_max(k) > max_th
        object_info.green_val_bin(k) = 1;
    end
    if object_info.blue_val(k) >= avg_th && object_info.blue_val_max(k) > max_th
        object_info.blue_val_bin(k) = 1;
    end
end
object_info
object_info.depth_val
imshow(im);
save lab9b3
%% Conversion of Red and Yellow Object Coordinates into World Coordinates - Lab 8 Modified
% Extracting Red and Yellow Objects
red_uv = [];
red_depth = [];
yellow_uv = [];
yellow_depth = [];
for i = 1:length(object_info.red_val_bin)
    if (object_info.red_val_bin(i) && ~(object_info.green_val_bin(i)) && ~(object_info.blue_val_bin(i)))
        red_uv(end + 1) = [object_info.center_x(i); object_info.center_y(i); 1];
        red_depth(end + 1) = object_info.depth_val(i);
    elseif (object_info.red_val_bin(i) && (object_info.green_val_bin(i)) && ~(object_info.blue_val_bin(i)))
        yellow_uv(end + 1) = [object_info.center_x(i); object_info.center_y(i); 1];
        yellow_depth(end + 1) = object_info.depth_val(i);
    end
end
% Converting Red and Yellow Pixel values to world coordinates
WF_coord_red = [];
WF_coord_yellow = [];
Z = 820;
K = [
    1399.1 1 944.4568 ;
    0 1399.1 533.8895;
    0 0 1 
    ];
T_ = [
    1 0 0 -20;
    0 cos(pi) -sin(pi) 0;
    0 sin(pi) cos(pi) 688;
    ];
for i = (length(red_uv))
    WF_coord_red(end + 1) = inv(K * T_) * red_uv(i)*Z;
end
for i = (length(yellow_uv))
    WF_coord_yellow(end + 1) = inv(K * T_) * yellow_uv(i)*Z;
end
% Sending the coordinates  one by one to FSM of Lab 6 (with modification)
global obj_no_red;
global obj_no_yellow;
obj_no_red = 1;
obj_no_yellow = 1;
for i = (length(red_uv))
    WF_coord_red(3, i) = red_depth(i);
    FSM(WF_coord_red(i), true);
end
for i = (length(yellow_uv))
    WF_coord_yellow(3, i) = yellow_depth(i);
    FSM(WF_coord_yellow(i), true);
end
end