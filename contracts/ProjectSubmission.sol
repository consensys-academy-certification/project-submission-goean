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
    mapping (address => University) public universities; // Step 1 (state variable)

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
      universities[_account].available = true;
    }

    function disableUniversity(address _account)
      public
      onlyOwner
    { // Step 1
      universities[_account].available = false;
    }

    function submitProject(bytes32 _hashDoc, address _account)
      public
      payable
    { // Step 2 and 4
      require(msg.value >= 1 ether, 'Value is less than 1 eth.');
      require(universities[_account].available == true, 'Uni is not yet registered.');
      projects[_hashDoc].author = msg.sender;
      projects[_hashDoc].university = _account;
      projects[_hashDoc].status = ProjectStatus.Waiting;
      uint preBalance = ownerBalance;
      ownerBalance += msg.value;
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

    function donate(bytes32 _hashDoc)
      public
      payable
    { // Step 4
      require(msg.value >= 0, 'Value zero can not be donated.');
      require(projects[_hashDoc].status == ProjectStatus.Approved,'Project not yet approved.');
      uint oBalance = ownerBalance;
      uint projBalance = projects[_hashDoc].balance;
      uint uniBalance = universities[projects[_hashDoc].university].balance;
      ownerBalance += (msg.value / 100) * 10;
      projects[_hashDoc].balance += (msg.value / 100) * 70;
      universities[projects[_hashDoc].university].balance += (msg.value / 100) * 20;
      require(ownerBalance >= oBalance, 'Calculation of owner balance failed.');
      require(projects[_hashDoc].balance >= projBalance, 'Calculation of project balance failed.');
      require(universities[projects[_hashDoc].university].balance >= uniBalance, "Calculation of uni balance failed.");
    }

    function withdraw()
      public
      payable
    { // Step 5
      if (msg.sender == owner) {
        uint oBalance = ownerBalance;
        require(oBalance >= 0, 'No value to transfer available.');
        ownerBalance = 0;
        owner.transfer(oBalance);
      }
      else {
        uint relBalance = universities[msg.sender].balance;
        require(relBalance >= 0, 'No value to transfer available.');
        universities[msg.sender].balance = 0;
        msg.sender.transfer(relBalance);
      }
    }

    function withdraw(bytes32 _hashDoc)
      public
      payable
    {  // Step 5 (Overloading Function)
      require(projects[_hashDoc].author == msg.sender, 'Only the author is allowed to withdraw.');
      uint projBalance = projects[_hashDoc].balance;
      require(projBalance >= 0, 'No money to withdraw');
      projects[_hashDoc].balance = 0;
      msg.sender.transfer(projBalance);
    }
}