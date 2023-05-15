function lst = getCurrentPose()
%     arb = Arbotix('port', 'COM4', 'nservos', 5);
    global arb;
    lst = arb.getpos();
    lst = lst(1,1:4);
end