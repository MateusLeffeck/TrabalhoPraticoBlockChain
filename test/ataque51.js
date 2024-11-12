const { expect } = require("chai");
const hre = require("hardhat");
const ethers = hre.ethers;
const { Utils } = require("alchemy-sdk");

describe("Simulação de Ataque de 51% no BANDECoin", function () {
    let BANDECoin, bandeCoin, dono, atacante, usuario;

    before(async function () {
        [dono, atacante, usuario] = await ethers.getSigners();
        BANDECoin = await ethers.getContractFactory("BANDECoin");
        bandeCoin = await BANDECoin.deploy(1000000);
    });
    
    it("Simula ataque de 51% com controle majoritário", async function () {
        
        console.log("Saldo do Atacante:", (await bandeCoin.balanceOf(atacante.address)).toString());
        console.log("Fornecimento Total:", (await bandeCoin.totalSupply()).toString());

        // O dono transfere tokens para o usuário
        await bandeCoin.connect(dono).transfer(usuario.address, ethers.parseEther("10"));
        expect(await bandeCoin.balanceOf(usuario.address)).to.equal(ethers.parseEther("10"));

        // Simula o controle majoritário
        await bandeCoin.connect(dono).SimularAtaqueStake(atacante.address);
    
        expect(await bandeCoin.VerificaAtaqueMinoria(atacante.address)).to.be.true;

        console.log("Saldo do Atacante:", (await bandeCoin.balanceOf(atacante.address)).toString());
        console.log("Saldo Total:", (await bandeCoin.totalSupply()).toString());
    });
    
});
