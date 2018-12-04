import algorithm
import nre
import strutils
import times
import tables
import strformat

type
    SleepData = tuple[
        sleptMin: DateTime,
        wakeMin: DateTime
    ]

# GuardData holds the id (for posterity),total minutes slept by a guard and a list of all sleep/wake timings.
type 
    GuardData = tuple[
        id:int,
        totalSlept: int,
        sleepData: seq[SleepData],
    ]

# Parse guards ID from the raw input.
let guardIDRegex = re"\[.*\]\sGuard\s#([0-9]+).*"

# Parse the time from the raw input.
let timeCaptureRegex = re"\[(.*)\].*"

when isMainModule:
    # Read input data and sort it lexicographically.
    # This sorts the timestamps too!
    var
        f: File
        inputLines = newSeq[string]()
    if open(f, "input.txt"):
        var
            line: string
            ok = true

        while ok:
            try:
                line = readLine(f)
                inputLines.add(line)
            except EOFError:
                ok = false
            except:
                echo "error reading input from file"
                raise
    inputLines.sort(cmp)

    # Create a map of guard id -> GuardData.
    var g: GuardData
    var guardTable = newTable[int,GuardData]()
    
    for _, l in inputLines:
        let m = l.match(guardIDRegex)
        if m.isSome:
            let id = parseInt(m.get().captures[0])
            if guardTable.hasKey(id):
                g = guardTable[id]
            else:
                g = (id : id, totalSlept:0, sleepData : @[])
        elif l.contains("falls asleep"):
            let ts = parse(l.match(timeCaptureRegex).get().captures[0], "yyyy-MM-dd hh:mm")
            g.sleepData.add((sleptMin: ts, wakeMin: ts))
        elif l.contains("wakes up"):
            let ts = parse(l.match(timeCaptureRegex).get().captures[0], "yyyy-MM-dd hh:mm")
            g.sleepData[^1].wakeMin = ts
            g.totalSlept += int(g.sleepData[^1].wakeMin.toTime() - g.sleepData[^1].sleptMin.toTime())
            guardTable[g.id] = g


    # Find the guard who slept the most.
    var maxSleptGuard = guardTable[2213] # random seed from the given input.
    for key, gd in guardTable:
        if gd.totalSlept > maxSleptGuard.totalSlept:
            maxSleptGuard = gd
    
    # For the guard that slept the most, find the minutes when he was sleeping the most.
    var minutesMap: array[60, int]
    for _, s in maxSleptGuard.sleepData:
        let sleptMin = s.sleptMin.minute
        let wakeMin = s.wakeMin.minute

        for x in countup(int(sleptMin), int(wakeMin)-1):
            minutesMap[x] += 1

    var maxSleptMinID = 0
    var maxSleptMin = minutesMap[0]
    for i, m in minutesMap:
        if m > maxSleptMin:
            maxSleptMinID = i
            maxSleptMin = m

    # Result.
    echo &"the product is {maxSleptGuard.id * maxSleptMinID}"