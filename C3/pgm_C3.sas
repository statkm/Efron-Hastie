proc product_status;
run;


data dat_score ;
  infile '/folders/myfolders/CASI/Efron-Hastie/data/student_score.txt' firstobs=2 ;
  input mech vecs alg analy stat  ;
  SampleID =_n_ ;
run ;

proc corr data=dat_score ;
run ;




