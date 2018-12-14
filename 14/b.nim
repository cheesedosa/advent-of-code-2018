import sequtils
import strutils
import strformat

# Simple Brute force.
# Takes a while :(
when isMainModule:
    const
        RECIPES = 209231
        
    var
        score = @[3,7]
        x = 0
        y = 1
        iter: int64 = 2
        val = 0
        SRECIPES = toSeq(($RECIPES).items).mapIt($it).map(parseInt)

    while true:
        x = (x + score[x]+1).mod(score.len())
        y = (y + score[y]+1).mod(score.len())
        
        val = score[x] + score[y]
        if val >= 10:
            score.add(int(val/10))
            score.add(val.mod(10))
        else:
            score.add(val)

        iter += 1
        if score.len() >= SRECIPES.len()+1:
            if score[^SRECIPES.len()..^1] == SRECIPES:
                echo &"match at {score.len()-SRECIPES.len()}"
            elif  score[^(SRECIPES.len()+1)..^2] == SRECIPES:
                echo &"match at {score.len()-SRECIPES.len() - 1 }"
                break

