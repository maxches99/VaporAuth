import XCTest
@testable import VaporAuthFields
import Vapor

final class RegistrationFieldTests: XCTestCase {

    func testRegistrationFieldInitialization() {
        let field = RegistrationField(
            fieldName: "phone",
            fieldLabel: "Phone Number",
            fieldType: "text",
            isRequired: true,
            displayOrder: 1,
            isActive: true,
            placeholder: "+1 (555) 123-4567",
            helpText: "Enter your phone number",
            validationPattern: "^\\+?[1-9]\\d{1,14}$",
            options: nil
        )

        XCTAssertEqual(field.fieldName, "phone")
        XCTAssertEqual(field.fieldLabel, "Phone Number")
        XCTAssertEqual(field.fieldType, "text")
        XCTAssertTrue(field.isRequired)
        XCTAssertEqual(field.displayOrder, 1)
        XCTAssertTrue(field.isActive)
        XCTAssertEqual(field.placeholder, "+1 (555) 123-4567")
        XCTAssertEqual(field.helpText, "Enter your phone number")
        XCTAssertNotNil(field.validationPattern)
        XCTAssertNil(field.options)
    }

    func testSelectFieldWithOptions() {
        let optionsJSON = "[\"Option 1\",\"Option 2\",\"Option 3\"]"

        let field = RegistrationField(
            fieldName: "country",
            fieldLabel: "Country",
            fieldType: "select",
            isRequired: true,
            displayOrder: 2,
            isActive: true,
            placeholder: nil,
            helpText: nil,
            validationPattern: nil,
            options: optionsJSON
        )

        XCTAssertEqual(field.fieldType, "select")
        XCTAssertEqual(field.options, optionsJSON)
    }

    func testFieldTypes() {
        let validTypes = ["text", "email", "number", "select", "checkbox", "textarea"]

        for type in validTypes {
            let field = RegistrationField(
                fieldName: "test_field",
                fieldLabel: "Test Field",
                fieldType: type,
                isRequired: false,
                displayOrder: 0,
                isActive: true
            )

            XCTAssertEqual(field.fieldType, type)
        }
    }
}

final class RegistrationFieldDTOTests: XCTestCase {

    func testPublicRegistrationFieldResponse() {
        let response = PublicRegistrationFieldResponse(
            fieldName: "phone",
            fieldLabel: "Phone Number",
            fieldType: "text",
            isRequired: true,
            displayOrder: 1,
            placeholder: "+1 (555) 123-4567",
            helpText: "Enter your phone number",
            validationPattern: "^\\+?[1-9]\\d{1,14}$",
            options: ["Option 1", "Option 2"]
        )

        XCTAssertEqual(response.fieldName, "phone")
        XCTAssertTrue(response.isRequired)
        XCTAssertEqual(response.options?.count, 2)
    }

    func testCreateRegistrationFieldRequest() {
        let request = CreateRegistrationFieldRequest(
            fieldName: "company",
            fieldLabel: "Company Name",
            fieldType: "text",
            isRequired: false,
            displayOrder: 3,
            isActive: true
        )

        XCTAssertEqual(request.fieldName, "company")
        XCTAssertFalse(request.isRequired)
        XCTAssertTrue(request.isActive)
    }
}
