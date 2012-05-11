#!/bin/bash
infile=$1
ext=${infile##*.}
outfile=$HOME/Video/`basename $infile .$ext`.MiniSD-xiaoyong.mkv
codeset=CP936

if [ -z $infile ]; then
	echo "Usage: $0 film_file_name"
	exit
fi

# Determine # of audio tracks
n_audio=`HandBrakeCLI -i $infile --scan 2>&1 | grep  -E "Stream.*Audio" | wc -l`
for ((i=1; i<=n_audio; i++)); do
	astring=$astring,$i
	Estring=$Estring,"faac"
	Bstring=$Bstring,64
done

astring=${astring:1}
Estring=${Estring:1}
Bstring=${Bstring:1}

# Normal preset:
# ./HandBrakeCLI -i DVD -o ~/Movies/movie.mp4  -e x264 -q 20.0 -a 1 -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 --strict-anamorphic -m -x ref=2:bframes=2:subme=6:mixed-refs=0:weightb=0:8x8dct=0:trellis=0
# MiniSD settings based on normal preset:
MiniSD="-e x264 -b 1000 -2 -T -a $astring -E $Estring -B $Bstring -f mkv -X 800 --loose-anamorphic -m -x deblock=-1,-1:ref=13:bframes=8:subme=9"

for srtfile in `dirname $infile`/`basename $infile .mkv`.{chs,eng,chs\&eng}.srt; do
	if [ -f $srtfile ]; then
		srtfiles=$srtfiles,$srtfile
		srtencoding=$srtencoding,$codeset
		srtlang=`echo $srtfile | grep -oE 'chs|eng|chs&eng'`
		srtlangs=$srtlangs,${srtlang/chs/chi} # In iso639-2 code, Chinese is chi / zho
	fi
done
srtfiles=${srtfiles:1}
srtencoding=${srtencoding:1}
srtlangs=${srtlangs:1}

cmd="HandBrakeCLI -i $infile -o $outfile $MiniSD --srt-file $srtfiles --srt-codeset $srtencoding --srt-lang $srtlangs --srt-default --subtitle 1,2,3,4,5,6,7,8,9,10 --subtitle-default"
echo $cmd

read -p "Proceed? [Y|n] " answer
if [[ "$answer" == "n" || "$answer" == "no" ]]; then
	exit
else
	$cmd
fi
