proc product_status;
run;


data dat_kidney ;
  infile '/folders/myfolders/CASI/Efron-Hastie/data/kidney.txt' FIRSTOBS=2 ;
  input age  tot  ;
  SampleID =_n_ ;
run ;


proc means data=dat_kidney ;
  var _all_ ;
run ;


proc sgplot data=dat_kidney ;
*  scatter x=age y=tot / MARKERATTRS =(color=Blue symbol = Asterisk) ;
  REG x=age y=tot / 
  	LINEATTRS =(color=GREEN ) 
  	MARKERATTRS =(color=Blue symbol = Asterisk) 
  	CLM ;
run;

* ods trace off ;
proc loess data=dat_kidney;
   model tot = age / smooth=.333 STD ;
   output out=out_loess P ;
run;


/* Bootstrapによる s.e.計算 */

%let NumSamples = 250 ;       /* number of bootstrap resamples */
/* 2. Generate many bootstrap samples */
proc surveyselect data=dat_kidney NOPRINT seed=1
     out=BootSSFreq(rename=(Replicate=SampleID2))
     method=urs OUTHITS      /* resample with replacement 
     							OUTHITSで重複についても表示 */
     samprate=1              /* each bootstrap sample has N observations */
     /* OUTHITS                 option to suppress the frequency var */
     reps=&NumSamples;       /* generate NumSamples bootstrap resamples */
run ;




proc loess data= work.BOOTSSFREQ  ;
   model tot = age / smooth=.333 STD ;
   by sampleid2 ;
run ;




