// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract ERC721URIStorage is ERC721 {
    mapping(uint => string) _tokenURIs;

    function tokenURI(uint tokenID) public view virtual override _requireMinted(tokenID) {
        string memory _tokenURI = _tokenURIs[tokenID];
        string memory _base = _baseURI();
        if (bytes(_base).length == 0) {
            return _tokenURI;
        }
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(_base, _tokenURI));
        }

        return super.tokenURI(tokenID);
    }

    function _setTokenURI(
        uint tokenID,
        string memory _tokenURI
    ) internal virtual _requireMinted(tokenID) {
        _tokenURIs[tokenID] = _tokenURI;
    }

    function burn(uint tokenID) public o _requireMinted(tokenID) {
        super.burn(tokenID);

        if (bytes(_tokenURIs[tokenID]).length != 0) {
            delete _tokenURIs[tokenID];
        }
    }
}
