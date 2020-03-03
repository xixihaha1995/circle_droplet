% drop_edge_Wu_20200216
close all; 
clc;

format shortg
c = clock;
disp(c);

currentNdl = input('currentNdl: ');
currentHight = input('currentHight:  ');
currentRun = input('currentRun:  ');

prefix_1 = 'C:\Users\lab-admin\Desktop\Lichen_Wu\movies_processed\ndl';
prefix_10 = num2str(currentNdl);
prefix_11 = '_hgt';
prefix_6 = num2str(currentHight);
prefix_7 ='_r';
prefix_2 = num2str(currentRun);
prefix_3 ='\ndl';
prefix_12 = num2str(currentNdl);
prefix_13 = '_ht';
prefix_8 =num2str(currentHight);
prefix_9 ='_r';
prefix_4 =num2str(currentRun);
prefix_5= '_';

prefix = strcat(prefix_1,prefix_10,prefix_11,prefix_6,prefix_7,prefix_2,prefix_3,...
    prefix_12,prefix_13,prefix_8,prefix_9,prefix_4,prefix_5);
disp(prefix);




ext = '.bmp';
ext_out = '.txt';


ref_index = input('reference image (ref_index =?):  ');
FirstIm = ref_index + 1;
LastIm = input('last image before impacting (LastIm =?):  ');
totalNumber = LastIm - FirstIm + 1 ;
ref_a = imread(strcat(prefix,num2str(ref_index, '%05g'),ext),'bmp'); 

numCircledFailuer = 0;

for i = 0:1:totalNumber
 
    if i==0
        ii = FirstIm;
    else
        ii = FirstIm + i;
    end
    
    
    if(ii == LastIm + 1)
        fprintf('Total %d images have been processed, %d have been circled, %d have been centroided.\n', ...
            totalNumber, totalNumber - numCircledFailuer, numCircledFailuer);
        disp('------');
        diary myDiaryFile
        break;
    end
    
    
%     disp('The present image number: ');
%     disp(ii);
    filename = strcat(prefix, num2str(ii, '%05g'),ext);
%     [a, map] = imread(filename);
    a = imread(filename);

    a0 =ref_a-a; %subtract the background
    a0_max = double(max(max(a0)))/256.0;
    a1 = imadjust(a0, [0.01 a0_max], [0 1]); %for a better contrast
    BW = a0>max(max(a0))/5; %another way to convert into BW 

    
    [centers,radii] = imfindcircles(BW,[38 65],'ObjectPolarity','bright');
    filename_out = strcat(prefix,'Circled',num2str(ii, '%05g'),ext_out);
    
    siz=size(radii);
    if(siz(1) > 1)
        disp('Detect more than one circles');
        disp('current image');
        disp(ii);
        break;
    end
    
    if(size(radii) == 0)
        
        numCircledFailuer = numCircledFailuer + 1;
        filename_out = strcat(prefix,'Centroided',num2str(ii, '%05g'),ext_out);
        
        stats = regionprops('table',BW,'Centroid',...
            'MajorAxisLength','MinorAxisLength','Orientation');
        centers = stats.Centroid;
        centers = centers(1,:);
        majorAxisLength = stats.MajorAxisLength(1);
        minorAxisLength =stats.MinorAxisLength(1);
        orientation = stats.Orientation(1);
        
        fid = fopen(filename_out,'w');
        fprintf(fid, '%8.2f \t %8.2f \t %8.2f \t %8.2f \t %d\n',[centers(1);centers(2); majorAxisLength;...
            minorAxisLength; orientation]); 
        fclose(fid);
    
        continue

    end
    

    
    figure(1);
    imshow(a);
    hold on
    viscircles(centers,radii);
    hold off

    fid = fopen(filename_out,'w');
    fprintf(fid, '%8.2f \t %8.2f \t %8.2f\n',[centers(1);centers(2); radii]); %relative to flat surface
    fclose(fid);
end

