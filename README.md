# Game Of Life
O Jogo da Vida é um autômato celular criado pelo matemático britânico John Horton Conway em 1970. É um jogo de zero jogadores que se desenrola em uma grade bidimensional de células, onde cada célula pode estar em um dos dois estados possíveis: viva ou morta. A evolução do jogo é determinada por seu estado inicial, não exigindo intervenção adicional de jogadores.

## Regras:
O jogo segue quatro regras simples, aplicadas a cada célula da grade para determinar seu estado na próxima geração:
- Sobrevivência: Uma célula viva com dois ou três vizinhos vivos continua viva na próxima geração.
- Superpopulação: Uma célula viva com mais de três vizinhos vivos morre devido à superpopulação.
- Subpopulação: Uma célula viva com menos de dois vizinhos vivos morre devido à subpopulação.
- Reprodução: Uma célula morta com exatamente três vizinhos vivos torna-se viva na próxima geração.

## Funcionamento:
O jogo começa com uma configuração inicial de células vivas e mortas. Em cada etapa, as regras acima são aplicadas simultaneamente a todas as células da grade, produzindo uma nova geração.

O Jogo da Vida é conhecido por gerar padrões complexos e imprevisíveis a partir de regras simples, e tem sido usado para explorar conceitos em matemática, computação, biologia teórica e filosofia.

## Imagens:

a

## Vídeo do jogo:
Youtube: https://youtu.be/WgHUHPlJETs?si=DQC0SQZj_8xW6hn-

## A nova instrução para o processador:
A nova instrução implementada é a função de hold, que segura o processador por um determinado numero de ciclos de clock. A instrução se mantém no estado de decodificação até que uma varável secundaria atinga o valor passado no registrador, passar o valor 1000 no registrador, implica em fazer 65.536 decodificações 1000 vezes antes de seguir para a próxima instrução.

### Mudanças feitas em VHDL para implementação

 ```c
--========================================================================
-- HOLD RX
--========================================================================			
			IF(IR(15 DOWNTO 10) = HOLD) THEN
				
				IF (l = x"FFFF") THEN
					l(15 downto 0) :=	x"0000";
					m := m + 1;
				END IF;
				IF (m = REG(RX)) THEN
					  l(15 downto 0) :=	x"0000";  
					  m(15 downto 0) :=	x"0000";
					  state := fetch;
				ELSE
					  l := l + 1;
					  state := decode;
				END IF;
					
			END IF;		

-- XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
```

### Mudanças feitas no montador para implementação

#### Mudanças no def.h

 ```c
#define HOLD_CODE             99 //Inclusão do código da nova instrução
...
/* Hold Instructions: */
#define HOLD            "001011" //Inclusão do binário da nova instrução
...
/* HOLD */
#define HOLD_STR                "HOLD" //Inclusão do label (como aparecerá no código) a nova instrução
```

#### Mudanças no montador.c

 ```c
            case HOLD_CODE : //Definindo quantos separadores e quantas linhas minha instrução vai precisar
                parser_SkipUntilEnd();
                end_cnt++;
                break;
...

                /* ==============
                   Hold Rx                              //Definindo como a instrução deve ser montada
                   ==============
                */

                case HOLD_CODE :
                    str_tmp1 = parser_GetItem_s();
                    val1 = BuscaRegistrador(str_tmp1);
                    free(str_tmp1);
                    str_tmp1 = ConverteRegistrador(val1);
                    sprintf(str_msg,"%s%s0000000",HOLD,str_tmp1);
                    free(str_tmp1);
                    parser_Write_Inst(str_msg,end_cnt);
                    end_cnt += 1;
                    break;
...
        else if (strcmp(str_tmp,HOLD_STR) == 0) //Aviso que quando o programa encontrar a palavra hold, ele deve montar a instrução HOLD_CODE
    {
        return HOLD_CODE;
    }
```

### Montagem e execução à partir do arquivo .asm

#### Montagem

Para a montagem, precisa compilar o programa que está na pasta Assembler_Source no gcc com seguinte comando:

 gcc *.c -o main

 Também pode-se usar o makefile:
 
 make
  
 Depois disso
 
 ./montador <arquivoEntrada.asm> <cpuram.mif>
 
Isso ira gerar um arquivo ".mif"
 
 #### Execução
 
 Para a execução precisa seguir seguintes passos.

 - Renomear o arquivo "xxxxx.mif" para "cpuram.mif"
 - Copiar o arquivo ".mif" para pasta do quartus e substituir o que já existe lá
 - Compilar e executar o programa no FPGA.

### Teste da instrução

Utilizamos o teste.asm programa padrão de testes para verificar o funcionamento da nova instrução implementada. Colocamos a instrução entre a letra E e a letra F.

#### Teste no teste.asm

 ```c
	loadn r1, #'E'
	loadn r2, #1
	add r3, r1, r2
	loadn r0, #1000
	hold r0
	loadn r0, #10
	outchar r3, r0		; Printa F na linha 10
```

## Vídeo sobre a instrução:
Youtube: https://youtu.be/WgHUHPlJETs?si=DQC0SQZj_8xW6hn-

<h2>Membros:</h2>

<li> Karl Cruz Altenhofen - https://github.com/KarlCruzAltenhofen </li>
<li> Maicon Chaves Marques - https://github.com/MaiconChavesMarques </li>
<li> Rodrigo de Freitas Lima - https://github.com/RodrigoLimaRFL </li>
<li> Didrick Chancel Egnina Ndombi - https://github.com/LORDENDC </li>

<h2>Professor:</h2>

<li> Eduardo do Valle Simões </li>
