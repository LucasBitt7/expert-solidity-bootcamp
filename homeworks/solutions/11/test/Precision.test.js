const { expect } = require('chai');
const { BN, expectRevert, constants } = require('@openzeppelin/test-helpers'); // https://docs.openzeppelin.com/test-helpers/0.5/api
const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Precision = artifacts.require('./Precision')

// helper function converting ether to wei
const ether = (n) => {
	return new web3.utils.BN(
	  web3.utils.toWei(n.toString(), 'ether')
	)
}

/**
 * Exercise: make the tests pass by modifying the smart contract's code. You don't need to change any of the test's code.
 * 
  */

contract('NinfaMarketplace', ( [deployer, buyer, seller] ) => {

    beforeEach(async () => {
        /**
         * (1) Deploy NFT and Marketplace
         */
        vulnerableContract = await deployProxy(Precision, []);
    })

    it('checks token balance', async () => {
        await vulnerableContract.buyTokens( { value: ether(0.5), from: buyer } ) // if the amount to buy is less than 1 eth then the result of msg.value/weiPerEth will be 0.
        let balance = await vulnerableContract.balances(buyer)
        expect(balance).to.be.bignumber.equal(new BN(5))
    })

    it('checks ETH balance', async () => {

        await vulnerableContract.buyTokens( { value: ether(1), from: seller } ) // I buy 10 tokens

        let oldBalance = await web3.eth.getBalance('0x0000000000000000000000000000000dEAdbEEf0') // 0 eth


        await vulnerableContract.sellTokens( 5, { from: seller } ) // if the amount to buy is less than 10 tokens then final result will be 0.
          expect( await web3.eth.getBalance('0x0000000000000000000000000000000dEAdbEEf0') ).to.be.bignumber.equal( oldBalance + ether(0.5) )
    })

    it('should allow minting by owner only', async () => {

         
        await expectRevert(
            vulnerableContract.initialize({ from: seller }),
            'Initializable: contract is already initialized'
        );

        await expectRevert(
            vulnerableContract.mintTokens(seller, 10000, { from: seller }),
            'Ownable: caller is not the owner'
        );

    })


})
