// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Insurance{

    address[] public policyholders;
  
    mapping(address=>uint)  policies;
    mapping (address=> uint)  claims;

 
    address payable owner;
    uint public totalpremium;
    
    string  message= "Cogratulations! You have purchased a policy";

    constructor() {
       owner= payable(msg.sender);
    }

    receive  ()external payable  {
        uint premium=msg.value;
        require(msg.sender !=owner,"You are the owner");
        require(5 ether==premium,"Pls give premimum amount");
        require(premium>0,"Amount must be greater than 0");
        policyholders.push(msg.sender);
        policies[msg.sender] +=premium;
        totalpremium +=premium;
       
    }


    function claim(uint amount) public payable {
         require(policies[msg.sender]>0,"Must have a policy");
         require(10 wei== amount,"claim amount must be given");
         require(amount<=policies[msg.sender],"Policy amount is greater than your insurance balance");
         claims[msg.sender] +=amount;
    }
    
    function approveclaim(address payable policyholder) public {
      require(msg.sender==owner,"Only the owner can access");
      require(claims[policyholder]>0,"Claim amount has not given");
      policyholder.transfer(policies[policyholder]);
      
    }
        
    
    function getpolicy(address policyholder) public view returns (uint){

      return policies[policyholder];
    }

    function  transferownership(address newowner)public {

       require(owner==msg.sender,"You can not change");
       owner= payable (newowner);

    }

    function balance() public view returns (uint){
         return address(this).balance;
    }

    
    function destroy() public {
        require(owner==msg.sender,"You can not change");
        selfdestruct(owner);
    }

    
    

}