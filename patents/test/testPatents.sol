pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Patents.sol";

contract testPatents {
    // The address of the patents contract to be tested
    Patents patents = Patents(DeployedAddresses.Patents());
    string str_patent = "this is a contract.";

    //The expected owner of adopted pet is this contract
    address cur_adr = address(this);

    function testdeclarePatent() public {
        string memory new_patent = patents.declarePatent(cur_adr, str_patent);
        Assert.equal(new_patent, str_patent, "Patents should match");
    }

    function testCheckOwnerExists() public {
        bool is_owner = patents.checkOwnerExists(cur_adr);
        Assert.equal(true, is_owner, "Patents should match");
    }
}