import Foundation

protocol EventBusPublisher {
    func publish(event: PlayerEvents)
}

extension EventBus: EventBusPublisher where Event == PlayerEvents {}
