pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Patents {

    struct patentOwner{
        bytes[] patents;
        mapping (bytes => address[]) patentUsers;
        bool exists;
    }
    mapping (address => patentOwner) patentsOwner; // hashmap to keep addr->ownerInfo
    address[] public ownersAddress; // to make function to get info from owner through addrs

    // ownersAddress's getter
    function ownersArrayGetter() public view returns (address[] memory){
        return ownersAddress;
    }

    // check if owner already exists
    function checkOwnerExists(address adr) public view returns(bool){
        if (patentsOwner[adr].exists) return true;
        return false;
    }

    //transform string patent to bytes patent
    function toBytes(string memory patent) public pure returns (bytes memory){
        return bytes(patent);
    }

    // adding a patent
    function declarePatent(address adr, string memory patent) public returns (string memory) {
        // transforms string patent into bytecode
        bytes memory patentBytes = toBytes(patent);
        // add patent and change owner exists to true
        patentOwner storage ownerInfo = patentsOwner[adr]; //storage keeps mapping, memory keeps arrays
        ownerInfo.patents.push(patentBytes);
        ownerInfo.exists = true;
        // push owner address to array
        ownersAddress.push(adr);

        return string(patentBytes);
    }

    // given a patent from an user, get who is using it
    function getOwnerPatentClients(address adr, bytes memory patent) public view returns (address[] memory){
        patentOwner storage ownerInfo = patentsOwner[adr];
        return ownerInfo.patentUsers[patent];
    }

    function getOwnerPatents(address adr) public view returns (bytes[] memory){
        patentOwner storage ownerInfo = patentsOwner[adr];
        return ownerInfo.patents;
    }
}
