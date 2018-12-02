import tables
import strformat

# Test whether id falls in two count, three count or both.
proc bucketID(id: string): (bool, bool) =
    var charCount = newTable[char,int]()
    var 
        isTwo: bool = false
        isThree: bool = false
    for c in id.items():
        if charCount.hasKeyOrPut(c,1):
            charCount[c] += 1
    
    for k,v in charCount.pairs():
        if v == 2:
            isTwo = true
        elif v == 3:
            isThree = true

    (isTwo, isThree)
    
when isMainModule:
    var 
        f: File
        twoCount: int = 0 
        threeCount: int = 0
    if open(f, "input.txt"):
        var 
            line: string
            ok = true
    
        while ok:
            try:
                line = readLine(f)
                let b = bucketID(line)
                if b[0] :
                    twoCount += 1
                if b[1] :
                    threeCount += 1
            except EOFError:
                ok = false
            except:
                echo "error reading ids from file"
                raise
    echo &"two count is {twoCount}"
    echo &"three count is {threeCount}"
    let checksum = twoCount * threeCount
    echo &"checksum is {checksum}"