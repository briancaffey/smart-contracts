
/*
This is a sample contract available on the Ethereum Foundation website: https://ethereum.org/token
*/


contract owned {
  address public owner;

  function owned() {
    owner = msg.sender;
  }

  modifier onlyOwner {
  if (msg.sender != owner) throw;
  _;
  }

  function transferOwnership(address newOwner) onlyOwner {
    owner = newOwner;
  }
}

contract MyToken is owned {

  event Transfer(address indexed from, address indexed to, uint256 value);
  event FrozenFunds(address target, bool frozen);

  //create a new array with all balances
  mapping (address => uint256) public balanceOf;
  mapping (address => bool) public frozenAccount;

  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;
  uint256 public sellPrice;
  uint256 public buyPrice;

  function MyToken(
    uint256 initialSupply,
    string tokenName,
    uint8 decimalUnits,
    string tokenSymbol,
    address centralMinter
  ) {
    totalSupply = initialSupply;
    if(centralMinter != 0) owner = centralMinter;
    balanceOf[msg.sender] = initialSupply;
    name = tokenName;
    symbol = tokenSymbol;
    decimals = decimalUnits;
  }

  function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
    sellPrice = newSellPrice;
    buyPrice = newBuyPrice;
  }

  function freezeAccount(address target, bool freeze) onlyOwner {
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
  }

  function mintToken(address target, uint256 mintedAmount) onlyOwner {
    balanceOf[target] += mintedAmount;
    totalSupply += mintedAmount;
    Transfer(0, owner, mintedAmount);
    Transfer(owner, target, mintedAmount);
  }

  function transfer(address _to, uint256 _value) {
    if (frozenAccount[msg.sender])
      throw;
    if (balanceOf[msg.sender] < _value || balanceOf[_to] + _value < balanceOf[_to])
      throw;

    //add and subtract new balances
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    Transfer(msg.sender, _to, _value);
  }
}
