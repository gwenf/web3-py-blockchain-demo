pragma solidity 0.6.0;

contract Calculator {
    int256 public num;

    constructor() public {
        num = 1;
    }

    function getNum() public view returns (int256) {
        return num;
    }

    function add(int256 x, int256 y) public pure returns (int256) {
        return x + y;
    }

    function sub(int256 x, int256 y) public pure returns (int256) {
        return x - y;
    }

    function setNum(int256 x) public {
        num = x;
    }
}
