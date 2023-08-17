// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract DegreeCerificate is ERC721URIStorage {
    struct MyRecord {
        string ipfsHash;
        bool isMinted;
    }

    MyRecord public myrecord;
    uint256 public maxMintAmount = 1; //Allows to mint only one token per account

    mapping(address => MyRecord) public IndividualRecords;
    uint256 public tokenIdCounter;

    //Contract Initialization
    constructor() ERC721("DegreeCerificateRecord", "DEGNFT") {}

    //uploading the DegreeCertificate to IPFS and obtain the hash
    function uploadRecord(string memory ipfsHash) external {
        require(bytes(ipfsHash).length > 0, "Provided IPFS-hash is not valid");
        myrecord = IndividualRecords[msg.sender];
        myrecord = MyRecord(ipfsHash, false);
    }

    //Digitalise the DegreeCertificate
    function mintLNFT(uint256 _mintAmount) external {
        require(_mintAmount <= maxMintAmount);
        myrecord = IndividualRecords[msg.sender];
        require(bytes(myrecord.ipfsHash).length > 0, "Record is not uploaded");
        require(!myrecord.isMinted, "NFT is already minted");
        _mint(msg.sender, tokenIdCounter);
        _setTokenURI(tokenIdCounter, myrecord.ipfsHash);
        myrecord.isMinted = true;
        tokenIdCounter++;
    }
}
