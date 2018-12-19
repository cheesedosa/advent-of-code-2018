import nre
import strutils
import sequtils

# Types of instructions.
type 
    Instruction = enum
        addR, addI, mulR, mulI, banR, banI, borR, borI, setR, setI, gtIR, gtRI, gtRR, eqIR, eqRI, eqRR

# Input
type
    Input = ref object
        ins: Instruction
        a, b, c: int


# Maps string to Instruction.
proc getIns(i: string): Instruction =
    case i:
        of "addr":
            return addR
        of "addi":
            return addI
        of "mulr":
            return mulR
        of "muli":
            return mulI
        of "banr":
            return banR
        of "bani":
            return banI
        of "borr":
            return borR
        of "bori":
            return borI
        of "setr":
            return setR
        of "seti":
            return setI
        of "gtir":
            return gtIR
        of "gtri":
            return gtRI
        of "gtrr":
            return gtRR
        of "eqir":
            return eqIR
        of "eqri":
            return eqRI
        of "eqrr":
            return eqRR
        else:
            quit 1

# Applies Instruction `ins` and Input `i` to `state` and returns the resulting state.
proc applyIns(state: seq[int], i: Input): seq[int] = 
    var o = state
    case i.ins:
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

let digits = re"(\d+)"
when isMainModule:
    var
        f: File
        ip: int
        inputs = newSeq[Input]()
    if open(f, "input.txt"):
        var
            line: string
            ok = true

        line = readLine(f)
        ip = line.findAll(digits).map(parseInt)[0]

        while ok:
            try:
                line = readLine(f)
                let i = line.split(" ")[0]
                let d = line.findAll(digits).map(parseInt)
                inputs.add(Input(
                    ins: getIns(i),
                    a: d[0],
                    b: d[1],
                    c: d[2],
                ))
            except EOFError:
                ok = false
            except:
                echo "error reading input file"
                raise


    # Straight simulation
    var 
        state = newSeq[int](6)
        i = 0
    while true:
        state = applyIns(state, inputs[i])

        i = state[ip] + 1
        if i >= inputs.len():
            break
        state[ip] = i 

    echo state



            

        