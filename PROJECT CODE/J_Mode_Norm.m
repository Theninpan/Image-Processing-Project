function mode_filtered = J_Mode_Norm(g)

img_restored=zeros(size(g,1)); %empty image matrix
g = padarray(g,[2 2],0,'both');
[r,c,h]=size(g);
for i=3:r-2
    for j=3:c-2
        mat_tmp = [g(i-2:i+2,j-2:j+2,:)];
        for k=1:3
            tmp_mat=mat_tmp(:,:,k);
            img_restored(i-2,j-2,k)=mode(tmp_mat(:));
        end        
    end
end 
mode_filtered=img_restored;
return