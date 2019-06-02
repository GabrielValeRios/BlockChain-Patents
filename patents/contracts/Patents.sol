pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Patents {

    struct patentOwner{
        mapping (address => bytes[]) ownerPatents;
        mapping (bytes => address[]) patentUsers;
        uint balance;
        bool exists;
    }
    mapping (address => patentOwner) patentsOwner; // hashmap to keep addr->ownerInfo

    // check if owner already exists
    function checkOwnerExists() public view returns(bool){
        if (patentsOwner[msg.sender].exists) return true;
        return false;
    }

    //transform string patent to bytes patent
    function toBytes(string memory patent) public pure returns (bytes memory){
        return bytes(patent);
    }

    // given a patent from an user, get who is using it
    function getOwnerPatentClients(bytes memory patent) public view returns (address[] memory){
        patentOwner storage ownerInfo = patentsOwner[msg.sender];
        return ownerInfo.patentUsers[patent];
    }

    // get patents related to owner adr
    function getOwnerPatents() public view returns (bytes[] memory){
        patentOwner storage ownerInfo = patentsOwner[msg.sender];
        return ownerInfo.ownerPatents[msg.sender];
    }
    
    // adding a patent
    function declarePatent(string memory patent) public returns (string memory) {
        // transforms string patent into bytecode
        bytes memory patentBytes = toBytes(patent);
        // add patent and change owner exists to true
        patentOwner storage ownerInfo = patentsOwner[msg.sender]; //storage keeps mapping, memory keeps arrays
        ownerInfo.ownerPatents[msg.sender].push(patentBytes); // add patent to owner's address

        if (ownerInfo.exists == false){
            ownerInfo.exists = true;
            ownerInfo.balance = 0;
        }

        return string(patentBytes);
    }

    // pay patentOwner for patent use
    function payOwner(address owner, uint price) public payable {
        // msg.value is how much ether was sent
        require(
            msg.value == price,
            "Price not authorized."
        );
        require(
            msg.value <= patentsOwner[msg.sender].balance,
            "Ether quantity not authorized."
        );
        patentsOwner[msg.sender].balance -= price;
        patentsOwner[owner].balance += price;
    }
}