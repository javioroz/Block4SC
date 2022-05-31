// we define our web3 provider as localhost if Metamask has not defined one yet
if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
// we use the first account provided by ganache
web3.eth.defaultAccount = web3.eth.accounts[0];

// this is the ABI copied from Remix while compiling
var StorageContract = web3.eth.contract([
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "num",
				"type": "uint256"
			}
		],
		"name": "store",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "retrieve",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]);

// address of the contract after being deployed in localhost webProvider
var Stor = StorageContract.at('0xC72a7D9b0668E3717557C4b01dBE3a02eB252f4f');

Stor.retrieve(function(error, result) {
    if (!error) {
        //$("#data").html(result[0]+' ('+result[1]+' years old)');
        $("#data").html('data: ' + result[0]);
    } else
         console.log(error);
});

$("#buttonSet").click(function() {
    //Block4SC.setInstructor($("#name").val(), $("#age").val());
    Stor.store($("#name").val());
});

/*
// this is the ABI copied from Remix while compiling
var Block4SC_contract = web3.eth.contract([
	{
		"inputs": [],
		"name": "emit5TestContainers",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "emitNewContainer",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "contID",
				"type": "uint256"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "contName",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "origin",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "string",
				"name": "destiny",
				"type": "string"
			}
		],
		"name": "NewContainer",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_contID",
				"type": "uint256"
			}
		],
		"name": "receiveContainer",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_contID",
				"type": "uint256"
			}
		],
		"name": "sendContainer",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_contID",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_destiny",
				"type": "string"
			}
		],
		"name": "setDestiny",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_contID",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_origin",
				"type": "string"
			}
		],
		"name": "setOrigin",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_contID",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "_contName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_origin",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_destiny",
				"type": "string"
			}
		],
		"name": "storeContainerData",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_data",
				"type": "string"
			}
		],
		"name": "storeData",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "containersArray",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "contID",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "contName",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "origin",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "destiny",
				"type": "string"
			},
			{
				"internalType": "uint256",
				"name": "timeSent",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "timeReceived",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_destiny",
				"type": "string"
			}
		],
		"name": "getAllContainersInWH",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "contID",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "contName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "origin",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "destiny",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timeSent",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "timeReceived",
						"type": "uint256"
					}
				],
				"internalType": "struct Block4SC.Container[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "_contID",
				"type": "uint256"
			}
		],
		"name": "getContainerData",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "contID",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "contName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "origin",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "destiny",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timeSent",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "timeReceived",
						"type": "uint256"
					}
				],
				"internalType": "struct Block4SC.Container",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getContainersArray",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "contID",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "contName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "origin",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "destiny",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timeSent",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "timeReceived",
						"type": "uint256"
					}
				],
				"internalType": "struct Block4SC.Container[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getLastContainer",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "contID",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "contName",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "origin",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "destiny",
						"type": "string"
					},
					{
						"internalType": "uint256",
						"name": "timeSent",
						"type": "uint256"
					},
					{
						"internalType": "uint256",
						"name": "timeReceived",
						"type": "uint256"
					}
				],
				"internalType": "struct Block4SC.Container",
				"name": "",
				"type": "tuple"
			}
		],
		"stateMutability": "view",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "getLastData",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]);
// address of the contract after being deployed in localhost webProvider
var Block4SC = Block4SC_contract.at('0xB4Ea48fb02E899B29c58802b68427439015aEE32');

Block4SC.getLastData(function(error, result) {
    if (!error) {
        //$("#data").html(result[0]+' ('+result[1]+' years old)');
        $("#data").html('data: ' + result[0]);
    } else
         console.log(error);
});

$("#buttonSet").click(function() {
    //Block4SC.setInstructor($("#name").val(), $("#age").val());
    Block4SC.storeData($("#name").val());
});
*/