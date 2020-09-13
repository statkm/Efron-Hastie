proc product_status;
run;


data dat_gfr ;
  infile '/folders/myfolders/CASI/Efron-Hastie/data/gfr.txt' ;
  input gfr  ;
  SampleID =_n_ ;
run ;


proc means data=dat_gfr n mean median STDERR ;
  var gfr ;
run ;


proc univariate data= dat_gfr ;
  histogram gfr / midpoints= 20 to 120 by 3 ;
run ;


/* median s.e. Bootstrap */

%let NumSamples = 1000 ;       /* number of bootstrap resamples */
proc surveyselect data=dat_gfr NOPRINT seed=1
     out=BootSSFreq(rename=(Replicate=SampleID2))
     method=urs OUTHITS      /* resample with replacement 
     							OUTHITSで重複についても表示 */
     samprate=1              /* each bootstrap sample has N observations */
     /* OUTHITS                 option to suppress the frequency var */
     reps=&NumSamples;       /* generate NumSamples bootstrap resamples */
run ;

proc means data=BootSSFreq noprint ;
  var gfr ;
  output out=out_ds_median median = median ;
  by sampleID2 ;
run ;

proc means data= out_ds_median stddev ;
  var median ;
run ;






/* Winsorized mean */

proc means data=dat_gfr noprint ;
  var gfr ;
  output out=out_ds q1=q1 q3=q3 ;
run ;


data _null_ ;
  set out_ds ;
  call symputx('q1', q1) ;
  call symputx('q3', q3) ;
run ;


data dat_gfr_wm ;
  set dat_gfr ;
  if gfr < &q1. then gfr2 = &q1. ;
  else do ;
    if gfr < &q3. then gfr2=gfr ;
    else gfr2 = &q3. ;  
  end ;
run ;

proc means data=dat_gfr_wm mean ;
  var gfr2 ;
run ;


/* finish */



/* Winsorized mean s.e. Bootstrap  */

%let NumSamples = 1000 ;       /* number of bootstrap resamples */
proc surveyselect data=dat_gfr NOPRINT seed=1
     out=BootSSFreq(rename=(Replicate=SampleID2))
     method=urs OUTHITS      /* resample with replacement 
     							OUTHITSで重複についても表示 */
     samprate=1              /* each bootstrap sample has N observations */
     /* OUTHITS                 option to suppress the frequency var */
     reps=&NumSamples;       /* generate NumSamples bootstrap resamples */
run ;

proc means data=BootSSFreq noprint ;
  var gfr ;
  output out=out_ds q1 = q1 q3 = q3 ;
  by sampleID2 ;
run ;

data BootSSFreq_WM ;
  merge BootSSFreq out_ds ;
  by sampleid2 ;
  if gfr < q1 then gfr2 = q1 ;
  else do ;
    if gfr < q3 then gfr2=gfr ;
    else gfr2 = q3 ;  
  end ;
run ;

proc means data=BootSSFreq_WM noprint ;
  var gfr2 ;
  by sampleid2 ;
  output out=out_ds_wm mean=mean;
run ;

proc means data=out_ds_wm stddev ;
  var mean ;
run ;





