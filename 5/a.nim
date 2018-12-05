import strutils
import math
import strformat

when isMainModule:
    # Read entire input.
    var
        f: File
        line: string
    if open(f, "input.txt"):
        line = readAll(f)
    f.close()

    # Maintain a stack of units that don't react and after each reaction, try to
    # react as many units as possible from the stack with the input list.
    # The stack is implemented using a sequence, so pop is O(n) instead of O(1) for 
    # traditional stack.
    var 
        remainingStack = newSeq[char]()
        i = 0
    while i < line.len():
        if abs(int(line[i]) - int(line[i+1])) == 32:
            i += 2
            while remainingStack.len > 0 and abs(int(line[i]) - int(remainingStack[^1])) == 32:
                # If we can match with the stack, pop it from the stack.
                discard remainingStack.pop()
                i += 1
        else:
            remainingStack.add(line[i])
            i += 1

    echo &"final polymer length after reaction is {remainingStack.len()}"