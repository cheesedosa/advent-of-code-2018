import nre
import strutils
import sequtils
import strformat
import algorithm

# Transition represents a state transition input.
type
    Transition = tuple [
        pattern: string,
        outcome: char
    ]

# Parse a transition from an input line.
proc parseTransition(line: string): Transition =
    let parts = line.split("=>")
    (pattern: parts[0].strip(), outcome: parts[1].strip()[0])

let inputLineRegex = re"initial state:\s(.+)"
when isMainModule:
    const
        # GENERATIONS  = 50000000000 # PART B
        GENERATIONS  = 20 # PART A
    var
        f: File
        gen = newSeq[char]()
        transitions = newSeq[Transition]()

    if open(f, "input.txt"):
        var ok = true
        let inputLine = readLine(f)
        let input = inputLine.match(inputLineRegex).get().captures[0]
        for c in input.items:
            gen.add(c)

        while ok:
            try:
                let line = readLine(f)
                let t = parseTransition(line)
                transitions.add(t)
            except EOFError:
                ok = false
            except:
                echo "error reading input file"
    f.close()


    var 
        # where the current `0` is indexed
        startIdx = 0

        # number of generations
        num = 0
        
    while num < GENERATIONS:
        gen = concat(@['.','.','.','.'], gen, @['.','.','.','.'])
        startIdx += 4
        var newGen = newSeqWith(gen.len(),'.')
        for x in countup(1, gen.len()-6):
            for _, p in transitions:
                if gen[x..x+4].join("") == p.pattern:
                    newGen[x+2] = p.outcome

        num += 1
                    

        # Shrink the container, so we don't grow unbounded memory.
        var boundx = 0
        var boundy = gen.len()
        for i, c in newGen.pairs:
            if c == '#':
                boundx = i
                startIdx -= i
                break


        for i, c in newGen.reversed().pairs:
            if c == '#':
                boundy = i
                break

        gen = newGen[boundx..newGen.len()-boundy-1]        

        # PART B: Identify convergence by printing out samples.
        # echo gen.join("")
        # var totalScore = 0
        # for i, c in gen.pairs:
        #     if c == '#':
        #         totalScore += i-startIdx
    
        # echo totalScore, " ", num 
    
    var totalScore = 0
    for i, c in gen.pairs:
        if c == '#':
            totalScore += i-startIdx

    echo &"total score is: {totalScore}"

    # echo (50000000000-90)*50 + 5195 PART B Converging solution.


