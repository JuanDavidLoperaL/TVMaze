//
//  ActivePinViewModelTests.swift
//  TVMazeTests
//
//  Created by Juan david Lopera lopez on 28/04/25.
//

import XCTest
@testable import TVMaze

final class ActivePinViewModelTests: XCTestCase {
    
    var viewModel: ActivePinViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ActivePinViewModel()
        UserDefaults.standard.removeObject(forKey: "storedPin")
    }

    override func tearDown() {
        viewModel = nil
        UserDefaults.standard.removeObject(forKey: "storedPin")
        super.tearDown()
    }

    func testValidatePin_withValidPin_returnsTrue() {
        viewModel.pin = "12345"
        XCTAssertTrue(viewModel.validatePin(), "A 5-digit numeric PIN should be valid.")
    }

    func testValidatePin_withInvalidPins_returnsFalse() {
        let invalidPins = ["", "1234", "abcde", "123456", "12 34", "12a45"]
        for pin in invalidPins {
            viewModel.pin = pin
            XCTAssertFalse(viewModel.validatePin(), "PIN '\(pin)' should be invalid.")
        }
    }

    func testSavePin_and_isPinEnable() {
        viewModel.pin = "54321"
        XCTAssertFalse(viewModel.isPinEnable(), "There should be no stored PIN initially.")

        viewModel.savePin()
        
        let storedPin = UserDefaults.standard.string(forKey: "storedPin")
        XCTAssertEqual(storedPin, "54321", "Stored PIN should match saved value.")
        XCTAssertTrue(viewModel.isPinEnable(), "After saving, isPinEnable should return true.")
    }

    func testAlertTitle_and_Description_areCorrect() {
        XCTAssertEqual(viewModel.alertTitle, "PIN invalid")
        XCTAssertEqual(viewModel.alertDescription, "PIN is invalid, PIN should be just 5 digits and only numbers.")
    }
}
