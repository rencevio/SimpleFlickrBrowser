//
// Created by Maxim Berezhnoy on 16/01/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import XCTest
import Foundation

extension XCTestCase {
    func awaitQueueResolution(_ queue: DispatchQueue) {
        let resolutionTimeout = 1.0
        
        let expectation = XCTestExpectation(description: "Awaiting resolution of queue \(queue.label)")

        queue.async {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: resolutionTimeout)
    }

    func awaitMainQueueResolution() {
        awaitQueueResolution(DispatchQueue.main)
    }
} 