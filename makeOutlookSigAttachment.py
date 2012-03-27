#!/usr/bin/python

import sys;
import base64;
import uuid;
import os;
import pickle;
import shutil;

if len(sys.argv) <= 2:
  print( 'usage: '+sys.argv[0]+' <attach_file_to_replace> <new_image>');
  exit(1);

newSigImage = sys.argv[2];
sigToReplace = sys.argv[1];#'x34_66612.olk14SigAttach'
tempMimeFile = '_Attach';
tempSigFile = 'outAttach';
attId = str(uuid.uuid1());
filenumber = int(sigToReplace[sigToReplace.find('_')+1:sigToReplace.find('.')]);

r = open(newSigImage, 'r');
w = open(tempMimeFile, 'w');

lines = [ 'Content-type: image/png; name="'+attId+'.png"\r',
  'Content-ID: <'+attId+'>\r',
  'Content-disposition: inline;\r',
  '\tfilename="'+attId+'.png"\r',
  'Content-transfer-encoding: base64\r\r'];

for i in range(len(lines)):
  w.write( lines[i]);
base64.encode( r, w);

r.close();
w.close();

outfile = open(tempSigFile, 'w');
mimeFileSize = os.path.getsize( tempMimeFile);

outfile.write( 'SgAt'); #header

o = chr(mimeFileSize >> 24) #mime file size
o = o+chr((mimeFileSize & 0x00FF0000) >> 16)
o = o+chr((mimeFileSize & 0x0000FF00) >> 8)
o = o+chr(mimeFileSize & 0x000000FF);
outfile.write( o);
outfile.write( o);

outfile.write( "\xff\xff\xff\xff"); #no clue

o = chr(filenumber >> 24) #filenumber
o = o+chr((filenumber & 0x00ff0000) >> 16)
o = o+chr((filenumber & 0x0000ff00) >> 8)
o = o+chr(filenumber & 0x000000ff);
outfile.write( o);

r = open(tempMimeFile,'r')

for line in r:
  outfile.write( line);

r.close();
outfile.close();

shutil.copyfile( tempSigFile, sigToReplace);
