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

# Fetch max of an array with its index.
proc getMaxValAndIdx(arr: array[60,int]): (int, int) =
    var idx = 0
    var m = arr[0]
    for i, v in arr:
        if v > m:
            idx = i
            m = v
    (m,idx)

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


    # For each guard find the minute he mostly slept at and if it is the global max.
    var maxSleptMinute = 0
    var maxSleptVal = 0
    var maxSleptGuardID = 0
    for _, gd in guardTable:
        var mts: array[60, int]
        for _, s in gd.sleepData:
            let sleptMin = s.sleptMin.minute
            let wakeMin = s.wakeMin.minute
    
            for x in countup(int(sleptMin), int(wakeMin)-1):
                mts[x] += 1

        let m = getMaxValAndIdx(mts)
        if m[0] > maxSleptVal:
            maxSleptVal = m[0]
            maxSleptMinute = m[1]
            maxSleptGuardID = gd.id

    # Result.
    echo &"product is {maxSleptMinute*maxSleptGuardID}"
