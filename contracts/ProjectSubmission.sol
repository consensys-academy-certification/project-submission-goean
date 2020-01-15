pragma solidity ^0.5.0;

contract ProjectSubmission { // Step 1

    address payable public owner; // Step 1 (state variable)
    uint public ownerBalance; // Step 4 (state variable)
    modifier onlyOwner() { // Step 1
      require(msg.sender == owner, 'The sender is not the owner.');
      _;
    }

    struct University { // Step 1
        uint balance;
        bool available;
    }
    mapping (address => University) public univesities; // Step 1 (state variable)

    enum ProjectStatus {Waiting, Rejected, Approved, Disabled}
    struct Project { // Step 2
        address author;
        address university;
        ProjectStatus status;
        uint balance;
    }
    mapping (bytes32 => Project) public projects; // Step 2 (state variable)

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

    function submitProject(bytes32 _hashDoc, address _account)
      public
      payable
    { // Step 2 and 4
      require(msg.value >= 1 ether, 'Value is less than 1 eth.');
      require(univesities[_account].available == true, 'Uni is not yet registered.');
      projects[_hashDoc].author = msg.sender;
      projects[_hashDoc].university = _account;
      projects[_hashDoc].status = ProjectStatus.Waiting;
      uint preBalance = ownerBalance;
      ownerBalance = preBalance + msg.value;
      require(ownerBalance >= preBalance, 'Balance of owner incorrect (too low).');
    }

    function disableProject(bytes32 _hashDoc)
      public
      onlyOwner
    { // Step 3
      projects[_hashDoc].status = ProjectStatus.Disabled;
    }

    function reviewProject(bytes32 _hashDoc, ProjectStatus _status)
      public
      onlyOwner
    { // Step 3
      require(projects[_hashDoc].status == ProjectStatus.Waiting, 'Currently no action needed.');
      require(_status == ProjectStatus.Approved || _status == ProjectStatus.Rejected, 'Project already finalized.');
      projects[_hashDoc].status = _status;
    }

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