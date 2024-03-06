//
//  Dijkstra.swift
//  Skiblazer
//
//  Created by Peyton McKee on 3/4/24.
//

import Foundation

public enum EdgeType {
    case directed
    case undirected
}

class Vertex<Element: Equatable> {
    private var _value: Element
    private var _adjacentEdges: [DirectedEdge<Element>] = []
    private var mutex = NSLock()

    init(_ value: Element) {
        self._value = value
    }

    func addEdge(_ edge: DirectedEdge<Element>) {
        mutex.lock()
        _adjacentEdges.append(edge)
        mutex.unlock()
    }

    func edgeForDestination(_ destination: Vertex<Element>) -> DirectedEdge<Element>? {
        mutex.lock()
        let edge = _adjacentEdges.first(where: { $0.destination == destination })
        mutex.unlock()
        return edge
    }

    var adjacentEdges: [DirectedEdge<Element>] {
        get {
            return _adjacentEdges
        }
        set {
            mutex.lock()
            _adjacentEdges = newValue
            mutex.unlock()
        }
    }

    var value: Element {
        get {
            return _value
        }
        set {
            mutex.lock()
            _value = newValue
            mutex.unlock()
        }
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
    static func == (lhs: DirectedEdge, rhs: DirectedEdge) -> Bool {
        return lhs.source.value == rhs.source.value &&
            lhs.destination.value == rhs.destination.value &&
            lhs.weight == rhs.weight
    }
}

class Destination<Element: Equatable> {
    let vertex: Vertex<Element>
    var previousVertex: Vertex<Element>?
    var totalWeight: Double = .greatestFiniteMagnitude
    var isReachable: Bool {
        return totalWeight < Double.greatestFiniteMagnitude
    }

    init(_ vertex: Vertex<Element>) {
        self.vertex = vertex
    }
}

class EdgeWeightedDigraph<Element: Equatable> {
    private(set) var vertices: [Vertex<Element>] = []
    private var mutex = NSLock()

    func addVertex(_ vertex: Vertex<Element>) {
        mutex.lock()
        vertices.append(vertex)
        mutex.unlock()
    }

    func removeLastVertex() {
        mutex.lock()
        vertices.removeLast()
        mutex.unlock()
    }

    func removeVertices(_ where: (Vertex<Element>) -> Bool) {
        mutex.lock()
        vertices.removeAll(where: `where`)
        mutex.unlock()
    }

    // This function assumes that the source and destination vertices are in the vertices array.
    func addEdge(direction: EdgeType, from: Vertex<Element>, to: Vertex<Element>, weight: Double) {
        mutex.lock()
        // If we find an existing edge, just update the weight.
        if let existingEdge = from.edgeForDestination(to) {
            existingEdge.weight = weight
        } else {
            switch direction {
            case .undirected:
                let newEdge = DirectedEdge<Element>(source: from, destination: to, weight: weight)
                from.addEdge(newEdge)
                let otherEdge = DirectedEdge<Element>(source: to, destination: from, weight: weight)
                to.addEdge(otherEdge)
            case .directed:
                let newEdge = DirectedEdge<Element>(source: from, destination: to, weight: weight)
                from.addEdge(newEdge)
            }
        }
        mutex.unlock()
    }

    func adjacentEdges(forVertex vertex: Vertex<Element>) -> [DirectedEdge<Element>] {
        return vertex.adjacentEdges
    }

    func edges() -> [DirectedEdge<Element>] {
        return vertices
            .reduce([DirectedEdge<Element>]()) {
                result, vertex -> [DirectedEdge<Element>] in
                result + vertex.adjacentEdges
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
    // private class QueueItem<Element: Equatable>: Comparable {//..Redacted for clarity..//}

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
        items = items.sorted(by: <)
    }
}

class DijkstraShortestPath<Element: Equatable> {
    private var destinations: [Destination<Element>] = [] // Dictionary would be more efficient. Using array for simplicity.
    private var priorityQueue: SimplePriorityQueue<Vertex<Element>> = .init()
    private var mutex = NSLock()

    init(_ graph: EdgeWeightedDigraph<Element>, source: Vertex<Element>) {
        mutex.lock()
        graph.vertices.forEach { self.destinations.append(Destination($0)) }

        let sourceDestination = destination(for: source)
        sourceDestination.totalWeight = 0.0

        priorityQueue.insert(source, priority: 0.0)

        while priorityQueue.isEmpty == false {
            if let min = priorityQueue.deleteMin() {
                relax(min)
            }
        }
        mutex.unlock()
    }

    private func destination(for vertex: Vertex<Element>) -> Destination<Element> {
        let destination = destinations.first(where: { $0.vertex == vertex }) ?? Destination(vertex)
        return destination
    }

    private func relax(_ vertex: Vertex<Element>) {
        vertex.adjacentEdges.forEach { edge in

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
        mutex.lock()
        guard hasPathTo(vertex) else {
            mutex.unlock()
            return nil
        }
        var results: [Vertex<Element>] = [vertex]

        var currentDestination = destination(for: vertex)
        while let previousVertex = currentDestination.previousVertex {
            results.insert(previousVertex, at: 0)
            currentDestination = destination(for: previousVertex)
        }

        mutex.unlock()
        return results
    }
}
