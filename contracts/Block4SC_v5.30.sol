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
     * 15.05.2022 | J.Oroz | setOrigin(contID,origin), setDestiny(contID,destiny), getContData(contID)
     * 16.05.2022 | J.Oroz | emit5TestContainers(), getAllcontainersInWH(destiny) --> for loop not workin???? 
     * 27.05.2022 | J.Oroz | v2.0 created: New definition of struct Warehouses & mapping for containers
     * 30.05.2022 | J.Oroz | created testSet(), 
     */
    
    uint contNr = 0; // number of emited containers

    string data = "{'contID': 123456, 'content': 'containerA', 'origin': WH001, 'destiny': WH002, 'timeSent': '2022.02.03 23:02:00'}";

    struct Container {
        uint contID;
        string content;
        uint origin;
        uint destiny;
        uint timeSent;
        uint timeReceived;
    }

    struct Warehouse {
        uint WHID;
        string WHname;
        uint numOfConts;
        uint [] containersArray;
    }

    mapping(uint => Container) public containersbyID; // maps Container by contID
    mapping(uint => Warehouse) public warehousesbyID; // maps Warehouse by WHID
    mapping(uint => uint[]) public containersbyWH;  // maps contIDs by warehouse num
    mapping(uint => mapping(uint => uint)) public containers_byWH_byContID;
    
    //-------------------------------------------------------------------------------------
    //------- SET Functions (store data) --------------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev mapContainerData in an array
     * @param _contID id
     * @param _content measurement
     * @param _origin warehouse
     * @param _destiny warehouse
     */
    function setContainerData(uint _contID, string memory _content, uint _origin, uint _destiny) public {
        Container memory _container;
            _container.contID   = _contID;
            _container.content = _content;
            _container.origin   = _origin;
            _container.destiny  = _destiny;
        containersbyID[_contID] = _container;
        //containersbyID[_contID] = Container(_contID, _content, _origin, _destiny, 0, 0);  
    }

    /**
     * @dev setContent data to the container mapping
     * @param _contID identifier of the container
     * @param _content inside the container
     */
    function setContent(uint _contID, string memory _content) public {
        containersbyID[_contID].content=_content;
    }

    /**
     * @dev setOrigin data to the container mapping
     * @param _contID identifier of the container
     * @param _origin from where the container is sent
     */
    function setOrigin(uint _contID, uint _origin) public {
        containersbyID[_contID].origin=_origin;
    }

    /**
     * @dev setDestiny data to the container mapping
     * @param _contID identifier of the container
     * @param _destiny where the container is received
     */
    function setDestiny(uint _contID, uint _destiny) public {
        containersbyID[_contID].destiny=_destiny;
    }

    //-------------------------------------------------------------------------------------
    /**
     * @dev sendContainer 
     * @param _contID identifier of the container
     */
    function sendContainer(uint _contID) public {
        // require( bytes(containersbyID[_contID].destiny).length != 0 , "This container has no destination assigned.");
        require(containersbyID[_contID].destiny != 0 , "This container has no destination assigned.");
        uint _originWH = containersbyID[_contID].origin;
        require(warehousesbyID[_originWH].numOfConts > 0 , "The origin warehouse is empty.");
        containersbyID[_contID].timeSent=block.timestamp; //timestamp when the container was sent from origin WH
        delete containers_byWH_byContID[_originWH][_contID]; //remove container from origin warehouse
        warehousesbyID[_originWH].numOfConts--;
    }

    /**
     * @dev receiveContainer 
     * @param _contID identifier of the container
     */
    function receiveContainer(uint _contID) public {
        require( containersbyID[_contID].timeSent != 0 , "This container has not been sent yet.");
        containersbyID[_contID].timeReceived=block.timestamp; //timestamp when the container was received in destiny WH
        uint _destinyWH = containersbyID[_contID].destiny;
        containers_byWH_byContID[_destinyWH][_contID]=_contID; //add container to destiny warehouse
        warehousesbyID[_destinyWH].numOfConts++;
    }

    //-------------------------------------------------------------------------------------
    //------- GET Functions (retrieve data) -----------------------------------------------
    //-------------------------------------------------------------------------------------

    /**
     * @dev getContainerData in the mapping by contID
     * @return container data in mapping by contID
     */
    function getContainerData(uint _contID) public view returns (Container memory){
        return containersbyID[_contID];
    }

    /**
     * @dev getContainerData in the mapping by contID
     * @return container data in mapping by contID
     */
    function getContainers_inWH(uint _WHID) public view returns (uint[]){
        require( warehousesbyID[_WHID].numOfConts > 0 , "This warehouse is empty.");
        for (uint i = 0; i <= warehousesbyID[_WHID].numOfConts; i++) {
            return containers_byWH[_WHID].containersArray;
        }
        
    }

    /**
     * @dev getOrigin in the mapping by contID
     * @return container data in mapping by contID
     */
    function getOrigin(uint _contID) public view returns (uint){
        return containersbyID[_contID].origin;
    }

    /**
     * @dev getDestiny in the mapping by contID
     * @return container data in mapping by contID
     */
    function getDestiny(uint _contID) public view returns (uint){
        return containersbyID[_contID].destiny;
    }

    //-------------------------------------------------------------------------------------
    //------- TEST Functions --------------------------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev test set
     */
     function testSet() public {
        setContainerData(1, "cajasX", 11, 12);
        setContainerData(2, "lavadoras", 11, 13);
        setContainerData(3, "carros", 14, 12);
        setContainerData(4, "cajasY", 12, 15);
        setContainerData(5, "cajasZ", 12, 11);
        setContainerData(6, "fruta", 15, 11);
    }

    /**
     * @dev test send
     */
    function testSend() public {
        sendContainer(1);
        receiveContainer(1);
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
