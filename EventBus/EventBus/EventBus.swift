import Foundation

class EventBus<Event: Hashable> {
    private var listeners: [Event: [AnyHashable: EventEntry<Event>]]
    private var lock: NSLock = NSLock()
    
    init(listeners: [Event: [Int: EventEntry<Event>]] = [:]) {
        self.listeners = listeners
    }
    
    func register(event: Event,
                for listener: @escaping (Event) -> (),
                for object: AnyHashable,
                priority: Priority = .medium) {
        defer {
            lock.unlock()
        }
        lock.lock()
        
        let entry = EventEntry(id: object, priority: priority, listener: listener)
        
        if var listenersWithEvent = listeners[event] {
            guard listenersWithEvent[object] == nil else {
                return
            }
            
            listenersWithEvent[object] = entry
            listeners[event] = listenersWithEvent
        } else {
            listeners[event] = [object: entry]
        }
    }
    
    func publish(event: Event) {
        defer {
            lock.unlock()
        }
        lock.lock()
        
        guard
            let listeners = listeners[event]
        else {
            return
        }
        let sortedByPriority = listeners.values.sorted(by: { $0.priority.rawValue > $1.priority.rawValue })
        
        for listener in sortedByPriority {
            listener.listener(event)
        }
    }
    
    func unregister(object: AnyHashable) {
        defer {
            lock.unlock()
        }
        lock.lock()
        
        let allKeys = listeners.keys
        
        for key in allKeys {
            listeners[key]?[object] = nil
        }
    }
}
