pragma solidity ^0.5.8;

contract DriverRegister{
 
  //data structure for Driver's details
    struct Driver{
        string name;
        string phno;
        string licenceno;
        address driverAddress;
        uint createdAt;
        uint updatedAt;
    }

//map driver's wallet address to driver id
mapping (address => uint) public driversIds;

//Array to hold Driver list and Driver's Details
Driver[] public drivers;

// event fired when a Driver is registered
    event newDriverRegistered(uint id);

// event fired when the Driver updates his Contact Number or LicenceNumber or Name
    event driverUpdateEvent(uint id);

// Modifier: check if the caller of the smart contract is registered
    modifier checkSenderIsRegistered {
    	require(isRegistered());
    	_;
    }    

/**
     * Constructor function
     */
    constructor() public
    {
        // NOTE: the first user MUST be emtpy: if you are trying to access to an element
        // of the usersIds mapping that does not exist (like usersIds[0x12345]) you will
        // receive 0, that's why in the first position (with index 0) must be initialized
        addDriver(address(0x0), "","","");

        // Some dummy data
        addDriver(address(0x333333333333), "Sita Devi","111","DL1001");
        addDriver(address(0x111111111111), "Begaum Razia","222","DL0987");
        addDriver(address(0x222222222222), "Mary Smith","333","DL8755");
    }


    /**
     * Function to register a new user.
     *
     * @param _driverName 		The displaying name of the Driver
     * @param _phno             The Contact Number of the Driver
     * @param _licenceno        The Licence Number of the Driver
     */
    function registerDriver(string memory _driverName, string memory _phno, string memory _licenceno) public
    returns(uint)
    {
    	return addDriver(msg.sender, _driverName, _phno, _licenceno);
    }


    /**
     * Add a new user. This function must be private because an user
     * cannot insert another user on behalf of someone else.
     *
     * @param _wAddr		Address wallet of the Driver
     * @param _driverName		Displaying name of the Driver
     * @param _phno             Contcat Number of the Driver
     * @param _licenceno        Licence Number of the Driver
     */
    function addDriver(address _wAddr, string memory  _driverName, string memory _phno, string memory _licenceno) private
    returns(uint)
    {
        // checking if the driver is already registered
        uint driverId = driversIds[_wAddr];
        require (driverId == 0);

        // associating the driver wallet address with the new ID
        driversIds[_wAddr] = drivers.length;
        uint newDriverId = drivers.length++;

        // storing the new user details
        drivers[newDriverId] = Driver({
        	name: _driverName,
        	phno: _phno,
            licenceno: _licenceno,
        	driverAddress: _wAddr,
        	createdAt: now,
        	updatedAt: now
        });

        // emitting the event that a new driver has been registered
        emit newDriverRegistered(newDriverId);

        return newDriverId;
    }


    /**
     * Update the user profile of the caller of this method.
     * Note: the user can modify only his own profile.
     *
     * @param _newDriverName	The new driver's displaying name
     * @param _newPhno 	The new Contact Number 
     * @param _newLicenceno The new Licence Number
     */
    function updateDriver(string memory _newDriverName, string memory _newPhno, string memory _newLicenceno) checkSenderIsRegistered public
    returns(uint)
    {
    	// A driver can modify only his own profile.
    	uint driverId = driversIds[msg.sender];

    	Driver storage driver = drivers[driverId];

    	driver.name = _newDriverName;
    	driver.phno = _newPhno;
        driver.licenceno = _newLicenceno;
    	driver.updatedAt = now;

    	emit driverUpdateEvent(driverId);

    	return driverId;
    }


    /**
     * Get the user's profile information.
     *
     * @param _id 	The ID of the driver stored on the blockchain.
     */
    function getDriverById(uint _id) public view
    returns(
    	uint,
    	string memory,
        string memory,
        string memory,
    	address,
    	uint,
    	uint
    ) {
    	// checking if the ID is valid
    	require( (_id > 0) || (_id <= drivers.length) );

    	Driver memory i = drivers[_id];

    	return (
    		_id,
    		i.name,
    		i.phno,
            i.licenceno,
    		i.driverAddress,
    		i.createdAt,
    		i.updatedAt
    	);
    }


    /**
     * Return the profile information of the caller.
     */
    function getOwnProfile() checkSenderIsRegistered public view
    returns(
    	uint,
    	string memory,
    	string memory,
        string memory,
    	address,
    	uint,
    	uint
    ) {
    	uint id = driversIds[msg.sender];

    	return getDriverById(id);
    }


    /**
     * Check if the user that is calling the smart contract is registered.
     */
    function isRegistered() public view returns (bool)
    {
    	return (driversIds[msg.sender] > 0);
    }

	
    /**
     * Return the number of total registered users.
     */
    function totalDrivers() public view returns (uint)
    {
        // NOTE: the total registered user is length-1 because the user with
        // index 0 is empty check the contructor: addUser(address(0x0), "", "");
        return drivers.length - 1;
    }

}    



