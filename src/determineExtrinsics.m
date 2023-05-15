function determineExtrinsics()
    % Make Pipeline object to manage streaming
    pipe = realsense.pipeline();
    
    % Start streaming on an arbitrary camera with default settings
    profile = pipe.start();

    % Extract the color and depth streams
    color_stream = profile.get_stream(realsense.stream.color).as('video_stream_profile');
    depth_stream = profile.get_stream(realsense.stream.depth).as('video_stream_profile');
    
    % Get and display the intrinsics
    Tdc = depth_stream.get_extrinsics_to(color_stream);
    T = [Tdc.rotation(1:3) Tdc.translation(1); Tdc.rotation(4:6) Tdc.translation(2); Tdc.rotation(7:9) Tdc.translation(3); 0 0 0 1]
    Tdc = depth_stream.get_extrinsics_to(depth_stream);
    T = [Tdc.rotation(1:3) Tdc.translation(1); Tdc.rotation(4:6) Tdc.translation(2); Tdc.rotation(7:9) Tdc.translation(3); 0 0 0 1]
    
end