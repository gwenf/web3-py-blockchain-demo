pragma solidity 0.6.0;

// pragma solidity >=0.4.22 <0.7.0;

// phone company dapp

// charge telemarkers coins for calls
// whitelist people don't get charged
// anyone not on the whitelist has to pay a small fee

contract PhoneCompany {
    uint256 public chargeAmount;
    uint256 public coinPrice;
    address companyOwner;

    // a list of phone numbers attached to my address
    // only the user can view their own phonebook

    mapping(uint256 => uint256[]) whitelisted;

    struct User {
        string name;
        uint256 phoneNumber;
        uint256 coins;
    }
    mapping(address => User) users;

    constructor(uint256 amount, uint256 price) public {
        companyOwner = msg.sender;
        chargeAmount = amount;
        coinPrice = price;
    }

    function updateAmount(uint256 amount) public {
        require(
            msg.sender == companyOwner,
            "Only the company owner can update charge amount."
        );
        chargeAmount = amount;
    }

    function initNewUser(uint256 phoneNumber, string memory name)
        public
        payable
        returns (string memory)
    {
        // check amount paid
        require(
            msg.value >= coinPrice * 100,
            "You didn't send enough money to buy 100 coins."
        );
        users[msg.sender] = User({
            phoneNumber: phoneNumber,
            name: name,
            coins: 100
        });
        return "Success! You now have 100 coins.";
    }

    function coinBalance() public view returns (uint256) {
        return users[msg.sender].coins;
    }

    // add a phone number to a users phone book, whitelist
    function addPhoneNumber(uint256 phoneNumber) public {
        whitelisted[users[msg.sender].phoneNumber].push(phoneNumber);
    }

    function makeCall(uint256 phoneNumber) public returns (uint256) {
        bool isWhitelisted = false;
        uint256 userPhone = users[msg.sender].phoneNumber;
        for (uint256 i; i < whitelisted[userPhone].length; i++) {
            if (whitelisted[userPhone][i] == phoneNumber) {
                isWhitelisted = true;
                break;
            }
        }

        if (!isWhitelisted) {
            users[msg.sender].coins = users[msg.sender].coins - chargeAmount;
        }
        return users[msg.sender].coins;
    }

    // users can restock their coins
    function buyCoins() public payable returns (uint256) {
        require(
            msg.value >= coinPrice,
            "You didn't send enough money to buy coins."
        );
        uint256 coinNum = msg.value / coinPrice;

        users[msg.sender].coins = users[msg.sender].coins + coinNum;
        return users[msg.sender].coins;
    }

    // addLastCallerToWhitelist
    // store info of last caller and return coins
}
