#include "rwmake.ch"
#include 'MsOle.ch'
#include 'TopConn.ch'            
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rdmake    �RPMSM01   �Autor  �Cosme da Silva Nunes   �Data  �28/01/2010���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Programa para impressao da folha de rosto do projeto        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �PMS - Gestao de Projetos                                    ���
�������������������������������������������������������������������������Ĵ��
���           Atualiza�oes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���            |          |                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RPMSR01(ucAF8Prj)

//���������������������������������������������������������������������Ŀ
//�Declaracao de Variaveis                                              �
//�����������������������������������������������������������������������
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Folha de Rosto do Projeto"
Local cPict         := ""
Local titulo       	:= "Folha de Rosto do Projetos"
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Private ucProj 		:= ucAF8Prj
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nTipo       := 18
Private aReturn     := {"Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private cPerg       := PADR("PMSR01", LEN(SX1->X1_GRUPO)) //nome da pegunta do grupo de perguntas
Private nomeprog    := FunName() // Nome do programa para impressao no cabecalho
Private wnrel      	:= FunName() // Nome do arquivo usado para impressao em disco
Private cString 	:= "AF8" 

//���������������������������������������������������������������������Ŀ
//�Pergunta desabilitada                                                �
//�����������������������������������������������������������������������
//ValidPerg()
//If Pergunte(cPerg,.F.)
//	Return
//EndIf

//���������������������������������������������������������������������Ŀ
//�Monta a interface padrao com o usuario...                            �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//�Processamento. RptStatus monta janela com a regua de processamento.  �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rdmake    �RunReport �Autor  �Cosme da silva Nunes   �Data  �28/01/2010���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Funcao auxiliar chamada pela RptStatus. A funcao RptStatus  ���
���          �monta a janela com a regua de processamento.                ���
�������������������������������������������������������������������������Ĵ��
���Uso       �nomeprog                                                    ���
�������������������������������������������������������������������������Ĵ��
���           Atualiza�oes sofridas desde a constru�ao inicial            ���
�������������������������������������������������������������������������Ĵ��
���Programador �Data      �Motivo da Altera�ao                            ���
�������������������������������������������������������������������������Ĵ��
���            |          |                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//���������������������������������������������������������������������Ŀ
//�Impressao do cabecalho do relatorio...                               �
//�����������������������������������������������������������������������
If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
	nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin++
Endif

//����������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������Ŀ
//|Lay-out do relatorio                                                                                                                                                                                                        |
//|0                                                                                                   1                                                                                                   2                   |
//|0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         |
//|0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789|
//|Posicao do conteudo da variavel Cabec1                                                                                                                                                                              |
//|
//|Tipo                  ABC                                  
//|
//|Projeto	             ABC                         Gestor	                   ABC
//|
//|Indice de Natalidade	 000                         MW	                       9999999999
//|
//|Aprova��o em RD       9999999999
//|
//|Data de Inicio Prev.	 DD/MM/AAAA	                 Data entrega Aneel Prev.  DD/MM/AAAA               
//|
//|Data de Inicio Real	 DD/MM/AAAA	                 Data entrega Aneel Real   DD/MM/AAAA                	
//|
//|Or�amento Aprovado 	 R$	                         Realizado Acum.           R$                    
//|
//������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������������

dbSelectArea("AF8")
dbSetOrder(1)//AF8_FILIAL+AF8_PROJET+AF8_DESCRI
dbSeek(xFilial("AF8")+ucProj)

@nLin, 00 PSay "Tipo"
@nLin, 22 PSay AF8->AF8_XTIPO
nLin := nLin + 2 // Avanca a linha de impressao

@nLin, 00 PSay "Projeto"
@nLin, 22 PSay SubStr(AF8->AF8_DESCRI,1,40)
@nLin, 50 PSay "Gestor"
@nLin, 76 PSay AF8->AF8_GESTOR
nLin := nLin + 2 // Avanca a linha de impressao

@nLin, 00 PSay "Indice de Natalidade"
@nLin, 22 PSay AF8->AF8_INDNAT
@nLin, 50 PSay "MW"
@nLin, 76 PSay AF8->AF8_MW
nLin := nLin + 2 // Avanca a linha de impressao

@nLin, 00 PSay "Aprova��o em RD"
@nLin, 22 PSay AF8->AF8_RD
nLin := nLin + 2 // Avanca a linha de impressao

@nLin, 00 PSay "Data de Inicio Prev."
@nLin, 22 PSay AF8->AF8_DIPR
@nLin, 50 PSay "Data entrega Aneel Prev."
@nLin, 76 PSay AF8->AF8_DEAP
nLin := nLin + 2 // Avanca a linha de impressao

@nLin, 00 PSay "Data de Inicio Real"
@nLin, 22 PSay AF8->AF8_DIR
@nLin, 50 PSay "Data Entrega Aneel Real"
@nLin, 76 PSay AF8->AF8_DEAR
nLin := nLin + 2 // Avanca a linha de impressao

@nLin, 00 PSay "Or�amento Aprovado"
@nLin, 22 PSay Transform(AF8->AF8_VORAPR,"@E 99,999,999,999.99")
@nLin, 50 PSay "Realizado Acum."
@nLin, 76 PSay Transform(AF8->AF8_VRACUM,"@E 99,999,999,999.99")
nLin := nLin + 2 // Avanca a linha de impressao

roda(cbcont,cbtxt,tamanho)

//���������������������������������������������������������������������Ŀ
//�Finaliza a execucao do relatorio...                                  �
//�����������������������������������������������������������������������
Set Device To Screen

//���������������������������������������������������������������������Ŀ
//�Se impressao em disco, chama o gerenciador de impressao...           �
//�����������������������������������������������������������������������
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Rdmake    �ValidPerg �Autor  �Cosme da Silva Nunes   �Data  �28/01/2010���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Cria Pergunta no SX1                                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       �nomeprog                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg()

Local aRegs := {}
//Estrutura {Grupo	/Ordem	/Pergunta		/Pergunta Espanhol	/Pergunta Ingles	/Variavel	/Tipo	/Tamanho	/Decimal	/Presel	/GSC	/Valid	/Var01		/Def01		/DefSpa1	/DefEng1	/Cnt01	/Var02	/Def02		/DefSpa2	/DefEng2	/Cnt02	/Var03	/Def03	/DefSpa3	/DefEng3	/Cnt03	/Var04	/Def04	/DefSpa4	/DefEng4	/Cnt04	/Var05	/Def05	/DefSpa5	/DefEng5	/Cnt05	/F3		/PYME	/GRPSX6	/HELP	}
Aadd(aRegs,{cPerg	,"01"	,"Projeto De"	,"Projeto De"		,"Projeto De"		,"mv_ch1"	,"C"	, 3			,0			,0		,"G"	,""		,"mv_par01"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,"AF8"	,"S"	,""		,""		})
Aadd(aRegs,{cPerg	,"02"	,"Projeto Ate"	,"Projeto Ate"		,"Projeto Ate"		,"mv_ch2"	,"C"	, 3			,0			,0		,"G"	,""		,"mv_par02"	,""			,""			,""			,""		,""		,""			,""			,""			,""		,""		,""		,""	  		,""			,""		,""		,""		,""			,""			,""		,""		,""		,""			,""			,""		,"AF8"	,"S"	,""		,""		})

lValidPerg( aRegs )

Return()