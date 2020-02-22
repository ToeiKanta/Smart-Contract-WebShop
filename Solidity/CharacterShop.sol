pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

contract CharacterShop {
    
    event BuyCharacter(address buyer, uint256 characterId); // Event
    event CreateCharacter(address creater, uint256 characterId); // Event
    event ErrorCharacterNotAvailable(address buyer, uint256 characterId); // Event
    event ErrorNotEnoughMoney(address buyer, uint256 characterId); // Event
    
    struct Character {
        uint256 id;
        string name;
        uint256 price;
        CharacterStatus characterStatus;
        address seller;
        address buyer;
        string imgPath;
    }
    
    enum CharacterStatus {Available,Purchased,Unavailable}
    // presonal character have been purchase
    mapping (address => uint256[]) private userCharacters;
    // character storage
    mapping(uint256 => Character) characters;
    uint256[] characterList;
    
    constructor() public {
        characterCounter = 0;
        createCharacter("Sasuke",2.0,"Sasuke.png");
        createCharacter("Sakura",3.0,"Sakura.jpg");
        createCharacter("Hidan",4.0,"Hidan.jpg");
        createCharacter("Hinata",1.0,"Hinata.jpg");
    }

    uint256 characterCounter;
    function getCharacterId() private returns(uint) { return ++characterCounter; }
    
    function isEmpty(string memory _str) pure private returns(bool _isEmpty){
        bytes memory tempEmptyStringTest = bytes(_str); // Uses memory
        if (tempEmptyStringTest.length == 0) {
            return true;
        } else {
            return false;
        }
    }
    
    function createCharacter (string memory _name,uint256 _price,string memory _imgPath) public returns(bool success) {
        require(!isEmpty(_name),"Name must not empty.");
        uint256 characterId = getCharacterId();
        Character memory character = characters[characterId];
        character.id = characterId;
        character.name = _name;
        character.price = _price;
        character.characterStatus = CharacterShop.CharacterStatus.Available;
        character.seller = msg.sender;
        character.imgPath = _imgPath;
        characters[characterId] = character;
        
        characterList.push(characterId);
        emit CreateCharacter(msg.sender, character.id);
        return true;
    }
    
    function getAllCharacterList() public view returns(uint256[] memory _characters){
        return characterList;
    }
    
    function getCharacterById(uint256 _id) public view returns(Character memory character){
        return characters[_id];
    }
    
    function getMyCharacter() public view returns(uint256[] memory character){
        return userCharacters[msg.sender];
    }
    
    function buyCharacter (uint256 _characterId) public payable returns(bool success){
        Character memory c = getCharacterById(_characterId);
        require(c.characterStatus == CharacterStatus.Available,"Character not available for sale.");
        require(msg.value >= c.price,"Not enough money.");
        // if(c.characterStatus != CharacterStatus.Available){
        //     emit ErrorCharacterNotAvailable(msg.sender,_characterId);
        //     return false;
        // }
        // if(msg.value <= c.price){
        //     emit ErrorNotEnoughMoney(msg.sender,_characterId);
        //     return false;
        // }
        
        c.buyer = msg.sender;
        c.characterStatus = CharacterShop.CharacterStatus.Purchased;
        characters[_characterId] = c;
        userCharacters[msg.sender].push(c.id);
        msg.sender.transfer(msg.value);
        emit BuyCharacter(msg.sender,c.id);
        return true;
    }
    
}
