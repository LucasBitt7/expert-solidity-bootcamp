	// SPDX-License-Identifier: MIT
	pragma solidity ^0.8.4;
	import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

	contract DogCoinGame is ERC20 {
		
        uint public currentPrize;
        uint256 public numberPlayers;
        address payable [] public players;
        address payable [] public winners;

        event startPayout();

       constructor() ERC20("DogCoin", "DOG") payable{

       }

         function addPlayer () payable public {
             require(msg.value == 1 ether);
             players.push(msg.sender);
             numberPlayers++;
             if(numberPlayers == 200 ) {
                 payout();
                emit startPayout();
             }
         } 

        function addWinner(address payable _winner) internal {
            winners.push(_winner);
        }

        function payout() internal {
            if(address(this).balance == 200 ether) {
                uint amountToPay = winners.length / 100;
                payWinners(amountToPay);
            }
        }

        function payWinners(uint amountToPay) internal {
            for (uint i = 0;i <= winners.length; i++ ){
                (bool sent,) =  winners[i].call{value: amountToPay}("");
                require(sent, "Failed to send Ether");
            }

        }

	}
