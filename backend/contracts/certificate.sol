// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title CertificateContract
/// @author 
/// @notice A contract for issuing certificates and verifying their validity.

contract CertificateContract {

    using SafeMath for uint256;


    /// @notice The owner of the contract.
    address public owner;

    /// @notice The number of organizations that have been created.
    uint256 public organizationCount = 0;

    /// @notice The number of programs that have been created.
    uint256 public programCount = 0;

    /// @notice A struct representing an organization.
    struct Organization {
        string name;
        string email;
    }

    /// @notice A struct representing a program.
    struct Program {
        string name;
    }

    /// @notice A struct representing a student.
    struct Student {
        string name;
    }

    /// @notice A struct representing a certificate.
    struct Certificate {
        string certificateHash;
        address issuedBy;
        address issuedTo;
    }

    /// @notice A mapping from an address to an organization.
    mapping(address => Organization) public organizations;


    /// @notice A mapping from an address to a student.
    mapping(address => Student) public students;


    /// @notice A mapping from a program ID to a program. 
    /// @dev The program ID is the count of programs that have been created.
    mapping(uint256 => Program) public programs;


    /// @notice A mapping from a student address to an array of certificates.
    mapping(address => Certificate[]) public certificatesByStudent;


    /// @notice A mapping from an organization address to an array of programs.
    mapping(address => Program[]) public programsByOrganization;


    /// @notice A mapping from a program ID to an array of students.
    mapping(uint256 => Student[]) public studentsByProgram;


    /// @notice An event that is emitted when an organization is created.
    event OrganizationCreated(
        string name,
        string email,
        address indexed organizationAddress
    );

    /// @notice An event that is emitted when a certificate is issued.
    event CertificateIssued(
        string certificateHash,
        address indexed issuedBy,
        address indexed issuedTo
    );

    /// @notice A modifier that requires the caller to be the owner of the contract.
    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    /// @notice A modifier that requires the caller to be an organization.
    modifier onlyOrganizer() {
        require(
            bytes(organizations[msg.sender].name).length != 0,
            "NOT_ORGANIZER"
        );
        _;
    }


    /// @notice Constructor for the contract.
    /// @dev Sets the owner of the contract to the address that deployed it.
    constructor() {
        owner = msg.sender;
    }

    /// @notice Creates an organization.
    /// @param _name The name of the organization.
    /// @param _email The email of the organization.
    function createOrganization(string memory _name, string memory _email)
        public
    {
        organizationCount = organizationCount.add(1);
        organizations[msg.sender] = Organization(_name, _email);
        emit OrganizationCreated(_name, _email, msg.sender);
    }


    /// @notice Creates a program.
    /// @param _name The name of the program.
    function createProgram(string memory _name) public onlyOrganizer {
        programCount = programCount.add(1);
        programs[programCount] = Program(_name);
        programsByOrganization[msg.sender].push(Program(_name));
    }

    /// @notice Adds a student to a program.
    /// @param _student The address of the student.
    /// @param _programId The ID of the program.
    function addStudentToProgram(address _student, uint256 _programId)
        public
        onlyOrganizer
    {
        students[_student] = Student(students[_student].name);
        studentsByProgram[_programId].push(Student(students[_student].name));
    }


    /// @notice Issues a certificate to a student.
    /// @param _certificateHash The hash of the certificate.
    /// @param _issuedTo The address of the student.
    function issueCertificate(string memory _certificateHash, address _issuedTo)
        public
        onlyOrganizer
    {
        certificatesByStudent[_issuedTo].push(
            Certificate(_certificateHash, msg.sender, _issuedTo)
        );
        emit CertificateIssued(_certificateHash, msg.sender, _issuedTo);
    }


    /// @notice Gets the number of certificates issued to a student.
    /// @param _student The address of the student.
    /// @return The number of certificates issued to the student.
    function getCertificateCount(address _student)
        public
        view
        returns (uint256)
    {
        return certificatesByStudent[_student].length;
    }

    /// @notice Gets the number of programs created by an organization.
    /// @param _organization The address of the organization.
    /// @return The number of programs created by the organization.
    function getProgramCount(address _organization)
        public
        view
        returns (uint256)
    {
        return programsByOrganization[_organization].length;
    }

    /// @notice Gets the number of students in a program.
    /// @param _programId The ID of the program.
    /// @return The number of students in the program.
    function getStudentCount(uint256 _programId) public view returns (uint256) {
        return studentsByProgram[_programId].length;
    }

    /// @notice Gets the certificates of the caller/student.
    /// @return An array of certificates.
    function getMyCertificates() public view returns (Certificate[] memory) {
        return certificatesByStudent[msg.sender];
    }
    /// @notice Gets the programs of the caller/organization.
    /// @return An array of programs.
    function getMyPrograms() public view returns (Program[] memory) {
        return programsByOrganization[msg.sender];
    }

    /// @notice Gets the students in a program.
    /// @param _programId The ID of the program.
    /// @return An array of students.
    function getStudentsInProgram(uint256 _programId)
        public
        view
        returns (Student[] memory)
    {
        return studentsByProgram[_programId];
    }

    /// @notice Verfiies the validity of a certificate.
    /// @param _certificateHash The hash of the certificate.
    /// @param _issuedBy The address of the organization that issued the certificate.
    /// @param _issuedTo The address of the student that the certificate was issued to.
    /// @return A boolean indicating whether the certificate is valid.
    function verifyCertificate(
        string memory _certificateHash,
        address _issuedBy,
        address _issuedTo
    ) public view returns (bool) {
        Certificate[] memory certificates = certificatesByStudent[_issuedTo];
        for (uint256 i = 0; i < certificates.length; i++) {
            if (
                keccak256(abi.encodePacked(certificates[i].certificateHash)) ==
                keccak256(abi.encodePacked(_certificateHash)) &&
                certificates[i].issuedBy == _issuedBy &&
                certificates[i].issuedTo == _issuedTo
            ) {
                return true;
            }
        }
        return false;
    }




}