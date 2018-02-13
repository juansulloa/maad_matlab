%% IMAGE FILTERING PIPELINES
% Options
% 'gblur'       Filters: rmprofile, close, rmprofile, gaussian blur
% 'deep_gblur'  Filters: rmprofile, deep gaussian blur
% 'delaunay'    Filters: rmprofile, delaunay density estimation
% 'dbscan'      Filters: density based clustering - different output 

function im_out=im_filter(op,im,imfilt_opt)

switch op
%%
    case 'gblur' 
        disp('Filters: rmprofile, close, rmprofile, gaussian blur')
        
        % --  parameters
        se = strel('disk',2);
        th_bin=0.3;   % threshold for final binarisation     
        
        % -- rmprofile, close, rmprofile
        %n_medfilt=16;
        %im_out=im_rmprofile(im,n_medfilt,2);
        im_out=im;
        %figure;imshow(im_out);colormap(hot)
        
        n_medfilt=16;
        im_out=imclose(im_out,se);
        im_out=im_rmprofile(im_out,n_medfilt,2);
        im_out=im_out>th_bin;

        % gaussian filter on binary image
        h = fspecial('gaussian',[5 5],1);
        im_out = imfilter(im_out, h);
        
                
    case 'deep_gblur'
%%
        disp('Filters: rmprofile, deep gaussian blur')
        im_out=im;
        % -- parameters
        th_bin=0.3;
        
        % -- rmprofile
        %n_medfilt=16;
        %im_out=im_rmprofile(im,n_medfilt,2);
        %figure(1);imshow(im_out)
        
        % -- binarisation
        im_out=im_out>th_bin;
        %figure(2);imshow(im_out)
        
        % -- gaussian filter
        h = fspecial('gaussian',[2 2],1);
        im_out = imfilter(im_out, h);
        %figure(3);imshow(im_out)

        h = fspecial('gaussian',[4 4],1);
        im_out = imfilter(im_out, h);
        %figure(4);imshow(im_out)

        h = fspecial('gaussian',[8 8],1);
        im_out = imfilter(im_out, h);
        %figure(5);imshow(im_out)

        h = fspecial('gaussian',[16 16],1);
        im_out = imfilter(im_out, h);
        %figure(6);imshow(im_out)

        h = fspecial('gaussian',[16 16],1);
        im_out = imfilter(im_out, h);
        %figure(7);imshow(im_out)

        
     case 'delaunay'
%%
        disp('Filters: rmprofile, delaunay density estimation')
        % params ---
        th_spec=0.4;
        th_dens=0.15;
        
        % -- rmprofile
        im_out=im;
        %n_medfilt=16;
        %im_out=im_rmprofile(im,n_medfilt,2);
        
        % -- binarisation
        figure(1);imshow(im_out);
        [i,j]=find(im_out>th_spec);
        %figure(2);imshow(im_out<th_spec);
        
        % -- delaunay filter
        tri_sparse=delaunay_filter(i,j,th_dens);
        figure(3);imshow(ones(size(im_out)));
        hold on
        triplot(tri_sparse,j,i);fill(j(tri_sparse)',i(tri_sparse)','black')
        hold off
        title('Image filterinf - Delaunay');
        F = getframe;close;
        im_out=imcomplement(F.cdata(:,:,1));
        im_out=im_out>0;
        
     case 'dbscan'
%%
        th_spec=0.6;
        
        %n_medfilt=16;
        %im=im_rmprofile(im,n_medfilt,2);
        im=im/max(im(:));
        im_bin=im>th_spec;
        
        [i,j]=find(im_bin); % spectrogram representation to matrix of observations
        x=[i,j];
        
        % search for the correct parameters
        %[idx,d]=knnsearch(x,x,'k',5,'distance','euclidean'); % 4+1 because the first neighbor is the same point
        %figure;plot(sort(d(:,5),'descend'));title('sorted 4-dist graph for spectrogram')
        
        % dbscan
        [class,type]=dbscan(x,4,10);
        im_mask=zeros(size(im,1),size(im,2));
        im_mask(sub2ind(size(im_mask),i,j))=class;
        
        rois=zeros(max(class),4);
        for i=1:max(class)
            [~,xmin]=ind2sub(size(im_mask),find(im_mask==i,1,'first'));
            [~,xmax]=ind2sub(size(im_mask),find(im_mask==i,1,'last'));
            [~,ymax]=ind2sub(size(im_mask'),find(im_mask'==i,1,'first'));
            [~,ymin]=ind2sub(size(im_mask'),find(im_mask'==i,1,'last'));
            rois(i,:)=[xmin, ymax, xmax-xmin, ymin-ymax];
        end
        imshow_rois(im,rois,[])
        im_out=im_mask;
    case 'morpho_opening'
        
        % morphological opening
        se = strel('square',3);
        im_op=imopen(im,se);
        im_op=im_op/max(im_op(:));
        
        % threshold estimation
        h_spec=hist(im_op(:));
        th_bin=0.15;
        
        % binarization
        im_out=im_op>th_bin;
        
    case 'smooth_gauss'
        % Gaussian 2D low pass filter
        fh = fspecial('gaussian',imfilt_opt.size,imfilt_opt.std);
        im_out=imfilter(im,fh);
        im_out=scaledata(im_out,0,1);
        % get mask using double threshold
        im_out=double_th(im_out,imfilt_opt.c,imfilt_opt.l);
        
     
    otherwise
        disp('Invalid option, image unchanged')
        im_out=im;
end