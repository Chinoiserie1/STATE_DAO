const Token = artifacts.require('./DT');

require('chai')
    .use(require('chai-as-promised'))
    .should()

const tokens = (n) => {
    return web3.utils.toBN(
        web3.utils.toWei(n.toString(), 'ether')
    );
}

contract('Token', ([deployer, receiver, exchange]) => {
    const name = "DAO Token";
    const symbol = "DT";
    const decimals = "18";
    const totalSupply = tokens(1000000).toString();
    let token;

    beforeEach(async () => {
        token = await Token.new();
    })
    describe('deployment', () => {
        it('tracks the name', async () => {
            const result = await token.name();
            result.should.equal(name);
        })
        it('tract the symbole', async () => {
            const result = await token.symbol();
            result.should.equal(symbol);
        })
        it('tract the decimal', async () => {
            const result = await token.decimals();
            result.toString().should.equal(decimals);
        })
        // it('tract the total sypply', async () => {
        //     const result = await token.totalSupply()
        //     result.toString().should.equal(totalSupply.toString());
        // })
    })
    describe('sending token', () => {
        let result;
        let amount;
        describe('success', () => {
            beforeEach(async () => {
                amount = tokens(100)
                result = await token.transfer(receiver, amount, { from: deployer });
            })
            it('transfer token balances', async () => {
                let balance = await token.balanceOf(deployer);
                balance = await token.balanceOf(deployer);
                balance.toString().should.equal(tokens(999900).toString());
                balance = await token.balanceOf(receiver);
                balance.toString().should.equal(tokens(100).toString());
            })
            it('emit a Transfer event', () => {
                const log = result.logs[0];
                log.event.should.equal('Transfer');
                const res = log.args;
                res._from.should.equal(deployer, 'deployer is correct');
                res._to.should.equal(receiver, 'receiver is correct');
                res._value.toString().should.equal(amount.toString(), 'value is correct');
            })
        })
        describe('failure', () => {
            beforeEach(async () => {
                amount = tokens(100)
            })
            it('reject insufisiance found', async () => {
                let invalideAmount = tokens(100000000);
                await token.transfer(receiver, invalideAmount, { from: deployer }).should.be.rejectedWith('VM Exception while processing transaction: revert');
                invalideAmount = tokens(10);
                await token.transfer(deployer, invalideAmount, { from: receiver }).should.be.rejectedWith('VM Exception while processing transaction: revert');
            })
            it('reject invalid recipient', async () => {
                await token.transfer(0x0, amount, { from: deployer }).should.be.rejectedWith('invalid address');
            })
        })
    })
    describe('approving token', async () => {
        let result;
        let amount;
        beforeEach(async () => {
            amount = tokens(100);
            result = await token.approve(exchange, amount, { from: deployer });
        }) 
        describe('success', () => {
            it('allocates an allowance for delegated token spending', async () => {
                const allowance = await token.allowance(deployer, exchange);
                allowance.toString().should.equal(amount.toString());
            })
            it('emit a Approval event', () => {
                const log = result.logs[0];
                log.event.should.equal('Approval');
                const res = log.args;
                res._owner.should.equal(deployer, 'deployer is correct');
                res._spender.should.equal(exchange, 'spender is correct');
                res._value.toString().should.equal(amount.toString(), 'value is correct');
            })
        })
        describe('failure', () => {
            it('rejected invalid address', async () => {
                await token.approve(0x0, amount, { from: deployer}).should.be.rejectedWith('invalid address');
            })
        })
    })
    describe('delegated token transfers', () => {
        let result;
        let amount;
        beforeEach(async () => {
            amount = tokens(100)
            result = await token.approve(exchange, tokens(150), { from: deployer });
        })
        describe('success', () => {
            beforeEach(async () => {
                result = await token.transferFrom(deployer, receiver, amount, { from: exchange });
            })
            it('transfer token balances', async () => {
                let balance = await token.balanceOf(deployer);
                balance = await token.balanceOf(deployer);
                balance.toString().should.equal(tokens(999900).toString());
                balance = await token.balanceOf(receiver);
                balance.toString().should.equal(tokens(100).toString());
            })
            it('reset the allowance', async () => {
                const allowance = await token.allowance(deployer, exchange);
                allowance.toString().should.equal(tokens(50).toString());
            })
            it('emit a Transfer event', () => {
                const log = result.logs[0];
                log.event.should.equal('Transfer');
                const res = log.args;
                res._from.should.equal(deployer, 'deployer is correct');
                res._to.should.equal(receiver, 'receiver is correct');
                res._value.toString().should.equal(amount.toString(), 'value is correct');
            })
            it('emit a Approval event', () => {
                const log = result.logs[1];
                log.event.should.equal('Approval');
                const res = log.args;
                res._owner.should.equal(deployer, 'deployer is correct');
                res._spender.should.equal(exchange, 'spender is correct');
                res._value.toString().should.equal(tokens(50).toString(), 'value is correct');
            })
        })
        describe('failure', () => {
            beforeEach(async () => {
                amount = tokens(100)
            })
            it('reject insufisiance found', async () => {
                let invalideAmount = tokens(100000000);
                await token.transferFrom(deployer, receiver, invalideAmount, { from: exchange }).should.be.rejectedWith('VM Exception while processing transaction: revert');
                invalideAmount = tokens(10);
                await token.transferFrom(receiver, deployer, invalideAmount, { from: exchange }).should.be.rejectedWith('VM Exception while processing transaction: revert');
            })
            it('reject invalid recipient', async () => {
                await token.transferFrom(deployer, 0x0, amount, { from: exchange }).should.be.rejectedWith('invalid address');
            })
        })
    })
})