// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

 ______     ______     ______     ______     ______
/\  ___\   /\  __ \   /\  ___\   /\  __ \   /\  __ \
\ \ \____  \ \  __ \  \ \ \____  \ \  __ \  \ \ \/\ \
 \ \_____\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_____\
  \/_____/   \/_/\/_/   \/_____/   \/_/\/_/   \/_____/

 ______     __   __   ______     __         ______     __   __     ______     __  __     ______
/\  __ \   /\ \ / /  /\  __ \   /\ \       /\  __ \   /\ "-.\ \   /\  ___\   /\ \_\ \   /\  ___\
\ \  __ \  \ \ \'/   \ \  __ \  \ \ \____  \ \  __ \  \ \ \-.  \  \ \ \____  \ \  __ \  \ \  __\
 \ \_\ \_\  \ \__|    \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_\ \_\  \ \_____\
  \/_/\/_/   \/_/      \/_/\/_/   \/_____/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_/\/_/   \/_____/


import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721BurnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/draft-ERC721VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract CACAO_TREES is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, PausableUpgradeable, AccessControlUpgradeable, ERC721BurnableUpgradeable, EIP712Upgradeable, ERC721VotesUpgradeable, UUPSUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    CountersUpgradeable.Counter private _tokenIdCounter;
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC721_init("TREES", "TREE");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Pausable_init();
        __AccessControl_init();
        __ERC721Burnable_init();
        __EIP712_init("TREES", "1");
        __ERC721Votes_init();
        __UUPSUpgradeable_init();

        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(UPGRADER_ROLE, msg.sender);
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyRole(UPGRADER_ROLE)
        override
    {}

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721Upgradeable, ERC721VotesUpgradeable)
    {
        super._afterTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable, ERC721URIStorageUpgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}

