// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interfaces/IERC721.sol";
import "../interfaces/IERCMetadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC721 is IERC721, IERC721Metadata {
    //todo add library
    string public name;
    string public symbol;
    mapping(address => uint) _balances;
    mapping(uint => address) _owners;
    mapping(uint => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) _operatorApprovals;

    modifier _requireMinted(uint tokenID) {
        require(_exists(tokenID), "not minted");
        _;
    }

    constructor(string _name, string _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function TransferFrom(address from, address to, uint tokenID) external {
        require(_IsApprove(msg.sender, tokenID), "not approve");

        _transfer(from, to, tokenID);
    }

    function ownerOf(uint tokenID) public view _requireMinted(tokenID) returns (address) {
        return _owners[tokenID];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function getApproved(uint tokenID) external view _requireMinted(tokenID) returns (address) {
        return _tokenApprovals[tokenID];
    }

    function _baseURI() internal pure virtual returns (string memory) {
        return ""; //todo make better
    }

    function tokenURI(
        uint tokenID
    ) public view virtual _requireMinted(tokenID) returns (string memory) {
        string memory baseURI = _baseURI();
        return
            bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenID.toString())) : "";
    }

    function balanceOf(address owner) public view returns (uint) {
        required(owner != address(0), "zero address");
        return _balances[owner];
    }

    function _IsApprove(address spender, uint tokenID) internal view returns (bool) {
        address owner = ownerOf(tokenID);
        require(
            getApproved(tokenID) == spender || isApprovedForAll(owner, spender),
            "now approved"
        );
        return true;
    }

    function approve(address to, uint tokenID) public {
        address _owner = ownerOf(tokenID);
        require(isApprovedForAll(_owner, msg.sender), "permission denied");
        require(to != _owner, "cant approve to self");
        _tokenApprovals[tokenID] = to;

        emit Approval(_owner, to, tokenID);
    }

    function _safeMint(address to, uint tokenID) internal virtual {
        _mint(to, tokenID);
    }

    function burn(uint tokenID) public virtual _requireMinted(tokenID) {
        require(_isApprove, "permission denied");
        address _owner = ownerOf(tokenID);

        delete _tokenApprovals[tokenID];
        _balances[owner]--;
        delete _owners[tokenID];
    }

    function _mint(address to, uint tokenID) internal virtual {
        require(to != address(0), "zero address");
        require(!_exists(tokenID), "already exists");
        _owners[tokenID] = to;
        _balances[to]++;
    }

    function _exists(uint tokenID) internal view returns (bool) {
        return _owners[tokenID] != address(0);
    }

    function _transfer(address from, address to, uint tokenID) internal {
        require(ownerOf(tokenID) == from, "not an owner");
        require(to != address(0));

        _beforeTokenTransfer(from, to, tokenID);
        _balances[from]--;
        _balances[to]++;
        _owners[tokenID] = to;

        _afterTokenTransfer(from, to, tokenID);

        emit Transfer(from, to, tokenID);
    }

    function _beforeTokenTransfer(from, to, tokenID) internal virtual {}

    function _afterTokenTransfer(from, to, tokenID) internal virtual {}
}
