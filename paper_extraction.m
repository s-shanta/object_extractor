function [out] = paper_extraction(in)
%% Read Image 
Inputimage= in;
%figure;
%imshow(Inputimage);

%% PreProcess

if size(Inputimage,3)==3 % RGB image
 Inputimage=rgb2gray(Inputimage);
end

Inputimage =  medfilt2(Inputimage);

%figure;
%imshow(Inputimage);

Inputimage = edge(Inputimage,'log');

%figure;
%imshow(Inputimage);

%% Localization and extraction

%threshold = graythresh(Inputimage);
Inputimage =im2bw(Inputimage);

nhood = [1 1 1 1;1 1 1 1];
Inputimage = imdilate(Inputimage,nhood);

%figure;
%imshow(Inputimage);

[L Ne]=bwlabel(Inputimage);
measurements = regionprops(L, 'BoundingBox');
for k = 1 : length(measurements)
    thisBB = measurements(k).BoundingBox;
    rectangle('Position',[thisBB(1),thisBB(2),thisBB(3),thisBB(4)],'EdgeColor','b','LineWidth',1 );
end

%figure;
out = L;

%% Component filtering

for n=1:Ne
  [r,c] = find(L==n);
  h = max(r)-min(r);
  w = max(c)-min(c);
  if((w <=(2*h)) && (h*w)>30 )
    n1=Inputimage(min(r):max(r),min(c):max(c));
    figure;
    imshow(n1);
    pause(0.5)
  end
end

end