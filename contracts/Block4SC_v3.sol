// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0;

// contract for "Blockchain for Supply Chain" dApp
contract Block4SC {
    /// @notice this contract stores in the blockchain the temperature and humidity measurements from several IoT sensors
    /// @dev storeData function saves data and getData shows the saved data
    /*
     * Changes:
     * 10.05.2022 | J.Oroz | Creation of contract + functions emitNewContainer(), storeContainerData(), getContainersArray(), getLastContainer()
     * 11.05.2022 | J.Oroz | sendContainer(contID), receiveContainer(contID) -> which sets the timestamp 
     * 15.05.2022 | J.Oroz | setContOrigin(contID,origin), setContDestiny(contID,destiny), getContData(contID)
     * 27.05.2022 | J.Oroz | v2.0 created: New definition of mapping for containers
     * 30.05.2022 | J.Oroz | created testSet(), added quantity to container struct
     * 03.03.2022 | J.Oroz | v3.0 created mappings for quant_byMat_inWH, materials_byID, matID
     *                     | created functions createStock(), deleteStock(), testCreateStock(), getQuantityOfMatInWH(), getMaterialsInWH()
     */
    
    uint contNr = 0; // number of emited containers

    string data = "{'contID': 123456, 'material': 'doors', 'quantity': '10', 'origin': WH001, 'destiny': WH002, 'timeSent': '2022.02.03 23:02:00'}";

    struct Container {
        uint contID;
        string material;
        uint quantity;
        string origin;
        string destiny;
        uint timeSent;
        uint timeReceived;
    }

    mapping(uint => Container) private containers_byID; // maps Container by contID
    mapping(string => mapping(string => uint)) private quant_byMat_inWH; // maps quantity by material and warehouse
    mapping(uint => string) private materials_byID;   // maps materials by ID
    mapping(string => uint) private matID;            // reverse maps IDs by material
    uint numOfMaterials = 0;                         // number of different materials
    string manufacturerWH = "Manufacturer";

    //-------------------------------------------------------------------------------------
    //------- SET Functions (store data) --------------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev createStock generates material information in warehouse factory
     * @param _material measurement
     * @param _quantity of material
     */
    function createStock(string memory _material, uint _quantity) public {
        if (matID[_material]==0){
            quant_byMat_inWH[_material][manufacturerWH] = _quantity;
            numOfMaterials++;
            materials_byID[numOfMaterials]=_material;
            matID[_material]=numOfMaterials;
        } else{ quant_byMat_inWH[_material][manufacturerWH] += _quantity; }
    }

    /**
     * @dev deleteStock generates material information in warehouse
     * @param _material measurement
     * @param _warehouse where the stock should be created
     */
    function deleteStock(string memory _material, string memory _warehouse) public {
        delete quant_byMat_inWH[_material][_warehouse];
    }

    /**
     * @dev mapContainerData in an array
     * @param _contID id
     * @param _material measurement
     * @param _quantity of material
     * @param _origin warehouse
     * @param _destiny warehouse
     */
    function setContData(uint _contID, string memory _material, uint _quantity, string memory _origin, string memory _destiny) public {
        containers_byID[_contID] = Container(_contID, _material, _quantity, _origin, _destiny, 0, 0);  
    }

    /**
     * @dev setContent data to the container mapping
     * @param _contID identifier of the container
     * @param _material inside the container
     */
    function setContMaterial(uint _contID, string memory _material, uint _quantity) public {
        containers_byID[_contID].material=_material;
        containers_byID[_contID].quantity=_quantity;
    }

    /**
     * @dev setOrigin data to the container mapping
     * @param _contID identifier of the container
     * @param _origin from where the container is sent
     */
    function setContOrigin(uint _contID, string memory _origin) public {
        containers_byID[_contID].origin=_origin;
    }

    /**
     * @dev setDestiny data to the container mapping
     * @param _contID identifier of the container
     * @param _destiny where the container is received
     */
    function setContDestiny(uint _contID, string memory _destiny) public {
        containers_byID[_contID].destiny=_destiny;
    }

    //-------------------------------------------------------------------------------------
    /**
     * @dev sendContainer 
     * @param _contID identifier of the container
     */
    function sendContainer(uint _contID) public {
        // it is necessary to turn strings into bytes to compare
        require(keccak256(bytes(containers_byID[_contID].destiny)) != 0 , "This container has no destination assigned.");
        string memory _originWH = containers_byID[_contID].origin;
        string memory _material = containers_byID[_contID].material;
        require(quant_byMat_inWH[_material][_originWH] >= containers_byID[_contID].quantity , "There is not enough quantity in origin warehouse to send.");
        quant_byMat_inWH[_material][_originWH] -= containers_byID[_contID].quantity;
        containers_byID[_contID].timeSent=block.timestamp; //timestamp when the container was sent from origin WH
    }

    /**
     * @dev receiveContainer 
     * @param _contID identifier of the container
     */
    function receiveContainer(uint _contID) public {
        require( containers_byID[_contID].timeSent != 0 , "This container has not been sent yet.");
        string memory _destinyWH = containers_byID[_contID].destiny;
        string memory _material = containers_byID[_contID].material;
        quant_byMat_inWH[_material][_destinyWH] += containers_byID[_contID].quantity;
        containers_byID[_contID].timeReceived=block.timestamp; //timestamp when the container was received in destiny WH
    }

    //-------------------------------------------------------------------------------------
    //------- GET Functions (retrieve data) -----------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev getQuantityOfMatInWH in the mapping(string => mapping(uint => uint))
     * @return container data in mapping by contID
     */
    function getQuantityOfMatInWH(string memory _material, string memory _warehouse) public view returns (uint){
        return quant_byMat_inWH[_material][_warehouse];
    }

    /**
     * @dev getQuantityOfMatInWH in the mapping(string => mapping(uint => uint))
     * @return container data in mapping by contID
     */
    function getMaterialsInWH(string memory _warehouse) public view returns (string[] memory){
        string memory _material;
        string[] memory _matList;
        uint _j;
        for (uint _i; _i<numOfMaterials; _i++){
            _material = materials_byID[_i];
            if (quant_byMat_inWH[_material][_warehouse] != 0){
                _matList[_j]=materials_byID[_i];
                _j++;
            }
        }
        return _matList;
    }

    /**
     * @dev getContainerData in the mapping by contID
     * @return container data in mapping by contID
     */
    function getContData(uint _contID) public view returns (Container memory){
        return containers_byID[_contID];
    }

    /**
     * @dev getOrigin in the mapping by contID
     * @return container data in mapping by contID
     */
    function getContOrigin(uint _contID) public view returns (string memory){
        return containers_byID[_contID].origin;
    }

    /**
     * @dev getDestiny in the mapping by contID
     * @return container data in mapping by contID
     */
    function getContDestiny(uint _contID) public view returns (string memory){
        return containers_byID[_contID].destiny;
    }

    //-------------------------------------------------------------------------------------
    //------- TEST Functions --------------------------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev testCreateStock
     */
     function test1CreateStock() public {
        // createStock(_material, _quantity);
        createStock("Secadoras_A", 200);
        createStock("Lavadoras_B", 200);
        createStock("Lavavajillas_A", 200);
    }

    /**
     * @dev test set
     */
     function test2SetCont() public {
         //setContData(containerID, material, quantity, originWH, destinyWH)
        setContData(1, "Secadoras_A", 50, "Manufacturer", "Warehouse_ES");
        setContData(2, "Lavadoras_B", 50, "Manufacturer", "Warehouse_FR");
        setContData(3, "Lavavajillas_A", 100, "Manufacturer", "Warehouse_FR");
        setContData(4, "Secadoras_A", 20, "Warehouse_ES", "Warehouse_FR");
        setContData(5, "Lavavajillas_A", 20, "Warehouse_FR", "Warehouse_DE");
        setContData(6, "Lavavajillas_A", 20, "Warehouse_FR", "Warehouse_ES");
        setContData(7, "Lavadoras_B", 30, "Warehouse_FR", "Warehouse_ES");
    }

    /**
     * @dev test send
     */
    function test3Send() public {
        for (uint _i; _i<8; _i++){
            sendContainer(_i);
            receiveContainer(_i);
        }
    }
    
    //-------------------------------------------------------------------------------------
    //------- BASIC store/getData Functions -----------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev storeData value in variable
     * @param _data whatever temporal data, such us, json file in string format
     */
    function storeData(string memory _data) public {
        data = _data;
    }

    /**
     * @dev getData string from variable
     * @return data from variable
     */
    function getData() public view returns (string memory){
        return data;
    }

    //-------------------------------------------------------------------------------------
}
/*

Containers -> en vez de un array usar un maping de Containers

Warehouses[A{}]

frontend -> integrar con metamask (buscar plantilla) 

*/
