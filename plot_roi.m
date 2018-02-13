%% PLOT ROI

function plot_roi(roi,color)
    
    roi=round(roi);

    hu=[(roi(1):roi(1)+roi(3))'  repmat(roi(2),roi(3)+1,1)];
    hd=[(roi(1):roi(1)+roi(3))'  repmat(roi(2)+roi(4),roi(3)+1,1)];
    vl=[repmat(roi(1),roi(4)+1,1)       (roi(2):roi(2)+roi(4))'];
    vr=[repmat(roi(1)+roi(3),roi(4)+1,1)       (roi(2):roi(2)+roi(4))']; 
    
    plot(hu(:,1),hu(:,2),'Color',color,'LineWidth',1);
    plot(hd(:,1),hd(:,2),'Color',color,'LineWidth',1);
    plot(vl(:,1),vl(:,2),'Color',color,'LineWidth',1);
    plot(vr(:,1),vr(:,2),'Color',color,'LineWidth',1);
    