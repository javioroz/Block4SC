import 'dart:convert';
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

  // The library web3dart won’t send signed transactions to miners itself.
  // Instead, it relies on an RPC client to do that. _rpcUrl
  // For the WebSocket URL just modify the RPC URL. _wsUrl
  // constants for web3client using local GANACHE blockchain
  final String _ganacheRpcUrl = "http://127.0.0.1:7545";
  final String _ganacheWsUrl = "ws://127.0.0.1:7545/";
  final String _privateKey = dotenv.env['GANACHE_PRIVATE_KEY']!;
  final String _block4scAddress = dotenv.env['BLOCK4SC_CONTRACT_ADDRESS']!;
  // constants for web3client using INFURA to connect real blockchain
  final String _infuraRpcUrl = dotenv.env['INFURA_URL']!;
  final String _infuraWsUrl = dotenv.env['INFURA_WS']!;

  // http.Client _httpClient;
  Web3Client? _ethClient; // connects to the ethereum rpc via WebSocket
  bool isLoading = true; // checks the state of the contract
  String? _abi;
  EthereumAddress? _contractAddress; // address of the deployed contract
  EthPrivateKey? _credentials; // credentials of the smartcontract deployer
  DeployedContract? _contract; //where contract is declared, for Web3dart
  // contracts used in Hello tab
  ContractFunction? _getData; // data getter function in Block4SC.sol
  ContractFunction? _setData; // data setter function in Block4SC.sol
  String? deployedData; // data from the smartcontract
  // contracts used in Stocks tab
  ContractFunction? _getAllMaterials;
  ContractFunction? _createStock;
  ContractFunction? _deleteStock;
  // contracts used in Containes tab
  // contracts used in Transport tab
  // contracts used in Locations tab

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
    _getAllMaterials = _contract!.function("getAllMaterials");
    _createStock = _contract!.function("createStock");
    _deleteStock = _contract!.function("deleteStock");
  }

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

  getAllMaterials() async {
    var currentAllMats = await _ethClient!
        .call(contract: _contract!, function: _getAllMaterials!, params: []);
    deployedData = currentAllMats[0];
    isLoading = false;
    state = isLoading;
  }

  createStock(String materialToSet, int quantityToSet) async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _createStock!,
            parameters: [materialToSet, quantityToSet]));
  }

  deleteStock(String materialToSet, int quantityToSet) async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _deleteStock!,
            parameters: [materialToSet, quantityToSet]));
  }
}
