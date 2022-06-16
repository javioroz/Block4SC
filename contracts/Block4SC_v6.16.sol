// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.12;
// it is required version 0.8.12 because funtion string.concat(string,string) is only available for this version or higher
import "@openzeppelin/contracts/utils/Strings.sol"; // it is required this library to use function Strings.toString(uint)

// contract for "Blockchain for Supply Chain" dApp
contract Block4SC {
    /// @notice this contract stores in the blockchain the temperature and humidity measurements from several IoT sensors

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
     * v6.15      | fix bug in getMaterialsInWH() and change naming of WH by Loc and warehouse by location
     * v6.16      | mapping cont_i and loc_i and add user to the container
     *            | created functions getAllLocations() and getAllContIDs()
     * productive version.
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
        address editUser;
    }

    mapping(uint => Container) private containers_byID; // maps Container by contID
    mapping(string => mapping(string => uint)) private quant_byMat_inLoc; // maps quantity by material and location

    uint numOfMaterials = 0;                       // number of different materials
    mapping(uint => string) private matName_by_i;  // maps materials by index
    mapping(string => uint) private mat_i;         // reverse maps IDs by material

    uint numOfLocs = 0;                            // number of different Locations
    mapping(uint => string) private locName_by_i;  // maps location name by index
    mapping(string => uint) private loc_i;         // reverse maps index by location name

    uint numOfConts = 0;                           // number of different ContainerIDs
    mapping(uint => uint) private contID_by_i;     // maps materials by index
    mapping(uint => uint) private cont_i;          // reverse maps index by cont

    string initLoc = "Manufacturer";


    //-------------------------------------------------------------------------------------
    //------- SET Functions (store data) --------------------------------------------------
    //-------------------------------------------------------------------------------------
    /**
     * @dev createStock generates material information in location factory
     * @param _material measurement
     * @param _quantity of material
     */
    function createStock(string memory _material, uint _quantity) public {
        if (mat_i[_material]==0){   // if it´s the first time this material is created
            if (loc_i[initLoc]==0){ // if it´s the first material, the initLocation must be created for first tim
                numOfLocs=1;
                loc_i[initLoc]=numOfLocs;
                locName_by_i[numOfLocs]=initLoc;
            }
            quant_byMat_inLoc[_material][initLoc] = _quantity;
            numOfMaterials++;
            matName_by_i[numOfMaterials]=_material;
            mat_i[_material]=numOfMaterials;
        } else{ quant_byMat_inLoc[_material][initLoc] += _quantity; } // if the material already exists, it simply increases the qty.
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
        containers_byID[_contID] = Container(_contID, _material, _quantity, _origin, _destiny, 0, 0, msg.sender);  
        if (loc_i[_origin]==0){ // if the origin does not exists in the list of locations, it is added to locations
            numOfLocs++;
            loc_i[_origin]=numOfLocs;
            locName_by_i[numOfLocs]=_origin;
        }
        if (loc_i[_destiny]==0){ // if the destiny does not exists in the list of locations, it is added to locations
            numOfLocs++;
            loc_i[_destiny]=numOfLocs;
            locName_by_i[numOfLocs]=_destiny;
        }
        if (cont_i[_contID]==0){ // if the contID does not exists in the list of containers, it is added to locations
            numOfConts++;
            cont_i[_contID]=numOfConts;
            contID_by_i[numOfConts]=_contID;
        }
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
        containers_byID[_contID].editUser=msg.sender;    //it registers the address of the sender user
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
        containers_byID[_contID].editUser=msg.sender;    //it registers the address of the receiver user
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
     * @dev getAllMaterials in the mapping(string => uint)
     * @return container data in mapping by contID
     */
    function getAllMaterials() public view returns (string memory){
        string memory _material;
        string memory _matList;
        for (uint _i=1; _i<=numOfMaterials; _i++){
            _material = matName_by_i[_i];
            _matList = string.concat(_matList,matName_by_i[_i]);
            _matList = string.concat(_matList,", ");
        }
        return _matList;
    }

    /**
     * @dev getAllLocations in the mapping(string => uint)
     * @return locations list as a string concatenating the data in mapping by loc_i
     */
    function getAllLocations() public view returns (string memory){
        string memory _location;
        string memory _locList;
        for (uint _i=1; _i<=numOfLocs; _i++){
            _location = locName_by_i[_i];
            _locList = string.concat(_locList, locName_by_i[_i]);
            _locList = string.concat(_locList, ", ");
        }
        return _locList;
    }

    /**
     * @dev getAllContIDs in the mapping(uint => uint)
     * @return containerIDs list as a string concatenating the data in mapping by loc_i
     */
    function getAllContIDs() public view returns (string memory){
        string memory _contID;
        string memory _contList;
        for (uint _i=1; _i<=numOfConts; _i++){
            _contID = locName_by_i[_i];
            _contList = string.concat(_contList, Strings.toString(contID_by_i[_i]));
            _contList = string.concat(_contList, ", ");
        }
        return _contList;
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
     function A_test1CreateStock() public {
        // createStock(_material, _quantity);
        createStock("Secadoras_A", 200);
        createStock("Lavadoras_B", 200);
        createStock("Lavavajillas_A", 200);
    }

    /**
     * @dev testSetCont
     */
     function A_test2SetCont() public {
         //setContData(containerID, material, quantity, originLoc, destinyWH)
        setContData(1231, "Secadoras_A", 50, "Manufacturer", "Warehouse_ES");
        setContData(1232, "Lavadoras_B", 50, "Manufacturer", "Warehouse_FR");
        setContData(1233, "Lavavajillas_A", 100, "Manufacturer", "Warehouse_FR");
        setContData(1234, "Secadoras_A", 20, "Warehouse_ES", "Warehouse_FR");
        setContData(1235, "Lavavajillas_A", 20, "Warehouse_FR", "Warehouse_DE");
        setContData(1236, "Lavavajillas_A", 20, "Warehouse_FR", "Warehouse_ES");
        setContData(1237, "Lavadoras_B", 30, "Warehouse_FR", "Warehouse_ES");
    }

    /**
     * @dev testSend
     */
    function A_test3Send() public {
        for (uint _i=1; _i<=numOfConts; _i++){
            sendContainer(contID_by_i[_i]);
            receiveContainer(contID_by_i[_i]);
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
