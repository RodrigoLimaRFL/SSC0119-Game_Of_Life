# Game_Of_Life
Jogo...

## Vídeo do jogo:
Youtube:

## A nova instrução para o processador:
A nova função

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
 
 - Compilar e executar o programa no FPGA.

### Teste da instrução

Teste

#### Teste no teste.asm

teste

<h2>Membros:</h2>

<li> Karl Cruz Altenhofen - https://github.com/KarlCruzAltenhofen </li>
<li> Maicon Chaves Marques - https://github.com/MaiconChavesMarques </li>
<li> Rodrigo de Freitas Lima - https://github.com/RodrigoLimaRFL </li>
<li> Didrick Chancel Egnina Ndombi - https://github.com/LORDENDC </li>

<h2>Professor:</h2>

<li> Eduardo do Valle Simões </li>
