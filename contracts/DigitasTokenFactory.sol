import "./DigitasToken.sol";

pragma solidity ^0.4.18;

contract DigitasTokenFactory {

    mapping(address => address[]) public created;
    mapping(address => bool) public isDigitasToken;
    bytes public DigitasTokenByteCode;

    function DigitasTokenFactory() public {
        address verifiedToken = createDigitasToken(10000, "Verify Token", 3, "VTX");
        DigitasTokenByteCode = codeAt(verifiedToken);
    }

    function verifyDigitasToken(address _tokenContract) public view returns (bool) {
        bytes memory fetchedTokenByteCode = codeAt(_tokenContract);
        if (fetchedTokenByteCode.length != DigitasTokenByteCode.length) {
            return false; 
        }
        for (uint i = 0; i < fetchedTokenByteCode.length; i++) {
            if (fetchedTokenByteCode[i] != DigitasTokenByteCode[i]) {
                return false;
            }
            return true;
        }
    }
    
    function createDigitasToken(uint256 _initialAmount, string _name, uint8 _decimals, string _symbol) public returns (address) {
        DigitasToken newToken = (new DigitasToken(_initialAmount, _name, _decimals, _symbol));
        created[msg.sender].push(address(newToken));
        isDigitasToken[address(newToken)] = true;
        newToken.transfer(msg.sender, _initialAmount); 
        return address(newToken);
    }

    function codeAt(address _addr) internal view returns (bytes outputCode) {
        assembly { // solhint-disable-line no-inline-assembly   
            // retrieve the size of the code, this needs assembly
            let size := extcodesize(_addr)
            // allocate output byte array - this could also be done without assembly
            // by using outputCode = new bytes(size)
            outputCode := mload(0x40)
            // new "memory end" including padding
            mstore(0x40, add(outputCode, and(add(add(size, 0x20), 0x1f), not(0x1f))))
            // store length in memory
            mstore(outputCode, size)
            // actually retrieve the code, this needs assembly
            extcodecopy(_addr, add(outputCode, 0x20), 0, size)
        }
    }
}