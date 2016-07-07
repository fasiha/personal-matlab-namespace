function [] = rgbaToPng(c, fname)
imwrite(c(:,:, 1:3), fname, 'Alpha', c(:,:, 4));
