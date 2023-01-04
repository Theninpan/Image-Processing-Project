function perf_dat = Evaluation(high_pass,low_pass,merged,g)

%PSNR
HighP_PSNR = psnr(high_pass,g);
LowP_PSNR = psnr(low_pass,g);
Merged_PSNR = psnr(merged,g);
PSNR_mat=[HighP_PSNR,LowP_PSNR,Merged_PSNR];

%Entropy
R_ent=entropy(high_pass(:,:,1));
G_ent=entropy(high_pass(:,:,2));
B_ent=entropy(high_pass(:,:,3));
HighP_ent=(R_ent+G_ent+B_ent)/3;

R_ent=entropy(low_pass(:,:,1));
G_ent=entropy(low_pass(:,:,2));
B_ent=entropy(low_pass(:,:,3));
LowP_ent=(R_ent+G_ent+B_ent)/3;

R_ent=entropy(merged(:,:,1));
G_ent=entropy(merged(:,:,2));
B_ent=entropy(merged(:,:,3));
Merge_ent=(R_ent+G_ent+B_ent)/3;


ent_mat=[HighP_ent,LowP_ent,Merge_ent];

%RMSE
HighP_rmse=rmse(high_pass,g);
LowP_rmse=rmse(low_pass,g);
merge_rmse=rmse(merged,g);
rmse_mat=[HighP_rmse,LowP_rmse,merge_rmse];

%MAE
HighP_mae=meanAbsoluteError(high_pass,g);
LowP_mae=meanAbsoluteError(low_pass,g);
merge_mae=meanAbsoluteError(merged,g);
mae_mat=[HighP_mae,LowP_mae,merge_mae];

%MSE
HighP_mse=MSE3D(g,high_pass);
LowP_mse=MSE3D(g,low_pass);
merge_mse=MSE3D(g,merged);
mse_mat=[HighP_mse,LowP_mse,merge_mse];


perf_dat=[ent_mat;rmse_mat;mae_mat;PSNR_mat;mse_mat];

return