pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;
import './Data.sol';

contract Patents {

    Data data = new Data();

    // check if owner already exists
    function _checkOwnerExists() public view returns(bool){
        if (data.getExists(msg.sender)) return true;
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
    
    // withdraw from contract to account "owner"
    function _deposit(address payable owner) public payable{
        owner.transfer(msg.value);
    }

    // get all patents avaiable
    function allPatents() public returns(string[] memory) {
        return data.getAllPatents();
    }

    // adding a patent
    function declarePatent(string memory patent) public returns (string memory) {
        // transforms string patent into bytecode
        bytes memory patentBytes = _toBytes(patent);

        // add patent and change owner exists to true
        uint num_patents = data.getPatents_len(msg.sender);
        data.setPatents(num_patents, patentBytes, msg.sender);
        data.setPatents_len(msg.sender);
        data.setPatent_owner_map(msg.sender, patentBytes);

        data.setOwnersAddresses(msg.sender);
        data.setOwnersAddresses_len();

        return string(data.getPatents(msg.sender, data.getPatents_len(msg.sender))[0]);
    }
    
    // attach user to patent and pay the owner
    function usePatent(string memory patent) public payable returns (address){
        bytes memory patentBytes = _toBytes(patent);
        address ownerAddress = data.getPatent_owner_map(patentBytes);

        data.setPatentUsers(ownerAddress, patentBytes);
        data.setUsers_len(ownerAddress, patentBytes);
        data.setNum_users(ownerAddress, patentBytes);

        address payable ownerAddress_payable = address(uint160(ownerAddress)); // payable address
        _deposit(ownerAddress_payable); // deposit to smartContract

        return data.getUsers(ownerAddress)[0];
    }

    // given a patent from an user, get who is using it
    function getOwnerPatentClients(string memory patent) public returns (address){
        bytes memory patentBytes = _toBytes(patent);
        return data.getPatentUsers(patentBytes)[0];
    }

    // get patents related to owner adr
    function getOwnerPatents() public returns (string memory){
        uint patents_len = data.getPatents_len(msg.sender);
        bytes[] memory patentsBytes = data.getPatents(msg.sender, patents_len);

        string[] memory patents = new string[](data.getPatents_len(msg.sender));

        for(uint i = 0; i < patents_len; i++){
            string memory stringPatent = _toString(patentsBytes[i]);
            patents[i] = stringPatent;
        }
        return patents[0];
    }

}