function Imgs = chop_image(Image,Row_Block,Col_Block)
[r, c] = size(Image);
% Now scan though, storing each block in a cell array
Count = 1;
for row = 1 : Row_Block : r
	for col = 1 : Col_Block : c
		row1 = row;
		row2 = row1 + Row_Block - 1;
		col1 = col;
		col2 = col1 + Col_Block - 1;
		% Extract out the block into a single subimage.
		Img = Image(row1:row2, col1:col2);
        %Storing the extracted image inside a cell array
        Imgs{Count}=(Img);
		Count = Count + 1;
	end
end

end