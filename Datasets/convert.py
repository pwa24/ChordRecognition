import argparse
import csv
import subprocess
import os

#notes = list of midi pitches (0-127)
#newNotes = [b, b, b, b, b, b, b, b, b, b, b, b, bass]
def formatNotes(notes):
    newNotes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128]
    minNote = 128
    for note in notes:
        if minNote > note:
            minNote = note
            newNotes[12] = note % 12
        newNotes[note % 12] = 1
    return newNotes

def readcsv(filePath, sid):
    with open(filePath, newline='') as file:
        #CSV -> List
        RR = list(csv.reader(file, delimiter=',', skipinitialspace=True))
        #Convert first 2 columns to ints
        R = list(map(lambda x: [int(x[0]), int(x[1])] + x[2:], RR))
        #Sort by time, then by type
        R = sorted(R, key=(lambda x: (x[1], x[2])))
        eList = dict()
        heldNotes = []
        prevTime = 0
        for row in R:
            if (row[2] == 'Note_off_c' or (row[2] == 'Note_on_c' and row[5] == '0')):
                if (prevTime != row[1]):
                    currNotes = []
                    currNotes.extend(heldNotes) #shallow copy
                    eList.update(dict({prevTime:currNotes}))
                offNote = int(row[4])
                if offNote in heldNotes: heldNotes.remove(offNote)
                prevTime = row[1]
            if (row[2] == 'Note_on_c' and row[5] != '0'):
                onNote = int(row[4])
                heldNotes.append(onNote)
                prevTime = row[1]
        eList2 = []
        i = 1
        W = []
        for k, v in sorted(eList.items()):
            x = [sid, i]
            x.extend(formatNotes(v))
            W.append(x)
            i = i + 1
        return W

def writecsv(filePath, W):
    with open(filePath, 'a', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(W)
        return

parser = argparse.ArgumentParser()
parser.add_argument("inputDir")
parser.add_argument("outputDir")
args = parser.parse_args()

inputFolder = args.inputDir + '/'
outputFolder = args.outputDir + '/'

for file in sorted(os.listdir(inputFolder)):
    if file.endswith('.mid'):
        fileTitle = file.split(sep='.')[0]
        midiToCSV = ['Midicsv.exe', inputFolder + file, 'temp.csv']
        subprocess.call(midiToCSV)
        W = readcsv('temp.csv', fileTitle)
        writecsv(outputFolder + 'X.csv', W)
subprocess.call('rm temp.csv')




