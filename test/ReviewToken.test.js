const {expectEvent} = require('@openzeppelin/test-helpers');

const ReviewToken = artifacts.require('ReviewToken');

contract ('ReviewToken', function(accounts) {
    const [ReviewerOne, ReviewerTwo] = accounts;

    beforeEach(async function () {
        this.token = await ReviewToken.deployed();
    });

    it('should transfer RTK to the reviewer', async function() {
        expectEvent(await this.token.safeMint(ReviewerOne, '10000'), 'Transfer')
    });
});