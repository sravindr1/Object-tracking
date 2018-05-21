temp = imgaussfilt(rgb2gray(imread('target_a.jpg')),2);
temp_norm = temp - mean(mean(temp));

r_center=zeros(1,100);
c_center=zeros(1,100);


r_center(1)=394.5;
c_center(1)=327.5;

for m=51:120
    frames=s(m).cdata;
    g_frames=imgaussfilt(rgb2gray(frames),2);
    mask = zeros(size(g_frames));
%     %find roi center

    % region of interest
    y_min = max(floor(r_center(m-50))-400,1);
    y_max = min(floor(r_center(m-50))+400,720);
    x_min = max(floor(c_center(m-50))-400,1);
    x_max = min(floor(c_center(m-50))+400,1280);
    
    %create mask ROI set to 1 and rest 0 
    mask(y_min:y_max,x_min:x_max) = ones(y_max-y_min+1,x_max-x_min+1);
    g_frames_norm = g_frames-mean(mean(g_frames)); 
    roi_frame=g_frames_norm.*uint8(mask);
    
    % Correlation
    
    cor = xcorr2(roi_frame,temp_norm);
    cropped_cor=cor(62:842-61,63:1406-62);
    [cor_max,r_center(m-50+1)] = max(max(cropped_cor)); % value of max ,and column to which it belongs
    [~,c_center(m-50+1)] = max(cropped_cor(:,r_center(m-50+1)));
    tracker = insertShape(frames, 'circle', [r_center(m-50+1),c_center(m-50+1),40], 'LineWidth', 20 ,'Color','red');
    
    
%     figure(1)
%     imshow(frames)
%     title('Actual frame')
    
    figure(1)
    imshow(tracker)
    title('Object tracking')
end