// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import "./KassTestBase.sol";

contract KassSetupTest is KassTestBase {

    function test_UpdateL2KassAddress() public {
        _kassBridge.setL2KassAddress(0xdead);
        assertEq(_kassBridge.l2KassAddress(), 0xdead);
    }

    function test_CannotUpdateL2KassAddressIfNotOwner() public {
        vm.prank(address(0x42));
        vm.expectRevert("Ownable: caller is not the owner");
        _kassBridge.setL2KassAddress(0xdead);
    }
}