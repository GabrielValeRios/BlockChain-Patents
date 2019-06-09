pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Data {

    struct users{
        uint users_len;
        bool exists;
        mapping (uint => address) users;
    }

    struct addresses{
        mapping (uint => address) ownersAddresses; // keep track of patentOwners for map access
        uint ownersAddresses_len;
        bool exists;
    }

    struct patentOwner{
        mapping (uint => bytes) patents;
        uint patents_len;
        mapping (bytes => users) patentUsers;
        mapping (bytes => uint) num_users;
        mapping (bytes => bool) num_users_exists;
        bool exists;
        // backup
        uint balance;
    }

    addresses Addresses;

    mapping (address => patentOwner) patentsOwner; // hashmap to keep addr->ownerInfo
    mapping (bytes => address) patent_owner_map; // hashmap to keep patent->ownerAddr

    function setPatentUsers(address owner, bytes memory patent) public {
        uint users_len = getUsers_len(owner, patent);
        patentsOwner[owner].patentUsers[patent].users[users_len] = msg.sender;
    }

    function setPatents(uint index, bytes memory patent, address owner) public {
        patentsOwner[owner].patents[index] = patent;
    }

    function setNum_users(address owner, bytes memory patent) public {

        if (!patentsOwner[owner].num_users_exists[patent]) {
            patentsOwner[owner].num_users_exists[patent] = true;
            patentsOwner[owner].num_users[patent] = 1;
        }
        else{
            patentsOwner[owner].num_users[patent] += 1;
        }
    }

    function setOwnersAddresses(address adr) public {
        uint idx = getOwnersAddresses_len();
        Addresses.ownersAddresses[idx] = adr;
    }

    function setPatents_len(address adr) public{
        if (!patentsOwner[adr].exists) {
            patentsOwner[adr].exists = true;
            patentsOwner[adr].patents_len = 1;
        }
        else{
            patentsOwner[adr].patents_len += 1;
        }
    }

    function setUsers_len(address adr, bytes memory patent) public {

        if (!patentsOwner[adr].patentUsers[patent].exists) {
            patentsOwner[adr].patentUsers[patent].exists = true;
            patentsOwner[adr].patentUsers[patent].users_len = 1;
        }
        else{
            patentsOwner[adr].patentUsers[patent].users_len += 1;
        }
    }
    
    function setOwnersAddresses_len() public {

        if (!Addresses.exists) {
            Addresses.exists = true;
            Addresses.ownersAddresses_len = 0;
            Addresses.ownersAddresses_len += 1;
        }
        else{
            Addresses.ownersAddresses_len += 1;
        }
    }

    function setPatent_owner_map(address adr, bytes memory patent) public {
        patent_owner_map[patent] = adr;
    }

    function getOwnersAddresses_len() public returns(uint) {

        if (!Addresses.exists) {
            Addresses.exists = true;
            Addresses.ownersAddresses_len = 0;
            return Addresses.ownersAddresses_len;
        }
        else{
            return Addresses.ownersAddresses_len;
        }
    }

    function getAllPatents() public returns (string[] memory){

        uint count = 0;
        for (uint i = 0; i < getOwnersAddresses_len(); i++){
            uint p_len = patentsOwner[Addresses.ownersAddresses[i]].patents_len;
            count += p_len;
        }

        string[] memory patents_s = new string[](count);
        
        for (uint i = 0; i < getOwnersAddresses_len(); i++){
            uint p_len = patentsOwner[Addresses.ownersAddresses[i]].patents_len;
            for (uint j = 0; j < p_len; j++){
                string memory stringPatent = string(patentsOwner[Addresses.ownersAddresses[i]].patents[j]);
                patents_s[j] = stringPatent;
            }
        }

        return patents_s;

    }

    function getUsers_len(address adr, bytes memory patent) public returns(uint) {

        if (!patentsOwner[adr].patentUsers[patent].exists) {
            patentsOwner[adr].patentUsers[patent].exists = true;
            patentsOwner[adr].patentUsers[patent].users_len = 0;
            return patentsOwner[adr].patentUsers[patent].users_len;
        }
        else{
            return patentsOwner[adr].patentUsers[patent].users_len;
        }
    }

    function getPatents_len(address adr) public returns(uint) {

        if (!patentsOwner[adr].exists) {
            patentsOwner[adr].exists = true;
            patentsOwner[adr].patents_len = 0;
            return patentsOwner[adr].patents_len;
        }
        else{
            return patentsOwner[adr].patents_len;
        }
    }

    function getPatent_owner_map(bytes memory patent) public view returns(address) {
        return patent_owner_map[patent];
    }

    function getOwnersAddresses() public returns(address[] memory) {
        address[] memory adrs;

        for (uint i = 0; i < getOwnersAddresses_len(); i++){
            adrs[i] = Addresses.ownersAddresses[i];
        }

        return adrs;
    }

    function getPatents(address adr, uint patents_len) public view returns(bytes[] memory) {
        bytes[] memory patents_array = new bytes[](patents_len);

        for (uint i = 0; i < patents_len; i++){
            patents_array[i] = patentsOwner[adr].patents[i];
        }

        return patents_array;
    }

    function getUsers(address adr) public returns(address[] memory) {
        
        uint counter = 0;
        for(uint i = 0; i < getPatents_len(adr); i++){
            bytes memory p = patentsOwner[adr].patents[i];
            uint users_quantity = patentsOwner[adr].num_users[p];
            counter += users_quantity;
        }

        address[] memory patents_array = new address[](counter);

        for(uint k = 0; k < getPatents_len(adr); k++){
            bytes memory p = patentsOwner[adr].patents[k];
            uint users_quantity = patentsOwner[adr].num_users[p];
            users storage adr_users = patentsOwner[adr].patentUsers[p];
            for (uint l = 0; l < users_quantity; l++){
                patents_array[l] = adr_users.users[l];
            }
        }

        return patents_array;
    }

    function getPatentUsers(bytes memory patent) public returns(address[] memory) {

        address[] memory p_users = new address[](getUsers_len(msg.sender, patent));
        for(uint i = 0; i < getUsers_len(msg.sender, patent); i++){
            address usr = patentsOwner[msg.sender].patentUsers[patent].users[i];
            p_users[i] = usr;
        }
        return p_users;
    }

    function getExists(address adr) public view returns(bool) {
        bool exists = patentsOwner[adr].exists;
        return exists;
    }

    function getBalance(address adr) public view returns(uint) {
        uint balance = patentsOwner[adr].balance;
        return balance;
    }
}