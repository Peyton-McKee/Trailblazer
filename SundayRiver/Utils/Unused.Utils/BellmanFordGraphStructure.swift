////
////  BelmontFordGraphStructure.swift
////  SundayRiver
////
////  Created by Peyton McKee on 10/22/22.
////
//
//import Foundation
//
//
//
//class ATQueue<Element: Equatable> {
//    
//    private class Node<Element: Equatable> {
//        
//        let value: Element
//        var previous: Node?
//        var next: Node?
//        
//        init(_ value: Element) {
//            self.value = value
//        }
//    }
//    
//    private var head: Node<Element>?
//    private var tail: Node<Element>?
//    
//    public var isEmpty: Bool {
//        return head == nil
//    }
//    
//    public var size: Int {
//        var count = 0
//        var current = head
//        while (current != nil) {
//            current = current?.next
//            count += 1
//        }
//        return count
//    }
//    
//    public var elements: [Element] {
//        get {
//            var result: [Element] = []
//            
//            var current = head
//            while let node = current {
//                result.append(node.value)
//                current = node.next
//            }
//            
//            return result
//        }
//    }
//    
//    public var reversedElements: [Element] {
//        get {
//            var result: [Element] = []
//            
//            var current = tail
//            while let node = current {
//                result.append(node.value)
//                current = node.previous
//            }
//            
//            return result
//        }
//    }
//    
//    public func enqueue(_ element: Element) {
//        guard contains(element) == false else {
//            return
//        }
//        
//        let newNode = Node(element)
//        tail?.next = newNode
//        newNode.previous = tail
//        
//        tail = newNode
//        
//        if head == nil {
//            head = tail
//        }
//    }
//    
//    public func dequeue() -> Element? {
//        let element = head
//        
//        head = element?.next
//        
//        if head == nil {
//            tail = nil
//        }
//        
//        return element?.value
//    }
//    
//    public func contains(_ element: Element) -> Bool {
//        var current = head
//        while (current != nil) {
//            if current?.value == element {
//                return true
//            }
//            current = current?.next
//        }
//        return false
//    }
//    
//    
//}
//
//public class ATStack<Element: Equatable> {
//    
//    class Node<Element> {
//        var item: Element
//        var next: Node?
//        
//        init(withItem item: Element) {
//            self.item = item
//        }
//    }
//    
//    private var head: Node<Element>?
//    private var count: Int = 0
//    
//    public var isEmpty: Bool {
//        return head == nil
//    }
//    
//    public var size: Int {
//        return count
//    }
//    
//    public func push(item: Element) {
//        let oldHead = head
//        head = Node(withItem: item)
//        head?.next = oldHead
//        count += 1
//    }
//    
//    public func pop() -> Element? {
//        let item = head?.item
//        head = head?.next
//        count -= 1
//        return item
//    }
//    
//    public func peek() -> Element? {
//        return head?.item
//    }
//    
//    public func contains(_ element: Element) -> Bool {
//        var current = head
//        while (current != nil) {
//            if current?.item == element {
//                return true
//            }
//            current = current?.next
//        }
//        return false
//    }
//    
//    public func allElements() -> [Element] {
//        var result: [Element] = []
//        
//        var current = head
//        while current != nil {
//            result.append(current!.item)
//            current = current?.next
//        }
//        
//        return result
//    }
//}
//
//class BellmanFordShortestPath<Element: Equatable> {
//    
//    public var hasNegativeCycle: Bool {
//        return negativeCycle != nil
//    }
//    
//    private(set) var negativeCycle: [Vertex<Element>]?
//    
//    private var destinations: [Destination<Element>] = []
//    private var relaxationQueue: ATQueue<Vertex<Element>> = ATQueue() // :)
//    private var iteration: Int = 0
//    private let graph: EdgeWeightedDigraph<Element>
//    
//    init(_ graph: EdgeWeightedDigraph<Element>, source: Vertex<Element>) {
//        
//        self.graph = graph
//        
//        graph.vertices.forEach { self.destinations.append(Destination($0)) }
//        
//        let sourceDestination = destination(for: source)
//        sourceDestination.totalWeight = 0.0
//        
//        relaxationQueue.enqueue(source)
//        
//        while (relaxationQueue.isEmpty == false && self.hasNegativeCycle == false) {
//            if let vertex = relaxationQueue.dequeue() {
//                self.relax(vertex)
//            }
//        }
//    }
//    
//    private func destination(for vertex: Vertex<Element>) -> Destination<Element> {
//        return destinations.filter { $0.vertex == vertex }.first ?? Destination(vertex)
//    }
//    
//    private func relax(_ vertex: Vertex<Element>) {
//        vertex.adjacentEdges.forEach { (edge) in
//            
//            let edgeDestination = edge.destination
//            let nextDestination = destination(for: edgeDestination)
//            let currentDestination = destination(for: vertex)
//            
//            if nextDestination.totalWeight > (currentDestination.totalWeight + edge.weight) {
//                nextDestination.totalWeight = currentDestination.totalWeight + edge.weight
//                nextDestination.previousVertex = edge.source
//                
//                if (relaxationQueue.contains(edgeDestination) == false) {
//                    relaxationQueue.enqueue(edgeDestination)
//                }
//            }
//            
//            iteration += 1
//            
//            if (iteration % self.graph.edgesCount() == 0) {
//                findNegativeCycle()
//            }
//        }
//    }
//    
//    public func distanceTo(_ vertex: Vertex<Element>) -> Double {
//        return destination(for: vertex).totalWeight
//    }
//    
//    public func hasPathTo(_ vertex: Vertex<Element>) -> Bool {
//        return destination(for: vertex).totalWeight < Double.greatestFiniteMagnitude
//    }
//    
//    public func pathTo(_ vertex: Vertex<Element>) -> [Vertex<Element>]? {
//        guard hasPathTo(vertex) else {
//            return nil
//        }
//        
//        var results: [Vertex<Element>] = [vertex]
//        
//        var currentDestination = destination(for: vertex)
//        while let previousVertex = currentDestination.previousVertex {
//            results.insert(previousVertex, at: 0)
//            currentDestination = destination(for: previousVertex)
//        }
//        
//        return results
//    }
//    
//    private func findNegativeCycle() {
//        let shortestPath = EdgeWeightedDigraph<Element>()
//        
//        self.destinations.forEach { (destination) in
//            if destination.isReachable {
//                if let previous = destination.previousVertex, let edge = previous.edgeForDestination(destination.vertex) {
//                    shortestPath.addEdge(direction: .directed, from: self.vertex(edge.source, fromArray: shortestPath.vertices),
//                                         to: self.vertex(edge.destination, fromArray: shortestPath.vertices),
//                                         weight: edge.weight)
//                }
//            }
//        }
//        
//        let cycleFinder = EdgeWeightedDirectedCycle(shortestPath)
//        self.negativeCycle = cycleFinder.hasCycle ? cycleFinder.cycle : nil
//    }
//    
//    // Returns an existing vertex from the graph or creates a new one if the graph doesn't contain the vertex.
//    private func vertex(_ vertex: Vertex<Element>, fromArray array: [Vertex<Element>]) -> Vertex<Element> {
//        if let idx = array.firstIndex(of: vertex) {
//            return array[idx]
//        } else {
//            return Vertex(vertex.value)
//        }
//    }
//}
//
//
//import Foundation
//
//class EdgeWeightedDirectedCycle<Element: Equatable> {
//    
//    private var visitedVertices: [Vertex<Element>] = []
//    private var destinations: [Destination<Element>] = []
//    private var cycleStack: ATStack<Vertex<Element>>?
//    private var recursionStack: ATStack<Vertex<Element>> = ATStack()
//    
//    public var hasCycle: Bool {
//        return cycleStack != nil
//    }
//    
//    public var cycle: [Vertex<Element>] {
//        return cycleStack?.allElements().reversed() ?? []
//    }
//    
//    init(_ graph: EdgeWeightedDigraph<Element>) {
//        
//        graph.vertices.forEach { self.destinations.append(Destination($0)) }
//        
//        graph.vertices.forEach { vertex in
//            if self.isVisited(vertex) == false {
//                self.depthFirstSearch(vertex)
//            }
//        }
//    }
//    
//    private func depthFirstSearch(_ vertex: Vertex<Element>) {
//        self.recursionStack.push(item: vertex)
//        self.visitedVertices.append(vertex)
//        
//        vertex.adjacentEdges.forEach { (edge) in
//            
//            let edgeDestination = edge.destination
//            let nextDestination = self.destination(for: edgeDestination)
//            
//            if self.hasCycle {
//                return
//            } else if self.isVisited(edgeDestination) == false {
//                nextDestination.previousVertex = edge.source
//                self.depthFirstSearch(edgeDestination)
//            } else if self.recursionStack.contains(edgeDestination) == true {
//                
//                self.cycleStack = ATStack()
//                
//                self.cycleStack?.push(item: vertex)
//                
//                var currentDestination = destination(for: vertex)
//                while let previousVertex = currentDestination.previousVertex {
//                    
//                    self.cycleStack?.push(item: previousVertex)
//                    
//                    if previousVertex == edgeDestination {
//                        break
//                    }
//                    
//                    currentDestination = destination(for: previousVertex)
//                }
//                
//                self.cycleStack?.push(item: vertex)
//            }
//        }
//        
//        _ = self.recursionStack.pop()
//    }
//    
//    private func isVisited(_ vertex: Vertex<Element>) -> Bool {
//        return visitedVertices.contains(vertex)
//    }
//    
//    private func destination(for vertex: Vertex<Element>) -> Destination<Element> {
//        return destinations.filter { $0.vertex == vertex }.first ?? Destination(vertex)
//    }
//}
//
//class EdgeWeightedDigraph<Element: Equatable> {
//    private(set) var vertices: [Vertex<Element>] = []
//    
//    func addVertex(_ vertex: Vertex<Element>) {
//        vertices.append(vertex)
//    }
//    
//    private func addVertexIfNotPresent(vertex: Vertex<Element>) {
//        guard vertices.contains(vertex) == false else {
//            return
//        }
//        addVertex(vertex)
//    }
//    
//    func addEdge(direction: EdgeType, from: Vertex<Element>, to: Vertex<Element>, weight: Double) {
//        
//        addVertexIfNotPresent(vertex: from)
//        addVertexIfNotPresent(vertex: to)
//        
//        // If we find an existing edge, just update the weight.
//        switch direction{
//        case .undirected:
//            if let existingEdge = from.edgeForDestination(to) {
//                existingEdge.weight = weight
//            } else {
//                let newEdge = DirectedEdge<Element>(source: from, destination: to, weight: weight)
//                from.addEdge(newEdge)
//                let otherEdge = DirectedEdge<Element>(source: to, destination: from, weight: weight)
//                from.addEdge(otherEdge)
//            }
//        case .directed :
//            if let existingEdge = from.edgeForDestination(to) {
//                existingEdge.weight = weight
//            } else {
//                let newEdge = DirectedEdge<Element>(source: from, destination: to, weight: weight)
//                from.addEdge(newEdge)
//            }
//        }
//    }
//    
//    func adjacentEdges(forVertex vertex: Vertex<Element>) -> [DirectedEdge<Element>] {
//        return vertex.adjacentEdges
//    }
//    
//    func edges() -> [DirectedEdge<Element>] {
//        return vertices
//            .reduce([DirectedEdge<Element>]()) {
//                (result, vertex) -> [DirectedEdge<Element>] in
//                return result + vertex.adjacentEdges
//        }
//    }
//    
//    func edgesCount() -> Int {
//        return edges().count
//    }
//    
//    func verticesCount() -> Int {
//        return vertices.count
//    }
//}
