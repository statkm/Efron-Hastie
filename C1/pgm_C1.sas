proc product_status;
run;

* C1 ;

data dat_kidney ;
  infile '/folders/myfolders/CASI/kidney.txt' FIRSTOBS=2 ;
  input age  tot  ;
run ;


proc means data=dat_kidney ;
  var _all_ ;
run ;


proc sgplot data=dat_kidney ;
*  scatter x=age y=tot / MARKERATTRS =(color=Blue symbol = Asterisk) ;
  REG x=age y=tot / MARKEROUTLINEATTRS =(color=GREEN ) MARKERATTRS =(color=Blue symbol = Asterisk)  ;
run;