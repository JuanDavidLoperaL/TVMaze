//
//  SerieDetailViewModelTests.swift
//  TVMazeTests
//
//  Created by Juan david Lopera lopez on 28/04/25.
//

import XCTest
import Combine
@testable import TVMaze

final class SerieDetailViewModelTests: XCTestCase {

    var viewModel: SerieDetailViewModel!
    var mockAPI: MockSerieDetailAPI!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPI = MockSerieDetailAPI()
        cancellables = Set<AnyCancellable>()
        
        let serieData = SerieDataView(
            id: 1,
            title: "Test Serie",
            language: "English",
            genres: "Drama",
            scheduleDays: "Monday",
            scheduleTime: "9 PM",
            summary: "<p>Summary with <b>HTML</b></p>",
            image: nil
        )

        viewModel = SerieDetailViewModel(serieDataView: serieData, api: mockAPI)
    }

    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadEpisodesSuccess() {
        let expectation = XCTestExpectation(description: "Episodes loaded")

        mockAPI.shouldReturnError = false
        mockAPI.mockEpisodes = [
            SerieEpisodes(id: 101, name: "Pilot", season: 1, number: 1, summary: "<p>Great episode</p>", image: SerieImage(medium: "http://image.com/ep1.jpg", original: "")),
            SerieEpisodes(id: 102, name: "Next", season: 1, number: 2, summary: "<p>Second episode</p>", image: SerieImage(medium: "http://image.com/ep2.jpg", original: ""))
        ]

        viewModel.loadEpisodes()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.episodesList.count, 2)
            XCTAssertEqual(self.viewModel.episodesList[0].name, "Pilot")
            XCTAssertEqual(self.viewModel.episodesTitle, "Episodes")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadEpisodesFailure() {
        let expectation = XCTestExpectation(description: "API failure handled")

        mockAPI.shouldReturnError = true

        viewModel.loadEpisodes()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.episodesList.count, 0)
            XCTAssertEqual(self.viewModel.episodesTitle, "")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testCleanSummaryStripsHTML() {
        let clean = viewModel.cleanSummary()
        XCTAssertEqual(clean, "Summary with HTML")
    }
}
