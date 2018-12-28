pragma solidity ^0.4.18;

import "./MintableToken.sol";


contract UNTToken is MintableToken{

    string public constant name = "untx";
    string public constant symbol = "UNTX";
    uint32 public constant decimals = 8;
    mapping(address => uint256) public lockamount;
    address[] lockaddress;
    bool private isFreezed = false;

    function UNTToken() public {
        totalSupply = 2000000000E3;
        balances[msg.sender] = totalSupply; // Add all tokens to issuer balance (crowdsale in this case)
    }


    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(isFreezed == false);
        if(msg.sender == owner)
        {
            if(hasAddress(_to) == true)
            {
               lockamount[_to]+= _value;
            }
            else
            {
               lockaddress.push(_to);
               lockamount[_to] = _value;
            }

        }
        else if(hasAddress(msg.sender) == true)
        {

             require(balanceOf(msg.sender)-lockamount[msg.sender]>=_value);

        }


        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function lockToken(address target, uint256 amount) public
    {   require(owner == msg.sender);
        if(hasAddress(target) == false)
        {
            if(balanceOf(target)>=amount)
            {
              lockaddress.push(target);
              lockamount[target] = amount;
            }

        }
        else
        {
          if(balanceOf(target)-lockamount[target]>= amount)
          {

              lockamount[target] += amount;

          }

        }

    }

    function unlockToken(address target, uint256 amount) public
    {
        require(owner == msg.sender);
        if(hasAddress(target) == false)
        {

        }
        else
        {
          if(lockamount[target]>= amount)
          {

            lockamount[target]=lockamount[target]-amount;

          }

        }


    }

    function hasAddress(address target) private returns(bool)
    {

          for(uint i = 0; i< lockaddress.length; i++)
          {
              if(lockaddress[i] == target)
              {
                return true;
              }

          }
          return false;

    }

    function freezeToken() public
    {
       require(owner == msg.sender);
       isFreezed = true;
    }

    function unfreezeToken() public
    {
       require(owner == msg.sender);
       isFreezed = false;

    }




}
