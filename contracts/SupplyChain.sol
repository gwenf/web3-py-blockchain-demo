pragma solidity 0.6.0;
import "github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";

contract SupplyChain {
    using SafeMath for uint256;

    // Entities
    enum EntityType {
        PRODUCER,
        PROCESSOR,
        DISTRIBUTER,
        RETAILER
    }
    struct Entity {
        string name;
        EntityType entityType;
    }
    mapping(address => Entity) public entities;
    mapping(address => uint256) entityNumGoods;

    // Goods
    enum GoodStatus {
        PENDING,
        SOLD
    }
    struct Good {
        string name;
        GoodStatus status;
    }
    Good[] public goods;
    mapping(uint256 => address) public goodToOwner;

    // Events
    event NewEntity(address entityAddress, string name, EntityType entityType);
    event NewGood(uint256 goodId, string name);
    event GoodSold(uint256 goodId, string name);

    // Modifiers
    modifier isProducer(address _sender) {
        require(entities[_sender].entityType == EntityType.PRODUCER);
        _;
    }

    modifier isNotDuplicateEntity(address _sender) {
        bytes memory _name = bytes(entities[_sender].name);
        require(_name.length == 0);
        _;
    }

    // function to initialize an entity
    function initEntity(string memory _name, EntityType _entityType)
        public
        isNotDuplicateEntity(msg.sender)
    {
        entities[msg.sender].name = _name;
        entities[msg.sender].entityType = _entityType;
        emit NewEntity(msg.sender, _name, _entityType);
    }

    // function to initialize a good
    function initGood(string memory _goodName) public isProducer(msg.sender) {
        uint256 id = goods.push(Good(_goodName, GoodStatus.PENDING));
        goodToOwner[id] = msg.sender;
        emit NewGood(id, _goodName);
    }

    function transferGood(uint256 goodId, address _to) public {
        goodToOwner[goodId] = _to;
        entityNumGoods[msg.sender].sub(1);
        entityNumGoods[_to].add(1);
    }

    function makePayment(address payable _to) public payable {
        require(msg.value > 0);
        _to.transfer(msg.value);
    }

    // get all goods that belong to an entity
    function getGoodsByOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](entityNumGoods[_owner]);
        uint256 counter = 0;
        for (uint256 i = 0; i < goods.length; i++) {
            if (goodToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
