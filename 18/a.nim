import sequtils
import strformat

# Straight simulation of the automata.
when isMainModule:
    const
        BOUND = 50
        ITER = 10
    var
        f: File
        grid: array[BOUND, array[BOUND,char]]
    if open(f, "input.txt"):
        var
            line: string
            ok = true
            y = 0
        while ok:
            try:
                line = readLine(f)
                for i,c in line.pairs:
                    grid[y][i] = c
                
                y += 1
            except EOFError:
                ok = false
            except:
                echo "error reading input"
                raise

    f.close()

    var 
        min = 0
        nextGrid = grid
    while min < ITER:
        for y in countup(0, BOUND-1):
            for x in countup(0, BOUND-1):
                var 
                    ct = 0
                    cl = 0
                    co = 0
        
                for l in countup(-1, 1):
                    for k in countup(-1,1):
                        if l == 0 and k == 0 :
                            continue
                        if y+l < 0 or y+l >= BOUND or x+k < 0 or x+k >= BOUND:
                            continue
                        case grid[x+k][y+l]:
                            of '|':
                                ct += 1
                            of '#':
                                cl += 1
                            of '.':
                                co += 1
                            else:
                                raise newException(ValueError,"unknown point")

                case grid[x][y]:
                    of '.':
                        if ct >= 3:
                            nextGrid[x][y] = '|'
                    of '|':
                        if cl >= 3:
                            nextGrid[x][y] = '#'
                    of '#':
                        if ct >= 1 and cl >= 1:
                            nextGrid[x][y] = '#'
                        else:
                            nextGrid[x][y] = '.'
                    else:
                        raise newException(ValueError,"unknown point")
        min += 1
        grid = nextGrid

    var 
        ct = 0
        cl = 0
    for y in countup(0, BOUND-1):
        for x in countup(0, BOUND-1):
            if grid[x][y] == '|':
                ct += 1
            if grid[x][y] == '#':
                cl += 1
    echo  &"the value of resources is {ct*cl}"