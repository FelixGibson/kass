// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import "../../src/ethereum/KassUtils.sol";
import "../../src/ethereum/ERC1155/KassERC1155.sol";
import "./KassTestBase.sol";

contract WithdrawTest is KassTestBase {
    KassERC1155 public _l1TokenInstance;

    function setUp() public override {
        super.setUp();

        // request and create L1 instance
        requestL1InstanceCreation(L2_TOKEN_ADDRESS, L2_TOKEN_URI);
        _l1TokenInstance = KassERC1155(_kassBridge.createL1Instance(L2_TOKEN_ADDRESS, L2_TOKEN_URI));
    }

    function test_WithdrawFromL2() public {
        address l1Recipient = address(uint160(uint256(keccak256("rando 1"))));
        uint256 tokenId = uint256(keccak256("token 1"));
        uint256 amount = uint256(keccak256("huge amount"));

        // deposit from L2
        depositFromL2(L2_TOKEN_ADDRESS, tokenId, amount, l1Recipient);

        // assert balance is empty
        assertEq(_l1TokenInstance.balanceOf(l1Recipient, tokenId), 0);

        // with deposited tokens
        withdrawFromL2(tokenId, amount, l1Recipient);

        // assert balance was updated
        assertEq(_l1TokenInstance.balanceOf(l1Recipient, tokenId), amount);
    }

    function test_WithdrawFromL2_2() public {
        address l1Recipient = address(uint160(uint256(keccak256("rando 2"))));
        uint256 tokenId = 0x2;
        uint256 amount = 0x3;

        // deposit from L2
        depositFromL2(L2_TOKEN_ADDRESS, tokenId, amount, l1Recipient);

        // assert balance is empty
        assertEq(_l1TokenInstance.balanceOf(l1Recipient, tokenId), 0);

        // with deposited tokens
        withdrawFromL2(tokenId, amount, l1Recipient);

        // assert balance was updated
        assertEq(_l1TokenInstance.balanceOf(l1Recipient, tokenId), amount);
    }

    function test_WithdrawFromL2_3() public {
        address l1Recipient = address(uint160(uint256(keccak256("rando 3"))));
        uint256 tokenId = 0x2 << UINT256_PART_SIZE_BITS;
        uint256 amount = 0x3 << UINT256_PART_SIZE_BITS;

        // deposit from L2
        depositFromL2(L2_TOKEN_ADDRESS, tokenId, amount, l1Recipient);

        // assert balance is empty
        assertEq(_l1TokenInstance.balanceOf(l1Recipient, tokenId), 0);

        // with deposited tokens
        withdrawFromL2(tokenId, amount, l1Recipient);

        // assert balance was updated
        assertEq(_l1TokenInstance.balanceOf(l1Recipient, tokenId), amount);
    }

    function test_CannotWithdrawFromL2WithDifferentTokenIdFromL2Request() public {
        address l1Recipient = address(uint160(uint256(keccak256("rando 1"))));
        uint256 tokenId = uint256(keccak256("token 1"));
        uint256 amount = 0x10;

        // deposit from L2
        depositFromL2(L2_TOKEN_ADDRESS, tokenId, amount, l1Recipient);

        vm.expectRevert();
        withdrawFromL2(tokenId - 1, amount, l1Recipient);
    }

    function test_CannotWithdrawFromL2WithDifferentAmountFromL2Request() public {
        address l1Recipient = address(uint160(uint256(keccak256("rando 1"))));
        uint256 tokenId = uint256(keccak256("token 1"));
        uint256 amount = 0x10;

        // deposit from L2
        depositFromL2(L2_TOKEN_ADDRESS, tokenId, amount, l1Recipient);

        vm.expectRevert();
        withdrawFromL2(tokenId, amount + 1, l1Recipient);
    }

    function test_CannotWithdrawFromL2WithDifferentL1RecipientFromL2Request() public {
        address l1Recipient = address(uint160(uint256(keccak256("rando 1"))));
        address fakeL1Recipient = address(uint160(uint256(keccak256("rando 2"))));
        uint256 tokenId = uint256(keccak256("token 1"));
        uint256 amount = 0x10;

        // deposit from L2
        depositFromL2(L2_TOKEN_ADDRESS, tokenId, amount, l1Recipient);

        vm.expectRevert();
        withdrawFromL2(tokenId, amount, fakeL1Recipient);
    }
}
