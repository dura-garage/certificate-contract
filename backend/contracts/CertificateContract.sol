// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title CertificateContract
/// @author 
/// @notice A contract for issuing certificates and verifying their validity.

contract CertificateContract {

    using SafeMath for uint256;


    /// @notice The owner of the contract.
    address public owner;

    /// @notice The number of organizations that have been created.S
    uint256 public organizationCount = 0;

    /// @notice The number of programs that have been created.
    uint256 public programCount = 0;

    /// @notice The number of students that have been created.
    uint256 public studentCount = 0;

    /// @notice The number of instructors that have been created.
    uint256 public instructorCount = 0;

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
        string email;
    }

    /// @notice A struct representing an instructor.
    struct Instructor {
        string name;
        string email;
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

    /// @notice A mapping from an address to an instructor.
    mapping(address => Instructor) public instructors;


    /// @notice A mapping from a program ID to a program. 
    /// @dev The program ID is the count of programs that have been created.
    mapping(uint256 => Program) public programs;


    /// @notice A mapping from a student address to an array of certificates.
    mapping(address => Certificate[]) public certificatesByStudent;


    /// @notice A mapping from an organization address to an array of programs.
    mapping(address => Program[]) public programsByOrganization;


    /// @notice A mapping from a program ID to an array of students.
    mapping(uint256 => Student[]) public studentsByProgram;

    /// @notice A mapping from list instructors to programs.
    mapping(address => Program[]) public programsByInstructor;

    /// @notice A mapping from a program ID to an array of instructors.
    mapping(uint256 => Instructor[]) public instructorsByProgram;

    /// @notice A mapping from a certificate hash to a boolean indicating whether the certificate has been issued.
    mapping(bytes32 => bool) public certificateIssued;



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

    /// @notice An event that is emitted when a program is created.
    event ProgramCreated(
        string name, 
        address indexed organizationAddress,
        uint256 indexed programId
    );

    /// @notice An event that is emitted when a student is added to a program.
    event StudentAddedToProgram(
        string studentName,
        string programName,
        address indexed studentAddress,
        uint256 indexed programId
    );

    /// @notice An event that is emitted when an instructor is added to a program.
    event InstructorAddedToProgram(
        string instructorName,
        string programName,
        address indexed instructorAddress,
        uint256 indexed programId
    );

    /// @notice An event that is emitted when a student is removed from a program.
    event StudentRemovedFromProgram(
        string studentName,
        string programName,
        address indexed studentAddress,
        uint256 indexed programId
    );

    /// @notice An event that is emitted when an instructor is removed from a program.
    event InstructorRemovedFromProgram(
        string instructorName,
        string programName,
        address indexed instructorAddress,
        uint256 indexed programId
    );

    /// @notice An event that is emitted when a student is created.
    event StudentCreated(
        string name,
        string email,
        address indexed studentAddress
    );

    /// @notice An event that is emitted when an instructor is created.
    event InstructorCreated(
        string name,
        string email,
        address indexed instructorAddress
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

    /// @notice A modifier that requires the caller to be a student.
    modifier onlyStudent() {
        require(
            bytes(students[msg.sender].name).length != 0,
            "NOT_STUDENT"
        );
        _;
    }

    /// @notice A modifier that requires the caller to be an instructor.
    modifier onlyInstructor() {
        require(
            bytes(instructors[msg.sender].name).length != 0,
            "NOT_INSTRUCTOR"
        );
        _;
    }

    /// @notice A modifier that requires the caller to be an organization or an instructor.
    modifier onlyOrganizerOrInstructor() {
        require(
            bytes(organizations[msg.sender].name).length != 0 ||
            bytes(instructors[msg.sender].name).length != 0,
            "NOT_ORGANIZER_OR_INSTRUCTOR"
        );
        _;
    }


    /// @notice Constructor for the contract.
    /// @dev Sets the owner of the contract to the address that deployed it.
    constructor() {
        owner = msg.sender;
    }




    /********************************  FOR ORGANIZARIONS  ********************************/


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
        studentsByProgram[_programId].push(students[_student]);
        emit StudentAddedToProgram(students[_student].name, programs[_programId].name, _student, _programId);
    }

    /// @notice Adds an instructor to a program.
    /// @param _instructor The address of the instructor.
    /// @param _programId The ID of the program.
    function addInstructorToProgram(address _instructor, uint256 _programId)
        public
        onlyOrganizer
    {
        instructorsByProgram[_programId].push(instructors[_instructor]);
        emit InstructorAddedToProgram(instructors[_instructor].name, programs[_programId].name, _instructor, _programId);
    }
    

    /// @notice Removes a student from a program.
    /// @param _student The address of the student.
    /// @param _programId The ID of the program.
    function removeStudentFromProgram(address _student, uint256 _programId)
        public
        onlyOrganizer
    {
        delete students[_student];
        for (uint256 i = 0; i < studentsByProgram[_programId].length; i++) {
            if (keccak256(abi.encodePacked(studentsByProgram[_programId][i].name)) == keccak256(abi.encodePacked(students[_student].name))) {
                delete studentsByProgram[_programId][i];
            }
        }
    }

    /// @notice Removes an instructor from a program.
    /// @param _instructor The address of the instructor.
    /// @param _programId The ID of the program.
    function removeInstructorFromProgram(address _instructor, uint256 _programId)
        public
        onlyOrganizer
    {
        delete instructors[_instructor];
        for (uint256 i = 0; i < instructorsByProgram[_programId].length; i++) {
            if (keccak256(abi.encodePacked(instructorsByProgram[_programId][i].name)) == keccak256(abi.encodePacked(instructors[_instructor].name))) {
                delete instructorsByProgram[_programId][i];
            }
        }
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
        onlyOrganizerOrInstructor
        returns (Student[] memory)
    {
        return studentsByProgram[_programId];
    }


    /****************************  FOR CERTIFICATE ISSUNACE *******************************/

    /// @notice Issues a certificate to a student.
    /// @param _certificateCID The IPFS CID of the certificate.
    /// @param _certificateBytes The bytes of the certificate.
    /// @param _issuedTo The address of the student.
    function issueCertificate(string memory _certificateCID, string memory _certificateBytes, address _issuedTo)
        public
        onlyOrganizer
    {
        certificatesByStudent[_issuedTo].push(
            Certificate(_certificateCID, msg.sender, _issuedTo)
        );
        // add the certificate to the certificateIssued
        bytes32 certificateHash = keccak256(abi.encodePacked(_certificateBytes));
        certificateIssued[certificateHash] = true;
        emit CertificateIssued(_certificateBytes, msg.sender, _issuedTo);
    }


    /****************************  FOR INSTRUCTORS  *********************/

    /// @notice Creates an instructor.
    /// @param _name The name of the instructor.
    /// @param _email The email of the instructor.
    function createInstructor(string memory _name, string memory _email)
        public
    {
        instructorCount = instructorCount.add(1);
        instructors[msg.sender] = Instructor(_name, _email);
        emit InstructorCreated(_name, _email, msg.sender);
    }



    /*********************** FOR STUDENTS ********************/


    /// @notice Creates a student.
    /// @param _name The name of the student.
    /// @param _email The email of the student.
    function createStudent(string memory _name, string memory _email)
        public
    {
        studentCount = studentCount.add(1);
        students[msg.sender] = Student(_name, _email);
        emit StudentCreated(_name, _email, msg.sender);
    }



    /// @notice Gets the certificates of the caller/student.
    /// @return An array of certificates.
    function getMyCertificates() public view returns (Certificate[] memory) {
        return certificatesByStudent[msg.sender];
    }



    /*********************** FOR VERIFIERS ********************/


    /// @notice Verfiies the validity of a certificate.
    /// @param _certificateBytes The bytes of the certificate.
    /// @return A boolean indicating whether the certificate is valid or not.
    function verifyCertificate(string memory _certificateBytes)
        public
        view
        returns (bool)
    {
        bytes32 certificateHash = keccak256(abi.encodePacked(_certificateBytes));
        return certificateIssued[certificateHash];
    }

}