import strutils
import math
import tables
import strformat

when isMainModule:
    var
        f: File
        line: string
    if open(f, "input.txt"):
        line = readAll(f)
    f.close()

    var uniqueUnits = newTable[char, int]()

    # Collect all unique units in the given input.
    for c in line.toLowerAscii().items:
        uniqueUnits[c] = 0

    # Loop through each unique unit, skipping it from the match process.
    # Match process is same as part `a` (see: `a.nim` for reference).
    for c,_ in uniqueUnits:
        var 
            remainingStack = newSeq[char]()
            i = 0
        while i < line.len():
            # Skip if we see the above unit.
            if line[i].toLowerAscii() == c:
                i += 1

                # Since, we are skipping, we also try to match with the stack.
                while remainingStack.len() > 0 and abs(int(line[i]) - int(remainingStack[^1])) == 32:
                    discard remainingStack.pop()
                    i += 1
                continue

            if abs(int(line[i]) - int(line[i+1])) == 32:
                i += 2
                while remainingStack.len() > 0 and abs(int(line[i]) - int(remainingStack[^1])) == 32:
                    discard remainingStack.pop()
                    i += 1
            else:
                remainingStack.add(line[i])
                i += 1  

        # Update for which unit, we saw what length of reacted polymer.
        uniqueUnits[c] = remainingStack.len()

    # Find the lowest length.
    var minPolymerLength = high(int)
    for c, v in uniqueUnits:
        if v < minPolymerLength:
            minPolymerLength = v
        
    echo &"shortest polymer length is {minPolymerLength}"