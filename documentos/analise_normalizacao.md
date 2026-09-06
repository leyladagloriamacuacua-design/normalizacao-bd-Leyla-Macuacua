# Trabalho II — Normalização de Base de Dados
### Sistema de Gestão de Funcionários
**Universidade Licungo — Faculdade de Ciências e Tecnologias — Curso de Licenciatura em Informática**

---

**Sumário**

1. Identificação dos problemas na tabela original (0FN)
2. Primeira Forma Normal (1FN)
3. Segunda Forma Normal (2FN)
4. Terceira Forma Normal (3FN)
5. Quarta Forma Normal (4FN)
6. Cardinalidades dos relacionamentos
7. Modelo Entidade-Relacionamento (MER) final
8. Scripts SQL

---

## 1. Identificação dos problemas na tabela original (0FN)

A tabela de partida (`Dados_Nao_Normalizados_Funcionarios.xlsx`) guarda, numa única linha por funcionário, dados pessoais, morada, dados profissionais, até 3 filhos e até 3 contactos telefónicos. Isto gera os seguintes problemas:

### 1.1 Dados não atómicos
- **Endereço**: o campo "Endereço" mistura, num único texto, o tipo/nome da via (Avenida/Rua), o número de porta e o bairro (ex.: *"Av. Julius Nyerere, n.º 245, Sommerschield"*). Não é possível pesquisar ou filtrar por bairro ou número sem primeiro decompor a string.
- Foi ainda detetado um pequeno erro de introdução de dados no campo Endereço do funcionário Bernardo Machava (*"Polana Caniço8"*), evidenciando como a falta de estrutura facilita erros deste tipo.

### 1.2 Grupos repetitivos
- **Filhos**: `Filho1`, `Filho2`, `Filho3` — um grupo repetitivo que limita artificialmente o número de filhos a 3 e deixa colunas vazias (NULL) quando o funcionário tem menos filhos, desperdiçando espaço.
- **Contactos telefónicos**: `Celular1`, `Celular2`, `Celular3` — o mesmo problema, com o agravante de que não há forma de distinguir o "tipo" de número (pessoal, trabalho) nem pesquisar "todos os telefones" com uma única condição (é preciso testar as 3 colunas).

### 1.3 Dependências parciais
Se, para eliminar os grupos repetitivos, simplesmente duplicássemos a linha do funcionário para cada filho/telefone (em vez de criar tabelas novas), a chave da tabela passaria a ser composta — por exemplo `(BI, NomeFilho)`. Nesse cenário, atributos como `Nome`, `Email`, `Cargo` ou `Endereço` dependeriam **apenas de `BI`** (parte da chave), e não da chave composta inteira. Isto é uma **dependência parcial**, a anomalia que a 2.ª Forma Normal resolve.

### 1.4 Dependências transitivas
Na tabela original existem atributos não-chave que dependem de **outros atributos não-chave**, e não diretamente da chave primária (`BI`):
- `BI → Cidade → Província → País` — a província e o país de um funcionário são determinados pela cidade onde reside, não pelo funcionário em si (todas as pessoas de "Beira" estão em "Sofala, Moçambique").
- `BI → Cód. Cargo → Cargo` — a designação do cargo depende do código do cargo, que se repete entre vários funcionários (conforme referido no enunciado).
- `BI → Cód. Função → Função` — o mesmo se aplica à função.
- `BI → Posto de Trabalho → Cidade` — o próprio nome do posto de trabalho (ex.: "Delegação Beira", "Sede Maputo") já embute a cidade onde este se localiza, ou seja, a cidade do local de trabalho depende do posto, não do funcionário individualmente.

### 1.5 Dependências multivaloradas
Um mesmo funcionário pode ter **vários filhos** e, independentemente disso, **vários telefones**. Estes são dois factos multivalorados **independentes** entre si sobre a entidade Funcionário (não há relação entre "qual filho" e "qual telefone"). Se estas duas listas fossem combinadas numa única tabela linha-a-linha (ex.: repetir a linha do funcionário para cada combinação Filho×Telefone), surgiriam combinações artificiais que nunca existiram nos dados originais — a anomalia que a 4.ª Forma Normal elimina.

---

## 2. Primeira Forma Normal (1FN)

**Regra**: eliminar grupos repetitivos e garantir que todos os atributos são atómicos.

**Ações tomadas:**
1. O campo `Endereço` foi decomposto em `Rua`, `Número` e `Bairro`.
2. Os grupos repetitivos `Filho1..3` foram extraídos para uma tabela própria **FILHO**, com uma linha por filho.
3. Os grupos repetitivos `Celular1..3` foram extraídos para uma tabela própria **TELEFONE**, com uma linha por número.

**FUNCIONARIO (1FN)** — chave primária: `BI`. Exemplo de registo (1 de 16), dividido em dois blocos temáticos para facilitar a leitura:

*Dados pessoais e morada*

| BI | Nome | Data Nasc. | NUIT | Email | Rua | Número | Bairro | Cidade | Província | País |
|---|---|---|---|---|---|---|---|---|---|---|
| 110100123456A | Amélia Fernanda Cossa | 12/03/1985 | 100234567 | amelia.cossa@empresa.co.mz | Av. Julius Nyerere | 245 | Sommerschield | Maputo | Maputo Cidade | Moçambique |

*Dados profissionais*

| BI | Cargo | Cód. Cargo | Função | Cód. Função | Posto de Trabalho | Data Admissão |
|---|---|---|---|---|---|---|
| 110100123456A | Técnico de Informática | C01 | Tecnologias de Informação | F01 | Sede Maputo | 05/02/2015 |

*(Os restantes 15 registos seguem a mesma estrutura e estão listados na íntegra no ficheiro `sql/normalizacao.sql`.)*

**FILHO (1FN)** — chave primária: `id_filho`

| id_filho | BI (FK) | Nome Filho |
|---|---|---|
| 1 | 110100123456A | Cátia Cossa |
| 2 | 110100234567B | Nelson Machava |
| 3 | 110100234567B | Ivete Machava |
| ... | ... | ... |

**TELEFONE (1FN)** — chave primária: `id_telefone`

| id_telefone | BI (FK) | Número Telefone |
|---|---|---|
| 1 | 110100123456A | 841234567 |
| 2 | 110100123456A | 821234567 |
| ... | ... | ... |

*(As tabelas completas com os 16 funcionários, 20 filhos e 26 números de telefone estão no ficheiro `sql/normalizacao.sql`.)*

---

## 3. Segunda Forma Normal (2FN)

**Regra**: eliminar dependências parciais em relação à chave primária (só se aplica a chaves compostas).

Como, ao aplicar a 1FN, a tabela **FUNCIONARIO** já ficou com uma chave primária simples e atómica (`BI`), não existe qualquer dependência parcial dentro dela — todos os atributos dependem inteiramente de `BI`.

A dependência parcial só existiria se, em vez de criar as tabelas `FILHO` e `TELEFONE`, tivéssemos optado por "achatar" os dados repetindo a linha do funcionário (chave composta `BI + NomeFilho`, por exemplo). Como este trabalho já resolveu os grupos repetitivos corretamente na 1FN (criando tabelas próprias com chave substituta `id_filho` / `id_telefone`), **a 2FN já está automaticamente satisfeita**: `FUNCIONARIO`, `FILHO` e `TELEFONE` não têm nenhum atributo que dependa apenas de parte de uma chave composta.

**Conclusão:** nenhuma tabela adicional foi necessária nesta etapa — o esquema da 1FN já cumpre a 2FN.

---

## 4. Terceira Forma Normal (3FN)

**Regra**: eliminar dependências transitivas (atributo não-chave que depende de outro atributo não-chave, e não diretamente da chave primária).

**Dependências transitivas identificadas e eliminadas:**

| Dependência transitiva | Solução |
|---|---|
| `BI → Cidade → Província, País` | Criada a tabela **CIDADE** (`cod_cidade` PK; `nome_cidade`, `provincia`, `pais`) |
| `BI → Cód. Cargo → Cargo` | Criada a tabela **CARGO** (`cod_cargo` PK; `descricao_cargo`) |
| `BI → Cód. Função → Função` | Criada a tabela **FUNCAO** (`cod_funcao` PK; `descricao_funcao`) |
| `BI → Posto de Trabalho → Cidade (do posto)` | Criada a tabela **POSTO_TRABALHO** (`cod_posto` PK; `nome_posto`; `cod_cidade` FK → CIDADE) |

**FUNCIONARIO (3FN)** passa a ter apenas atributos que dependem diretamente do `BI`, mais chaves estrangeiras para as tabelas de referência:

`BI (PK)`, `Nome`, `Data Nasc.`, `NUIT`, `Email`, `Rua`, `Número`, `Bairro`, `cod_cidade (FK)`, `cod_cargo (FK)`, `cod_funcao (FK)`, `cod_posto (FK)`, `Data Admissão`

**CIDADE**

| cod_cidade | nome_cidade | provincia | pais |
|---|---|---|---|
| CID01 | Beira | Sofala | Moçambique |
| CID04 | Maputo | Maputo Cidade | Moçambique |
| CID07 | Nampula | Nampula | Moçambique |
| ... | ... | ... | ... |

**CARGO**

| cod_cargo | descricao_cargo |
|---|---|
| C01 | Técnico de Informática |
| C02 | Contabilista |
| C03 | Engenheiro Civil |
| ... | ... |

**FUNCAO**

| cod_funcao | descricao_funcao |
|---|---|
| F01 | Tecnologias de Informação |
| F02 | Finanças |
| ... | ... |

**POSTO_TRABALHO**

| cod_posto | nome_posto | cod_cidade (FK) |
|---|---|---|
| PT10 | Sede Maputo | CID04 |
| PT01 | Delegação Beira | CID01 |
| ... | ... | ... |

Com isto, a designação de um cargo ou de uma função passa a estar guardada **uma única vez** (e não repetida em cada funcionário que a partilha), eliminando redundância e anomalias de atualização — por exemplo, corrigir o nome de um cargo passa a exigir alterar **um único registo**, e não todos os funcionários que o partilham.

---

## 5. Quarta Forma Normal (4FN)

**Regra**: eliminar dependências multivaloradas independentes — quando uma entidade tem dois ou mais atributos multivalorados que não têm relação lógica entre si, cada um deve ficar na sua própria tabela.

**Análise**: `FUNCIONARIO` tem duas dependências multivaloradas independentes:
- `BI ->> NomeFilho` (um funcionário pode ter vários filhos)
- `BI ->> NumeroTelefone` (um funcionário pode ter vários telefones)

Estes dois factos **não estão relacionados entre si** — não existe uma associação lógica entre "qual filho" e "qual telefone" de um funcionário. Se tivéssemos optado por juntar filhos e telefones numa única tabela (por exemplo, uma tabela genérica de "informações associadas" com ambos os tipos misturados, ou pior, cruzando as duas listas linha a linha), criaríamos combinações fictícias que não existem na realidade (ex.: associar o "Filho 1" ao "Telefone 2" sem que isso tenha qualquer significado).

**Solução aplicada** (já implementada na 1FN, e mantida/confirmada aqui): manter `FILHO` e `TELEFONE` como duas tabelas **completamente independentes**, cada uma relacionada com `FUNCIONARIO` apenas através da chave estrangeira `bi_funcionario`. Isto garante que adicionar ou remover um filho não interfere com os telefones (e vice-versa), sem gerar combinações espúrias entre as duas listas.

**Conclusão:** o esquema já está em 4FN. Não foi necessária nenhuma tabela adicional nesta fase — o trabalho de decomposição feito na 1FN já preveniu corretamente a anomalia multivalorada.

---

## 6. Cardinalidades dos relacionamentos

| Relacionamento | Cardinalidade | Justificação |
|---|---|---|
| FUNCIONARIO — CIDADE (reside em) | **N : 1** | Vários funcionários podem residir na mesma cidade; cada funcionário reside numa única cidade. |
| FUNCIONARIO — CARGO (ocupa) | **N : 1** | Vários funcionários podem ocupar o mesmo cargo; cada funcionário ocupa um único cargo. |
| FUNCIONARIO — FUNCAO (desempenha) | **N : 1** | Vários funcionários podem desempenhar a mesma função; cada funcionário tem uma única função. |
| FUNCIONARIO — POSTO_TRABALHO (trabalha em) | **N : 1** | Vários funcionários podem trabalhar no mesmo posto; cada funcionário está afeto a um único posto. |
| POSTO_TRABALHO — CIDADE (localizado em) | **N : 1** | Vários postos de trabalho podem situar-se na mesma cidade; cada posto localiza-se numa única cidade. |
| FUNCIONARIO — FILHO (tem) | **1 : N** | Um funcionário pode ter zero ou vários filhos registados; cada registo de filho pertence a um único funcionário. |
| FUNCIONARIO — TELEFONE (possui) | **1 : N** | Um funcionário pode ter um ou vários números de telefone; cada número pertence a um único funcionário. |

Não existem relacionamentos **N:M** neste esquema, porque nenhuma das entidades resultantes precisa de se associar a "múltiplos do lado A para múltiplos do lado B" — todas as associações têm um lado "1" bem definido.

---

## 7. Modelo Entidade-Relacionamento (MER) final

![Modelo Entidade-Relacionamento final](MER_Funcionarios.png)

**Entidades finais:** FUNCIONARIO, CIDADE, CARGO, FUNCAO, POSTO_TRABALHO, FILHO, TELEFONE — 7 entidades, contra 1 única tabela na versão original. O ficheiro fonte do diagrama (`MER_Funcionarios.dot`, gerado com Graphviz) está disponível na pasta `/diagramas` do repositório, juntamente com esta imagem.

---

## 8. Scripts SQL

Ver ficheiro `sql/normalizacao.sql`: contém o DDL completo (`CREATE TABLE` com chaves primárias e estrangeiras), os `INSERT` com os 16 funcionários (e respetivos filhos/telefones) extraídos e limpos da tabela original, e 3 queries de exemplo com `JOIN` que reconstituem a informação original (ficha completa do funcionário, lista de filhos e lista de telefones).
