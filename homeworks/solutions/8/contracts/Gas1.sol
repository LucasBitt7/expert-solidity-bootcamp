// GAS OPTIMAZATION 4006566 ==> 3178965 21.7%

// BEFORE
// ·----------------------------------|----------------------------|-------------|-----------------------------·
// |       Solc version: 0.8.0        ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 30000000 gas  │
// ···································|····························|·············|······························
// |  Methods                                                                                                  │
// ················|··················|··············|·············|·············|···············|··············
// |  Contract     ·  Method          ·  Min         ·  Max        ·  Avg        ·  # calls      ·  usd (avg)  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  addToWhitelist  ·       60239  ·      64698  ·      62473  ·         2400  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  transfer        ·      145461  ·     196785  ·     171125  ·           20  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  updatePayment   ·           -  ·          -  ·     190499  ·            2  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  whiteTransfer   ·           -  ·          -  ·      54795  ·            6  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  Deployments                     ·                                          ·  % of limit   ·             │
// ···································|··············|·············|·············|···············|··············
// |  GasContract                     ·           -  ·          -  ·    4006566  ·         13 %  ·          -  │
// ·----------------------------------|--------------|-------------|-------------|---------------|-------------·

// AFTER
// ·----------------------------------|----------------------------|-------------|-----------------------------·
// |       Solc version: 0.8.7        ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 30000000 gas  │
// ···································|····························|·············|······························
// |  Methods                                                                                                  │
// ················|··················|··············|·············|·············|···············|··············
// |  Contract     ·  Method          ·  Min         ·  Max        ·  Avg        ·  # calls      ·  usd (avg)  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  addToWhitelist  ·       57643  ·      57871  ·      57760  ·         2400  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  transfer        ·      142061  ·     193385  ·     167725  ·           20  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  updatePayment   ·           -  ·          -  ·     180277  ·            2  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  GasContract  ·  whiteTransfer   ·           -  ·          -  ·      54795  ·            6  ·          -  │
// ················|··················|··············|·············|·············|···············|··············
// |  Deployments                     ·                                          ·  % of limit   ·             │
// ···································|··············|·············|·············|···············|··············
// |  GasContract                     ·           -  ·          -  ·    3178965  ·       10.6 %  ·          -  │
// ·----------------------------------|--------------|-------------|-------------|---------------|-------------·


// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Constants {
    uint8 constant public tradeFlag = 1;
    uint8 constant public basicFlag = 0;
    uint8 constant public dividendFlag = 1;
}

contract GasContract is Ownable, Constants {
    uint256 public totalSupply; // cannot be updated
    uint256 public paymentCounter;
    uint256 constant public tradePercent = 12;
    address public immutable contractOwner;
    uint256 public tradeMode;
    address[5] public administrators;
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }
    PaymentType constant defaultPayment = PaymentType.Unknown;

    mapping(address => uint256) public balances;
    mapping(address => Payment[]) public payments;
    History[] public paymentHistory; // when a payment was updated
    mapping(address => uint256) public whitelist;

    struct Payment {
        uint paymentID;
        bool adminUpdated;
        PaymentType paymentType;
        address recipient;
        string recipientName; // max 8 characters
        address admin; // administrators address
        uint amount;
    }

    struct History {
        uint lastUpdate;
        address updatedBy;
        uint blockNumber;
    }

    event AddedToWhitelist(address userAddress, uint256 tier);

    error InvalidPaymentName();
    error Unauthorized();
    error InvalidPaymentType();
    error InvalidPaymentAmount();
    error InvalidPaymentID();
    

    modifier onlyAdminOrOwner() {
        if (checkForAdmin(msg.sender)) {
            _;
        } else if (msg.sender == contractOwner) {
            _;
        } else {
            revert Unauthorized();
        }
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount,
        string recipient
    );
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        contractOwner = msg.sender;
        totalSupply = _totalSupply;

        for (uint256 ii = 0; ii < administrators.length; ii++) {
            if (_admins[ii] != address(0)) {
                administrators[ii] = _admins[ii];
                if (_admins[ii] == msg.sender) {
                    balances[msg.sender] = totalSupply;
                } else {
                    balances[_admins[ii]] = 0;
                }
                if (_admins[ii] == msg.sender) {
                    emit supplyChanged(_admins[ii], totalSupply);
                } else if (_admins[ii] != msg.sender) {
                    emit supplyChanged(_admins[ii], 0);
                }
            }
        }
    }

    function getPaymentHistory()
        public view
        returns (History[] memory)
    {
        return paymentHistory;
    }

    function checkForAdmin(address _user) public view returns (bool) {
        bool admin = false;
        for (uint256 i = 0; i < administrators.length; )
         {
            if (administrators[i] == _user) {
                admin = true;
            }
            unchecked { i++;}
        }
        return admin;
    }

    function balanceOf(address _user) public view returns (uint256) {
        return balances[_user];
    }

    function getTradingMode() public pure returns (bool mode_) {
        bool mode = false;
        if (tradeFlag == 1 || dividendFlag == 1) {
            mode = true;
        } else {
            mode = false;
        }
        return mode;
    }

    function addHistory(address _updateAddress, bool _tradeMode)
        public
        returns (bool status_, bool tradeMode_)
    {
        History memory history;
        history.blockNumber = block.number;
        history.lastUpdate = block.timestamp;
        history.updatedBy = _updateAddress;
        paymentHistory.push(history);
        bool[] memory status = new bool[](tradePercent);
        for (uint256 i = 0; i < tradePercent;) {
            status[i] = true;
             unchecked { i++;}
        }
        return ((status[0] == true), _tradeMode);
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory )
    {
        if(
            _user == address(0)
        ) revert InvalidPaymentID();

        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool) {
        if(
            balances[msg.sender] < _amount
        ) revert InvalidPaymentAmount();
        if(
            bytes(_name).length >= 8
        ) revert InvalidPaymentName();
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        Payment memory payment;
        payment.admin = address(0);
        payment.adminUpdated = false;
        payment.paymentType = PaymentType.BasicPayment;
        payment.recipient = _recipient;
        payment.amount = _amount;
        payment.recipientName = _name;
        payment.paymentID = ++paymentCounter;
        payments[msg.sender].push(payment);
        bool[] memory status = new bool[](tradePercent);
        for (uint256 i = 0; i < tradePercent; i++) {
            status[i] = true;
        }
        return (status[0] == true);
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyAdminOrOwner {
        if(
            _ID <= 0
        ) revert InvalidPaymentID();
        if(
           !( _amount > 0)
        ) revert InvalidPaymentAmount();
        if(
            _user == address(0)
        ) revert Unauthorized();

        for (uint256 i = 0; i < payments[_user].length;) {
            if (payments[_user][i].paymentID == _ID) {
                payments[_user][i].adminUpdated = true;
                payments[_user][i].admin = _user;
                payments[_user][i].paymentType = _type;
                payments[_user][i].amount = _amount;
                bool tradingMode = getTradingMode();
                addHistory(_user, tradingMode);
                emit PaymentUpdated(
                    msg.sender,
                    _ID,
                    _amount,
                    payments[_user][i].recipientName
                );
            }
            unchecked { i++;}
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
        onlyAdminOrOwner
    {
        if(
            _tier > 255
        ) revert InvalidPaymentAmount();
        if(
            _userAddrs == address(0)
        ) revert Unauthorized();

        whitelist[_userAddrs] = _tier;
        if (_tier > 3) {
            whitelist[_userAddrs] = 3;
        } else if (_tier == 1) {
            whitelist[_userAddrs] = 1;
        } else if (_tier > 0 && _tier < 3) {
            whitelist[_userAddrs] = 2;
        }

        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(address _recipient, uint256 _amount) public {
        if(
            balances[msg.sender] < _amount
        ) revert InvalidPaymentAmount();
        if(
            _amount <= 3 
        ) revert InvalidPaymentAmount();
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        balances[msg.sender] += whitelist[msg.sender];
        balances[_recipient] -= whitelist[msg.sender];
        emit WhiteListTransfer(_recipient);
    }
}
