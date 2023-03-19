import Foundation
import MapKit

public enum EdgeType {
    case directed
    case undirected
}

class Vertex<Element: Equatable> {
    var value: Element
    private(set) var adjacentEdges: [DirectedEdge<Element>] = []
    
    init(_ value: Element) {
        self.value = value
    }
    
    func addEdge(_ edge: DirectedEdge<Element>) {
        self.adjacentEdges.append(edge)
    }
    
    func edgeForDestination(_ destination: Vertex<Element>) -> DirectedEdge<Element>? {
        return adjacentEdges.filter { $0.destination == destination }.first
    }
}

extension Vertex: Equatable {
    static func == (lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.value == rhs.value && lhs.adjacentEdges == rhs.adjacentEdges
    }
}

class DirectedEdge<Element: Equatable> {
    var source: Vertex<Element>
    var destination: Vertex<Element>
    var weight: Double
    
    init(source: Vertex<Element>, destination: Vertex<Element>, weight: Double) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}

extension DirectedEdge: Equatable {
    static func ==(lhs: DirectedEdge, rhs: DirectedEdge) -> Bool {
//        if let source = lhs.source.value as? ImageAnnotation, let destination = lhs.destination.value as? ImageAnnotation
//        {
//            print("\(source.title) -> \(destination.title)")
//        }
        return lhs.source == rhs.source &&
        lhs.destination == rhs.destination &&
        lhs.weight == rhs.weight
    }
}

class Destination<Element: Equatable> {
    let vertex: Vertex<Element>
    var previousVertex: Vertex<Element>?
    var totalWeight: Double = Double.greatestFiniteMagnitude
    var isReachable: Bool {
        return totalWeight < Double.greatestFiniteMagnitude
    }
    
    init(_ vertex: Vertex<Element>) {
        self.vertex = vertex
    }
}

class EdgeWeightedDigraph<Element: Equatable> {
    private(set) var vertices: [Vertex<Element>] = []

    func addVertex(_ vertex: Vertex<Element>) {
        vertices.append(vertex)
    }
    
    func removeLastVertex(){
        vertices.removeLast()
    }
    
    func removeVertices(_ where: (Vertex<Element>) -> Bool) {
        vertices.removeAll(where: `where`)
    }
    
    // This function assumes that the source and destination vertices are in the vertices array.
    func addEdge(direction: EdgeType, from: Vertex<Element>, to: Vertex<Element>, weight: Double) {
        // If we find an existing edge, just update the weight.
        if let existingEdge = from.edgeForDestination(to) {
            existingEdge.weight = weight
        }
        else {
            switch direction{
            case .undirected:
                let newEdge = DirectedEdge<Element>(source: from, destination: to, weight: weight)
                from.addEdge(newEdge)
                let otherEdge = DirectedEdge<Element>(source: to, destination: from, weight: weight)
                to.addEdge(otherEdge)
            case .directed :
                let newEdge = DirectedEdge<Element>(source: from, destination: to, weight: weight)
                from.addEdge(newEdge)
            }
        }
    }

    func adjacentEdges(forVertex vertex: Vertex<Element>) -> [DirectedEdge<Element>] {
        return vertex.adjacentEdges
    }

    func edges() -> [DirectedEdge<Element>] {
        return vertices
            .reduce([DirectedEdge<Element>]()) {
                (result, vertex) -> [DirectedEdge<Element>] in
                return result + vertex.adjacentEdges
            }
    }

    func edgesCount() -> Int {
        return edges().count
    }

    func verticesCount() -> Int {
        return vertices.count
    }
}

private class QueueItem<Element: Equatable>: Comparable {

    let value: Element
    var priority: Double

    init(_ value: Element, priority: Double) {
        self.value = value
        self.priority = priority
    }

    static func < (lhs: QueueItem<Element>, rhs: QueueItem<Element>) -> Bool {
        return lhs.priority < rhs.priority
    }

    static func == (lhs: QueueItem<Element>, rhs: QueueItem<Element>) -> Bool {
        return lhs.priority == rhs.priority
    }
}

public class SimplePriorityQueue<Element: Equatable> {

    //private class QueueItem<Element: Equatable>: Comparable {//..Redacted for clarity..//}

    private var items: [QueueItem<Element>] = []

    public var isEmpty: Bool {
        return items.isEmpty
    }

    public func contains(_ item: Element) -> Bool {
        return items.contains { $0.value == item }
    }

    public func insert(_ item: Element, priority: Double) {
        if contains(item) {
            update(item, priority: priority)
        } else {
            let newItem = QueueItem<Element>(item, priority: priority)
            items.append(newItem)
            sortItems()
        }
    }

    public func update(_ item: Element, priority: Double) {
        if let existingItem = items.filter({ $0.value == item }).first {
            existingItem.priority = priority
            sortItems()
        }
    }

    public func deleteMin() -> Element? {
        guard isEmpty == false else {
            return nil
        }

        let item = items.removeFirst()
        return item.value
    }

    private func sortItems() {
        items = items.sorted(by: < )
    }
}

class DijkstraShortestPath<Element: Equatable> {
    
    private var destinations: [Destination<Element>] = [] // Dictionary would be more efficient. Using array for simplicity.
    private var priorityQueue: SimplePriorityQueue<Vertex<Element>> = SimplePriorityQueue<Vertex<Element>>()
    
    init(_ graph: EdgeWeightedDigraph<Element>, source: Vertex<Element>) {
        
        graph.vertices.forEach { self.destinations.append(Destination($0)) }
        
        let sourceDestination = destination(for: source)
        sourceDestination.totalWeight = 0.0
        
        priorityQueue.insert(source, priority: 0.0)
        
        while (priorityQueue.isEmpty == false) {
            if let min = priorityQueue.deleteMin() {
                relax(min)
            }
        }
    }
    
    private func destination(for vertex: Vertex<Element>) -> Destination<Element> {
        return destinations.filter { $0.vertex == vertex }.first ?? Destination(vertex)
    }
    
    private func relax(_ vertex: Vertex<Element>) {
        vertex.adjacentEdges.forEach { (edge) in
            
            let edgeDestination = edge.destination
            let nextDestination = destination(for: edgeDestination)
            let currentDestination = destination(for: vertex)
            
            if nextDestination.totalWeight > (currentDestination.totalWeight + edge.weight) {
                nextDestination.totalWeight = currentDestination.totalWeight + edge.weight
                nextDestination.previousVertex = edge.source
                
                priorityQueue.insert(nextDestination.vertex, priority: nextDestination.totalWeight)
            }
        }
    }
    
    public func distanceTo(_ vertex: Vertex<Element>) -> Double {
        return destination(for: vertex).totalWeight
    }
    
    public func hasPathTo(_ vertex: Vertex<Element>) -> Bool {
        
        return destination(for: vertex).isReachable
    }
    
    public func pathTo(_ vertex: Vertex<Element>) -> [Vertex<Element>]? {
        guard hasPathTo(vertex) else {
            return nil
        }
        var results: [Vertex<Element>] = [vertex]
        
        var currentDestination = destination(for: vertex)
        while let previousVertex = currentDestination.previousVertex {
            results.insert(previousVertex, at: 0)
            currentDestination = destination(for: previousVertex)
        }
        
        return results
    }
}
