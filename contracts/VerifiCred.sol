//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract VerifiCred is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _orgId;
    Counters.Counter private _nftId;
    
    struct Organization {
        uint orgId;
        string assest;
        string name;
        address[] contributors;
    }

    mapping (address => Organization[]) public orgOwnerLookup;
    mapping (address => uint[]) public userNftLookUp;
    
    event NftTransfer(uint nftId);
    event userNft(uint[] nftIds);
    event MyOrganization(Organization[] organizations);

    constructor() ERC721("VeriCred", "VeriCred") {
        _nftId.increment();
        _orgId.increment();
    }

    function createOrganizations(string memory _name, string memory _assest) public{
        uint256 newItemId = _orgId.current();
        address[] memory contributors;

        Organization memory newOrg = Organization({
            orgId: newItemId,
            contributors: contributors,
            name: _name,
            assest: _assest
        });

        orgOwnerLookup[msg.sender].push(newOrg);

        _orgId.increment();
    }

    function createDegree(uint orgId, address contributorAddress, string memory svg) public {
        require(orgId < _orgId.current(), "Invalid organization id");
        
        uint index = 0;

        for (uint i = 0; i < orgOwnerLookup[msg.sender].length; i++) {
            if(orgOwnerLookup[msg.sender][i].orgId == orgId){
                index = i + 1;
            }
        }

        require(index == 0, "Organization does not exist");
        index = index - 1;

        for (uint i = 0; i < orgOwnerLookup[msg.sender][index].contributors.length; i++) {
            require(orgOwnerLookup[msg.sender][index].contributors[i] == contributorAddress, "Already given");
        }

        uint256 newItemId = _nftId.current();

        _safeMint(msg.sender, newItemId);
    
        _setTokenURI(newItemId, svg);

        _transfer(msg.sender, contributorAddress, newItemId);
        
        orgOwnerLookup[msg.sender][index].contributors.push(contributorAddress);
        userNftLookUp[msg.sender].push(newItemId);

        _nftId.increment();

        emit NftTransfer(newItemId);
    }

    function getMyNFTs() public{
        emit userNft(userNftLookUp[msg.sender]);
    }   

    function getMyOrganizations() public{
        emit MyOrganization(orgOwnerLookup[msg.sender]);
    }
}