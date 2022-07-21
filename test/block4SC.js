const Block4SC = artifacts.require("Block4SC");

contract("Block4SC", () => {
    it("should create 3 stocks", async() => {
        const block4SC = await Block4SC.deployed();
        //await block4SC.A_test1CreateStock();
        await block4SC.createStock("Secadoras_A", 200);
        await block4SC.createStock("Lavadoras_B", 200);
        await block4SC.createStock("Lavavajillas_A", 200);
    });
    it("should set data in 7 containers and send them to 3 locations", async() => {
        const block4SC = await Block4SC.deployed();
        //await block4SC.A_test2SetCont();
        await block4SC.setContData(1231, "Secadoras_A", 50, "Manufacturer", "Warehouse_ES");
        await block4SC.setContData(1232, "Lavadoras_B", 50, "Manufacturer", "Warehouse_FR");
        await block4SC.setContData(1233, "Lavavajillas_A", 100, "Manufacturer", "Warehouse_FR");
        await block4SC.setContData(1234, "Secadoras_A", 20, "Warehouse_ES", "Warehouse_FR");
        await block4SC.setContData(1235, "Lavavajillas_A", 20, "Warehouse_FR", "Warehouse_DE");
        await block4SC.setContData(1236, "Lavavajillas_A", 20, "Warehouse_FR", "Warehouse_ES");
        await block4SC.setContData(1237, "Lavadoras_B", 30, "Warehouse_FR", "Warehouse_ES");
        
        await block4SC.A_test3Send()
    });
    it("should call all getter functions", async() => {
        const block4SC = await Block4SC.deployed();    
        // all getter funtions here
        const resultAllContIDs = await block4SC.getAllContIDs();
        assert(resultAllContIDs === "1231, 1232, 1233, 1234, 1235, 1236, 1237, ");
        const resultAllLocations = await block4SC.getAllLocations();
        assert(resultAllLocations === "Manufacturer, Warehouse_ES, Warehouse_FR, Warehouse_DE, ");
        const resultAllMaterials = await block4SC.getAllMaterials();
        assert(resultAllMaterials === "Secadoras_A, Lavadoras_B, Lavavajillas_A, ");
    });
    it("should set and get the string hola into the variable Data", async() => {
        const block4SC = await Block4SC.deployed();   
        await block4SC.setData("hola");
        const resultData = await block4SC.getData();
        assert(resultData === "hola");
    });
})