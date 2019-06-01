pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Patents.sol";

contract TestPatents {
    // The address of the patent contract to be tested
    Patents patents = Patents(DeployedAddresses.Patents());

    // Patent
    string expectedPatent = "Eu sou uma patente";
    bytes expectedPatentBytes = bytes(expectedPatent);

    //The expected owner of patent owner is this contract
    address expectedAdr = address(this);

    // Testing patent declaration function
    function testUserCanDeclarePatent() public {
        string memory returnedPatent = patents.declarePatent(expectedAdr,expectedPatent);

        Assert.equal(returnedPatent, expectedPatent, "ReturnedPatent and expectedPatent should be equal.");
    }

}
