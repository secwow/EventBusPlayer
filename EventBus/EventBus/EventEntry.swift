import Foundation

class EventEntrie<Event>: Hashable {
    init(id: AnyHashable, priority: Priority, listener: @escaping (Event) -> ()) {
        self.id = id
        self.priority = priority
        self.listener = listener
    }
    
    static func == (lhs: EventEntrie<Event>, rhs: EventEntrie<Event>) -> Bool {
        return self == self
    }
    
    let id: AnyHashable
    let priority: Priority
    let listener: (Event) -> ()
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
