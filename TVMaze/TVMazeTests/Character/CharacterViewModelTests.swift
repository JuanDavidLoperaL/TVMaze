//
//  CharacterViewModelTests.swift
//  TVMazeTests
//
//  Created by Juan david Lopera lopez on 28/04/25.
//

import XCTest
import Combine
@testable import TVMaze

final class CharacterViewModelTests: XCTestCase {
    
    var viewModel: CharacterViewModel!
    var mockAPI: MockCharacterAPI!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockAPI = MockCharacterAPI()
        viewModel = CharacterViewModel(api: mockAPI)
        cancellables = []
    }

    override func tearDown() {
        mockAPI = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadCharacters_successful() {
        mockAPI.mockCharacters = [
            CharacterResponse(id: 1, name: "Rick", image: SerieImage(medium: "https://image.com/rick.jpg", original: "")),
            CharacterResponse(id: 2, name: "Morty", image: nil)
        ]
        
        let expectation = XCTestExpectation(description: "Characters loaded")
        
        viewModel.loadCharacters()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            viewModel.$characterList
                .dropFirst()
                .sink { list in
                    XCTAssertEqual(list.count, 2)
                    XCTAssertEqual(list.first?.name, "Rick")
                    XCTAssertEqual(self.viewModel.viewState, .loaded)
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadCharacters_failure() {
        mockAPI.shouldReturnError = true

        let expectation = XCTestExpectation(description: "Characters load failed")
        viewModel.$viewState
            .dropFirst()
            .sink { state in
                XCTAssertEqual(state, .loading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadCharacters()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadCharactersByName_successful() {
        mockAPI.mockCharactersByName = [
            CharacterByNameResponse(person: CharacterResponse(id: 10, name: "Summer", image: nil))
        ]
        viewModel.searchText = "Summer"

        let expectation = XCTestExpectation(description: "Characters by name loaded")
        viewModel.$characterList
            .dropFirst()
            .sink { list in
                XCTAssertEqual(list.count, 1)
                XCTAssertEqual(list.first?.name, "Summer")
                XCTAssertEqual(self.viewModel.viewState, .loaded)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadSeriesByName()
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadCharactersByName_failure() {
        mockAPI.shouldReturnError = true
        viewModel.searchText = "Summer"

        let expectation = XCTestExpectation(description: "Characters by name load failed")
        viewModel.$viewState
            .dropFirst()
            .sink { state in
                XCTAssertEqual(state, .loading)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadSeriesByName()
        
        wait(for: [expectation], timeout: 1.0)
    }
}
