// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0;
import "@openzeppelin/contracts/utils/Strings.sol";

// contract for "Blockchain for Supply Chain" dApp
contract Block4SC {
    /// @notice this contract stores in the blockchain the temperature and humidity measurements from several IoT sensors
    /// @dev storeData function saves data and getData shows the saved data
    /*
     * Changes by J. Oroz:
     * 10.05.2022 | Creation of contract + functions emitNewContainer(), storeContainerData(), getContainersArray(), getLastContainer()
     * 11.05.2022 | sendContainer(contID), receiveContainer(contID) -> which sets the timestamp 
     * 15.05.2022 | setContOrigin(contID,origin), setContDestiny(contID,destiny), getContData(contID)
     * 27.05.2022 | v2.0 created: New definition of mapping for containers
     * 30.05.2022 | created testSet(), added quantity to container struct
     * 03.06.2022 | v3.0 created mappings for quant_byMat_inLoc, matName_by_i, mat_i
     *            | created functions createStock(), deleteStock(), testCreateStock(), getQuantityOfMatInWH(), 
     * 08.06.2022 | new function getMaterialsInWH() and getAllStocks()
     * v6.15      | fix bug in getMaterialsInWH() and change naming of WH by Loc
     * pending to develop getAllLocations() and getAllContainerIDs()
     */
    
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
    mapping(string => mapping(string => uint)) private quant_byMat_inLoc; // maps quantity by material and location

    uint numOfMaterials = 0;                        // number of different materials
    mapping(uint => string) private matName_by_i;   // maps materials by index
    mapping(string => uint) private mat_i;          // reverse maps IDs by material

    //uint numOfConts = 0;
    //uint[] containersArray;
    //string[] locationsArray;

    uint numOfLocs = 0;                             // number of different Locations
    mapping(uint => string) private locName_by_i;   // maps location name by index
    mapping(string => uint) private locName_i;      // reverse maps index by location name

    uint numOfConts = 0;                            // number of different ContainerIDs
    mapping(uint => string) private contID_by_i;    // maps materials by index
    mapping(string => uint) private cont_i;         // reverse maps index by cont

    string manufacturerLoc = "Manufacturer";

    //-------------------------------------------------------------------------------------
    //------- SET Functions (store data) --------------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev createStock generates material information in location factory
     * @param _material measurement
     * @param _quantity of material
     */
    function createStock(string memory _material, uint _quantity) public {
        if (mat_i[_material]==0){
            quant_byMat_inLoc[_material][manufacturerLoc] = _quantity;
            numOfMaterials++;
            matName_by_i[numOfMaterials]=_material;
            mat_i[_material]=numOfMaterials;
        } else{ quant_byMat_inLoc[_material][manufacturerLoc] += _quantity; }
    }

    /**
     * @dev deleteStock generates material information in location
     * @param _material measurement
     * @param _location where the stock should be created
     */
    function deleteStock(string memory _material, string memory _location) public {
        delete quant_byMat_inLoc[_material][_location];
    }

    /**
     * @dev mapContainerData in an array
     * @param _contID id
     * @param _material measurement
     * @param _quantity of material
     * @param _origin location
     * @param _destiny location
     */
    function setContData(uint _contID, string memory _material, uint _quantity, string memory _origin, string memory _destiny) public {
        containers_byID[_contID] = Container(_contID, _material, _quantity, _origin, _destiny, 0, 0);  
    }

    /**
     * @dev setContent data to the container mapping
     * @param _contID identifier of the container
     * @param _material inside the container
     */
    function setContMaterial(uint _contID, string memory _material, uint _quantity) private {
        containers_byID[_contID].material=_material;
        containers_byID[_contID].quantity=_quantity;
    }

    /**
     * @dev setOrigin data to the container mapping
     * @param _contID identifier of the container
     * @param _origin from where the container is sent
     */
    function setContOrigin(uint _contID, string memory _origin) private {
        containers_byID[_contID].origin=_origin;
    }

    /**
     * @dev setDestiny data to the container mapping
     * @param _contID identifier of the container
     * @param _destiny where the container is received
     */
    function setContDestiny(uint _contID, string memory _destiny) private {
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
        string memory _originLoc = containers_byID[_contID].origin;
        string memory _material = containers_byID[_contID].material;
        require(quant_byMat_inLoc[_material][_originLoc] >= containers_byID[_contID].quantity , "There is not enough quantity in origin location to send.");
        quant_byMat_inLoc[_material][_originLoc] -= containers_byID[_contID].quantity;
        containers_byID[_contID].timeSent=block.timestamp; //timestamp when the container was sent from origin Loc
    }

    /**
     * @dev receiveContainer 
     * @param _contID identifier of the container
     */
    function receiveContainer(uint _contID) public {
        require( containers_byID[_contID].timeSent != 0 , "This container has not been sent yet.");
        string memory _destinyLoc = containers_byID[_contID].destiny;
        string memory _material = containers_byID[_contID].material;
        quant_byMat_inLoc[_material][_destinyLoc] += containers_byID[_contID].quantity;
        containers_byID[_contID].timeReceived=block.timestamp; //timestamp when the container was received in destiny Loc
    }

    //-------------------------------------------------------------------------------------
    //------- GET Functions (retrieve data) -----------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev getQuantityOfMatInLoc in the mapping(string => mapping(uint => uint))
     * @return container data in mapping by contID
     */
    function getQuantityOfMatInLoc(string memory _material, string memory _location) public view returns (uint){
        return quant_byMat_inLoc[_material][_location];
    }

    /**
     * @dev getQuantityOfMatInLoc in the mapping(string => mapping(uint => uint))
     * @return container data in mapping by contID
     */
    function getMaterialsInLoc(string memory _location) public view returns (string memory){
        string memory _material;
        //string[] memory _matList;
        string memory _matList;
        uint _quant;
        //uint _j=0;
        for (uint _i=1; _i<numOfMaterials; _i++){
            _material = matName_by_i[_i];
            _quant = quant_byMat_inLoc[_material][_location];
            if (_quant != 0){
                //_matList[_j]=matName_by_i[_i];
                _matList = string.concat(_matList,matName_by_i[_i]);
                _matList = string.concat(_matList,": ");
                _matList = string.concat(_matList, Strings.toString(_quant));
                _matList = string.concat(_matList,", ");
                //_j++;
            }
        }
        return _matList;
    }

    /**
     * @dev getQuantityOfMatInLoc in the mapping(string => mapping(uint => uint))
     * @return container data in mapping by contID
     */
    function getAllMaterials() public view returns (string memory){
        string memory _material;
        //string[] memory _matList;
        string memory _matList;
        //uint _j=0;
        for (uint _i=1; _i<=numOfMaterials; _i++){
            _material = matName_by_i[_i];
            _matList = string.concat(_matList,matName_by_i[_i]);
            _matList = string.concat(_matList,", ");
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
    function getContOrigin(uint _contID) private view returns (string memory){
        return containers_byID[_contID].origin;
    }

    /**
     * @dev getDestiny in the mapping by contID
     * @return container data in mapping by contID
     */
    function getContDestiny(uint _contID) private view returns (string memory){
        return containers_byID[_contID].destiny;
    }

    //-------------------------------------------------------------------------------------
    //------- TEST Functions --------------------------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev testCreateStock
     */
     function Atest1CreateStock() public {
        // createStock(_material, _quantity);
        createStock("Secadoras_A", 200);
        createStock("Lavadoras_B", 200);
        createStock("Lavavajillas_A", 200);
    }

    /**
     * @dev test set
     */
     function Atest2SetCont() public {
         //setContData(containerID, material, quantity, originLoc, destinyWH)
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
    function Atest3Send() public {
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
    function storeData(string memory _data) private {
        data = _data;
    }

    /**
     * @dev getData string from variable
     * @return data from variable
     */
    function getData() private view returns (string memory){
        return data;
    }

    //-------------------------------------------------------------------------------------
}
/*

Containers -> en vez de un array usar un maping de Containers

Warehouses[A{}]

frontend -> integrar con metamask (buscar plantilla) 

*/
