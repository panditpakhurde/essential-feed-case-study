//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Pakhurde Pandit on 23/07/20.
//  Copyright © 2020 Quikr. All rights reserved.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        refreshControl?.beginRefreshing()
        load()
    }
    
    @objc private func load() {
        loader?.load() {[weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
    
}

extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulateToPullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool  {
        return refreshControl?.isRefreshing == true
    }
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let (_ , loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_LoadsFeed() {
        let (sut , loader) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    func test_userInitiatedFeedReload_LoadsFeed() {
        let (sut , loader) = makeSUT()

        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2)
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3)
    }
    
    func test_viewDidLoad_ShowsLoadingIndicator() {
        let (sut , _) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }
    
    func test_viewDidLoad_HidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading()
        
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }
    
    func test_userInitiatedFeedReload_ShowsLoadingIndicator() {
        let (sut , _) = makeSUT()

        sut.simulateUserInitiatedFeedReload()

        XCTAssertTrue(sut.isShowingLoadingIndicator)
    }
    
    func test_userInitiatedFeedReload_HidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()

        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading()
        
        XCTAssertFalse(sut.isShowingLoadingIndicator)
    }

    
    //MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(loader)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            return completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading() {
            completions[0](.success([]))
        }
    }
}

private extension UIRefreshControl {
    func simulateToPullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
