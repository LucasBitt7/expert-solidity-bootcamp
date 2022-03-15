// SPDX-License-Identifier: MIT
pragma solidity^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Foundation.sol";

///Ensure that your master contract is not self-destructed as it will cause all clones to stop working, thus freezing their state and balances
contract FoundationFactory is Ownable {
    address public templateAddress;
    mapping(address => address[]) public allClones;

    event TemplateCreated(address newTemplate);
    function createClone(address target) internal returns (address result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
      mstore(add(clone, 0x14), targetBytes)
      mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
      result := create(0, clone, 0x37)
    }
    require(result != address(0), "Failed to create clone");
  }

  function isClone(address target, address query) internal view returns (bool result) {
    bytes20 targetBytes = bytes20(target);
    assembly {
      let clone := mload(0x40)
      mstore(clone, 0x363d3d373d3d3d363d7300000000000000000000000000000000000000000000)
      mstore(add(clone, 0xa), targetBytes)
      mstore(add(clone, 0x1e), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

      let other := add(clone, 0x40)
      extcodecopy(query, other, 0, 0x2d)
      result := and(
        eq(mload(clone), mload(other)),
        eq(mload(add(clone, 0xd)), mload(add(other, 0xd)))
      )
    }
  }

    function foundationFactory(address _templateAddress) public {
        templateAddress = _templateAddress;
    }

  function createFoundation(string memory _name, string memory _description) public onlyOwner {
    address clone = createClone(templateAddress);
    allClones[msg.sender].push(clone);
    Foundation(clone).init(_name, _description);
    emit TemplateCreated(clone);
    }

   function getInstances() external view returns (address[] memory) {
    return allClones[msg.sender];
    }


}