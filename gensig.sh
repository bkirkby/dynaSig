#!/bin/sh

color='#00ff00' #green
#color='#efa300' #amber
fullname="brian kirkby"
phone="801.400.8254"
email="bkirkby@zappos.com"

if [ "" == "$1" ]; then
  skip_outlook_copy=0
  sigfile=sig`date +%y%m%d`.png
  if [ -e "$sigfile" ]; then
    echo "file:'$sigfile' already created today"
    exit
  fi
else
  skip_outlook_copy=1
  sigfile=$1
fi

numlines=`wc -l hostnames.txt | sed "s/hostnames.txt//"`
r=$((RANDOM%numlines+1))
server_name=`head -$r hostnames.txt | tail -1`

numlines=`wc -l titleone.txt | sed "s/titleone.txt//"`
r=$((RANDOM%numlines+1))
title_one=`head -$r titleone.txt | tail -1`

numlines=`wc -l titletwo.txt | sed "s/titletwo.txt//"`
r=$((RANDOM%numlines+1))
title_two=`head -$r titletwo.txt | tail -1`

#  -font "/Library/Fonts/Microsoft/Lucida Console.ttf" \
#  -font "/Users/bkirkby/Library/Fonts/PrintChar21.ttf" \
#  -font "/Users/bkirkby/Library/Fonts/PRNumber3.ttf" \
/opt/local/bin/convert  \
  -font "/Library/Fonts/Microsoft/Lucida Console.ttf" \
  -fill "$color" -background Black \
  label:"$server_name:~ $ cat ~/${title_one}_$title_two\n$fullname\n$phone\n$email\n$server_name:~ $ _" \
  -bordercolor Black -border 5 \
  term_overlay.png
/opt/local/bin/composite -dissolve 30 sig_background.png term_overlay.png $sigfile

if [ "$skip_outlook_copy"==0 ]; then
  ./makeOutlookSigAttachment.py "/Users/bkirkby/Documents/Microsoft User Data/Office 2011 Identities/Main Identity/Data Records/Signature Attachments/0T/0B/0M/67K/x34_67215.olk14SigAttach" $sigfile
fi
