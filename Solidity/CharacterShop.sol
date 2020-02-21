pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

contract NarutoShop {
    
    event BuyCharacter(address buyer, Character character); // Event
    event CreateCharacter(address adder, Character character); // Event
    
    struct Character {
        uint256 id;
        string name;
        uint256 price;
        CharacterStatus characterStatus;
        address seller;
        address buyer;
    }
    
    enum CharacterStatus {Available,Purchased,Unavailable}
    
    mapping (address => Character) public userCharacters;
    
    // character storage
    mapping(uint256 => Character) characters;
    uint256[] characterList;
    
    constructor() public {
        characterCounter = 0;
        createCharacter("Naruto",2.0);
        createCharacter("Sasuke",3.0);
        createCharacter("Sakura",4.0);
        createCharacter("Hinata",1.0);
    }

    uint256 characterCounter;
    function getCharacterId() private returns(uint) { return ++characterCounter; }
    
    function createCharacter (string memory _name,uint256 _price) public returns(bool success) {
        uint256 characterId = getCharacterId();
        Character memory character = characters[characterId];
        character.id = characterId;
        character.name = _name;
        character.price = _price;
        character.characterStatus = NarutoShop.CharacterStatus.Available;
        character.seller = msg.sender;
        characters[characterId] = character;
        
        characterList.push(characterId);
        emit CreateCharacter(msg.sender, character);
        return true;
    }
    
    function getAllCharacterList() public view returns(uint256[] memory _characters){
        return characterList;
    }
    
    function getCharacterById(uint256 _id) public view returns(Character memory character){
        return characters[_id];
    }
    
    function buyCharacter (address _address,uint256 _characterId) public returns(bool success){
        Character memory c = getCharacterById(_characterId);
        c.buyer = _address;
        c.characterStatus = NarutoShop.CharacterStatus.Purchased;
        characters[_characterId] = c;
        emit BuyCharacter(_address,c);
        return true;
    }
    
}
