# PR_Curve
Matlab code for computing and visualization:  Precision-Recall curve,  AUPR, Accuracy  etc. for Classification.


pr_curve.m can plot Precision-Recall-Curve and output the value of AUPR.


myACC.m can calcuate the values of ACC, PRE, SEN, F1_score, MCC under 5 different conditions.
        
Note that 5 conditions including method='sp0.99'or'sp0.95'or 'youden'or 'accMAX' or 'f1sMAX'. 

Usually we define method='sp0.99' or 'sp0.95'.
