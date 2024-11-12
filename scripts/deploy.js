const hre = require("hardhat");

async function main() {
    const [implantador] = await hre.ethers.getSigners();
    console.log("Implantando contratos com a conta:", implantador.address);
    // Obtém a fábrica do contrato BANDECoin
    const BANDECoin = await hre.ethers.getContractFactory("BANDECoin");
    // Implanta com 1 milhão de tokens
    const bandeCoin = await BANDECoin.deploy(1000000);
    console.log("BANDECoin implantado em:", bandeCoin.address);
}

main()
    .then(() => process.exit(0))
    .catch((erro) => {
        console.error(erro);
        process.exit(1);
    });
