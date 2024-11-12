require("@nomicfoundation/hardhat-toolbox"); // Certifique-se de que isso está incluído

module.exports = {
  solidity: "0.8.27", // Altere para a versão que você está usando
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
  },
};
