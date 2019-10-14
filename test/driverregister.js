var DriverRegister = artifacts.require('./DriverRegister.sol');

contract('DriverRegister', function(accounts) {
    var mainAccount = accounts[0];

    it("Should register a Driver", function() {
        var driversBeforeRegister = null;

    return DriverRegister.deployed().then(function(contractInstance) {
        // storing the contract instance so it will be used later on
        instance = contractInstance;

        // calling the smart contract function totalDrivers to get the current number of drivers
        return instance.totalDrivers.call();
    }).then(function(result) {
        // storing the current number on the var driversBeforeRegister
        driversBeforeRegister = result.toNumber();

        // registering the user calling the smart contract function registerUser
        return instance.registerDriver('Test Driver Name','Test Contact Number','Test Licence Number', {
            from: mainAccount
        });
    }).then(function(result) {
        return instance.totalDrivers.call();
    }).then(function(result) {
        // checking if the total number of driver is increased by 1
        assert.equal(result.toNumber(), (driversBeforeRegister+1), "number of drivers must be (" + driversBeforeRegister + " + 1)");

        // calling the smart contract function isRegistered to know if the sender is registered.
        return instance.isRegistered.call();
    }).then(function(result) {
        // we are expecting a boolean in return that it should be TRUE
        assert.isTrue(result);
    });
}); // end of "should register a driver"
  
// Testing the data of the driver profile stored in the blockchain match with the data
    // gave during the registration.
    it("Driver Name, Contact Number and Licence Number in the blockchian should be the same as the one given when registred", function() {
        // NOTE: the contract instance has been instantiated before, so no need
        // to do again: return DriverRegister.deployed().then(function(contractInstance) { ...
        // like before in "should register an user".
        return instance.getOwnProfile.call().then(function(result) {
            // the result is an array where in the position 0 there driver ID, in
            // the position 1 the driver name and in the position 2 the phno, position 3 licenceno
            assert.equal(result[1], 'Test Driver Name');
            assert.equal(result[2],'Test Contact Number');
            assert.equal(result[3],'Test Licence Number');
        });
    }); // end testing driver name, phno and licenceno


// Testing the update profile function: first update the driver's profile name, contact and licencenumber then
    // checking that the profile has been updated correctly.
    it("Should update the Driver Details", function() {
        return instance.updateDriver('Updated Driver Name','Updated Contact Number', 'Updated Licence Number', {
            from: mainAccount
        }).then(function(result) {
            return instance.getOwnProfile.call();
        }).then(function(result) {
            // the result is an array where in the position 0 there user ID, in
            // the position 1 the user name and in the position 2 the status,
            assert.equal(result[1],'Updated Driver Name');
            assert.equal(result[2],'Updated Contact Number');
            assert.equal(result[3],'Updated Licence Number');         
        });
    }); // end should update the profile


    // Testing that a user cannot register itself twice.
    it("Should not be able register for the second time", function() {
        // we are expecting the call to registerUser to fail since the driver account
        // is already registered!
        return instance.registerDriver('Test Driver Name Twice','Test Contact Number Twice','Test Licence Number Twice', {
            from: mainAccount
        }).then(assert.fail).catch(function(error) { // here we are expecting the exception
            assert(true);
        });
    }); // end testing registration twice
});

