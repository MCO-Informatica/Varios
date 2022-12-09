#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RFATR31  ³ Autor ³   Rafael de Souza       ³ Data ³ 21/02/2011 ³±±
±±³          ³          ³       ³ MVG Consultoria Ltda    ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Relatorio de Pedido de venda em excel                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ricaelle Industria e Comercio Ltda                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR31()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo gerar planilha "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relacao de Pedidos de Venda"
Local cPict          := ""
Local titulo         := "Relacao de Pedidos de Venda"
Local nLin         	 := 80
Local imprime      	 := .T.
Local Cabec1       	 := ""
Local Cabec2       	 := ""
Local _cQuery := ""
Local _dDT
Local _cPedido :=""
Local _cCli :=""
Local _cProd :=""
Local _nPrcVen :=0
Local _nPrcTab :=0

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATR31"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private wnrel        := "RFATR31"
Private cString 	 := "SC6"
Private cPerg   	 := "FATR31"
Private nOrdem
Private _cGrupo:= ""
Private _daduser:=_grupo:={}
Private _nomeuser:=substr(cusuario,7,15)  
Private _nomeuser2:=substr(cusuario,7,06)  
psworder(2)
             	
if pswseek(_nomeuser,.t.)
        _daduser:=pswret(1)
        _grupo:=Array(len(_daduser[1,10]))
        psworder(1)
        for i:=1 to len(_daduser[1,10])
            if pswseek(_daduser[1,10,i],.f.)
               _grupo[i]:=pswret(NIL)
               _cGrupo := _grupo[i,1,2]
            endif
        next
endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aRegs := {}

AAdd(_aRegs,{cPerg,"01","Do Pedido ?     ","Do Pedido ?     ","Do Pedido ?     ","mv_ch0","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"02","Ate o Pedido ?  ","Ate o Pedido ?  ","Ate o Pedido ?  ","mv_ch0","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"03","Do Cliente ?     ","Do Cliente ?     ","Do Cliente ?  ","mv_ch0","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"04","Ate Cliente ?  ","Ate Cliente ?  ","Ate Cliente ?     ","mv_ch0","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"05","Data Inicial ?   ","Data Inicial ?   ","Data Inicial ?   ","mv_ch0","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"06","Data Final ?     ","Data Final ?     ","Data Final ?     ","mv_ch0","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"07","Cod. Tabela ?     ","Cod. Tabela ?     ","Cod. Tabela ?     ","mv_ch0","C",03,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{cPerg,"08","Gera Excel ?     ","Gera Excel ?     ","Gera Excel ?     ","mv_ch0","N",01,0,0,"C","","mv_par08","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","",""})

ValidPerg(_aRegs,cPerg)

Pergunte(cPerg,.F.)

dbSelectArea(cString)
dbSetOrder(1)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
nOrdem:= aReturn[8]



_cQuery	+=	"SELECT DISTINCT "
_cQuery	+=	"                      SC6010.C6_FILIAL, SC6010.C6_ITEM, SC6010.C6_PRODUTO, SC6010.C6_PRCVEN, "
_cQuery	+=	"                      SC6010.C6_CLI, SC6010.C6_LOJA, SC6010.C6_NUM, SC6010.C6_ENTREG, SC6010.D_E_L_E_T_ AS C6_DEL, "
_cQuery	+=	"                      DA1010.DA1_CODTAB, DA1010.DA1_CODPRO, DA1010.DA1_PRCVEN, DA1010.D_E_L_E_T_ AS DA1_DEL "
_cQuery	+=	"FROM         SC6010 INNER JOIN "
_cQuery	+=	"                      DA1010 ON SC6010.C6_PRODUTO = DA1010.DA1_CODPRO "
_cQuery	+=	"WHERE     (SC6010.D_E_L_E_T_ = '') AND (DA1010.D_E_L_E_T_ = '') AND "
_cQuery	+=	"                      (SC6010.C6_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"') AND "
_cQuery	+=	"                      (SC6010.C6_CLI BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
//_cQuery	+=	"                      (SC6010.C6_ENTREG BETWEEN '"+DTOS(MV_PAR05)+"' AND '"+DTOS(MV_PAR06)+"') AND  "
_cQuery	+=	"                      (DA1010.DA1_CODTAB BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR07+"') "
_cQuery	+=	"ORDER BY  SC6010.C6_FILIAL,  SC6010.C6_ITEM,   SC6010.C6_PRODUTO,  SC6010.C6_CLI, DA1010.DA1_CODPRO "

_cQuery	:=	ChangeQuery(_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QUERY",.T.,.T.)


dbSelectArea("QUERY")
dbGoTop()

While !Eof()
	
	_cPedido		:=	QUERY->C6_NUM
	_cCli			:=	QUERY->C6_CLI
	_cLojaCli		:=	QUERY->C6_LOJA
	_cDT			:=	QUERY->C6_ENTREG
	_cItem			:=	QUERY->C6_ITEM
	_cProd			:=	QUERY->C6_PRODUTO
	_nPrcVen		:=	QUERY->C6_PRCVEN
	_cTab			:=	QUERY->DA1_CODTAB
	_nPrcTab		:=	QUERY->DA1_PRCVEN
	
	_aDados := {}
	
	If mv_par08 == 1
		
		aAdd(_aDados,{'EMISSAO'    	,'C',08,0})
		aAdd(_aDados,{'PEDIDO'     	,'C',06,0})
		aAdd(_aDados,{'CODCLI'	   	,'C',06,0})
		aAdd(_aDados,{'CODPROD'    	,'C',15,0})
		aAdd(_aDados,{'VLPROD'     	,'N',12,2})
		aAdd(_aDados,{'VLTAB'      	,'N',12,2})
		
	EndIf
	
	If mv_par08 == 1
		TRB 		:= CriaTrab(_aDados,.T.)
		_cIndTrb  	:= CriaTrab(Nil,.F.)
	EndIf
	
	IF 	SELECT("XLS")>0
		dbSelectArea("XLS")
	Else
		dbUseArea(.T.,,TRB,"XLS",.F.,.F.)
		IndRegua("XLS",_cIndTrb,"EMISSAO",,,"")
		dbSelectArea("XLS")
	EndIf
	
	If mv_par08 == 1
		RecLock("XLS",.T.)
		If mv_par08 == 1
			XLS->EMISSAO	:= _cDT
			XLS->PEDIDO     := _cPedido
			XLS->CODCLI     := _cCli
			XLS->CODPROD     := _cProd
			XLS->VLPROD		:= _nPrcVen
			XLS->VLTAB      := _nPrcTab
			
		EndIf
		XLS->(MsUnlock())
	EndIf
	
	dbSelectArea("QUERY")
	dbSkip()
EndDo

//----> GERA PLANILHA EXCEL
If MV_PAR08 == 1
	_cArquivo := __RELDIR+"RFATR31.DBF"
	
	dbSelectArea("XLS")
	Copy To &(_cArquivo)
	
	__COPYFILE (_cArquivo,"C:\TAB\RFATR31.XLS")
	
	MSGAlert("Planilha gerada: C:\TAB\RFATR31.XLS")
	
	dbCloseArea("XLS")
EndIf

SET DEVICE TO SCREEN

MS_FLUSH()

Return()
