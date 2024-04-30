pragma solidity >=0.5.0 <0.5.17;

import "./ERC20Basic.sol";

// Déclaration du contrat Token qui hérite des propriétés de ERC20Basic.
contract Token is ERC20Basic {
    string public symbol = "YDIP";
    string public name = "YDIPToken";
    uint8 public decimal = 15;

    using SafeMath for uint256;
    uint256 totalSupply_;

    // Constructeur qui initialise le contrat avec l'offre totale des tokens.
    constructor(uint256 total) public {
        totalSupply_ = total;
        __balanceOf[msg.sender] = totalSupply_;
    }

    mapping(address => uint256) private __balanceOf;
    mapping(address => mapping(address => uint256)) __allowances;

    // Événements pour signaler les transferts de tokens et les approbations.
    event Transfer(address _addr, address _to, uint256 _value);
    event Approval(address _owner, address _spender, uint256 _value);

    // Fonction pour retourner l'offre totale de tokens.
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    // Fonction pour retourner le solde de tokens d'une adresse donnée.
    function balanceOf(address _addr) public view returns (uint256 balance) {
        return __balanceOf[_addr];
    }

    // Fonction pour transférer des tokens à une autre adresse.
    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(_value <= __balanceOf[msg.sender]);
        __balanceOf[msg.sender] = __balanceOf[msg.sender].sub(_value);
        __balanceOf[_to] = __balanceOf[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // Fonction pour transférer des tokens en partant d'une troisième adresse autorisée.
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= __balanceOf[_from]);
        require(_value <= __allowances[_from][msg.sender]);

        __balanceOf[_from] = __balanceOf[_from].sub(_value);
        __allowances[_from][msg.sender] = __allowances[_from][msg.sender].sub(
            _value
        );
        __balanceOf[_to] = __balanceOf[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    // Fonction pour autoriser une adresse à dépenser certains tokens en notre nom.
    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        require(__allowances[msg.sender][_spender] == 0, "");
        __allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    // Fonction pour consulter le montant qu'une adresse a encore le droit de dépenser pour le compte d'une autre adresse.
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 remaining)
    {
        return __allowances[_owner][_spender];
    }
}


library SafeMath {
    // Fonction de soustraction sécurisée pour prévenir le débordement négatif.
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    // Fonction d'addition sécurisée pour prévenir le débordement positif.
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}