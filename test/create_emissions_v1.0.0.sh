#! /bin/sh
#GRA=./gra
#VFM=../
DIR_EMISSION=/home/poluicao/EMISSION_DATA
DIR_SURFACE=/home/poluicao/SURFACE_DATA
DIR_FIRES=/home/poluicao/FIRES_DATA
zero=0
year=2008

mes=10
while [ $mes -le 11 ]
do

if [ $mes -eq 1 ]
 then
  cmes=JAN
  idx=01
  fdx=31
fi

if [ $mes -eq 2 ]
 then
  cmes=FEB
  idx=01
  fdx=28
fi

if [ $mes -eq 3 ]
 then
  cmes=MAR
  idx=10
  fdx=11
fi

if [ $mes -eq 4 ]
 then
  cmes=APR
  idx=01
  fdx=30
fi

if [ $mes -eq 5 ]
 then
  cmes=MAY
  idx=15
  fdx=31
fi


if [ $mes -eq 6 ]
 then
  cmes=JUN
  idx=01
  fdx=30
fi



if [ $mes -eq 7 ]
 then
  cmes=JUL
  idx=01
  fdx=31
fi

if [ $mes -eq 8 ]
 then
  cmes=AUG
  idx=01
  fdx=31
fi

if [ $mes -eq 9 ]
 then
  cmes=SEP
  idx=01
  fdx=02
fi

if [ $mes -eq 10 ]
 then
  cmes=OCT
  idx=01
  fdx=31
fi

if [ $mes -eq 11 ]
 then
  cmes=NOV
  idx=01
  fdx=30
fi


if [ $mes -eq 12 ]
 then
  cmes=DEC
  idx=15
  fdx=31
fi

####### loop nos dias do mes #########################
day=`expr $idx \* 1`


while [ $day -le $fdx ]
do

####### loop nos horarios dos dia #########################
time=0
while [ $time -le 0 ]
do

cmes=$mes
if [ $mes -lt 10 ]; then cmes=$zero$mes; fi

cday=$day
if [ $day -lt 10 ]; then cday=$zero$day; fi

ctime=$time
if [ $time -lt 10 ]; then ctime=$zero$time; fi


###################### aqui comeca o procedimento ############

cat << Eof > prep_chem_sources.inp
 \$RP_INPUT
!##########################################################################!
!  CATT-BRAMS/MCGA-CPTEC emission model    CPTEC/INPE                      !
!  version 1: 28/feb/2007                                                  !
!  developed/coded by Saulo Freitas and Karla Longo                        !
!  contact: sfreitas@cptec.inpe.br   - www.cptec.inpe.br/meio_ambiente     !
!###########################################################################

 
!---------------- grid_type of the grid output
   grid_type= 'rams',	!'rams' = rams grid 
                        ! 'gg'  = gaussian grid output
			! 'll'  = lat/lon grid output
 
!---------------- if the output data is for use in CATT-BRAMS model, provide at least one analysis file 
!---------------- of this model
    rams_anal_prefix = './ANL/barca',
!---------------- date of emission  
   ihour=$ctime,
    iday=$day,
    imon=$mes,
    iyear=$year,

!---------------- select the sources datasets to be used   
   use_retro =1,  ! 1 = yes, 0 = not
   retro_data_dir ='${DIR_EMISSION}/RETRO/anthro',

   use_edgar =1,  ! 0 - not, 1 - Version 3, 2 - Version 4 for some species
   edgar_data_dir ='${DIR_EMISSION}/EDGAR/anthro',

   use_gocart =0,
   gocart_data_dir ='${DIR_EMISSION}/GOCART/emissions',

   use_fwbawb =1,
   fwbawb_data_dir ='${DIR_EMISSION}/Emissions_Yevich_Logan',

   use_bioge =2, ! 1 - geia, 2 - megan 
   ! ###### 
   ! # BIOGENIC = 1
   !bioge_data_dir ='${DIR_EMISSION}/biogenic_emissions',
   ! # MEGAN = 2
   ! ######   
    bioge_data_dir='${DIR_EMISSION}/MEGAN/2000',   
   ! ######

   use_gfedv2 =0,
   gfedv2_data_dir ='${DIR_EMISSION}/GFEDv2-8days',

   use_bbem =1,
   use_bbem_plumerise =1,
!---------------- if  the merging of gfedv2 with bbem is desired (=1, yes, 0 = no)  
   merge_GFEDv2_bbem =0,
!---------------- Fire product for BBBEM/BBBEM-plumerise emission models
!   bbem_wfabba_data_dir  ='${DIR_FIRES}/WF_ABBA_v60/2002/filt/f',
   bbem_wfabba_data_dir   ='${DIR_FIRES}/WF_ABBA_v60_GABRIEL/2008/filt/f',
   bbem_modis_data_dir    ='${DIR_FIRES}/MODIS_GLOBAL/2008/Fires',
   bbem_inpe_data_dir     ='${DIR_FIRES}/DSA/2008/Focos',
   bbem_extra_data_dir    ='',

!---------------- veg type data set (dir + prefix)
! veg_type_data_dir      ='${DIR_SURFACE}/GL_IGBP_AVHRR_INPE/IGBP',	       
  veg_type_data_dir      ='${DIR_SURFACE}/GL_IGBP_INPE_39classes/IGBP',	
  
!---------------- vcf type data set (dir + prefix)
  use_vcf = 0,
  vcf_type_data_dir      ='/dados/dados3/stockler/VCF/data_out/2004/VCF',	       
       

!----------------  Carbon density data  ----------------
!----------------  New Olson''s data set (dir + prefix)
  olson_data_dir= '${DIR_EMISSION}/OLSON2/OLSON',   
     
!----------------  Old Olson''s data set
  carbon_density_data_dir= '${DIR_SURFACE}/GL_OGE_INPE/OGE',
 
!---------------- carbon density data set for Amazon (dir + prefix)
   fuel_data_dir      ='${DIR_EMISSION}/Carbon_density_Saatchi/amazon_biomass_final.gra',
 

!---------------- gocart background
   use_gocart_bg =0,
   gocart_bg_data_dir ='${DIR_EMISSION}/GOCART',

!---------------- volcanoes emissions
   use_volcanoes =0,
   volcano_index =0, !REDOUBT

   use_these_values='NONE',
! define a text file for using external values for INJ_HEIGHT, DURATION,
! MASS ASH (units are meters - seconds - kilograms) and the format for
! a file 'values.txt' is like this:
! 11000. 10800. 1.5e10
! use_these_values='values.txt', 
   begin_eruption='198912141930',  !begin time UTC of eruption YYYYMMDDhhmm   

!---------------- degassing volcanoes emissions
   use_degass_volcanoes =1,
   degass_volc_data_dir ='${DIR_EMISSION}/VOLC_SO2', 

!---------------- user specific  emissions directory
!---------------- Update for South America megacities
!---------------- set 'NONE' if you do not want to use
   user_data_dir='${DIR_EMISSION}/SouthAmerica_Megacities',


!--------------------------------------------------------------------------------------------------
   pond=1,   ! mad/mfa  0 -> molar mass weighted 
             !          1 -> Reactivity weighted   

!---------------- for grid type 'll' or 'gg' only
   grid_resolucao_lon=0.2,
   grid_resolucao_lat=0.2,

   nlat=192,          ! if gg (only global grid)
   lon_beg   = -85., ! (-180.:+180.) long-begin of the output file
   lat_beg   = -55., ! ( -90.:+90. ) lat -begin of the output file
   delta_lon =  60., ! total long extension of the domain (360 for global)
   delta_lat =  70., ! total lat  extension of the domain (180 for global)

!---------------- For regional grids (polar or lambert)

   NGRIDS   = 1,            ! Number of grids to run

   NNXP     = 40,50,86,46,        ! Number of x gridpoints
   NNYP     = 40,50,74,46,        ! Number of y gridpoints
   NXTNEST  = 0,1,1,1,          ! Grid number which is the next coarser grid
   DELTAX   = 60000.,
   DELTAY   = 60000.,         ! X and Y grid spacing

   ! Nest ratios between this grid and the next coarser grid.
   NSTRATX  = 1,2,3,4,           ! x-direction
   NSTRATY  = 1,2,3,4           ! y-direction

   NINEST = 1,10,0,0,        ! Grid point on the next coarser
   NJNEST = 1,10,0,0,        !  nest where the lower southwest
                             !  corner of this nest will start.
                             !  If NINEST or NJNEST = 0, use CENTLAT/LON
   POLELAT  = 40.,          ! If polar, latitude/longitude of pole point
   POLELON  = -115.,         ! If lambert, lat/lon of grid origin (x=y=0.)

   STDLAT1  = 40.,          ! If polar, unused
   STDLAT2  = 35.,          ! If lambert, standard latitudes of projection

   CENTLAT  = 40.,  -23., 27.5,  27.5,
   CENTLON  = -115.,  -46.,-80.5, -80.5,



!---------------- model output domain for each grid (only set up for rams)
   lati =  -90.,  -90.,   -90., 
   latf =  +90.,  +90.,   +90.,  
   loni = -180., -180.,  -180., 
   lonf =  180.,  180.,   180., 

!---------------- project rams grid (polar sterogr) to lat/lon: 'YES' or 'NOT'
   proj_to_ll='YES', 
   
!---------------- output file prefix (may include directory other than the current)
   chem_out_prefix = 'test1.0.0', 
   chem_out_format = 'vfm',
!---------------- convert to WRF/CHEM (yes,not)
  special_output_to_wrf = 'NO',
 !--------------- bytes size INTEL=1 PORTLAND=4 ------------------------
 ! output_byte_size = 4,
   
\$END 
Eof

./prep_chem_sources_RACM.exe> prep_sources_racm.$day$cmes$year$ctime.out
#mv *.gra *.ctl $GRA
#mv *.vfm $VFM

time=`expr $time + 1`
done
day=`expr $day + 1`
done
mes=`expr $mes + 1`
done

#echo $gif_arq
exit
