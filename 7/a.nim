import nre
import tables
import sets
import algorithm

# Parse input.
let lineParseRegex = re"Step ([A-Z]{1}) must be finished before step ([A-Z]{1}) can begin."

when isMainModule:
    var
        f: File
        nodes = newTable[string, seq[string]]()
        inDegrees = newTable[string, int]()
    if open(f, "input.txt"):
        var
            line: string
            ok = true
        while ok:
            try:
                line = readLine(f)
                let n = line.match(lineParseRegex).get()
                if nodes.hasKeyOrPut(n.captures[0], @[n.captures[1]]):
                    nodes[n.captures[0]].add(n.captures[1])
                if inDegrees.hasKeyOrPut(n.captures[1], 1):
                    inDegrees[n.captures[1]] += 1
            except EOFError:
                ok = false
            except:
                echo "error reading inputs from file"
                raise
    f.close()

    var queue = newSeq[string]()
    for k, _ in nodes:
        if inDegrees.getOrDefault(k) == 0:
            queue.add(k)


    # Solve using Kahn's topological sort.
    # Maintain a list of in degree nodes and add to queue
    # when all child nodes are explored.
    # Sort before removing from the queue and adding to the output.
    var output : string = ""
    while queue.len() > 0:
        queue.sort(cmp)
        let x = queue[0]
        queue = queue[1..len(queue)-1]
        output.add(x)

        let outEdges = nodes.getOrDefault(x)
        for e in outEdges:
            inDegrees[e] -= 1
            if inDegrees[e] == 0:
                queue.add(e)

    echo output