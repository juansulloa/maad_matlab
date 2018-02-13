%% Draw rectangular ROIs on image
% Each ROI must be defined as: [xmin ymin width height]

function imshow_rois(im,rois,labels)

% accepts dataset
if isa(rois,'dataset')
    xx(:,1)=rois.xmin;
    xx(:,2)=rois.ymin;
    xx(:,3)=rois.width;
    xx(:,4)=rois.height;
    rois=xx;
end

% for empty labels
if isempty(labels)
    labels=num2str(zeros(size(rois,1),1));
    label_empty=1;
else
    label_empty=0;
end

% set colors
nlabels=size(unique(labels),1);
map=distinguishable_colors(nlabels,'k'); % or other colormap. ex parula
[~,~,label_color]=unique(labels);
color=map(label_color,:);

% display
imscrollpanel(figure,imshow(im));
%imagesc(im);

hold on
for i=1:size(rois,1)
    plot_roi(rois(i,:),color(i,:));
   % text(rois(i,1),rois(i,2),num2str(labels(i)),'Color',color(i,:));
   if ~label_empty
    text(rois(i,1),rois(i,2),num2str(labels(i)),'Color',color(i,:));
   end
end
hold off