import Foundation

struct EventEntry<Event> {
    let id: AnyHashable
    let priority: Priority
    let listener: (Event) -> ()
    
    init(id: AnyHashable, priority: Priority, listener: @escaping (Event) -> ()) {
        self.id = id
        self.priority = priority
        self.listener = listener
    }
}

extension EventEntry: Hashable {
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: EventEntry<Event>, rhs: EventEntry<Event>) -> Bool {
        return self == self
    }
}
