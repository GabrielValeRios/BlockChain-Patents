pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Patents.sol";

contract testPatents {
    // The address of the patents contract to be tested
    Patents patents = Patents(DeployedAddresses.Patents());
    string str_patent_title = "this is a title.";
    string str_patent_description = "this is a description.";

    //The expected owner of adopted pet is this contract
    address cur_adr = address(this);

    function testdeclarePatent() public {
        string memory new_patent = patents.declarePatent(str_patent_description, str_patent_title);
        Assert.equal(new_patent, str_patent_title, "Patents should match");
    }

    // function testListPatentsByUser() public {
    //     Assert.equal(patents.listPatentsByUser()[0], (true, true), "Patents should match");
    // }

    // function testCheckOwnerExists() public {
    //     bool is_owner = patents._checkOwnerExists();
    //     Assert.equal(true, is_owner, "Patents should match");
    // }
}