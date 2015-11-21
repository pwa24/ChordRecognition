@echo off
REM //Run on Windows Only!
REM //convertMIDI.cmd <input>.mid <output>.csv

Midicsv.exe %1 temp.csv
python formatcsv.py temp.csv %2
rm temp.csv