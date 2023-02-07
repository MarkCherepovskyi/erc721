// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC721.sol";
import "./ERC721Enumerable.sol";
import "./ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;
    mapping(address => bool) private owners;

    Counters.Counter private _tokenIdCounter;

    modifier onlyOwner() {
        require(owners[msg.sender], "permission denied");
        _;
    }

    constructor() ERC721("MyToken", "MTK") {
        owners[msg.sender] = true;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function safeMint(address to, string memory uri) public onlyOwner returns (uint256) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        return tokenId;
    }

    function transferToken(address from, address to, uint tokenId) external onlyOwner {
        transferFrom(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override onlyOwner {
        _transfer(from, to, tokenId);
    }

    function _safeMint(address to, uint256 tokenId, bytes memory data) internal override(ERC721) {
        _mint(to, tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setNewAdmin(address admin) external override onlyOwner {
        owners[admin] = true;
        _admins[admin] = true;
    }

    function deleteAdmin(address admin) external override onlyOwner {
        delete owners[admin];
        delete _admins[admin];
    }

    function burn(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal override onlyOwner {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");

        unchecked {
            // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
            // `from`'s balance is the number of token held, which is at least one before the current
            // transfer.
            // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
            // all 2**256 token ids to be minted, which in practice is impossible.
            _balances[from] -= 1;
            _balances[to] += 1;
        }
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }
}
