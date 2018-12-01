from strutils import parseInt
import sets
import strformat

iterator changesIterator(changes: seq[int]):int = 
    var i = changes.low
    while true:
        if i > changes.high:
            i = changes.low
        yield changes[i]
        inc i

when isMainModule:
    var f: File
    var freq = 0
    var changes = newSeq[int]()
    # Read file into a sequence.
    if open(f,"input.txt"):
        var line:string
        var ok = true
        while ok:
            try:
                line = readLine(f)
                changes.add(parseInt(line))
            except EOFError:
                ok = false
            except:
                echo "error reading changes from file"
                raise

        close(f)
    # Iterate over the sequence while managing state of seen frequencies.
    var seenFreq = initSet[int]()
    for c in changesIterator(changes):
        freq += c
        if seenFreq.contains(freq):
            echo &"first frequency to hit 2 times is {freq}"
            quit 0
        seenFreq.incl(freq)