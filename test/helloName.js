const HelloName = artifacts.require("HelloName");

contract("HelloName", () => {
	it("should return the passed string", async() => {
        const helloName = await HelloName.deployed();
        await helloName.setName("Javier");
        const result = await helloName.userName();
        assert(result === "Javier");
	})
})