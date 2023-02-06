// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC721 {
    event Transfer(address indexed from, addres indexed to, uint indexed tokenID);
    event Approval(address indexed owner, address indexed approved, uint indexed tokenID);
    event ApprovalFromAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint);

    function ownerOf(uint tokenId) external view returns (address);

    function safeTransferFrom(address from, address to, uint tokenID) external;

    function transferFrom(address from, address to, uint tokenID) external;

    function approve(address to, uint tokenID) external;

    function setApprovalForAll(address operator, bool approved) external;

    function getApproved(uint tokenID) external view returns (address);

    function isApprovalForAll(address owner, address operator) public view;

    function isApproved(address owner, address operator) external view returns (bool);
}
