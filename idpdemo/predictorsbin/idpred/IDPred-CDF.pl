#!/usr/bin/perl -w
#
# May 2010 by Bin Xue 
# Based on version of May. 2009, By Bin Xue
#
# Usage: ./IDPredStat.pl input.fasta
#   input.fasta is the aa sequence in FASTA format, multiple 
#      sequences in one file is allowed
#
# update:
#      1. 200808: add CDF_vl3 and CDF_vsl2
#      2. 200905: add FoldIndex, TopIDP, and IUPred
#      3. 200906: unify the definition of $ibg, $iend in reading individual predictions.
#      4. 201001: add in -w and revise accordingly.
#
  use strict;
  use warnings;
  use Data::Dumper;

  open(STDERR,'<&STDOUT'); $| = 1; 

  my ( $infasta ) = $ARGV[0];

  my ( $nfile,$ref_zfile,$ref_zseq,$ref_nlength) = read_input_multi_fasta($infasta);  
  
  run_pred_output( $nfile,$ref_zfile,$ref_zseq,$ref_nlength); 

  
# =====================================================================

# ---------------------------------------------------------------------
  sub run_pred_output {

     use strict;
     use warnings;

     my ( $nfile,$ref_zfile,$ref_zseq,$ref_nlength) = @_;
     my ( @zfile ) = @$ref_zfile;
     my ( @zseq ) = @$ref_zseq;
     my ( @nlength ) = @$ref_nlength;


     #my ($dir_PONDR,$dir_VSL2,$dir_MORF, $dir_IUPred,$dir_FoldIndex, $dir_TopIDP,$dir_out) = def_working_dir();
     my ($dir_VSL2, $dir_IUPred,$dir_out) = def_working_dir();
	 
	 
	 
#     open_output_outFF_all;
     my ( $zh0 ) = "NAME";
     open(OUTFF,">all_new_PONDRFIT.out");
    
     printf OUTFF "%-15s%6s%10s%5s%10s%5s%10s%5s%10s%5s%10s%5s%10s%5s%10s%5s%9s%11s%10s%10s%10s%8s%7s%8s%7s%8s%7s%8s%7s%8s%7s%8s%7s",$zh0," N ","R%_meta","No","R%_VLXT","No","R%_VL3","No","R%_VSL2B","No","R%_IUPred","No","R%_FD","No","R%_Top","No","No_MoRF","CH_Charge","CH_Hydro","CH_dist","CH_dist2","N_CDFx","dCDFx","N_CDFs","dCDFs","N_CDF3","dCDF3","N_CDFi","dCDFi","N_CDFf","dCDFf","N_CDFt","dCDFt";
     print OUTFF "\n";

     for ( my $ifile=0; $ifile<$nfile; $ifile++ ) {
        my ( $zff ) = $zfile[$ifile];
        my ( $zaa ) = $zseq[$ifile];
        my ( $nseq ) = $nlength[$ifile];

        write_single_FASTA($zff,$zaa);
        write_single_seqProf($zaa);

        #my ( $pr_vlxt,$nseg_vlxt ) = anal_VLXT($dir_out,$zff);#to be removed as per Dr Bin Xue request ... Iqbal Addou comment
        #my ( $pr_vl3,$nseg_vl3 ) = anal_VL3($dir_out,$zff);#to be removed as per Dr Bin Xue request ... Iqbal Addou comment
        my ( $pr_vsl2,$nseg_vsl2 ) = anal_VSL2B($dir_out,$zff);
###        anal_MoRF($zff);

        my ( $pr_iupred,$nseg_iupred ) = anal_IUPred($dir_out,$zff);
        #my ( $pr_fd,$nseg_fd ) = anal_FoldIndex($dir_out,$zff);#to be removed as per Dr Bin Xue request ... Iqbal Addou comment
        #my ( $pr_tp,$nseg_tp ) = anal_TopIDP($dir_out,$zff);#to be removed as per Dr Bin Xue request ... Iqbal Addou comment
        #my ( $pr_meta,$nseg_meta ) = anal_PONDRFIT($dir_out,$zff);#to be removed as per Dr Bin Xue request ... Iqbal Addou comment
        

        my ( $CH_charge,$CH_hydro,$CH_dist,$CH_dist2) = run_CH();
        #my ($ref_CDFpoints_vlxt,$ref_CDFpoints_vl3,$ref_CDFpoints_vsl2,$ref_CDFpoints_iupred,$ref_CDFpoints_fd,$ref_CDFpoints_tp) = read_CDFpoints();
		my ($ref_CDFpoints_vsl2,$ref_CDFpoints_iupred) = read_CDFpoints();

        #my ( $nCDF_vlxt,$acdf_vlxt ) = run_CDF_vlxt($dir_out,$zff,$ref_CDFpoints_vlxt);
        #my ( $nCDF_vl3,$acdf_vl3 ) = run_CDF_vl3($dir_out,$zff,$ref_CDFpoints_vl3);
        my ( $nCDF_vsl2,$acdf_vsl2 ) = run_CDF_vsl2b($dir_out,$zff,$ref_CDFpoints_vsl2);

        my ( $nCDF_iupred,$acdf_iupred ) = run_CDF_IUPred($dir_out,$zff,$ref_CDFpoints_iupred);
        #my ( $nCDF_fd,$acdf_fd ) = run_CDF_FoldIndex($dir_out,$zff,$ref_CDFpoints_fd);
        #my ( $nCDF_tp,$acdf_tp ) = run_CDF_TopIDP($dir_out,$zff,$ref_CDFpoints_tp);

        my $nMoRF = 0;

        #&write_pred_outFF($zff,$nseq,$pr_meta,$nseg_meta,$pr_vlxt,$nseg_vlxt,$pr_vl3,$nseg_vl3,$pr_vsl2,$nseg_vsl2,$pr_iupred,$nseg_iupred,$pr_fd,$nseg_fd,$pr_tp,$nseg_tp,$nMoRF,$CH_charge,$CH_hydro,$CH_dist,$CH_dist2,$nCDF_vlxt,$acdf_vlxt,$nCDF_vsl2,$acdf_vsl2,$nCDF_vl3,$acdf_vl3,$nCDF_iupred,$acdf_iupred,$nCDF_fd,$acdf_fd,$nCDF_tp,$acdf_tp);
        &write_pred_outFF($zff,$nseq,$pr_vsl2,$nseg_vsl2,$pr_iupred,$nseg_iupred,$nMoRF,$CH_charge,$CH_hydro,$CH_dist,$CH_dist2,$nCDF_vsl2,$acdf_vsl2,$nCDF_iupred,$acdf_iupred);

     }

     close(OUTFF);

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub def_working_dir{
     use strict;
     use warnings;

     #my ( $dir_PONDR )= "/opt/bin/";
     my ( $dir_VSL2 ) = "/tmp/ram/VSL2"; #"/opt/local/bin/";
     #my ( $dir_MORF ) = "/opt/local/MoRE/";
     my ( $dir_IUPred ) = "/tmp/ram/iupred";#"/home/binxue/Tools/IUPred/iupred/";
     #my ( $dir_FoldIndex ) = "/home/binxue/Tools/FoldIndex/";
     #my ( $dir_TopIDP ) = "/home/binxue/Tools/TopIDP/";
     my ( $dir_out ) = "/tmp/ram/idpred/pred-PONDRFIT/";

     #return ($dir_PONDR,$dir_VSL2,$dir_MORF, $dir_IUPred,$dir_FoldIndex, $dir_TopIDP,$dir_out);
     return ($dir_VSL2, $dir_IUPred , $dir_out);
  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub write_pred_outFF{
     no warnings;
	 
	 my($zfile,$nseq,$pr_meta,$nseg_meta,$pr_vlxt,$nseg_vlxt,$pr_vl3,$nseg_vl3,$pr_vsl2b,$nseg_vsl2b,$pr_iupred,$nseg_iupred,$pr_fd,$nseg_fd,$pr_tp,$nseg_tp,$nMoRF,$CH_charge,$CH_hydro,$CH_dist,$CH_dist2,$nCDF_vlxt,$acdf_vlxt,$nCDF_vsl2,$acdf_vsl2,$nCDF_vl3,$acdf_vl3,$nCDF_iupred,$acdf_iupred,$nCDF_fd,$acdf_fd,$nCDF_tp,$acdf_tp) = @_;
     printf OUTFF "%-15s%6d%10.3f%5d%10.3f%5d%10.3f%5d%10.3f%5d%10.3f%5d%10.3f%5d%10.3f%5d%9d%11.3f%10.3f%10.3f%10.3f%8d%7.3f%8d%7.3f%8d%7.3f%8d%7.3f%8d%7.3f%8d%7.3f",$zfile,$nseq,$pr_meta,$nseg_meta,$pr_vlxt,$nseg_vlxt,$pr_vl3,$nseg_vl3,$pr_vsl2b,$nseg_vsl2b,$pr_iupred,$nseg_iupred,$pr_fd,$nseg_fd,$pr_tp,$nseg_tp,$nMoRF,$CH_charge,$CH_hydro,$CH_dist,$CH_dist2,$nCDF_vlxt,$acdf_vlxt,$nCDF_vsl2,$acdf_vsl2,$nCDF_vl3,$acdf_vl3,$nCDF_iupred,$acdf_iupred,$nCDF_fd,$acdf_fd,$nCDF_tp,$acdf_tp;
     printf OUTFF "\n";
	 
  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub write_single_FASTA{

     use strict;
     use warnings;

     my($zff,$zaa) = @_;

     open(OUTA,">tmp.fasta");
        print OUTA ">",$zff,"\n";
        print OUTA $zaa,"\n";
     close(OUTA);

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub write_single_seqProf{
     use strict;
     use warnings;

     my($zaa) = @_;
     open(OUTB,">tmp.seq");
        print OUTB $zaa,"\n";
     close(OUTB);

  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub open_output_outFF_all{
   
     use strict;
     use warnings;

     my ($zh0) = "";
     open(OUTFF,">all_new.out");

     printf OUTFF "%15s%6s%10s%5s%10s%5s%10s%5s%10s%5s%10s%5s%10s%5s%10s%5s%9s%11s%10s%10s%10s%8s%7s%8s%7s%8s%7s%8s%7s%8s%7s%8s%7s",$zh0," N ","R%_meta","No","R%_VLXT","No","R%_VL3","No","R%_VSL2B","No","R%_IUPred","No","R%_FD","No","R%_Top","No","No_MoRF","CH_Charge","CH_Hydro","CH_dist","CH_dist2","N_CDFx","dCDFx","N_CDFs","dCDFs","N_CDF3","dCDF3","N_CDFi","dCDFi","N_CDFf","dCDFf","N_CDFt","dCDFt";
     print OUTFF "\n";

  }
# ---------------------------------------------------------------------





# ---------------------------------------------------------------------
  sub read_CDFpoints{
     use strict;
     use warnings;

#===== these CDF points are from Chris 11-17
#    my ( @CDFpoints_vlxt ) = ( 1.6854594e-01, 2.4062123e-01, 2.9459226e-01, 3.5187231e-01,
#                         4.0408285e-01, 4.5250932e-01, 4.9398914e-01, 5.3662253e-01,
#                         5.7788765e-01, 6.1747296e-01, 6.5656028e-01, 6.9487312e-01,
#                         7.3230155e-01, 7.7360084e-01, 8.1414959e-01, 8.5387866e-01,
#                         9.0515831e-01, 9.4674352e-01, 9.6968641e-01, 1.0000000);


#===== these CDF points are from my small training set, 11-17
#     my ( @CDFpoints_vlxt ) = ( 0.11696713523, 0.16778117962, 0.21542493708, 0.25386033162,
#                         0.30094449298, 0.34161865682, 0.39084201959, 0.42856061948,
#                         0.46961460564, 0.50897891537, 0.54631100842, 0.73774663181,
#                         0.78187865581, 0.82315671970, 0.86169322254, 0.90848786008,
#                         0.94729937777, 0.97643044457, 0.89630520703, 1.0000000);
     

#===== these CDF points are from my small training set  6-12
     my ( @CDFpoints_vsl2 ) = ( 0.00466834295, 0.01376322418, 0.03697131523, 0.07022659780,
                         0.11425834113, 0.15368471778, 0.30261342094, 0.36856397137,
                         0.46193997756, 0.55290908335, 0.59143473289, 0.70183795083,
                         0.75817983440, 0.77392184613, 0.81779464445, 0.87469574654,
                         0.92288343420, 0.95943457668, 0.82201985457, 1.0000000);


#===== these CDF points are from my samll training set, change later 7-15
#     my ( @CDFpoints_vl3 ) = ( 0.03326464640, 0.08004993602, 0.16470180385, 0.23852552215,
#                        0.35717913609, 0.43047282518, 0.54910757314, 0.49017170949,
#                        0.52328909057, 0.55495293480, 0.72435313801, 0.81120017703,
#                        0.88933859337, 0.90644927298, 0.96679661502, 0.89926457447,
#                        0.91882926200, 0.96519016395, 0.99045997891, 1.0000000);

# ===== optimized by using all_aft_clust-1.lst, and DisProt-20080715-fullyD3-1.lst, 5-7
#     my ( @CDFpoints_fd ) = ( 0.01529385291, 0.0183363457, 0.0247228955, 0.0390724139, 0.0051529583,
#                        0.03578952411, 0.0686254464, 0.1617305606, 0.3076264417, 0.4930640540,
#                        0.70091464797, 1.0000000000, 1.0000000000, 1.0000000000, 1.0000000000,
#                        1.00000000000, 1.0000000000, 1.0000000000, 0.9927396805, 0.9928248246);

# ===== optimized by using all_aft_clust-1.lst, and DisProt-20080715-fullyD3-1.lst, 5th-9th
     my ( @CDFpoints_iupred ) = ( 0.0440126937, 0.1138367067, 0.2100638033, 0.2891087091, 0.5701771155,
                           0.4495559353, 0.6252845738, 0.6913970717, 0.8530415185, 0.8955413640,
                           0.6844522451, 1.0000000000, 1.0000000000, 1.0000000000, 1.0000000000,
                           1.0000000000, 1.0000000000, 1.0000000000, 0.9928248246, 0.9928248246);

# ===== optimized by using all_aft_clust-1.lst, and DisProt-20080715-fullyD3-1.lst, 9th-11th
#     my ( @CDFpoints_tp ) = (  0,          0,          0,          0.00106868,
#                        0.00709331, 0.02977107, 0.05713761, 0.09107103,
#                        0.16447473, 0.48225988, 0.85346154, 0.99123819,
#                        0.99125701, 0.99720349, 0.99952626, 1,
#                        1, 1, 1, 1);


     #return ( \@CDFpoints_vlxt,\@CDFpoints_vl3,\@CDFpoints_vsl2,\@CDFpoints_iupred,\@CDFpoints_fd,\@CDFpoints_tp);
      return ( \@CDFpoints_vsl2,\@CDFpoints_iupred); 
  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub run_CDF_TopIDP{
     use strict;
     use warnings;

     my ( $dir_out,$zfile,$ref_CDFpoints_tp) = @_;

     my ( $infile ) = $dir_out.$zfile.".tp";
     my ( @trecd ) = read_all_records_of_a_file($infile);
     my $nrecd;
     $nrecd = @trecd;

     my ( $ibg )     = 0;
     my ( $iend )    = $nrecd - 1;
    
     my ( $ibin)    = 20;         ##### No. of bins in CDF plot
     my ( $ibin_bg) = 9;          ##### starting point of the boundary
     my ( $ibin_end)= 11;         ##### ending point of the boundary

     my ( $ref_tpred ) = read_pred_pondrFORMAT(\@trecd,$ibg,$iend);
     my ( $ref_histo ) = cal_histogram_20bins( $ref_tpred,$ibin);
     my ( $ref_cdf, $ref_dcdf ) = cal_cdf_20HisBin($ref_CDFpoints_tp,$ibin,$ref_histo);

     my ( $points,$acdf_tp ) = cal_cdf_status($ref_CDFpoints_tp,$ref_cdf,$ibin,$ibin_bg,$ibin_end);

     my ( $zfile2 ) = $zfile.".tp";
     output_cdf_recd($dir_out,$zfile2,$ref_cdf,$ref_dcdf);

     my ( $nCDF_tp ) = $points;
     return ($nCDF_tp,$acdf_tp);
  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub run_CDF_FoldIndex{
     use strict;
     use warnings;

     my ( $dir_out,$zfile,$ref_CDFpoints_fd) = @_;

     my ( $infile ) = $dir_out.$zfile.".fd";
     my ( @trecd ) = read_all_records_of_a_file($infile);
     my $nrecd;
     $nrecd = @trecd;

     my ( $ibg, $iend ) = find_FoldIndex_ibg_iend(\@trecd);

     my ( $ibin)    = 20;         ##### No. of bins in CDF plot
     my ( $ibin_bg) = 5;          ##### starting point of the boundary
     my ( $ibin_end)= 7;          ##### ending point of the boundary

     my ( $ref_tpred ) = read_pred_pondrFORMAT(\@trecd,$ibg,$iend);
     my ( $ref_histo ) = cal_histogram_20bins($ref_tpred,$ibin);
     my ( $ref_cdf, $ref_dcdf ) = cal_cdf_20HisBin($ref_CDFpoints_fd,$ibin,$ref_histo);

     my ( $points, $acdf_fd ) = cal_cdf_status($ref_CDFpoints_fd,$ref_cdf,$ibin,$ibin_bg,$ibin_end);

     my ( $zfile2 ) = $zfile.".fd";
     output_cdf_recd($dir_out,$zfile2,$ref_cdf,$ref_dcdf);

     my ( $nCDF_fd ) = $points;
     return ($nCDF_fd,$acdf_fd);
  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub run_CDF_IUPred{
     use strict;
     use warnings;

     my ( $dir_out,$zfile,$ref_CDFpoints_iupred) = @_;

     my ( $infile ) = $dir_out.$zfile.".iupred";
     my ( @trecd ) = read_all_records_of_a_file($infile);
     my $nrecd;
     $nrecd = @trecd;

     my ( $ibg, $iend ) = find_IUPred_ibg_iend(\@trecd);

     my($ibin)    = 20;         ##### No. of bins in CDF plot
     my($ibin_bg) = 5;          ##### starting point of the boundary
     my($ibin_end)= 9;          ##### ending point of the boundary

     my ( $ref_tpred ) = read_pred_pondrFORMAT(\@trecd,$ibg,$iend);

     my ( $ref_histo ) = cal_histogram_20bins($ref_tpred,$ibin);
     my ( $ref_cdf, $ref_dcdf ) = cal_cdf_20HisBin($ref_CDFpoints_iupred,$ibin,$ref_histo);

     my ( $points,$acdf_iupred ) = cal_cdf_status($ref_CDFpoints_iupred,$ref_cdf,$ibin,$ibin_bg,$ibin_end);

     my ( $zfile2 ) = $zfile.".iupred";
     output_cdf_recd($dir_out,$zfile2,$ref_cdf,$ref_dcdf);

     my ( $nCDF_iupred ) = $points;
     return ( $nCDF_iupred, $acdf_iupred );
  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub run_CDF_vsl2b{
     use strict;
     use warnings;
     my ($dir_out,$zfile,$ref_CDFpoints_vsl2) = @_;

     my ( $infile ) = $dir_out.$zfile.".vsl2";
     my ( @trecd ) = read_all_records_of_a_file($infile);
     my $nrecd;
     $nrecd = @trecd;

     my ( $ibg, $iend ) = find_VSL2_ibg_iend(\@trecd);

     my ($ibin)    = 20;         ##### No. of bins in CDF plot
     my ($ibin_bg) = 6;         ##### starting point of the boundary
     my ($ibin_end)= 12;         ##### ending point of the boundary

     my ( $ref_tpred ) = read_pred_pondrFORMAT(\@trecd,$ibg,$iend);
     my ( $ref_histo ) = cal_histogram_20bins($ref_tpred,$ibin);
     my ( $ref_cdf, $ref_dcdf ) = cal_cdf_20HisBin($ref_CDFpoints_vsl2,$ibin,$ref_histo);

     my ( $points,$acdf_vsl2) = cal_cdf_status($ref_CDFpoints_vsl2,$ref_cdf,$ibin,$ibin_bg,$ibin_end);

     my ( $zfile2 ) = $zfile.".vsl2";
     output_cdf_recd($dir_out,$zfile2,$ref_cdf,$ref_dcdf);

     my ( $nCDF_vsl2 ) = $points;

     return ($nCDF_vsl2,$acdf_vsl2);
  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub run_CDF_vl3{
     use strict;
     use warnings;
     my ( $dir_out,$zfile,$ref_CDFpoints_vl3 ) = @_;

     my ( $infile ) = $dir_out.$zfile.".vl3";
     my ( @trecd ) = read_all_records_of_a_file($infile);
     my $nrecd;
     $nrecd = @trecd;

     my ($ibg)     = 2;
     my ($iend)    = $nrecd  - 1;
     my ($ibin)    = 20;         ##### No. of bins in CDF plot
     my ($ibin_bg) = 7;         ##### starting point of the boundary
     my ($ibin_end)= 15;         ##### ending point of the boundary

     my ( $ref_tpred ) = read_pred_pondrFORMAT(\@trecd,$ibg,$iend);
     my ( $ref_histo ) = cal_histogram_20bins($ref_tpred,$ibin);
     my ( $ref_cdf, $ref_dcdf ) = cal_cdf_20HisBin($ref_CDFpoints_vl3,$ibin,$ref_histo);

     my ( $points,$acdf_vl3 ) = cal_cdf_status($ref_CDFpoints_vl3,$ref_cdf,$ibin,$ibin_bg,$ibin_end);

     my ( $zfile2 ) = $zfile.".vl3";
     output_cdf_recd($dir_out,$zfile2,$ref_cdf,$ref_dcdf);

     my ( $nCDF_vl3 ) = $points;
     return ( $nCDF_vl3, $acdf_vl3 );
  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub run_CDF_vlxt{
     use strict;
     use warnings;
     my ( $dir_out,$zfile,$ref_CDFpoints_vlxt) = @_;

     my ( $infile ) = $dir_out.$zfile.".vlxt";
     my ( @trecd ) = read_all_records_of_a_file($infile);
     my $nrecd;
     $nrecd = @trecd;

     my ( $ibg )     = 2;
     my ( $iend )    = $nrecd  - 1;
     my ( $ibin )    = 20;         ##### No. of bins in CDF plot
     my ( $ibin_bg ) = 11;         ##### starting point of the boundary
     my ( $ibin_end )= 17;         ##### ending point of the boundary

     my ( $ref_tpred ) = read_pred_pondrFORMAT(\@trecd,$ibg,$iend); 
     my ( $ref_histo ) = cal_histogram_20bins( $ref_tpred,$ibin);
     my ( $ref_cdf, $ref_dcdf ) = cal_cdf_20HisBin( $ref_CDFpoints_vlxt,$ibin,$ref_histo );
     my ( $points,$acdf_vlxt ) = cal_cdf_status( $ref_CDFpoints_vlxt,$ref_cdf,$ibin,$ibin_bg,$ibin_end);

     my ( $zfile2 ) = $zfile.".vlxt";
     output_cdf_recd($dir_out,$zfile2,$ref_cdf,$ref_dcdf);
     my ( $nCDF_vlxt) = $points;

     return ( $nCDF_vlxt,$acdf_vlxt );
  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub output_cdf_recd{

     my ( $dir_out,$zfile,$ref_cdf,$ref_dcdf) = @_;
     my ( @cdf ) = @$ref_cdf;
     my ( @dcdf ) = @$ref_dcdf;

     my($outf) = $dir_out.$zfile.".cdf";
     open(OUT3,">$outf");

     for ( my $i=0; $i<20; $i++) {
        printf OUT3 "%5d%8.3f%8.3f\n",($i+1),$cdf[$i],$dcdf[$i];
		printf "%5d%8.3f%8.3f\n",($i+1),$cdf[$i],$dcdf[$i];
     }
     close(OUT3);

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub cal_cdf_status{
     use strict;
     use warnings;

     my ( $ref_CDFpoints_vlxt,$ref_cdf,$ibin,$ibin_bg,$ibin_end) = @_;
     my ( @CDFpoints_vlxt ) = @$ref_CDFpoints_vlxt;
     my ( @cdf ) = @$ref_cdf;

     my($acdf) = 0;
     my $dd;
     my ( $points ) = 0;

     for ( my $i=0; $i<$ibin; $i++) {
     if ( $i >= $ibin_bg && $i <= $ibin_end ) {
  
        my ( $dd ) = $cdf[$i] - $CDFpoints_vlxt[$i];
        $acdf = $acdf + $dd;
     
           if ( $cdf[$i] <= $CDFpoints_vlxt[$i] ) {
              $points = $points +1;
           }

     }
     }
     my ( $acdf_vlxt ) = $acdf / ( $ibin_end - $ibin_bg + 1) ;
 
     return ( $points,$acdf_vlxt );

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub cal_cdf_20HisBin{
     use strict;
     use warnings;

     my ( $ref_CDFpoints,$ibin,$ref_histo) = @_;
     my ( @CDFpoints ) = @$ref_CDFpoints;
     my ( @histo ) = @$ref_histo; 
     my ( @cdf ) = "";
     my ( @dcdf ) = "";

     for ( my $i=0; $i<$ibin; $i++) {

        if ( $i == 0 ) {
           $cdf[$i] =  $histo[$i];
           $dcdf[$i] = $cdf[$i] - $CDFpoints[$i];
        } else {
           $cdf[$i] = $cdf[$i-1] + $histo[$i];
           $dcdf[$i] = $cdf[$i] - $CDFpoints[$i];
        }
     }

     return(\@cdf, \@dcdf);
  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub cal_histogram_20bins{
     use strict;
     use warnings;

     my($ref_tpred,$ibin) = @_;
     my ( @tpred ) = @$ref_tpred;
     my $npred;
     $npred = @tpred;
     my @histo;

     for ( my $i=0; $i<$npred; $i++) {
        my ( $vaa ) = int( $tpred[$i] * $ibin );
        if ( $vaa < 0 ) { $vaa = 0;} 
        if ( defined $histo[$vaa] ) { 
           $histo[$vaa] = $histo[$vaa] + 1;
        } else {
           $histo[$vaa] = 0;
        }
     }

     for ( my $i=0; $i<$ibin; $i++ ) {
        if ( defined $histo[$i] ) {
           $histo[$i] = $histo[$i] / ( $npred );
        } else {
           $histo[$i] = 0;
        }
     }

     return (\@histo );

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub read_pred_pondrFORMAT{
     use strict;
     use warnings;
     my($ref_trecd,$ibg,$iend) = @_;
     my ( @trecd ) = @$ref_trecd;
     my ( $ia )    = -1;
     my ( @tpred ) = "";

     for ( my $i=$ibg; $i<=$iend; $i++) {
        $ia = $ia + 1;
        my ( $ztmp ) = $trecd[$i];
        $ztmp =~ s/^\s+//;        #### delete the blanks at the begining of the record.
        my ( @t2recd ) = split( /\s+/, $ztmp );
        $tpred[$ia] = $t2recd[2];
     }

     return ( \@tpred );
  } 
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub run_CH{

    use strict;
    use warnings;

    my ( $ref_resname3,$ref_resname1,$ref_hydro_KD,$ref_netcharge,$ref_netcharge_NoH,$ref_totalcharge) = read_AA_hydro_charge();

#   
#   boardline is <C> = 2.743*<H> - 1.109
#   Christopher J. Oldfield, etc. Biochem 2005, 44:1989-2000.
#

    my ( $CH_charge,$CH_hydro )  = cal_Charge_Hydro_FASTA($ref_resname1,$ref_hydro_KD,$ref_netcharge_NoH);

    my($CH_a) = 1;
    my($CH_b) = -2.743;
    my($CH_c) = 1.109;
    my($CH_d) = 0.3425129775;

    my ( $CH_dist ) = ( $CH_charge * $CH_a + $CH_hydro * $CH_b + $CH_c) * $CH_d;
    my ( $CH_dist2) = $CH_charge - ( 2.743 * $CH_hydro -1.109 );

    return ( $CH_charge,$CH_hydro,$CH_dist,$CH_dist2 );

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub cal_Charge_Hydro_FASTA{

     use strict;
     use warnings;

     my($ref_resname1,$ref_hydro_KD,$ref_netcharge_NoH) = @_ ;
     my ( @resname1 ) = @$ref_resname1;
     my ( @hydro_KD ) = @$ref_hydro_KD;
     my ( @netcharge_NoH ) = @$ref_netcharge_NoH;

     open(FL2,"tmp.fasta");
        <FL2>;
        my($seq) = "";
        while(<FL2>){
           chomp($_);
           $seq.=$_;
        }
     close(FL2);
     my(@arrayN) = split("",$seq);
     my $narray;
     $narray = @arrayN;

     my($sum_charge) = 0;
     my($sum_hydro) = 0;
     my $iaa;
     my $ifg_aa;

     for ( my $i=0; $i<$narray; $i++) {
        my($zaa) = $arrayN[$i];
        $ifg_aa = 0;
    
        for ( my $j=0; $j<20; $j++) {
           if ( $zaa eq $resname1[$j] ) {
              $iaa = $j;
              $ifg_aa = 1;
              last;
           }
        }
        if ( $ifg_aa == 0) {$iaa=21;}

        $sum_charge = $sum_charge + $netcharge_NoH[$iaa];
        $sum_hydro = $sum_hydro + $hydro_KD[$iaa];

     }
     my ( $CH_charge ) = $sum_charge / $narray;
     $CH_charge  = abs( $CH_charge);
     my ( $CH_hydro ) = $sum_hydro / $narray;

     return ( $CH_charge,$CH_hydro );

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub read_AA_hydro_charge{
    use strict;
    use warnings;

    my ( @resname3 ) = ("ALA","ARG","ASN","ASP","CYS",
                        "GLN","GLU","GLY","HIS","ILE",
                        "LEU","LYS","MET","PHE","PRO",
                        "SER","THR","TRP","TYR","VAL");

    my ( @resname1 ) = ("A","R","N","D","C","Q","E","G","H","I",
                        "L","K","M","F","P","S","T","W","Y","V");

    my ( @hydro_KD ) = (
                 0.7,         # A ALA
                 0.0,         # R ARG
                 0.111111111, # N ASN
                 0.111111111, # D ASP
                 0.777777778, # C CYS
                 0.111111111, # Q GLN
                 0.111111111, # E GLU
                 0.455555556, # G GLY
                 0.14444444,  # H HIS
                 1.0,         # I ILE
                 0.922222222, # L LEU
                 0.066666667, # K LYS
                 0.711111111, # M MET
                 0.811111111, # F PHE
                 0.322222222, # P PRO
                 0.411111111, # S SER
                 0.422222222, # T THR
                 0.4,         # W TRP
                 0.355555556, # Y TYR
                 0.966666667, # V VAL
                 0.444444446);

    my ( @netcharge_NoH ) = (0,1,0,-1,0,0,-1,0,  0,0,0,1,0,0,0,0,0,0,0,0,0);
    my ( @netcharge )     = (0,1,0,-1,0,0,-1,0,0.5,0,0,1,0,0,0,0,0,0,0,0,0);
    my ( @totalcharge )   = (0,1,0, 1,0,0, 1,0,0.5,0,0,1,0,0,0,0,0,0,0,0,0);

    return ( \@resname3,\@resname1,\@hydro_KD,\@netcharge,\@netcharge_NoH,\@totalcharge );

  }
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub anal_MoRF{
    use strict;
    use warnings;
    my ( $zfile ) = @_;

    my ( $inf ) = "/home/binxue/data/tmp/".$zfile."MoRE".".txt";
    open(INFF,$inf);
        my ( @tmp_recd ) = <INFF>;
        my $n;
        $n = @tmp_recd;
        my ( $nMoRF ) = $n-1;
    close(INFF);

    return ( $nMoRF );

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------  
  sub anal_PONDRFIT{
     use strict;
     use warnings;

     my($dir_out,$zff) = @_;

     my($inf) = $dir_out.$zff.".meta";
     my $nrecd;

     open(INF2,$inf);
        my(@tmp_recd) = <INF2>;
        $nrecd = @tmp_recd;
        chomp @tmp_recd;
     close(INF2);

     my ( $ibg ) = 0;
     my ( $iend ) = $nrecd - 1;     
     my ( $pr_meta,$nseg_meta ) = stat_IDAA_IDseg(\@tmp_recd,$ibg,$iend);

     return ( $pr_meta,$nseg_meta );  
   }
# ---------------------------------------------------------------------



# ---------------------------------------------------------------------
  sub anal_TopIDP{
     use strict;
     use warnings;

     my($dir_out,$zff) = @_;

     my($inf) = $dir_out.$zff.".tp";
     my $nrecd;

     open(INF2,$inf);
        my(@tmp_recd) = <INF2>;
        $nrecd = @tmp_recd;
        chomp @tmp_recd;
     close(INF2);

     my ( $ibg ) = 0;
     my ( $iend ) = $nrecd - 1;
     my ( $pr_tp,$nseg_tp ) = stat_IDAA_IDseg(\@tmp_recd,$ibg,$iend);

     return ( $pr_tp,$nseg_tp );
  }
# ---------------------------------------------------------------------



# ---------------------------------------------------------------------
  sub anal_FoldIndex{
     use strict;
     use warnings;

     my ( $dir_out,$zff) = @_;

     my($inf) = $dir_out.$zff.".fd";
     my $nrecd;

     open(INF2,$inf);
        my(@tmp_recd) = <INF2>;
        $nrecd = @tmp_recd;
        chomp @tmp_recd;
     close(INF2);

     my ( $ibg, $iend ) = find_FoldIndex_ibg_iend(\@tmp_recd);
     my ( $pr_fd,$nseg_fd ) = stat_IDAA_IDseg(\@tmp_recd,$ibg,$iend);
     return ( $pr_fd,$nseg_fd );

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub find_FoldIndex_ibg_iend{

     use strict;
     use warnings;

     my ( $ref_tmp_recd ) = @_ ;
     my ( @tmp_recd ) = @$ref_tmp_recd;

     my $ibg;
     my $iend;
     my $nrecd;
     $nrecd = @tmp_recd;

     for ( my $i=1; $i<$nrecd; $i++) {
        my($ztmp) = $tmp_recd[$i];
        my(@tmp2_recd) = split(/[ \t]/,$ztmp);

        if ( $tmp2_recd[0] ne "#" ) {
           $ibg = $i;
           last;
        }
     }

     $iend = $nrecd - 1;     ##### for .vsl2 files

     return ( $ibg, $iend);
  }
# ---------------------------------------------------------------------



# ---------------------------------------------------------------------
  sub anal_IUPred{

     use strict;
     use warnings;

     my ( $dir_out, $zff ) = @_;

     my ( $inf ) = $dir_out.$zff.".iupred";
     my $nrecd;

     open(INF2,$inf);
        my ( @tmp_recd ) = <INF2>;
        $nrecd = @tmp_recd;
        chomp @tmp_recd;
     close(INF2);

     my ( $ibg, $iend ) = find_IUPred_ibg_iend(\@tmp_recd);

     my ( $pr_iupred, $nseg_iupred ) = stat_IDAA_IDseg(\@tmp_recd,$ibg,$iend);

     return ( $pr_iupred, $nseg_iupred );
  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub find_IUPred_ibg_iend{
     use strict;
     use warnings;
     my ( $ref_tmp_recd ) = @_ ;
     my ( @tmp_recd ) = @$ref_tmp_recd;
     my $ibg;
     my $iend;
     my $nrecd;
     $nrecd = @tmp_recd;

     for ( my $i=1; $i<$nrecd; $i++) {
        my($ztmp) = $tmp_recd[$i];
        my(@tmp2_recd) = split(/[ \t]/,$ztmp);

        if ( $tmp2_recd[0] ne "#" ) {
           $ibg = $i;
           last;
        }
     }

     $iend = $nrecd - 1;     ##### for .vsl2 files

     return ( $ibg, $iend );
  }
# ---------------------------------------------------------------------




# ---------------------------------------------------------------------
  sub anal_VSL2B{
    use strict;
    use warnings;
    my($dir_out,$zfile) = @_;

    my($inf) = $dir_out.$zfile.".vsl2";
    my $nrecd;

    open(INF2,$inf);
       my(@tmp_recd) = <INF2>;
       $nrecd = @tmp_recd;
        chomp @tmp_recd;
    close(INF2);

    my ( $ibg, $iend) = find_VSL2_ibg_iend(\@tmp_recd);
    my ( $pr_vsl2,$nseg_vsl2 ) = stat_IDAA_IDseg(\@tmp_recd,$ibg,$iend);
    return ( $pr_vsl2, $nseg_vsl2 );

  }
# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
  sub find_VSL2_ibg_iend{
     use strict;
     use warnings;
     my ( $ref_tmp_recd ) = @_ ;
     my ( @tmp_recd ) = @$ref_tmp_recd;
     my $ibg;
     my $iend;
     my $nrecd;
     $nrecd = @tmp_recd;
 
     for ( my $i=1; $i<$nrecd; $i++) {
        my($ztmp) = $tmp_recd[$i];
        my ( @tmp2_recd ) = split(/[ \t]/,$ztmp);
        if ( defined $tmp2_recd[0] ) { 
           if ( $tmp2_recd[0] eq "NO." ) {
              $ibg = $i+2;
              last;
           }
        } 
     }
   
     $iend = $nrecd - 1 - 1;     ##### for .vsl2 files

     return ( $ibg, $iend);

  }
# ---------------------------------------------------------------------




# ---------------------------------------------------------------------
  sub anal_VL3{

     use strict;
     use warnings;

     my ( $dir_out,$zfile ) = @_;    
     my ( $inf ) =  $dir_out.$zfile.".vl3";

     my $nrecd;
     open(INF2,$inf);
        my(@tmp_recd) = <INF2>;
        $nrecd = @tmp_recd;
        chomp @tmp_recd;
     close(INF2);
 
     my ( $ibg ) = 2;
     my ( $iend ) = $nrecd  - 1;    ##### .vl3 file for new PONDRFIT
 
     my ( $pr_vl3,$nseg_vl3 ) = stat_IDAA_IDseg(\@tmp_recd,$ibg,$iend);

     return ( $pr_vl3,$nseg_vl3 );
  }
# ---------------------------------------------------------------------



# ---------------------------------------------------------------------
  sub anal_VLXT{
    use strict;
    use warnings;
    my ( $dir_out,$zfile) = @_;

    my ( $inff ) =  $dir_out.$zfile.".vlxt";
    my $nrecd;

    open(INF2,$inff) or die "Can't open : $!";;
       my ( @tmp_recd ) = <INF2>;
       $nrecd = @tmp_recd;     
       chomp @tmp_recd;
    close(INF2); 

    my ( $ibg ) = 2;
    my ( $iend ) = $nrecd  - 1;    #####  .vlxt file in new PONDRFIT

    my ( $pr_vlxt, $nseg_vlxt ) = stat_IDAA_IDseg(\@tmp_recd,$ibg,$iend);

    return ( $pr_vlxt,$nseg_vlxt );

  } 
# ---------------------------------------------------------------------


# ---------------------------------------------------------------------
  sub stat_IDAA_IDseg{

    use strict;
    use warnings;

	
    my ( $ref_tmp_recd,$ibg,$iend) = @_;
    my ( @tmp_recd ) = @$ref_tmp_recd; 

    my ( $ifg_s ) = 0;
    my ( $ict_res ) = 0;
    my ( $ict_seg ) = 0;

    for (my $i=$ibg; $i<=$iend; $i++) {

       my ( $ztmp ) = $tmp_recd[$i]; 
       my ( @tmp2_recd ) = "";
       $ztmp =~ s/^\s+//;        #### delete the blanks at the begining of the record.

       @tmp2_recd = split(/\s+/,$ztmp);
       
       if ( $tmp2_recd[2] >= 0.5 ) {
          $ict_res = $ict_res + 1;

          if ( $ifg_s == 0 ) {
             $ict_seg = $ict_seg +1;
             $ifg_s = 1;
          }
       } else {
          $ifg_s = 0;
       }

    }
    my ( $pr_vlxt ) = $ict_res / ( $iend - $ibg + 1 );
    my ( $nseg_vlxt ) = $ict_seg;
  
    return ( $pr_vlxt, $nseg_vlxt );

  }
# ---------------------------------------------------------------------

# -------------------------------------------------------------------
  sub read_input_multi_fasta{

  my ( $infile ) = @_;
  my @zfile;
  my @zseq;
  my @nlength;

     my ( @trecd )= read_all_records_of_a_file($infile);
     
     my $nrecd;
     $nrecd = @trecd;
     my ( $ifile ) = -1;
     for ( my $ir=0; $ir<$nrecd; $ir++) {

        my ( $ztmp ) = $trecd[$ir];

        #change by iqbal
        #$zseq[$ifile]="";
        #change by iqbal 
        if ( substr($ztmp,0,1) eq ">") {
           $ifile = $ifile + 1;
           my ( $zf ) = substr( $ztmp, 1, ( length($ztmp) - 1 ) );
#           $zf =~ tr/a-z/A-Z/; 
           $zf =~ s/\r//;           #### replace the Windows Return; 
           
           $zfile[$ifile] = $zf;

           if ( $ifile >= 1 ) { $nlength[$ifile-1] = length($zseq[$ifile-1]); }
           $zseq[$ifile]="";
        } else {
           $ztmp =~ s/\s+//g;    #### replace blanks
           $ztmp =~ s/\r//;      #### replace the Windows Return; 
           $ztmp = &replace_abnormal_AA($ztmp);  
	       #print "\nERROR ----->".($zseq[$ifile])."<--------------------\n";
           #print "\nERROR 2----->".($ifile)."<--------------------\n";
	 
            
           $zseq[$ifile] = $zseq[$ifile].$ztmp;
 
        }

     }
     $nlength[$ifile] = length($zseq[$ifile]);
     my ( $nfile ) = $ifile + 1;        #### nNo. of sequences
     return($nfile, \@zfile, \@zseq, \@nlength );
  }
# -------------------------------------------------------------------

# -------------------------------------------------------------------
  sub replace_abnormal_AA{

    use strict;
    use warnings;

    my ( $zaa ) = @_;

    if ( $zaa =~ /[a-z]/ ) {
       print "The sequence contains lower-case character, pls check ... \n";
       print "\n";
       print "\n";
       exit;
    }
 
    $zaa =~ tr/X/A/;     #### hetero atoms
    $zaa =~ tr/Z/Q/;     #### Gln / Glu
    $zaa =~ tr/B/N/;     #### Asn / ASP
    $zaa =~ tr/U/A/;     #### U: Selenocystein
    $zaa =~ tr/J/L/;     #### Leu / Ile
    $zaa =~ tr/O/A/;     #### O: Pyrrolysine


    if ( $zaa =~ /[JOU]/ ) {
       print "The sequence contains J, O, or U, pls check ... \n";
       print "\n";
       print "\n";
       exit;
    }

    return ( $zaa );
  }
# -------------------------------------------------------------------

# -------------------------------------------------------------------
  sub read_all_records_of_a_file{

     use strict;
     use warnings;
     use Data::Dumper;

#     my ($inff) = $_[0];
     my ($inff) = @_;
     my( @z_all_records ) = "";

     open(ING,"$inff");
        @z_all_records = <ING>;
	
        chomp @z_all_records;
     close(ING);
     return ( @z_all_records );

  }
# -------------------------------------------------------------------




# ---------------------------------------------------------------------
  sub readme{
    print "USAGE: ./DisorderPred input.fasta\n";
    print "       input_file is in FASTA format, support multiple sequences;\n";
    print "       \n";
  }
# ---------------------------------------------------------------------


