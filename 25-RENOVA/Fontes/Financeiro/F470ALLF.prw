#Include 'Protheus.ch'

/*Este ponto de entrada permite a sinaliza��o
de que deve ser feito o  tratamento do extrato utilizando
o filtro da filial corrente.A rotina de Extrato Bancario
disp�e de tratamentos para que a filial do SE5 n�o seja filtrada
caso quando 'SA6 exclusivo' e 'SE5 compartilhado'. Esse controle � feito
garantir a integridade do Extrato Banc�rio.No entanto,  o cliente pode
utilizar suas tabelas nessa configura��o e ainda assim ter somente 1 filial ou todos os movimentos
banc�rios na mesma filial. Para tal, foi disponibilizado um Ponto de Entrada para que possa
ser sinalizado que quer o tratamento do extrato utilizando o filtro da filial corrente.
Uso: Renova Energia
Autor: Wellington Mendes*/


User Function F470ALLF()

Local lAllfil := ParamIxb[1]

Return .T.
