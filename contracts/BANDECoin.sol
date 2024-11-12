// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BANDECoin is ERC20, Ownable {
    // Mapear o saldo de staking dos usuários
    mapping(address => uint256) public balancoStaking;
    // Mapear o tempo de staking dos usuários
    mapping(address => uint256) public tempoStaking;
    // Rastrear quem controla a maioria do staking
    mapping(address => bool) private maioriaStakeholders;
    // Define a taxa de recompensa
    uint256 public taxaRecompensa = 100;

    // Construtor que inicializa o contrato com um valor inicial de tokens
    constructor(
        uint256 valorInicial
    ) ERC20("BANDECoin", "BND") Ownable(msg.sender) {
        _mint(msg.sender, valorInicial * (10 ** decimals()));
    }

    // Função para fazer staking de tokens
    function TokensStake(uint256 quantidade) external {
        require(quantidade > 0, "A quantidade deve ser maior que zero");
        // Transferir tokens do usuário para o contrato
        _transfer(msg.sender, address(this), quantidade);
        balancoStaking[msg.sender] += quantidade;
        // Armazena o tempo em que o staking foi iniciado
        tempoStaking[msg.sender] = block.timestamp;
    }

    // Função para retirar o staking e obter recompensas
    function EmpateStake() external {
        uint256 saldo = balancoStaking[msg.sender];
        require(saldo > 0, "Nenhum token em staking para retirar");

        uint256 recompensa = CalculaRecompensa(msg.sender);
        balancoStaking[msg.sender] = 0;
        // Mint de tokens de recompensa
        _mint(msg.sender, recompensa);
        // Transferir de volta os tokens em staking
        _transfer(address(this), msg.sender, saldo);
    }

    // Calcula a recompensa com base na duração do staking
    function CalculaRecompensa(address staker) public view returns (uint256) {
        uint256 duracaoStaking = block.timestamp - tempoStaking[staker];
        uint256 recompensa = (balancoStaking[staker] *
            taxaRecompensa *
            duracaoStaking) / (365 days);
        return recompensa;
    }

    // Simula um ataque onde alguém controla mais de 50% do fornecimento total
    function SimularAtaqueStake(address atacante) external onlyOwner {
        uint256 fornecimentoTotal = totalSupply();
        // 51% do fornecimento total
        uint256 attackerStake = (fornecimentoTotal * 51) / 100;
        // Gera tokens para o atacante
        _mint(atacante, attackerStake);
        balancoStaking[atacante] += attackerStake;

        // Marca o atacante como controlador majoritário
        if (balancoStaking[atacante] > fornecimentoTotal / 2) {
            maioriaStakeholders[atacante] = true;
        }
    }

    // Verifica se o endereço fornecido é um controlador majoritário
    function VerificaAtaqueMinoria(
        address attacker
    ) public view returns (bool) {
        return maioriaStakeholders[attacker];
    }
}
