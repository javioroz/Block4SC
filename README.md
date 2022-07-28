# block4sc

This is a Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Environment variables
If you pull this repository, first it will be necessary to create a .env file to store the needed enviroment variables for this project. This file is in the .gitignore, so it is excluded from the  repository because it contains the wallet private key and other variables:

```
GANACHE_PRIVATE_KEY='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
BLOCK4SC_CONTRACT_ADDRESS="0x00000000000000000000000000000000000000000"
HELLO_CONTRACT_ADDRESS="0x0000000000000000000000000000000000000000"

BLOCK4SC_GOERLI_ADDRESS="0x0000000000000000000000000000000000000000"
BLOCK4SC_MUMBAI_ADDRESS="0x0000000000000000000000000000000000000000"
``"""``
## Block4SC User interface

This is the homescreen of the Dapp for container traceability.

### Stocks page:
![stocks page](https://github.com/javioroz/block4sc/blob/main/assets/img/screenshot_stocks.png?raw=true)

### Containers page:
![containers page](https://github.com/javioroz/block4sc/blob/main/assets/img/screenshot_containers.png?raw=true)

### Containers page:
![transport page](https://github.com/javioroz/block4sc/blob/main/assets/img/screenshot_transport.png?raw=true)

### Locations page:
![locations page](https://github.com/javioroz/block4sc/blob/main/assets/img/screenshot_locations.png?raw=true)

## Block4SC backend (solidity functions):

### Functions for storing data
This functions can be called from the UI in order to store data in the smartcontract.

* createStock(material,location)
* deleteStock(material,location)
* setContainerData(contID,material,origin,destiny,timestamp)
* sendContainer(contID)
* receiveContainer(contID)
* set
* . . .

### Funcitons for getting data
This functions can be called in order to retrieve data form the smartcontract and show it to the user.

* getContainerData(contID)
* getAllContainerIDs()
* getAllMaterials()
* getAllLocations()
* . . .

### Structures
This are the constructions in the solidity smartcontract which are built to store data:

* struct Container 
    - uint contID
    - string material
    - uint quantity
    - string origin
    - string destiny
    - uint timeSent
    - uint timeReceived
    - address editUser
* maping of container data by ID
* maping of container IDs by index
* maping of material names by index
* maping of location names by index