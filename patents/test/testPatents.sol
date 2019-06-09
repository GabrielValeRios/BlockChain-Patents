pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Patents.sol";


//allPatents
//declarePatents
//getOwnerPatents

contract testPatents {
    // The address of the patents contract to be tested
    Patents patents = Patents(DeployedAddresses.Patents());
    string str_patent = "this is a contract.";

    //The expected owner of adopted pet is this contract
    address cur_adr = address(this);

    function testdeclarePatent() public {
        string memory users = patents.declarePatent(str_patent);
        Assert.equal(users, str_patent, "Patents should match");
    }

    function testUsePatent() public {
        address a = patents.usePatent(str_patent);
        Assert.equal(a, cur_adr, "Addresses should match");
    }
}