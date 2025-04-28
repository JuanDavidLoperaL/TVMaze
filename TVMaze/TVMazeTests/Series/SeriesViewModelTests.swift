//
//  SeriesViewModelTests.swift
//  TVMazeTests
//
//  Created by Juan david Lopera lopez on 28/04/25.
//

import XCTest
import Combine
@testable import TVMaze

class SeriesViewModelTests: XCTestCase {
    
    var viewModel: SeriesViewModel!
    var mockAPI: MockSeriesAPI!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockSeriesAPI()
        viewModel = SeriesViewModel(api: mockAPI)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockAPI = nil
        super.tearDown()
    }
    
    func testLoadSeriesSuccess() {
        mockAPI.shouldReturnError = false
        let expectedSeries = [
            Serie(id: 1, name: "Breaking Bad", language: "English", genres: ["Crime", "Drama"], summary: "A high school teacher turned meth kingpin.", schedule: SerieSchedule(time: "9 PM", days: ["Monday"]), image: nil),
            Serie(id: 2, name: "Stranger Things", language: "English", genres: ["Drama", "Fantasy"], summary: "A group of kids uncover supernatural events.", schedule: SerieSchedule(time: "10 PM", days: ["Thursday"]), image: nil)
        ]
        mockAPI.mockSeries = expectedSeries
        let expectation = XCTestExpectation(description: "Series loaded")
        viewModel.loadSeries()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.seriesList.count, 2)
            XCTAssertEqual(self.viewModel.seriesList.first?.title, "Breaking Bad")
            XCTAssertEqual(self.viewModel.seriesList.last?.title, "Stranger Things")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadSeriesFailure() {
        mockAPI.shouldReturnError = true
        let expectation = XCTestExpectation(description: "Series loaded")
        viewModel.loadSeries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.viewState, .error, "The view state should be error when the API request fails")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
