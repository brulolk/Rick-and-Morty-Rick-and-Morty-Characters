//
//  Debouncer.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation
import Combine

final class Debouncer {
    private let delay: RunLoop.SchedulerTimeType.Stride
    private var cancellable: AnyCancellable?
    
    init(delay: RunLoop.SchedulerTimeType.Stride) {
        self.delay = delay
    }
    
    func run(action: @escaping () -> Void) {
        cancellable?.cancel()
        cancellable = Just(())
            .delay(for: delay, scheduler: RunLoop.main)
            .sink { _ in action() }
    }
}
