from web3 import Web3

url = "HTTP://127.0.0.1:7545"
w3 = Web3(Web3.HTTPProvider(url))
print(w3.isConnected())

tx = {
    "from": w3.eth.accounts[0],
    "to": w3.eth.accounts[1],
    "value": w3.toWei(10, "ether"),
}
w3.eth.send_transaction(tx)
