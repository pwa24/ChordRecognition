import argparse
import csv
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

parser = argparse.ArgumentParser()
parser.add_argument("inputPath")
parser.add_argument("outputPath")
args = parser.parse_args()
with open(args.inputPath, newline='') as file:
    R = csv.reader(file, delimiter=',', skipinitialspace=True)
    eList = dict()
    for row in R:
        if (row[2] == 'Note_on_c' and row[5] != '0'):
            event = int(row[1])
            newNote = int(row[4])
            noteList = eList.get(event, [])
            noteList.append(newNote)
            eList.update(dict({event:noteList}))
    eList2 = []
    i = 1
    W = []
    for k, v in sorted(eList.items()):
        x = [i]
        x.extend(formatNotes(v))
        W.append(x)
        i = i + 1
        
with open(args.outputPath, 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerows(W)
