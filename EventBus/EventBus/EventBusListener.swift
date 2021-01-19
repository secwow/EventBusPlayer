import Foundation

protocol EventBusListenerManager {
    func register(event: PlayerEvents,
                for listener: @escaping (PlayerEvents) -> (),
                for object: AnyHashable,
                priority: Priority)
    func unregister(object: AnyHashable)
}

extension EventBus: EventBusListenerManager where Event == PlayerEvents {}
