pragma solidity ^0.4.0;

contract Owned {
    address public owner;

    function Owned() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        if (msg.sender != owner) revert();
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner == 0x0) revert();
        owner = newOwner;
    }
}

contract SteamAccountDictionary is Owned{
    struct SteamAccount{
        string steamID64;
        address walletAddress;
    }
    
    event AddedSteamAccount(string steamID64, address walletAddress);
    event RemovingSteamAccount(string steamID64, address walletAddress);
    
    SteamAccount[] Dictionary;
    
    function Add(string _steamID64, address _walletAddress) public onlyOwner 
    {
        Dictionary.push(SteamAccount(_steamID64,_walletAddress));
        AddedSteamAccount(_steamID64,_walletAddress);
    }
    
    function Remove(uint _index) public onlyOwner {
        RemovingSteamAccount(Dictionary[_index].steamID64,Dictionary[_index].walletAddress);
        delete Dictionary[_index];
    }
    
    function Get(uint _index) public view returns (string)          
    {
        return Dictionary[_index].steamID64;
    }
    
    function GetWalletAddress(string _steamID64) public view returns (address)
    {
        uint dictionaryLength = Dictionary.length;
    
        for (uint i=0; i< dictionaryLength; i++)
        {
            if (keccak256(Dictionary[i].steamID64) == keccak256(_steamID64))
            {
                return Dictionary[i].walletAddress;
            }
        }
    }
    
    function GetSteamID64(string _walletAddress) public view returns (string)
    {
        uint dictionaryLength = Dictionary.length;
    
        for (uint i=0; i< dictionaryLength; i++)
        {
            if (keccak256(Dictionary[i].walletAddress) == keccak256(_walletAddress))
            {
                return Dictionary[i].steamID64;
            }
        }
    }
}