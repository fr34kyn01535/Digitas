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

contract SteamAccountDictionary is Owned {
    event AddedSteamAccount(string steamID64, address walletAddress);
    event RemovingSteamAccount(string steamID64, address walletAddress);
    
    mapping(string => address) Addresses;
    
    function Add(string _steamID64, address _walletAddress) public onlyOwner 
    {
        Addresses[_steamID64] = _walletAddress;
        AddedSteamAccount(_steamID64,_walletAddress);
    }
    
    function Remove(string _steamID64) public onlyOwner {
        RemovingSteamAccount(_steamID64,Addresses[_steamID64]);
        delete Addresses[_steamID64];
    }
    
    function Get(string _steamID64) public view returns (address)          
    {
        return Addresses[_steamID64];
    }
}