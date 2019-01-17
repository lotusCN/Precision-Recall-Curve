%%  调用说明    20181215  version1@lotus
%  [ACC,PRE,SEN,F1_score,MCC] = myACC_2(预测分数,原始标准答案,method)
%  method='sp0.99'or'sp0.95'or 'youden'or 'accMAX' or 'f1sMAX'

        % method一般都是用sp0.99和sp0.95
        %'sp0.99'or'sp0.95'：以sp=0.99或0.95作为阈值求解 。%找到最接近FPR_value=0.01或0.05的位置
        %'youden'：用Youden约登指数定阈值,即当TPR-FPR取最大值时。约等于求最靠近左上角的点时的阈值
        %'accMAX'：用ACC最大值定阈值
        %'f1sMAX':用F1_score最大值定阈值

function [ACC,PRE,SEN,F1_score,MCC] = myACC( output,original,method )
      
   
    %% 检查是否已将矩阵变成一列
    output=output(:);
    original=original(:);

    %% 统计正类和负类个数
    count1=length(find(original==1));  %正类个数=TP+FN=真阳+假阴
    count0=length(find(original==0));  %负类个数=FP+TN=假阳+真阴

    [tpr,fpr,thresholds] = roc(original(:)',output(:)');  %[真阳率，假阳率,阈值]
    TP=count1*tpr;  %TP：真阳类个数。
    FP=count0*fpr;  %FP：假阳类个数
    ACC= (TP+count0-FP)/(count1+count0);  %准确率ACC=(TP+TN)/all=(真阳+真阴)/all  ,真阴TN=count0-假阳FP
    F1_score=2*TP./(TP+count1);  %F1分数=2P*R/(P+R)，精确率P ，敏感度R

    %% 选择一种方法决定阈值  
        % method='sp0.99'，'sp0.95'， 'youden'，'accMAX'四种
     
        %设定sp的值求ACC
        if method=='sp0.99' 
            sp_value=0.99 ;  %  sp=0.99，1-sp=FPR=0.01。
            [~,position]=min(abs( fpr-(1-sp_value)));  %找到最接近FPR_value的位置

        %设定sp的值求ACC。 
        elseif method=='sp0.95'
            sp_value=0.95 ;   % sp=0.95，1-sp=FPR=0.05。
            [~,position]=min(abs( fpr-(1-sp_value)));  %找到最接近FPR_value的位置

        %用Youden约登指数定阈值
        elseif method=='youden'
            [~,position]=max(abs(tpr-fpr));  %用约登指数定阈值,即当TPR-FPR取最大值时。

        %用ACC最大值定阈值
        elseif method=='accMAX'
            [~,position]=max(ACC); 
        

        %用ACC最大值定阈值
        elseif method=='f1sMAX'
            [~,position]=max(F1_score);
        end
        
        %（一般不用）求特定阈值的ACC
        %thre_value=0.05;  %设定阈值的值求ACC
        %[~,position]=min(abs(thresholds-thre_value));

    %% 求当前阈值的ACC等结果
    thre=thresholds(position); %求当前阈值
    TP=count1*tpr(position);  %TP：真阳类个数。
    FP=count0*fpr(position);  %FP：假阳类个数。
    FN=count1-TP;
    TN=count0-FP;

    %% 求结果：PRE/SEN/ACC/F1_score/MCC
    PRE=TP/(TP+FP)  ;  %精确率PRE=TP/TP+FP
    SEN=tpr(position); %敏感度SEM=真阳率TPR        %或者SEN=TP/(count1)
    ACC= (TP+count0-FP)/(count1+count0);  %准确率ACC=(TP+TN)/all=(真阳+真阴)/all  ,真阴TN=count0-假阳FP
    F1_score=2*TP/(count1+TP);  %F1分数=2P*R/(P+R)，精确率P ，敏感度R
    MCC=(TP*TN -FP*FN)/sqrt(count1*count0*(TP+FP)*(FN+TN));
    fprintf([ method,'：ACC=',num2str(ACC), '   PRE=',num2str(PRE), '   SEN=',num2str(SEN), '  F1 score=',num2str(F1_score), '   MCC=',num2str(MCC),  '\n']);
    
    %auc=roc_1(output(:),original(:),'red') %看一下ROC
    end
    
    
    
%%
    %%调用myACC_1求ACC、F1_score等的五种方法示范 %  method有'sp0.99'，'sp0.95'， 'youden'，'accMAX' 'f1MAX'五种
    %myACC_1(output,original,'sp0.99' );
    %myACC_1(output,original,'sp0.95' );
    %myACC_1(output,original,'youden' );
    %myACC_1(output,original,'accMAX' );
    %myACC_1(output,original,'f1sMAX' );
