import strutils
import sequtils
import strformat

# Node describes a node in the tree.
type 
    Node = ref object
        numChild: int
        numMeta: int
        children: seq[Node]
        metadata: seq[int]
        value: int

# Parse node recursively traverses `input` to build the node tree.
proc parseNode(input: seq[int], idx: int): (Node, int) =
    let nC = input[idx]
    let nM = input[idx+1]
    var endIdx = idx
    let n = Node(
        numChild: nC,
        numMeta: nM,
        children : @[],
        metadata: @[],
        value: 0
    )
    
    # Increment the trailing idx here, to offset the header.
    endIdx += 2
    
    # If we have children, recursively parse them.
    if nC > 0:
        for x in countup(0, nC - 1):
            let cn = parseNode(input, endIdx)
            n.children.add(cn[0])
            endIdx = cn[1]
    
    for x in countup(endIdx, endIdx+nM-1):
        n.metadata.add(input[x])
        endIdx += 1

    # Calculate the value of the node as per problem statement.
    if nC == 0:
        n.value = foldl(n.metadata, a + b)
    else:
        for _, m in n.metadata:
            try:
                n.value += n.children[m-1].value
            except IndexError:
                echo &"child {m} not found for node {idx}"
    
    (n, endIdx)
    
when isMainModule:
    var
        f: File
        input: seq[int]
    if open(f, "input.txt"):
        input = readAll(f).split(" ").map(proc (x: string):int = parseInt(x))
    f.close()

    let n = parseNode(input, 0)
    
    echo &"value of the root node is {n[0].value}"
        