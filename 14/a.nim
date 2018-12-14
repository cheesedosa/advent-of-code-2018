import sequtils
import strutils
import strformat

when isMainModule:
    const
        RECIPES = 209231
        QUERY = 10

    var
        score = @[3,7]
        x = 0
        y = 1
        iter = 2
        val = 0

    while iter < RECIPES + QUERY:
        x = (x + score[x]+1).mod(score.len())
        y = (y + score[y]+1).mod(score.len())
        
        val = score[x] + score[y]
        if val >= 10:
            score.add(int(val/10))
            score.add(val.mod(10))
        else:
            score.add(val)

        iter += 1
        
    echo score[RECIPES..RECIPES+QUERY-1].mapIt($it).join("")



        