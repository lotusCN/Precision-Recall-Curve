%%  调用说明    20181215  version1@lotus
%   aupr =pr_cure（预测分数,原始标准答案,colour)
%   返回PR曲线和PR曲线下面积aupr
%   PR曲线：precison-recall curve。

function aupr =pr_cure(output,original,colour)

    %%  测试例子1
    %{
        colour='red';
        %label_y=[1 1 1 0 1 0 1 1 0 1];
       % deci=[0.89 0.7 0.87 0.32 0.50 0.14 0.44 0.59 0.74 0.99];
        label_y=[0 0 0 0 1 1 1 1 1 1 ];
        deci=[0.99 0.2 0.3 0.4  0.5 0.6 0.7 0.8 0.9 0.95];
    %}


    %% 按预测结果分数deci降序排序，标准答案roc
    [threshold,ind] = sort(output,'descend');  %[阈值，下标]，把预测分数降序排序
    roc_y = original(ind);    %与阈值预测结果对应的标准答案

    %% 求x轴recall的各个点，求y轴precison的各个点。求PR曲线下面积aupr
    P=[1:length(roc_y)]';   %实际上是求(TP+FP)，即所有预测为阳的个数。因为阈值已是降序排序，阈值对应的下标即（TP+FP）
    stack_x = cumsum(roc_y == 1)/sum(roc_y == 1); %x轴：TPR=recall=TP/(TP+FN)=预测为阳的正类/所有正类
    stack_y = cumsum(roc_y == 1)./P; %y轴：precision=TP/(TP+FP)=预测为阳的正类/所有预测为阳
   % stack_x = cumsum(roc_y == 0)/sum(roc_y == 0);
   % stack_y = cumsum(roc_y == 1)/sum(roc_y == 1);
    aupr=sum((stack_x(2:length(roc_y))-stack_x(1:length(roc_y)-1)).*stack_y(2:length(roc_y)));  %PR曲线下面积

    %% 画PR曲线
    % subplot(2,2,1);   %把绘图窗口分成两行两列四块区域，然后在每个区域分别作图。在第一块绘图
    %figure;
    plot(stack_x,stack_y,colour);
    xlabel('recall');
    ylabel('precision');

end



%% 
%调用myACC_1求ACC、F1_score等的四种方法示范
    %myACC_1( deci,label_y,'sp0.99' ); %  method有'sp0.99'，'sp0.95'， 'youden'，'accMAX'四种
    %myACC_1( deci,label_y,'sp0.95' );
    %myACC_1( deci,label_y,'youden' );
    %myACC_1( deci,label_y,'accMAX' );
