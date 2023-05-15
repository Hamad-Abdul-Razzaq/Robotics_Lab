%% Depth Figure
figure;
imshow(img);
title(sprintf("Colorized depth frame"));
%% RGB Image
figure;
imshow(im);
title(sprintf("Color RGB frame"));
%% Depth Info Without color
figure;
imshow(mat2gray(ig));
title("UnColorized depth frame");
%% Image Processing
close all;
BW = imbinarize(im);
figure;
imshowpair(im,BW,'montage');
title('RGB Image & its binarized version');
len = size(BW);
BW2 = ~(BW(:,:,1) & BW(:,:,2) & BW(:,:,3));
BW3 = BW2;
figure;
imshow(BW3);
title('Inverted Binarized Image');
cc8 = bwconncomp(BW3);
remove_idx = [];
% Filtering out stuff other than cubes
for i = 1:length(cc8.PixelIdxList)
    if (length(cc8.PixelIdxList{i}) < 200) || (length(cc8.PixelIdxList{i}) > 2000)
        remove_idx(end + 1) = i;
    end
end
for i=1:length(remove_idx)
    BW2(cc8.PixelIdxList{remove_idx(i)}) = 0;
end
figure;
imshowpair(BW3, BW2, 'montage');
title('Before & After');
cc8 = bwconncomp(BW2);
% for i =1:length(cc8.PixelIdxList)
%     w = floor(cc8.PixelIdxList{i}(1) / len(1)) + 1;
%     c = mod(cc8.PixelIdxList{i}(1), len(1));
%     tmp = bwselect(BW2, w, c);
%     figure;
%     imshow(tmp);
% end
object_info = struct;
object_info.Index_data = cc8.PixelIdxList;
object_info.rgb_image = im2double(im);
object_info.depth_info = ig;
object_info.red_val = zeros(1,length(object_info.Index_data));
object_info.green_val = zeros(1,length(object_info.Index_data));
object_info.blue_val = zeros(1,length(object_info.Index_data));
for i = 1:length(object_info.Index_data)
    val = double(0);
    for j = 1:length(object_info.Index_data{i})
        w = floor(object_info.Index_data{i}(j) / len(1)) + 1;
        c = mod(object_info.Index_data{i}(j), len(1));
        val = val + object_info.rgb_image(w,c,1);
    end
    val = val / length(object_info.Index_data{i});
    val
end
% for i = 1:length(object_info.Index_data{1})
%     g = ig(object_info.Index_data{1}(i))
% end
%% New
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
object_info.depth_val = zeros(1,length(object_info.Index_data)); % Depth value for each object in cm
for i = 1:length(object_info.Index_data) % Looping over each object
    arr = []; % This array contains those pixels of an object whose depth value is non-zero
    for j = 1:length(object_info.Index_data{i})
        if object_info.depth_info_cm(object_info.Index_data{i}(j)) ~= 0
            arr(end +1) = object_info.depth_info_cm(object_info.Index_data{i}(j));
        end
    end
    counts = hist(arr, 10); % A Histogram is generated on the pixels having non-zero depth values
    figure;
    histogram(arr, 10);
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
object_info.red_val
object_info.green_val
object_info.blue_val