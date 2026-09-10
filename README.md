# Normalização de Base de Dados — Sistema de Gestão de Funcionários

**Universidade Licungo — Faculdade de Ciências e Tecnologias**
**Curso de Licenciatura em Informática — Trabalho II**

## Sobre o projeto

Este repositório contém o Trabalho II da disciplina, cujo objetivo é analisar uma
tabela de funcionários não normalizada (0FN) e aplicar, passo a passo, o processo
de normalização até à 4.ª Forma Normal (4FN), culminando num modelo relacional
bem desenhado, com Modelo Entidade-Relacionamento (MER) e scripts SQL.

Os dados de partida (16 funcionários, com grupos repetitivos de filhos e
telefones, e dados de morada/cargo/função não atómicos ou redundantes) estão no
ficheiro `Dados_Nao_Normalizados_Funcionarios.xlsx` fornecido pelo docente.

## Estrutura do repositório

```
.
├── documentos/
│   ├── analise_normalizacao.docx   # Documento completo: 1FN → 4FN, cardinalidades
│   └── analise_normalizacao.md     # Mesmo conteúdo, em Markdown
├── diagramas/
│   ├── MER_Funcionarios.png        # Modelo Entidade-Relacionamento final
│   └── gerar_diagrama.py           # Script (Graphviz) que gera o diagrama
├── sql/
│   └── normalizacao.sql            # DDL (CREATE TABLE), dados de exemplo e
│                                    # 3 queries com JOIN que reconstituem a
│                                    # informação original
└── README.md
```

## Resumo do trabalho

1. **Identificação dos problemas** — dados não atómicos (endereço), grupos
   repetitivos (filhos, telefones) e dependências parciais/transitivas/
   multivaloradas na tabela original.
2. **1FN** — eliminação dos grupos repetitivos, criando as tabelas `FILHO` e
   `TELEFONE`.
3. **2FN** — já satisfeita após a 1FN (chave primária simples, `BI`).
4. **3FN** — eliminação das dependências transitivas, criando `CIDADE`, `CARGO`,
   `FUNCAO` e `POSTO_TRABALHO`.
5. **4FN** — confirmação de que `FILHO` e `TELEFONE` são tabelas independentes
   (duas dependências multivaloradas sem relação entre si).
6. **Cardinalidades** — todos os relacionamentos são 1:N ou N:1; não há
   relacionamentos N:M neste esquema.
7. **MER final** — 7 entidades: `FUNCIONARIO`, `CIDADE`, `CARGO`, `FUNCAO`,
   `POSTO_TRABALHO`, `FILHO`, `TELEFONE`.
8. **SQL** — script `sql/normalizacao.sql` com o DDL completo e 3 queries de
   exemplo (com `JOIN`) que reconstituem a ficha do funcionário, a lista de
   filhos e a lista de telefones a partir do esquema normalizado.

## Como consultar

- Para a análise detalhada e justificada de cada forma normal, ver
  `documentos/analise_normalizacao.docx` (ou o `.md` equivalente).
- Para o diagrama do modelo de dados final, ver `diagramas/MER_Funcionarios.png`.
- Para testar o esquema, importar `sql/normalizacao.sql` num SGBD (testado em
  MySQL/MariaDB e SQLite; para PostgreSQL, substituir `AUTO_INCREMENT` por
  `GENERATED ALWAYS AS IDENTITY` ou `SERIAL`).

## Vídeo explicativo

Link do vídeo (YouTube, não listado): **https://youtu.be/o_u--W7lG2M?si=0XCD-4LZnRfWknfH**

## Autor

**Leyla Macuácua** — Curso de Licenciatura em Informática, Universidade Licungo
