import { ethers } from "hardhat";
import { expect } from "chai";

// writing test for the certificate contract
// including the test for the certificate contract

describe("Certificate Contract", function () {
    let certificate: any;
    let owner: any;
    let organization: any;
    let instructor: any;
    let student: any;
    let addr1: any[];


    before(async function () {
        const Certificate = await ethers.getContractFactory("CertificateContract");
        certificate = await Certificate.deploy();
        [...addr1] = await ethers.getSigners();
        owner = addr1[0].address;
        organization = addr1[1];
        instructor = addr1[2];
        student = addr1[3];
        await certificate.deployed();
    });

    //testing the deployment of the contract
    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            owner = addr1[0].address;
            expect(await certificate.owner()).to.equal(owner);
        });
    }
    );

    //organization creation
    describe("Organization Creation", function () {
        it("Should create an organization", async function () {
            await certificate.connect(organization).createOrganization("First Organization", "dura@first.org");
            expect(await certificate.organizationCount()).to.equal(1);
        });

    });

    //create Program
    describe("Program Creation", function () {
        it("Should create a program", async function () {
            await certificate.connect(organization).createProgram("First Program");
            expect(await certificate.programCount()).to.equal(1);
        });

    });

    //create Instructor
    describe("Instructor Creation", function () {
        it("Should create an instructor", async function () {
            instructor = addr1[2];
            await certificate.connect(instructor).createInstructor("First Instructor", "intructor@first.org");
            expect(await certificate.instructorCount()).to.equal(1);
        });

    });

    //create Student
    describe("Student Creation", function () {
        it("Should create a student", async function () {
            await certificate.connect(student).createStudent("First Student", "student@first.org");
            expect(await certificate.studentCount()).to.equal(1);
        });
    });

    // get the program of an organization
    describe("Get Programs of an Organization", function () {
        it("Should get the program of an organization", async function () {
            expect(await certificate.connect(organization).getMyPrograms()).length.to.be.greaterThan(0);
        });
    });




    // TODO: resolve the MISSING_ARGUMENT error
    // TODO: resolve the INVALID_ARGUMENT error

    //add instructor to a program
    describe("Add Instructor to a Program", function () {
        it("Should add an instructor to a program", async function () {
            await certificate.connect(organization).addInstructorToProgram("Instructor1", "instructor@first.org");
            expect(await certificate.connect(organization).insructorsByProgram(1)).length.to.be.greaterThan(0);
        }); 
    });

    //add student to a program
    describe("Add Student to a Program", function () {
        it("Should add a student to a program", async function () {
            await certificate.connect(organization).addStudentToProgram("Student1", "student@first.org");
            expect(await certificate.connect(organization).studentsByProgram(1)).length.to.be.greaterThan(0);   
        });
    });


    //get students of a program
    describe("Get Students of a Program", function () {
        it("Should get the students of a program", async function () {
            expect(await certificate.connect(organization).studentsByProgram(1)).length.to.be.greaterThan(0);    
        });
    });

    // issue the certificate
    describe("Issue Certificate", function () {
        it("Should issue a certificate", async function () {
            await certificate.connect(organization).issueCertificate("hash1", student.address);
            expect(await certificate.certificatesByStudent(student.address)).length.to.be.greaterThan(0);
        }
        );


    });

    // get the certificates of a student
    describe("Get Certificates of a Student", function () {
        it("Should get the certificates of a student", async function () {
            expect(await certificate.connect(student).getMyCertificates()).length.to.be.greaterThan(0);
        });
    }
    );

    // verify the certificate
    describe("Verify Certificate", function () {
        it("Should verify a certificate", async function () {
            expect(await certificate.connect(student).verifyCertificate("hash1",organization.address, student.address)).to.equal(true);
        });
    }
    );




});
