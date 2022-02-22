pragma solidity ^0.6.0;

contract PayrollSplit{
    
    address[] employees = [];//To do: enter employee addresses
    uint totalReceived = 0;
    mapping (address => uint) withdrawnAmounts;

    constructor()public payable{ 
        updateTotalReceived();
    }

    function updateTotalReceived() internal{
        totalReceived += msg.value;
    }
    
    modifier canWithdraw() {
        bool contains = False;
        for (uint i = 0, i< employees.length; i++){
            if (employees[i] == msg.sender){
                contains = True;
            }
        }
        require (contains);
        _;
    }

    function withdraw() canWithdraw{
        uint amountAllocated = totalReceived/employees.length;
        uint amountWithdrawn  = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;

        if (amount > 0) {
            msg.sender.transfer(amount);
        }
    }
}
