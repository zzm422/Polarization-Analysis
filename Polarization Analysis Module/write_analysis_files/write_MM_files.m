function[] = write_MM_files(mmMatrices, path, file)

csvPath = strcat(path, 'CSVs/');
colourPath = strcat(path, 'Colour/');
greyscalePath = strcat(path, 'Greyscale/');
greyscaleNoScalePath = strcat(path, 'Greyscale [No Scalebar]/');
greyscaleNoScaleRescaledPath = strcat(path, 'Greyscale [No Scalebar] - Rescaled/'); %values shifted to line up with greyscale range in bmps

for i=1:4
    for j=1:4 
        dlmwrite(strcat(csvPath, file, '_m', num2str(j-1), num2str(i-1), '.csv'), (mmMatrices(:,:,j,i)), 'precision',7);
        dlmwrite(strcat(csvPath, file, '_nm', num2str(j-1), num2str(i-1), '.csv'), (scale_for_bmp(mmMatrices(:,:,j,i), -1, 1)), 'precision',7);
        
        figure;
        set(gcf,'Visible','off');
        imagesc(mmMatrices(:,:,j,i)),colormap jet,axis image,axis off,colorbar, caxis([-1,1]);
        saveas(gcf, strcat(colourPath, file, '_m', num2str(j-1), num2str(i-1),'_colour.png'));
        colormap gray;
        saveas(gcf, strcat(greyscalePath, file, '_m', num2str(j-1), num2str(i-1),'_greyscale.png'));
        close;
                
        imwrite(mmMatrices(:,:,j,i), strcat(greyscaleNoScalePath, file, '_m', num2str(j-1), num2str(i-1), '.bmp'));
        imwrite(scale_for_bmp(mmMatrices(:,:,j,i), -1, 1), strcat(greyscaleNoScaleRescaledPath, file, '_nm', num2str(j-1), num2str(i-1), '.bmp'));
    end
end

compositePath = strcat(path, 'Composites/');

figure;
set(gcf,'color','w');
set(gcf,'Visible','off');

%tight_subplot is an fn from an external file
composite = tight_subplot(4,4,0.005,0.02,0.005);

for j=1:4,
    for i=1:4,
        axes(composite(((j-1)*4)+i));
        imshow(mmMatrices(:,:,j,i));
        set(gcf,'Visible','off');
        axis image;
        axis off;
    end
end

saveas(gcf, strcat(compositePath, file,'_mm_composite_m-series.png'));
close;

figure;
set(gcf,'color','w');
set(gcf,'Visible','off');

%tight_subplot is an fn from an external file
composite = tight_subplot(4,4,0.005,0.02,0.005);

for j=1:4,
    for i=1:4,
        axes(composite(((j-1)*4)+i));
        imshow(scale_for_bmp(mmMatrices(:,:,j,i), -1, 1));
        set(gcf,'Visible','off');
        axis image;
        axis off;
    end
end

saveas(gcf, strcat(compositePath, file,'_mm_composite_nm-series.png'));
close;

figure;
set(gcf,'color','w');
set(gcf,'Visible','off');

%tight_subplot is an fn from an external file
composite = tight_subplot(4,4,0.005,0.02,0.005);

%determine upper and lower bounds for image scaling
minValue = Inf(1);
maxValue = -Inf(1);

for i=1:4,
    for j=1:4,
        maxIndex = max(max(mmMatrices(:,:,j,i)));
        minIndex = min(min(mmMatrices(:,:,j,i)));
        
        if (minIndex < minValue)
            minValue = minIndex;
        end
        
        if (maxIndex > maxValue)
            maxValue = maxIndex;
        end
    end
end

for i=1:4,
    for j=1:4,
        axes(composite(((j-1)*4)+i));
        imagesc(mmMatrices(:,:,j,i),[minValue,maxValue]);
        set(gcf,'Visible','off');
        colormap gray;
        axis image;
        axis off;
    end
end

saveas(gcf, strcat(compositePath, file, '_mm_composite_max_scaled.png'));
close;