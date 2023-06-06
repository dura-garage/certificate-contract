// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CertificateContract {
    address public owner;
    uint256 public organizationCount = 0;
    uint256 public programCount = 0;

    struct Organization {
        string name;
        string email;
    }

    struct Program {
        string name;
    }

    struct Student {
        string name;
    }

    struct Certificate {
        string certificateHash;
        address issuedBy;
    }

    mapping(address => Organization) public organizations;
    mapping(address => Student) public students;

    mapping(uint256 => Program) public programs;
    mapping(address => Certificate[]) public certificatesByStudent;
    mapping(address => Program[]) public programsByOrganization;

    event OrganizationCreated(
        string name,
        string email,
        address indexed organizationAddress
    );

    event CertificateIssued(
        string certificateHash,
        address indexed issuedBy,
        address indexed issuedTo
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }
    modifier onlyOrganizer() {
        require(
            bytes(organizations[msg.sender].name).length != 0,
            "NOT_ORGANIZER"
        );
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createOrganization(
        string memory _name,
        string memory _email
    ) public onlyOwner {
        organizationCount++;
        organizations[msg.sender] = Organization(_name, _email);
        emit OrganizationCreated(_name, _email, msg.sender);
    }

    function createProgram(string memory _name) public onlyOrganizer {
        programCount++;
        programs[programCount] = Program(_name);
        programsByOrganization[msg.sender].push(programs[programCount]);
    }

    function registerStudent(string memory _name) public onlyOrganizer {
        students[msg.sender] = Student(_name);
    }

    function issueCertificate(
        string memory _certificateHash,
        address _issuedTo
    ) public onlyOrganizer {
        require(
            bytes(organizations[msg.sender].name).length != 0,
            "NOT_ORGANIZER"
        );
        certificatesByStudent[_issuedTo].push(
            Certificate(_certificateHash, msg.sender)
        );
        emit CertificateIssued(_certificateHash, msg.sender, _issuedTo);
    }

    function verifyCertificate(
        string memory _certificateHash,
        address _issuedTo
    ) public view returns (bool) {
        Certificate[] memory certificates = certificatesByStudent[_issuedTo];
        for (uint i = 0; i < certificates.length; i++) {
            if (
                keccak256(abi.encodePacked(certificates[i].certificateHash)) ==
                keccak256(abi.encodePacked(_certificateHash))
            ) {
                return true;
            }
        }
        return false;
    }

    function getOrganization(
        address _organizationAddress
    ) public view returns (string memory, string memory) {
        return (
            organizations[_organizationAddress].name,
            organizations[_organizationAddress].email
        );
    }

    function getProgram(
        uint256 _programId
    ) public view returns (string memory) {
        return programs[_programId].name;
    }

    function getStudent(
        address _studentAddress
    ) public view returns (string memory) {
        return students[_studentAddress].name;
    }
}
