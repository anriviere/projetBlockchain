pragma solidity ^0.5.3;

pragma experimental ABIEncoderV2;

import "./Token.sol";

contract Diploma {
    address private owner;
    address private token;

    // Structure représentant un établissement d'enseignement
    struct Establishment {
        bool exists;
        uint256 ees_id;
        string establishment_name;
        string establishment_type;
        string country;
        string addresses;
        string website;
        uint256 agent_id;
    }

    // Structure représentant les informations personnelles d'un étudiant
    struct StudentPersonalInfo {
        string LastName;
        string FirstName;
        string DateOfBirth;
        string Gender;
        string Nationality;
        string MaritalStatus;
        string Address;
        string Email;
        string Phone;
    }

    
    // Structure représentant les informations académiques d'un étudiant
    struct StudentAcademicInfo {
        string Section;
        string ThesisTopic;
        string InternshipCompany;
        string InternshipSupervisor;
        string InternshipStartDate;
        string InternshipEndDate;
        string Evaluation;
    }

    // Structure représentant un étudiant
    struct Student {
        bool exists;
        uint256 student_id;
        StudentPersonalInfo personalInfo;
        StudentAcademicInfo academicInfo;
    }

   
   // Structure représentant un diplôme
    struct DiplomaInfo {
        bool exists;
        uint256 holder_id;
        string institution_name;
        string country;
        string diploma_type;
        string specialization;
        string honors;
        string date_of_obtention;
    }

    // Structure représentant une entreprise
    struct Company {
        bool exists;
        uint256 diploma_id;
        uint256 company_id;
        string Name;
        string Sector;
        string DateOfCreation;
        string SizeClassification;
        string Country;
        string Address;
        string Email;
        string Phone;
        string Website;
    }

    // Mappings pour gérer les différents registres
    mapping(uint256 => Establishment) public Establishments;
    mapping(address => uint256) AddressEstablishments;
    mapping(uint256 => Student) public Students;
    mapping(uint256 => Company) public Companies;
    mapping(address => uint256) AddressCompanies;
    mapping(uint256 => DiplomaInfo) public Diplomas;

    uint256 public NbEstablishments;
    uint256 public NbStudents;
    uint256 public NbCompanies;
    uint256 public NbDiplomas;

    // Constructeur du contrat qui initialise certaines variables
    constructor(address tokenaddress) public {
        token = tokenaddress;
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor

        NbEstablishments = 0;
        NbStudents = 0;
        NbCompanies = 0;
        NbDiplomas = 0;
    }

    // Fonction privée pour ajouter un établissement au registre
    function AddEstablishments(Establishment memory e, address a) private {
        NbEstablishments += 1;
        e.exists = true;
        e.ees_id += 1;
        Establishments[NbEstablishments] = e;
        AddressEstablishments[a] = NbEstablishments;
    }

    // Fonction privée pour ajouter une entreprise au registre
    function AddCompanies(Company memory e, address a) private {
        NbCompanies += 1;
        e.exists = true;
        e.company_id += 1;
        Companies[NbCompanies] = e;
        AddressCompanies[a] = NbCompanies;
    }

    // Fonction privée pour ajouter un étudiant au registre
    function AddStudents(Student memory e) private {
        e.exists = true;
        e.student_id += 1;
        NbStudents += 1;
        Students[NbStudents] = e;
    }

    // Fonction privée pour ajouter un diplôme au registre
    function AddDiplomas(DiplomaInfo memory d) private {
        d.exists = true;
        d.holder_id += 1;
        NbDiplomas += 1;
        Diplomas[NbDiplomas] = d;
    }

    // Fonction publique pour ajouter un établissement au registre en fournissant des détails spécifiques
    function AddEstablishments(string memory name, string memory establishmentType, string memory country, string memory addresses, string memory website, uint256 agentId) public {
        Establishment memory e;
        e.establishment_name = name;
        e.establishment_type = establishmentType;
        e.country = country;
        e.addresses = addresses;
        e.website = website;
        e.agent_id = agentId;
        AddEstablishments(e, msg.sender);
    }

    // Fonction publique pour ajouter une entreprise au registre en fournissant des détails spécifiques
    function AddCompanies(string memory name, string memory sector, string memory dateOfCreation, string memory sizeClassification, string memory country, string memory companyAddress, string memory email, string memory phone, string memory website) public {
        Company memory e;
        e.Name = name;
        e.Sector = sector;
        e.DateOfCreation = dateOfCreation;
        e.SizeClassification = sizeClassification;
        e.Country = country;
        e.Address = companyAddress;
        e.Email = email;
        e.Phone = phone;
        e.Website = website;
        AddCompanies(e, msg.sender);
    }

    // Fonction publique pour ajouter un étudiant au registre en fournissant des informations personnelles et académiques
    function AddStudents(StudentPersonalInfo memory personalInfo,StudentAcademicInfo memory academicInfo) public {
        uint256 id = AddressEstablishments[msg.sender];
        require(id != 0, "Not Establishment");
        
        Student storage e = Students[NbStudents + 1];
        e.exists = true;
        e.student_id = NbStudents + 1;
        e.personalInfo = personalInfo;
        e.academicInfo = academicInfo;
        NbStudents += 1;
    }
  
    // Fonction publique pour ajouter un diplôme au registre en fournissant des détails spécifiques
    function AddDiplomas(uint256 holderId, string memory country, string memory diplomaType, string memory specialization, string memory honors, string memory dateOfObtention) public {
        uint256 id = AddressEstablishments[msg.sender];
        require(id != 0, "Not Establishment");
        require(Students[holderId].exists == true, "Not Students");
        DiplomaInfo memory d;
        d.exists = true;
        d.holder_id = holderId;
        d.institution_name = Establishments[id].establishment_name;
        d.country = country;
        d.diploma_type = diplomaType;
        d.specialization = specialization;
        d.honors = honors;
        d.date_of_obtention = dateOfObtention;
        AddDiplomas(d);
    }

    // Évalue et met à jour les informations académiques d'un étudiant, et gère les paiements en tokens.
    function evaluate(uint256 studentId,string memory thesisTopic,string memory internshipCompany,string memory internshipSupervisor,string memory internshipStartDate,string memory internshipEndDate,string memory evaluation) public {
        uint256 id = AddressCompanies[msg.sender];
        require(id != 0, "No Companies");
        require(Students[studentId].exists == true, "Not Students");
        Students[studentId].academicInfo.ThesisTopic = thesisTopic;
        Students[studentId].academicInfo.InternshipCompany = internshipCompany;
        Students[studentId].academicInfo.InternshipSupervisor = internshipSupervisor;
        Students[studentId].academicInfo.InternshipStartDate = internshipStartDate;
        Students[studentId].academicInfo.InternshipEndDate = internshipEndDate;
        Students[studentId].academicInfo.Evaluation = evaluation;
        
        // Gestion des paiements en tokens pour l'évaluation
        require(
            Token(token).allowance(owner, address(this)) >= 15, // Check the amount authorized by the owner >= number of tokens the user wants to buy
            "Token not allowed"
        );
        require(
            Token(token).transferFrom(owner, msg.sender, 15), // Transfer tokens
            "Transfer failed"
        );
    }

    // Événement déclenché lors de la vérification de l'authenticité d'un diplôme.
    event VerificationResult(bool success, DiplomaInfo diploma);

    // Vérifie l'authenticité d'un diplôme et enregistre le résultat.
    function verify(uint256 diplomaId) public returns (bool, DiplomaInfo memory) {
        // Paiement de 10 tokens comme frais pour la vérification
        require(
            Token(token).allowance(msg.sender, address(this)) >= 10, // Check the amount authorized by the owner >= number of tokens the user wants to buy
            "Token not allowed"
        );
        require(
            Token(token).transferFrom(msg.sender, owner, 10), // Transfer tokens
            "Transfer failed"
        );
        emit VerificationResult(Diplomas[diplomaId].exists, Diplomas[diplomaId]);
        return (Diplomas[diplomaId].exists, Diplomas[diplomaId]);
    }
}