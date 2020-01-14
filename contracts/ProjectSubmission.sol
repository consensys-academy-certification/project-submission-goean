pragma solidity ^0.5.0;

contract ProjectSubmission { // Step 1

    address payable public owner; // Step 1 (state variable)
    // ...ownerBalance... // Step 4 (state variable)
    modifier onlyOwner() { // Step 1
      require(msg.sender == owner, 'The sender is not the owner');
      _;
    }

    struct University { // Step 1
        uint balance;
        bool available;
    }
    mapping (address => University) public univesities; // Step 1 (state variable)

    // enum ProjectStatus { ... } // Step 2
    // struct Project { // Step 2
    //     ...author...
    //     ...university...
    //     ...status...
    //     ...balance...
    // }
    // ...projects... // Step 2 (state variable)

    constructor () public {
      owner = msg.sender;
    }

    function registerUniversity(address _account)
      public
      onlyOwner
    { // Step 1
      univesities[_account].available = true;
    }

    function disableUniversity(address _account)
      public
      onlyOwner
    { // Step 1
      univesities[_account].available = false;
    }

    // function submitProject... { // Step 2 and 4
    //   ...
    // }

    // function disableProject... { // Step 3
    //   ...
    // }

    // function reviewProject... { // Step 3
    //   ...
    // }

    // function donate... { // Step 4
    //   ...
    // }

    // function withdraw... { // Step 5
    //   ...
    // }

    // function withdraw... {  // Step 5 (Overloading Function)
    //   ...
    // }
}