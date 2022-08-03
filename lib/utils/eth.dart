import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

final ethUtilsProviders = StateNotifierProvider<EthereumUtils, bool>((ref) {
  return EthereumUtils();
});

class EthereumUtils extends StateNotifier<bool> {
  EthereumUtils() : super(true) {
    initialSetup();
  }

  // --------------------------------------------------------------------
  // RPC client (URL+WebSocket): to interact with blockchain
  // --------------------------------------------------------------------
  // constants for web3client using blockchain parameters defined in .env file
  final String _ganacheRpcUrl = dotenv.env['RPC_URL']!;
  final String _ganacheWsUrl = dotenv.env['RPC_WS']!;
  final String _privateKey = dotenv.env['PRIVATE_KEY']!;
  final String _block4scAddress = dotenv.env['CONTRACT_ADDRESS']!;
  // --------------------------------------------------------------------
  // http.Client for web3 and contract info
  // --------------------------------------------------------------------
  Web3Client? _ethClient; // connects to the ethereum rpc via WebSocket
  bool isLoading = true; // checks the state of the contract
  String? _abi;
  EthereumAddress? _contractAddress; // address of the deployed contract
  EthPrivateKey? _credentials; // credentials of the smartcontract deployer
  DeployedContract? _contract; //where contract is declared, for Web3dart
  // --------------------------------------------------------------------
  // functions and variables used in Hello tab
  // --------------------------------------------------------------------
  ContractFunction? _getData; // data getter function in Block4SC.sol
  ContractFunction? _setData; // data setter function in Block4SC.sol
  String? deployedData; // data from the smartcontract
  // --------------------------------------------------------------------
  // functions and variables used in Stocks tab
  // --------------------------------------------------------------------
  ContractFunction? _createStock;
  String? matCreated = "";
  String? qtyCreated = "";
  ContractFunction? _deleteStock;
  String? matDeleted = "";
  String? locDeleted = "";
  ContractFunction? _getAllMaterials;
  String? allMats = "";
  // --------------------------------------------------------------------
  // functions and variables used in Containes tab
  // --------------------------------------------------------------------
  ContractFunction? _setContData;
  String? contSaved = "";
  String? matSaved = "";
  String? qtySaved = "";
  String? origSaved = "";
  String? destSaved = "";
  ContractFunction? _getContData;
  String? contData = "";
  ContractFunction? _getAllContIDs;
  String? allContIDs = "";
  // --------------------------------------------------------------------
  // functions and variables used in Transport tab
  // --------------------------------------------------------------------
  ContractFunction? _sendContainer;
  String? timeSent = "";
  ContractFunction? _receiveContainer;
  String? timeReceived = "";
  // --------------------------------------------------------------------
  // functions and variables used in Locations tab
  // --------------------------------------------------------------------
  ContractFunction? _getMaterialsInLoc;
  String? matsInLoc = "";
  ContractFunction? _getQuantityOfMatInLoc;
  String? matQtyInLoc = "";
  ContractFunction? _getAllLocations;
  String? allLocs = "";
  // --------------------------------------------------------------------
  // functions and variables used in Test menu
  // --------------------------------------------------------------------
  ContractFunction? _test1CreateStock;
  ContractFunction? _test2SetCont;
  ContractFunction? _test3Send;

  // --------------------------------------------------------------------
  // Futures to initialize contract and functions
  // --------------------------------------------------------------------
  initialSetup() async {
    http.Client httpClient = http.Client();
    // web3client using local ganache blockchain
    _ethClient = Web3Client(_ganacheRpcUrl, httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(_ganacheWsUrl).cast<String>();
    });
    // web3client using infura to connect real blockchain
    /*
    _ethClient = Web3Client(_infuraRpcUrl, httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(_infuraWsUrl).cast<String>();
    });
    */
    await getAbi();
    await getCredentials();
    await getDeployedContracts();
  }

  Future<void> getAbi() async {
    //Reading the contract ABI
    String abiStringFile =
        await rootBundle.loadString("assets/abi/Block4SC.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abi = jsonEncode(jsonAbi["abi"]);

    _contractAddress = EthereumAddress.fromHex(_block4scAddress);
    //  EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContracts() async {
    // Telling Web3dart where our contract is declared.
    _contract = DeployedContract(
        ContractAbi.fromJson(_abi!, "Block4SC"), _contractAddress!);

    // Extracting the functions, declared in contract:
    //   funtions used in Hello tab
    _getData = _contract!.function("data");
    _setData = _contract!.function("setData");
    getData();
    //   funtions used in Stocks tab
    _createStock = _contract!.function("createStock");
    _deleteStock = _contract!.function("deleteStock");
    _getAllMaterials = _contract!.function("getAllMaterials");
    //   funtions used in Containers tab
    _setContData = _contract!.function("setContData");
    _getContData = _contract!.function("getContData");
    _getAllContIDs = _contract!.function("getAllContIDs");
    //   funtions used in Transport tab
    _sendContainer = _contract!.function("sendContainer");
    _receiveContainer = _contract!.function("receiveContainer");
    //   funtions used in Locations tab
    _getMaterialsInLoc = _contract!.function("getMaterialsInLoc");
    _getQuantityOfMatInLoc = _contract!.function("getQuantityOfMatInLoc");
    _getAllLocations = _contract!.function("getAllLocations");
    //   funtions used in Test menu
    _test1CreateStock = _contract!.function("test1CreateStock");
    _test2SetCont = _contract!.function("test2SetCont");
    _test3Send = _contract!.function("test3Send");
  }

  // --------------------------------------------------------------------
  // functions used in Hello tab
  // --------------------------------------------------------------------
  getData() async {
    // Getting the current data variable declared in the smart contract.
    var currentData = await _ethClient!
        .call(contract: _contract!, function: _getData!, params: []);
    deployedData = currentData[0];
    isLoading = false;
    state = isLoading;
  }

  setData(String dataToSet) async {
    // Setting the data to the variable data in the smart contract
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _setData!,
            parameters: [dataToSet]));
    getData();
  }

  // --------------------------------------------------------------------
  // functions used in Stocks tab
  // --------------------------------------------------------------------
  createStock(String sMatToSet, String sQuantityToSet) async {
    isLoading = true;
    state = isLoading;
    BigInt iQuantityToSet = BigInt.from(int.parse(sQuantityToSet));
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _createStock!,
            parameters: [sMatToSet, iQuantityToSet]));
    matCreated = sMatToSet;
    qtyCreated = sQuantityToSet;
    isLoading = false;
    state = isLoading;
  }

  deleteStock(String sMatToSet, String sLocDeleted) async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _deleteStock!,
            parameters: [sMatToSet, sLocDeleted]));
    matDeleted = sMatToSet;
    locDeleted = sLocDeleted;
    isLoading = false;
    state = isLoading;
  }

  getAllMaterials() async {
    isLoading = true;
    state = isLoading;
    var currentAllMats = await _ethClient!
        .call(contract: _contract!, function: _getAllMaterials!, params: []);
    allMats = currentAllMats[0];
    isLoading = false;
    state = isLoading;
  }

  // --------------------------------------------------------------------
  // functions used in Containers tab
  // --------------------------------------------------------------------
  setContData(String sContToSet, String sMatToSet, String sQtyToSet,
      String sOrigToSet, String sDestToSet) async {
    isLoading = true;
    state = isLoading;
    BigInt iQtyToSet = BigInt.from(int.parse(sQtyToSet));
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _setContData!,
            parameters: [
              sContToSet,
              sMatToSet,
              iQtyToSet,
              sOrigToSet,
              sDestToSet
            ]));
    contSaved = sContToSet;
    matSaved = sMatToSet;
    qtySaved = sQtyToSet;
    origSaved = sOrigToSet;
    destSaved = sDestToSet;
    isLoading = false;
    state = isLoading;
  }

  getContData(String sContToGet) async {
    isLoading = true;
    state = isLoading;
    var currentContData = await _ethClient!.call(
        contract: _contract!, function: _getContData!, params: [sContToGet]);
    String sContID = currentContData[0].toString();
    /*String sMat = currentContData[1].toString();
    String sQty = currentContData[2].toString();
    String sOrig = currentContData[3].toString();
    String sDest = currentContData[4].toString();
    BigInt iSent = currentContData[5];
    String sSent = (iSent.fromMillisecondsSinceEpoch(timestamp1 * 1000)).toString;
    BigInt iReceived = currentContData[6];
    String sReceived = (iSent.fromMillisecondsSinceEpoch(timestamp1 * 1000)).toString;
    contData = "$sContID, Mat: $sMat, Qty: $sQty, Orig: $sOrig, Dest: $sDest, Sent: $sSent, Received: $sReceived";*/
    contData = sContID;
    isLoading = false;
    state = isLoading;
    return contData;
  }

  getAllContIDs() async {
    isLoading = true;
    state = isLoading;
    var currentAllMats = await _ethClient!
        .call(contract: _contract!, function: _getAllContIDs!, params: []);
    allContIDs = currentAllMats[0];
    isLoading = false;
    state = isLoading;
  }

  // --------------------------------------------------------------------
  // functions used in Transport tab
  // --------------------------------------------------------------------
  sendContainer(String sContToSend) async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _sendContainer!,
            parameters: [sContToSend]));
    timeSent = DateTime.now().toString();
    isLoading = false;
    state = isLoading;
  }

  receiveContainer(String sContToReceive) async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _receiveContainer!,
            parameters: [sContToReceive]));
    timeReceived = DateTime.now().toString();
    isLoading = false;
    state = isLoading;
  }

  // --------------------------------------------------------------------
  // functions used in Stocks tab
  // --------------------------------------------------------------------
  getMaterialsInLoc(String sLocToCheck) async {
    isLoading = true;
    state = isLoading;
    var currentData = await _ethClient!.call(
        contract: _contract!,
        function: _getMaterialsInLoc!,
        params: [sLocToCheck]);
    matsInLoc = currentData[0].toString();
    isLoading = false;
    state = isLoading;
  }

  getQuantityOfMatInLoc(String sMatToCheck, String sLocToCheck) async {
    isLoading = true;
    state = isLoading;
    var currentData = await _ethClient!.call(
        contract: _contract!,
        function: _getQuantityOfMatInLoc!,
        params: [sMatToCheck, sLocToCheck]);
    matQtyInLoc = currentData[0].toString();
    isLoading = false;
    state = isLoading;
  }

  getAllLocations() async {
    isLoading = true;
    state = isLoading;
    var currentData = await _ethClient!
        .call(contract: _contract!, function: _getAllLocations!, params: []);
    allLocs = currentData[0].toString();
    isLoading = false;
    state = isLoading;
  }

  // --------------------------------------------------------------------
  // functions used in Test menu
  // --------------------------------------------------------------------
  test1CreateStock() async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _test1CreateStock!,
            parameters: []));
    isLoading = false;
    state = isLoading;
  }

  test2SetCont() async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!, function: _test2SetCont!, parameters: []));
    isLoading = false;
    state = isLoading;
  }

  test3Send() async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!, function: _test3Send!, parameters: []));
    isLoading = false;
    state = isLoading;
  }
}
