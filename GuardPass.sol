// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Agent ID Guard Pass
/// @notice Free, soulbound ERC721 pass for Agent ID holders (1 per Agent ID).
///         Minter must hold an Agent ID (balanceOf > 0 on the Agent ID registry).
///         Value 0, gas only. Non-transferable. Open-source, verified on BscScan.
/// @dev Registry address is immutable and set at deploy time so the same code
///      can be tested on testnet (against a mock registry) and deployed on
///      mainnet (against the real registry 0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F).
interface IAgentIDRegistry {
    function balanceOf(address owner) external view returns (uint256);
}

contract GuardPass is ERC721, Ownable {
    IAgentIDRegistry public immutable agentIdRegistry;

    uint256 public constant MAX_SUPPLY = 10_000;
    uint256 public totalMinted;
    uint256 private _nextTokenId = 1;

    mapping(address => bool) public hasMinted;
    string private _baseTokenURI;

    error NoAgentID();
    error AlreadyMinted();
    error MaxSupplyReached();
    error Soulbound();

    event GuardPassMinted(address indexed minter, uint256 indexed tokenId);

    constructor(address registry_, string memory baseURI_) ERC721("Agent ID Guard Pass", "GUARD") Ownable(msg.sender) {
        require(registry_ != address(0), "registry zero");
        agentIdRegistry = IAgentIDRegistry(registry_);
        _baseTokenURI = baseURI_;
    }

    /// @notice Free mint (value 0). One pass per wallet, only for Agent ID holders.
    function mint() external {
        if (agentIdRegistry.balanceOf(msg.sender) == 0) revert NoAgentID();
        if (hasMinted[msg.sender]) revert AlreadyMinted();
        if (totalMinted >= MAX_SUPPLY) revert MaxSupplyReached();

        hasMinted[msg.sender] = true;
        totalMinted += 1;
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        emit GuardPassMinted(msg.sender, tokenId);
    }

    /// @notice Soulbound: transfers are blocked. Mint (from == 0) and burn (to == 0) allowed.
    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        address from = _ownerOf(tokenId);
        if (from != address(0) && to != address(0)) revert Soulbound();
        return super._update(to, tokenId, auth);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata baseURI_) external onlyOwner {
        _baseTokenURI = baseURI_;
    }
}
