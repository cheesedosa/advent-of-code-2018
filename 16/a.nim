# Solves both partA and partB
import nre
import strutils
import sequtils
import tables
import sets
import strformat

# Types of instructions.
type 
    Instruction = enum
        addR, addI, mulR, mulI, banR, banI, borR, borI, setR, setI, gtIR, gtRI, gtRR, eqIR, eqRI, eqRR

# Input
type
    Input = ref object
        op, a, b, c: int

# State of sample.
type
    Sim = ref object
        stateBefore: seq[int]
        input: Input
        stateAfter: seq[int]


# Applies Instruction `ins` and Input `i` to `state` and returns the resulting state.
proc applyIns(state: seq[int], i: Input, ins: Instruction): seq[int] = 
    var o = state
    case ins:
        of addR:
            o[i.c] = state[i.a] + state[i.b]
        of addI:
            o[i.c] = state[i.a] + i.b
        of mulR:
            o[i.c] = state[i.a] * state[i.b]
        of mulI:
            o[i.c] = state[i.a] * i.b
        of banR:
            o[i.c] = state[i.a] and state[i.b]
        of banI:
            o[i.c] = state[i.a] and i.b
        of borR:
            o[i.c] = state[i.a] or state[i.b]
        of borI:
            o[i.c] = state[i.a] or i.b
        of setR:
            o[i.c] = state[i.a]
        of setI:
            o[i.c] = i.a
        of gtIR:
            o[i.c] = if i.a > state[i.b] : 1 else : 0
        of gtRi:
            o[i.c] = if state[i.a] > i.b : 1 else : 0
        of gtRR:
            o[i.c] = if state[i.a] > state[i.b] : 1 else : 0
        of eqIR:
            o[i.c] = if i.a == state[i.b] : 1 else : 0
        of eqRI:
            o[i.c] = if state[i.a] == i.b : 1 else : 0
        of eqRR:
            o[i.c] = if state[i.a] == state[i.b] : 1 else : 0

    o

# matches the sample with each Instruction and returns possible Instructions that lead to the final state.
proc matchIns(s: Sim): seq[Instruction] =
    var o = newSeq[Instruction]()
    for i in Instruction:
        if s.stateAfter == applyIns(s.stateBefore, s.input, i):
            o.add(i)

    o
            
let digits = re"(\d+)"
when isMainModule:
    var
        f: File
        insCount = initTable[int,HashSet[Instruction]]()
        threeOrMore = 0
    if open(f, "input.txt"):
        var
            line: string
            ok = true
            s =  Sim(stateBefore: nil, input: nil, stateAfter: nil)
        while ok:
            # Read each line maintaining state of samples,
            # On creating a new sample, test the sample for instruction possibilitis,
            # If possibilities >= 3, increment threeOrMore to solve partA.
            try:
                line = readLine(f)
                if line == "":
                    continue
                if line.contains("Before"):
                    let l = line.findAll(digits).map(parseInt)
                    s.stateBefore = l
                    continue

                if line.contains("After"):
                    let l = line.findAll(digits).map(parseInt)
                    s.stateAfter = l


                    let insMatch = matchIns(s)
                    if insMatch.len() >= 3:
                        threeOrMore += 1
                    var h = initSet[Instruction]()
                    for i in insMatch:
                        h.incl(i)

                    if insCount.hasKeyOrPut(s.input.op, h):
                        for i in insMatch:
                            h.incl(i)

                    continue

                let l = line.findAll(digits).map(parseInt)
                let i = Input()
                i.op = l[0]
                i.a = l[1]
                i.b = l[2]
                i.c = l[3]

                s.input = i
            except EOFError:
                ok = false
            except:
                echo "error reading input"
                raise
        
    echo &"samples with three of more instructions: {threeOrMore}"

    # Solve the op to possible instructions mapping(insCount) to find op -> Instruction mapping.
    var opToIns = initTable[int, Instruction]()
    while opToIns.len() != 16:
        var curr: Instruction
        for op, ins in insCount:
            if ins.len() == 1:
                for i in ins:
                    opToIns[op] = i
                    curr = i
                for op, _ in insCount:
                    insCount[op].excl(curr)
                    if insCount[op].len() == 0:
                        insCount.del(op)
    
    # Now we know what opcode is what instruction.
    # Start with blank state and simulate inputs.
    # HACK: read file again to parse input for partB.
    # The delimiter should have been better :(
    var state = @[0,0,0,0]
    for line in readFile("input.txt").split("\n\n\n")[1].split("\n"):
        if line == "":
            continue
        let l = line.findAll(digits).map(parseInt)
        let i = Input()
        i.op = l[0]
        i.a = l[1]
        i.b = l[2]
        i.c = l[3]
        state = applyIns(state, i, opToIns[l[0]])

    echo &"final state is {state}"