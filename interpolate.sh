#!/bin/bash
echo '
 / ___|___ \ / _ \_ _|
| |  _  __) | | | | | 
| |_| |/ __/| |_| | | 
 \____|_____|\___/___|
'
INTERPOL_TIME=0.25 # 1/4 seconds

echo "Processing bruts folders"
for raw in *brut*; 
  do
    out="${raw/brut/interpolated}" && \
    mkdir -p $out && \
    cd $raw && \
    for i in `ls *.gpx`;
      do echo "Removing duplicates points in $raw -- $i" && \
         gpsbabel -i gpx -f $i -x duplicate,location,shortname -o gpx -F ../$out/nodup_$i && \
         echo "Interpolation to $INTERPOL_TIME seconds"
         gpsbabel -i gpx -f ../$out/nodup_$i -x interpolate,time=$INTERPOL_TIME -o gpx -F ../$out/$i && \
         rm ../$out/nodup_*;
         echo "=> Output from $raw available in $out/$i"
    done
    cd ..
done

echo "Processing 'nodup' folder"
for n in *nodup*; 
  do 
    oup="${n/brut/interpolated}" && \
    mkdir -p $out && \
    cd $n && \
    for i in *.gpx;
      do echo "Interpolation to $INTERPOL_TIME seconds"
         gpsbabel -i gpx -f $i -x interpolate,time=$INTERPOL_TIME -o gpx -F ../$oup/$i ;
         echo "=> Output from $raw available in $out/$i"
    done
    cd ..
done
echo "Interpolation finished !"
echo '
######################
 / ___|___ \ / _ \_ _|
| |  _  __) | | | | | 
| |_| |/ __/| |_| | | 
 \____|_____|\___/___|
######################
'
