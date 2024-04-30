pragma solidity >=0.5.0 <0.5.17;

// Définition d'un contrat basique ERC20 pour la gestion des tokens
contract ERC20Basic {
    // Fonction pour obtenir la quantité totale de tokens
    function totalSupply() public view returns (uint256);

    // Fonction pour obtenir le solde de tokens d'une adresse spécifique
    function balanceOf(address who) public view returns (uint256);

    // Fonction pour transférer des tokens à une adresse spécifiée
    function transfer(address to, uint256 value) public returns (bool);

    // Fonction pour permettre le transfert de tokens
    // Permet à un contrat d'opérer avec nos tokens
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {}

    // Fonction pour approuver une adresse à dépenser un certain nombre de tokens
    function approve(address spender, uint256 value) public returns (bool);

    // Fonction pour obtenir le montant de tokens qu'une adresse est autorisée à dépenser en votre nom
    function allowance(address owner, address spender)
        public
        view
        returns (uint256);

    // Événement qui doit être émis lorsque des tokens sont transférés
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    // Événement qui doit être émis lorsqu'une approbation est donnée par une adresse
    // pour permettre à une autre adresse de dépenser des tokens en son nom
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}