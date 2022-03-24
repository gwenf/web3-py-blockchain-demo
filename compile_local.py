from web3 import Web3
from solcx import compile_source, install_solc

url = "HTTP://127.0.0.1:7545"
w3 = Web3(Web3.HTTPProvider(url))
print(w3.isConnected())

with open("./contracts/Calculator.sol") as f:
    contract = f.read()

install_solc("0.6.0")
compiled_sol = compile_source(contract, output_values=["abi", "bin"])

contract_id, contract_interface = compiled_sol.popitem()
bytecode = contract_interface["bin"]
abi = contract_interface["abi"]
print(bytecode, abi)

w3.eth.default_account = w3.eth.accounts[0]

Calculator = w3.eth.contract(abi=abi, bytecode=bytecode)
tx_hash = Calculator.constructor().transact()
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

calculator = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)
print(calculator.functions.getNum().call())

calculator.functions.setNum(7).transact()
print(calculator.functions.getNum().call())
