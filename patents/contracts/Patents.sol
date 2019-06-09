pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

contract Patents {

    struct Patent{
        string title; //nao uso por enquanto
        string description;
    }

    Patent[] patents;
    mapping (address => uint[]) userPatents;
    mapping (address => uint[]) usedPatents;

    // adding a patent
    function declarePatent(string memory content, string memory title) public returns (string memory) {
        
        patents.push(Patent(title, content));
        uint idx = patents.length - 1;

        userPatents[msg.sender].push(idx);  

        return patents[userPatents[msg.sender].length - 1].title;
    }

    function listPatents() public view returns (string[] memory) {
        uint[] memory idx_patents = userPatents[msg.sender];

        string[] memory descriptions = new string[](idx_patents.length);

        for (uint i = 0; i < idx_patents.length; i++) {
            descriptions[i] = (patents[idx_patents[i]].description);
        }

        return descriptions;
    }

    function listAllPatents() public view returns (string[] memory) {
        string[] memory descriptions = new string[](patents.length);

        for (uint i = 0; i < patents.length; i++) {
            descriptions[i] = (patents[i].description);
        }

        return descriptions;
    }

    function listUsedPatents() public view returns (string[] memory) {
        uint[] memory idx_patents = usedPatents[msg.sender];

        string[] memory descriptions = new string[](idx_patents.length);

        for (uint i = 0; i < idx_patents.length; i++) {
            descriptions[i] = (patents[idx_patents[i]].description);
        }

        return descriptions;
    }

    function usePatents(uint index) public returns (bool) {
        usedPatents[msg.sender].push(index);
        return true;
    }
}