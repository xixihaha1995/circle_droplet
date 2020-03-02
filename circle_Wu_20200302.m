% drop_edge_Wu_20200216
close all; 
clc;


prefix = 'C:\Users\lab-admin\Desktop\Lichen_Wu\movies_processed\ndl14_hgt4_r1\ndl14_h4_r1_';

ext = '.bmp';
ext_out = '.txt';
OutputDir = 'C:\Users\lab-admin\Desktop\Lichen_Wu\images\Processed_20200107_ndl14_h4_r1\Circled_ndl14_h4_r1_';


ref_index = input('Please enter the number of the reference image (ref_index =?):  ');
FirstIm = ref_index + 1;
LastIm = input('Please enter number of the last image (LastIm =?):  ');
totalNumber = LastIm - FirstIm+1 ;

ref_a = imread(strcat(prefix,num2str(ref_index, '%05g'),ext),'bmp'); 


centersSave{totalNumber} = [];
radiiSave{totalNumber} = [];
for i = 0:1:totalNumber
 
    if i==0
        ii = FirstIm;
    else
        ii = FirstIm + i;
    end
    
    disp('The present image number: ');
    disp(ii);
    filename = strcat(prefix, num2str(ii, '%05g'),ext);
    [a, map] = imread(filename);
    a = imread(filename, 'bmp');

    a0 =ref_a-a; %subtract the background
    a0_max = double(max(max(a0)))/256.0;
 
    a1 = imadjust(a0, [0.01 a0_max], [0 1]); %for a better contrast
    BW = a0>max(max(a0))/5; %another way to convert into BW 

    [centers,radii] = imfindcircles(BW,[40 65],'ObjectPolarity','bright');
    centersSave{i+1} = centers;
    radiiSave{i+1} = radii;
    
    figure(1);
    imshow(a);
    hold on
    viscircles(centers,radii);
    hold off
    if(size(radii) == 0)
        continue;
    end
    filename_out = strcat(OutputDir,num2str(ii, '%05g'),ext_out);
    fid = fopen(filename_out,'w');
    fprintf(fid, '%8.2f \t %8.2f \t %8.2f\n',[centers(1);centers(2); radii]); %relative to flat surface
    fclose(fid);
end

