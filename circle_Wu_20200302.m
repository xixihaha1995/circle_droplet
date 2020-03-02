% drop_edge_Wu_20200216
close all; 
clc;
currentHight = 1;
currentRun = 2;
prefix_1 = 'C:\Users\lab-admin\Desktop\Lichen_Wu\movies_processed\ndl14_hgt';
prefix_6 = num2str(currentHight);
prefix_7 ='_r';
prefix_2 = num2str(currentRun);
prefix_3 ='\ndl14_ht';
prefix_8 =num2str(currentHight);
prefix_9 ='_r';
prefix_4 =num2str(currentRun);
prefix_5= '_';

prefix = strcat(prefix_1,prefix_6,prefix_7,prefix_2,prefix_3,prefix_8,prefix_9,prefix_4,prefix_5);

ext = '.bmp';
ext_out = '.txt';


ref_index = input('Please enter the number of the reference image (ref_index =?):  ');
FirstIm = ref_index + 1;
LastIm = input('Please enter number of the last image (LastIm =?):  ');
totalNumber = LastIm - FirstIm+1 ;

ref_a = imread(strcat(prefix,num2str(ref_index, '%05g'),ext),'bmp'); 

numCircledFailuer = 0;
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

    [centers,radii] = imfindcircles(BW,[37 65],'ObjectPolarity','bright');
    centersSave{i+1} = centers;
    radiiSave{i+1} = radii;
    
    figure(1);
    imshow(a);
    hold on
    viscircles(centers,radii);
    hold off
    if(ii == LastIm + 1)
        fprintf('Total %d images have been processed, %d have been circled', ...
        totalNumber, totalNumber - numCircledFailuer);
        break;
    end
    if(size(radii) == 0)
        numCircledFailuer = numCircledFailuer + 1;
        continue;
    end
    
    siz=size(radii);
    if(siz(1) > 1)
        disp('Detect more than one circles');
        break;
    end
    filename_out = strcat(prefix,'Circled',num2str(ii, '%05g'),ext_out);
    fid = fopen(filename_out,'w');
    fprintf(fid, '%8.2f \t %8.2f \t %8.2f\n',[centers(1);centers(2); radii]); %relative to flat surface
    fclose(fid);
end

