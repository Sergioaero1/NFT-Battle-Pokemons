// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";  // já tráz por herança os metodos erc-721

contract nftPokemon is ERC721{

    struct Pokemon{
        string name;
        uint level;
        string img;  // img virá do nosso IPFS
    }

    Pokemon[] public pokemons;  // array de pokemon chamada de pokemons
    address public gameOwner;   // dizendo quem é o dono do jogo, que vai gerar nossos pokemons

    constructor () ERC721 ("nftPokemon", "PKM"){  // nome do tiken e simbolo

        gameOwner = msg.sender;  // o dono da carteira que gerou o contrato é o dono do jogo

    } 

    modifier onlyOwnerOf(uint _monsterId) {  // esse modificador tem uma exigencia(require) que o dono do mostro...

        require(ownerOf(_monsterId) == msg.sender,"Apenas o dono pode batalhar com este Pokemon");  // ...é que esta gerando uma transação
        _; // _ para contunuar a execução da função

    }

    function battle(uint _attackingPokemon, uint _defendingPokemon) public onlyOwnerOf(_attackingPokemon){ // o dono do monstro que ataca
        Pokemon storage attacker = pokemons[_attackingPokemon]; // ataque
        Pokemon storage defender = pokemons[_defendingPokemon]; // defesa

         if (attacker.level >= defender.level) { 
            attacker.level += 2;
            defender.level += 1; // ganha 1 pq esta defendendo, porem com ataque + forte que a defesa
        }else{
            attacker.level += 1;
            defender.level += 2; // ganha 2 pq esta defendendo, porem com defesa  + forte que o ataque
        }
    }

    function createNewPokemon(string memory _name, address _to, string memory _img) public {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos Pokemons");
        uint id = pokemons.length;     // id do novo pokemon que é o tamanho do array
        pokemons.push(Pokemon(_name, 1,_img));  // pushpara enviar para o array de pokemons
        _safeMint(_to, id);   // criar(mint) o token
    }


}