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

  // The library web3dart won’t send signed transactions to miners
  // itself. Instead, it relies on an RPC client to do that. For the
  // WebSocket URL just modify the RPC URL.
  final String _rpcUrl = "http://10.0.2.2:7545";
  final String _wsUrl = "ws://10.0.2.2:7545/";
  final String _privateKey = dotenv.env['GANACHE_PRIVATE_KEY']!;

  // http.Client _httpClient;
  Web3Client? _ethClient; //connects to the ethereum rpc via WebSocket
  bool isLoading = true;
  String? _abi;
  EthereumAddress? _contractAddress; // address of the deployed contract
  EthPrivateKey? _credentials; // credentials of the smartcontract deployer
  DeployedContract? _contract;

  ContractFunction? _getData; // name getter function in Block4SC.sol
  ContractFunction? _setData; // name setter function in Block4SC.sol

  String? deployedName; // name from the smartcontract

  initialSetup() async {
    http.Client _httpClient = http.Client();
    _ethClient = Web3Client(_rpcUrl, _httpClient, socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

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

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    _credentials = EthPrivateKey.fromHex(_privateKey);
  }

  Future<void> getDeployedContracts() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abi!, "Block4SC"), _contractAddress!);

    // Extracting the functions, declared in contract.
    _getData = _contract!.function("getData");
    _setData = _contract!.function("setData");
    getData();
  }

  getData() async {
    var currentName = await _ethClient!
        .call(contract: _contract!, function: _getData!, params: []);
    deployedName = currentName[0];
    isLoading = false;
    state = isLoading;
  }

  setData(String nameToSet) async {
    isLoading = true;
    state = isLoading;
    await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
            contract: _contract!,
            function: _setData!,
            parameters: [nameToSet]));
    getData();
  }
}
