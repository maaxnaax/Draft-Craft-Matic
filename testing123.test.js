const RandomNumbersConsumer = artifacts.require("RandomNumbersConsumer") 

contract('RandomNumbersConsumer', (accounts) => {
	const account1 = accounts[0]
	it("Chekcing that the keyHash is the expected number", async () => {
		const ssContract = await RandomNumbersConsumer.deployed()

		const keyHash = await ssContract.keyHash()
		// console.log(keyHash)
		// console.log('Console logging')
		assert.equal(keyHash, 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311, 'Account1 is the owner')
		
	})

	it("getRandomNumber provides a number between 1 and 20", async () => {
		const ssContract = await RandomNumbersConsumer.deployed()


		await ssContract.getRandomNumber().call() //.call({from:account1})
		const rr = ssContract.randomResult()
		console.log(rr)

		assert.ok(rr < 21, 'Random number is less than 21')
		assert.ok(rr > 0, 'Random number is greater than 0')
	})
	// Currently deployed at 0x8b064726F69790333228cF98460f39B899bcE958
})