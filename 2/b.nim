import strutils
import strformat

# Compares the strings x and y and returns true if exactly one character
# at the same position is different.
proc isSimilar(x, y: string): bool =
    var
        oneOff: bool = false
        similar: bool = true
    for i in countup(0, x.len()-1):
        if x[i] != y[i]:
            if not oneOff:
                oneOff = true
            else:
                similar = false
                break
    similar
    
# getCommon finds the common characters between strings x and y.
proc getCommon(x, y: string): string =
    var
        commonChar = newSeq[char]()
    
    for i in countup(0, x.len()):
        if x[i] == y[i]:
            commonChar.add(x[i])
    
    join(commonChar)

when isMainModule:
    var f: File
    var ids = newSeq[string]()
    # Read file into a sequence.
    if open(f,"input.txt"):
        var 
            line:string
            ok = true
        while ok:
            try:
                line = readLine(f)
                ids.add(line)
            except EOFError:
                ok = false
            except:
                echo "error reading ids from file"
                raise

    var commonID : string
    for i in countup(0, ids.len()-2):
        for j in countup(i+1, ids.len()-1):
            if isSimilar(ids[i], ids[j]):
                commonID = getCommon(ids[i], ids[j])
                break

    echo &"common between ids is: {commonID}"
        