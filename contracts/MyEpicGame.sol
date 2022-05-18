pragma solidity ^0.8.0;

// erc721
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// helper functions OpenZeppelin provide
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";
import "./libraries/Base64.sol";

contract MyEpicGame is ERC721 {
    struct CharaterAttr {
        uint charaterIndex;
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }

    struct Boss {
        string name;
        string imageURI;
        uint hp;
        uint maxHp;
        uint attackDamage;
    }
    Boss public boss ;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharaterAttr[] CharaterAttrsDefault;

    // a maping token id to nft
    mapping(uint256 => CharaterAttr) public nftHolderAttrs;

    mapping(address => uint256) public nftHolders;

    constructor(
    string[] memory charaterNames,
    string[] memory charaterImageURIs,
    uint[] memory charaterHp,
    uint[] memory charaterAttackDamage,
        string memory bossName,
        string  memory bossImageURI,
        uint  bossHp,
        uint  bossAttackDamage
    ) ERC721("Heros","HERO"){
        for (uint i = 0; i < charaterNames.length; i += 1) {
            CharaterAttrsDefault.push(CharaterAttr({
            charaterIndex : i,
            name : charaterNames[i],
            hp:charaterHp[i],
            maxHp:charaterHp[i],
            imageURI : charaterImageURIs[i],
            attackDamage : charaterAttackDamage[i]
            }));
            CharaterAttr memory c = CharaterAttrsDefault[i];
            console.log("init role# %s atk:%s hp:%s",c.name,c.attackDamage,c.hp);
        }
        boss.name = bossName;
        boss.imageURI = bossImageURI;
        boss.hp = bossHp;
        boss.attackDamage = bossAttackDamage;

        _tokenIds.increment();

    }

    function mintCharaterNFT(uint _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        // assign nft id to  caller address
        _safeMint(msg.sender,newItemId);
        nftHolderAttrs[newItemId] = CharaterAttr({
        charaterIndex : _characterIndex,
        name : CharaterAttrsDefault[_characterIndex].name,
        hp:CharaterAttrsDefault[_characterIndex].hp,
        maxHp:CharaterAttrsDefault[_characterIndex].maxHp,
        imageURI : CharaterAttrsDefault[_characterIndex].imageURI,
        attackDamage : CharaterAttrsDefault[_characterIndex].attackDamage
        });
        console.log("sucess mint #%s %s",newItemId,CharaterAttrsDefault[_characterIndex].name);
        nftHolders[msg.sender] = newItemId;
        _tokenIds.increment();
        emit mintedCharaterNFT(msg.sender,newItemId,nftHolderAttrs[newItemId].charaterIndex);
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory){
        CharaterAttr memory charAttr = nftHolderAttrs[_tokenId];

        string memory strHp = Strings.toString(charAttr.hp);
        string memory strMaxHp = Strings.toString(charAttr.maxHp);
        string memory strAttackDamage = Strings.toString(charAttr.attackDamage);

        string memory json = Base64.encode(abi.encodePacked('{"name": "',
            charAttr.name,
            ' -- NFT #: ',
            Strings.toString(_tokenId),
            '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
            charAttr.imageURI,
            '", "attributes": [ { "trait_type": "Health Points", "value": ',strHp,', "max_value":',strMaxHp,'}, { "trait_type": "Attack Damage", "value": ',
            strAttackDamage,'} ]}'));
        string  memory output =string(abi.encodePacked("data:application/json;base64,",json));
        return output;

    }

    function attackBoss() public {
        //get state of the player's NFT
        CharaterAttr storage nft = nftHolderAttrs[nftHolders[msg.sender]];
        //make sure the player has more than 0 HP
        assert(nft.hp>0);
        //make sure the boss has more than 0 HP
        assert(boss.hp>0);
        //atk each other
        if(nft.hp > boss.attackDamage){
        nft.hp = nft.hp - boss.attackDamage;
        }
        else {
            nft.hp = 0 ;
        }
        if (boss.hp > nft.attackDamage){
        boss.hp = boss.hp - nft.attackDamage;
        }
        else {
            boss.hp = 0;
        }
        return ;
        emit attackCompelete(msg.sender,boss.hp,nft.hp);
    }

    function has_nft(uint256 _tokenId) public returns (CharaterAttr memory){
        if (nftHolders[msg.sender] ==0){
            CharaterAttr memory null_charater;
            return null_charater;
        }
    return nftHolderAttrs[nftHolders[msg.sender]];
    }

    function get_charaters() public returns (CharaterAttr[] memory){
        return CharaterAttrsDefault;
    }

    function get_boss() public returns (Boss memory){
        return boss;
    }

    event mintedCharaterNFT(address sender,uint256 tokenId,uint charaterId);
    event attackCompelete(address sender,uint256 newBossHp,uint newPlayerHp);
}