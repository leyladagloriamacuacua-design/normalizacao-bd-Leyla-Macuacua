import graphviz

g = graphviz.Digraph('MER', format='png')
g.attr(rankdir='LR', splines='ortho', fontname='Helvetica', bgcolor='white')
g.attr('node', shape='plaintext', fontname='Helvetica')
g.attr('edge', fontname='Helvetica', fontsize='10', color='#444444')

def entity(name, title, pk_rows, fk_rows, attr_rows):
    rows = ''
    for r in pk_rows:
        rows += f'<TR><TD ALIGN="LEFT"><U><B>{r}</B></U></TD></TR>'
    for r in fk_rows:
        rows += f'<TR><TD ALIGN="LEFT"><I>{r}</I></TD></TR>'
    for r in attr_rows:
        rows += f'<TR><TD ALIGN="LEFT">{r}</TD></TR>'
    html = f'''<
    <TABLE BORDER="1" CELLBORDER="0" CELLSPACING="0" CELLPADDING="4">
    <TR><TD BGCOLOR="#2c3e50"><FONT COLOR="white"><B>{title}</B></FONT></TD></TR>
    {rows}
    </TABLE>
    >'''
    g.node(name, label=html)

entity('FUNCIONARIO', 'FUNCIONARIO',
       ['BI (PK)'],
       ['cod_cidade (FK)', 'cod_cargo (FK)', 'cod_funcao (FK)', 'cod_posto (FK)'],
       ['nome', 'data_nasc', 'nuit', 'email', 'rua', 'numero_porta', 'bairro', 'data_admissao'])

entity('CIDADE', 'CIDADE',
       ['cod_cidade (PK)'],
       [],
       ['nome_cidade', 'provincia', 'pais'])

entity('CARGO', 'CARGO',
       ['cod_cargo (PK)'],
       [],
       ['descricao_cargo'])

entity('FUNCAO', 'FUNCAO',
       ['cod_funcao (PK)'],
       [],
       ['descricao_funcao'])

entity('POSTO_TRABALHO', 'POSTO_TRABALHO',
       ['cod_posto (PK)'],
       ['cod_cidade (FK)'],
       ['nome_posto'])

entity('FILHO', 'FILHO',
       ['id_filho (PK)'],
       ['bi_funcionario (FK)'],
       ['nome_filho'])

entity('TELEFONE', 'TELEFONE',
       ['id_telefone (PK)'],
       ['bi_funcionario (FK)'],
       ['numero_telefone'])

# Relationships with cardinalities
g.edge('FUNCIONARIO', 'CIDADE', label='reside em', taillabel='N', headlabel='1')
g.edge('FUNCIONARIO', 'CARGO', label='ocupa', taillabel='N', headlabel='1')
g.edge('FUNCIONARIO', 'FUNCAO', label='desempenha', taillabel='N', headlabel='1')
g.edge('FUNCIONARIO', 'POSTO_TRABALHO', label='trabalha em', taillabel='N', headlabel='1')
g.edge('POSTO_TRABALHO', 'CIDADE', label='localizado em', taillabel='N', headlabel='1')
g.edge('FILHO', 'FUNCIONARIO', label='filho de', taillabel='N', headlabel='1')
g.edge('TELEFONE', 'FUNCIONARIO', label='pertence a', taillabel='N', headlabel='1')

g.render('MER_Funcionarios', cleanup=True)
print("done")
