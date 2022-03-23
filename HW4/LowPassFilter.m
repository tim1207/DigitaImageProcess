function[] = LowPassFilter(imagePath,radius)

    img = imread(imagePath);
    img = double(img);
    [M ,N]=size(img);
    %539    540
    x=0:N-1;
    y=0:M-1;
   
    subplot(2, 3, 1)
    imshow(img,[]);
    title(sprintf('Origin image'),'FontSize',8);
      
    F = fft2(img);
    Fsh = fftshift(F);
    log_img = log(1+abs(Fsh));
    subplot(2, 3, 2)
    imshow(log_img, []);
    title(sprintf('Origin image in Frequency Domain'),'FontSize',8);
     
    [X ,Y]=meshgrid(x,y);
    Cx=0.5*N;
    Cy=0.5*M;
    Co=(radius-sqrt((X-Cx).^2+(Y-Cy).^2))/radius;
    
    for i=1:M
        for j=1:N
            if (Co(i,j)<0)
                Co(i,j) =0;
            end
        end
    end
    subplot(2,3,3);
    imshow(Co);
    title(sprintf('Cone filter with radius ＝ 50'),'FontSize',8);
    
    freImageTran = fftshift(fft2(img));
    CoFre = fftshift(fft2(Co)); 
    
    filterImage = freImageTran .* Co;
    result = ifftshift(filterImage);
    result = ifft2(result);
    
    subplot(2,3,4);
    imshow(abs(result)/255);
    title(sprintf('Cones filter result'),'FontSize',8);
    
    
     tx = -(N/2):N/2-1;
     ty = -(M/2):M/2-1;
     [tX ,tY]=meshgrid(tx,ty);
     Co2 = tX.* tY;
     Co2 = Co2.* 0;
     Co2 = Co2 + 1;
     Co2 = Co2 .* Co;
    
     subplot(2,3,5);
     
     mesh(tX,tY,Co2,'FaceColor','Flat')
     title(sprintf('Cones filter 3D Visualization'),'FontSize',8);
     xlim([-300 300]) 
     ylim([-300 300])
    
    
    subplot(2,3,6);
    imshow(log(1+abs(CoFre)),[]);
    title(sprintf('Cone filter in Frequency domain'),'FontSize',8);

    
     
end


