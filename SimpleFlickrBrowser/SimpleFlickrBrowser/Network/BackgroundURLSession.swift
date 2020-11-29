//
// Created by Maxim Berezhnoy on 29/11/2020.
//
// Copyright (c) 2020 rencevio. All rights reserved.

import Foundation

extension URLSession {
    static let sharedBackground = BackgroundURLSession.shared
}

final class BackgroundURLSession {
    static let shared = BackgroundURLSession()

    private var onBackgroundEventsHandled: (() -> Void)?

    private let operatingQueue = DispatchQueue(label: "\(BackgroundURLSession.self)OperatingQueue")

    private let identifier = "\(BackgroundURLSession.self)Identifier"

    private var runningTasks = [URLSessionTask: Completion]()

    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)

        return URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: nil)
    }()

    private lazy var sessionDelegate = {
        BackgroundURLSessionDelegate(onTaskFinished: onTaskFinished(), onAllTasksFinished: onAllTasksFinished())
    }()

    private init() {}

    func set(onBackgroundEventsHandledCallback: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.onBackgroundEventsHandled = onBackgroundEventsHandledCallback
        }
    }

    private func onTaskFinished() -> (URLSessionTask, Data?, Error?) -> Void {
        { [weak self] task, data, error in
            self?.operatingQueue.async { [weak self] in
                guard let self = self, let taskCallback = self.runningTasks[task] else {
                    return
                }

                self.runningTasks.removeValue(forKey: task)

                taskCallback(data, error)
            }
        }
    }

    private func onAllTasksFinished() -> () -> Void {
        {
            DispatchQueue.main.async { [weak self] in
                self?.onBackgroundEventsHandled?()
                self?.onBackgroundEventsHandled = nil
            }
        }
    }
}

// MARK: - NetworkSession

extension BackgroundURLSession: NetworkSession {
    func getData(from url: URL, _ completion: @escaping Completion) {
        let task = session.downloadTask(with: url)

        operatingQueue.async { [weak self] in
            self?.runningTasks[task] = completion
        }

        task.resume()
    }
}

private final class BackgroundURLSessionDelegate: NSObject {
    private let onTaskFinished: (URLSessionTask, Data?, Error?) -> Void
    private let onAllTasksFinished: () -> Void

    init(onTaskFinished: @escaping (URLSessionTask, Data?, Error?) -> Void, onAllTasksFinished: @escaping () -> Void) {
        self.onTaskFinished = onTaskFinished
        self.onAllTasksFinished = onAllTasksFinished
    }
}

// MARK: - URLSessionDelegate

extension BackgroundURLSessionDelegate: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession _: URLSession) {
        onAllTasksFinished()
    }
}

// MARK: - URLSessionTaskDelegate

extension BackgroundURLSessionDelegate: URLSessionTaskDelegate {
    func urlSession(_: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        onTaskFinished(task, nil, error)
    }
}

// MARK: - URLSessionDownloadDelegate

extension BackgroundURLSessionDelegate: URLSessionDownloadDelegate {
    func urlSession(_: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)

            onTaskFinished(downloadTask, data, nil)
        } catch {
            onTaskFinished(downloadTask, nil, error)
        }
    }
}
