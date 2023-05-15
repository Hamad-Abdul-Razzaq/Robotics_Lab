function determineIntrinsics()
    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    
    % Start streaming on an arbitrary camera with default settings
    profile = pipe.start();

    % Extract the color stream
    color_stream = profile.get_stream(realsense.stream.color).as('video_stream_profile');
    depth_stream = profile.get_stream(realsense.stream.depth).as('video_stream_profile');
    
    % Get and display the intrinsics
    color_intrinsics = color_stream.get_intrinsics()
    depth_intrinsics = depth_stream.get_intrinsics()
    save lab_8

end