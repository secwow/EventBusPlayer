import Foundation

protocol EventBusManager {
    func register(event: PlayerEvents,
                for listener: @escaping (PlayerEvents) -> (),
                for object: AnyHashable,
                priority: Priority)
    func unregister(object: AnyHashable)
}

extension EventBus: EventBusManager where Event == PlayerEvents {}
