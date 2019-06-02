pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Patents {

    struct patentOwner{
        bytes[] patents;
        mapping (bytes => address[]) patentUsers;
        bool exists;
        // backup
        uint balance;
    }
    mapping (address => patentOwner) patentsOwner; // hashmap to keep addr->ownerInfo
    mapping (bytes => address) patent_owner_map; // hashmap to keep patent->ownerAddr
    address[] ownersAddresses; // keep track of patentOwners for map access

    // check if owner already exists
    function _checkOwnerExists() public view returns(bool){
        if (patentsOwner[msg.sender].exists) return true;
        return false;
    }

    // transform string patent to bytes patent
    function _toBytes(string memory patent) public pure returns (bytes memory){
        return bytes(patent);
    }

    // transform bytes patents to string
    function _toString(bytes memory patent) public pure returns (string memory){
        return string(patent);
    }

    // deposit to contract
    function _deposit(uint256 amount) public payable {
        require(
            msg.value == amount,
            "Ether value doesn't match amount given"
            );
    }
    
    // withdraw from contract to account "owner"
    function _withdraw(uint256 amount, address payable owner) public payable{
        require(
            address(this).balance >= amount,
            "SmartContract doesn't have this amount of ether"
        );
        owner.transfer(amount);
    }

    // get all patents avaiable
    function getAllPatents() public view returns(string[] memory) {
        string[] memory patents;
        uint counter = 0;
        for (uint i = 0; i < ownersAddresses.length; i ++){
            patentOwner storage ownerInfo = patentsOwner[ownersAddresses[i]];
            bytes[] memory owner_patents = ownerInfo.patents;
            for (uint j = 0; j < owner_patents.length; j ++){
                string memory stringPatent = _toString(owner_patents[j]);
                patents[counter] = stringPatent;
                counter += 1;
            }
        }

        return patents;
    }

    // adding a patent
    function declarePatent(string memory patent) public returns (string memory) {
        // transforms string patent into bytecode
        bytes memory patentBytes = _toBytes(patent);
        // add patent and change owner exists to true
        patentOwner storage ownerInfo = patentsOwner[msg.sender]; //storage keeps mapping, memory keeps arrays
        ownerInfo.patents.push(patentBytes); // add patent to owner's address
        ownersAddresses.push(msg.sender); // add ownerAddr to list of patentOwners
        patent_owner_map[patentBytes] = msg.sender; // attach patent to ownerAddr

        if (!_checkOwnerExists()){
            ownerInfo.exists = true;
            // backup
            ownerInfo.balance = 0;
        }

        return string(patentBytes);
    }
    
    // attach user to patent and pay the owner
    function usePatent(string memory patent, uint price) public payable {
        bytes memory patentBytes = _toBytes(patent);
        address ownerAddress = patent_owner_map[patentBytes];
        patentOwner storage ownerInfo = patentsOwner[ownerAddress];
        ownerInfo.patentUsers[patentBytes].push(msg.sender);

        _deposit(price); // deposit to smartContract
        address payable ownerAddress_payable = address(uint160(ownerAddress)); // payable address
        _withdraw(price, ownerAddress_payable); // give ether to owner

        // backup
        ownerInfo.balance += price;
        patentOwner storage userInfo = patentsOwner[msg.sender];
        userInfo.balance -= price;
    }

    // given a patent from an user, get who is using it
    function getOwnerPatentClients(string memory patent) public view returns (address[] memory){
        patentOwner storage ownerInfo = patentsOwner[msg.sender];
        bytes memory patentBytes = _toBytes(patent);
        return ownerInfo.patentUsers[patentBytes];
    }

    // get patents related to owner adr
    function getOwnerPatents() public view returns (bytes[] memory){
        patentOwner storage ownerInfo = patentsOwner[msg.sender];
        return ownerInfo.patents;
    }

}