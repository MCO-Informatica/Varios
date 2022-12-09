#INCLUDE "PROTHEUS.CH"
#INCLUDE "FONT.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FINA002  º Autor ³ Ricardo Felipelli  º Data ³  01/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ inclusao de movimentos bancarios - Sangria                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function UFINA002()

Local aSays        	:= {}
Local aButtons     	:= {}
Local nOpc        	:= 0
Local oDlg
Private oProcess
cCadastro    	    := "Importa Movimentacao Bancaria - Sangria"

AADD(aSays,OemToAnsi("Esta rotina realiza a importacao dos registros de movimentacao"))
AADD(aSays,OemToAnsi("bancaria do Socim para a tabela SE5 do Protheus."))
AADD(aSays,OemToAnsi("Somente os registros selecionados."))

AADD(aButtons, { 1,.T.,{|o| nOpc:= 1,If(MsgYesNo(OemToAnsi("Confirma processamento?"),OemToAnsi("Atenção")),o:oWnd:End(),nOpc:=0) } } )
AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )

FormBatch( cCadastro, aSays, aButtons,,200,405 )

If nOpc == 1
	oProcess := MsNewProcess():New({|lEnd| Integra(@lEnd)},"Processando","Transferindo...",.T.)
	oProcess:Activate()
EndIf

Return nil


Static Function Integra()

Local aArea := GetArea()
cMarca		:= GetMark()
aCampos		:= {}
aCpos		:= {}

bPesqui		:= {|| Pesqui()}
bLibera		:= {|| Libera()}

aRotina 	:= {{ "Pesquisar"	, "Eval(bPesqui)"	, 0 , 1},;
{ "Liberacao"	, "Eval(bLibera)"	, 0 , 3}}

If !__cUserId $ GetMv("MV_USRSANG") + GetMv('LA_PODER')
	MsgStop("Usuario sem permissao para utilizar a rotina!" + _cEnter + " Configure o parâmetro: MV_USRSANG" )
	Return(.F.)
	
else
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
	
	If Select("QRY") > 0
		QRY->(DbCloseArea())
	EndIf
	
	aCampos := {}
	Aadd(aCampos, {"OK"        , "C" ,  2, 0})
	Aadd(aCampos, {"A5_FILIAL" , "C" ,  2, 0})
	Aadd(aCampos, {"A5_NUMERO" , "C" ,  6, 0})
	Aadd(aCampos, {"A5_DATA"   , "D" ,  8, 0})
	Aadd(aCampos, {"A5_RECPAG" , "C" ,  1, 0})
	Aadd(aCampos, {"A5_MOEDA"  , "C" ,  2, 0})
	Aadd(aCampos, {"A5_VALOR"  , "N" , 17, 2})
	Aadd(aCampos, {"A5_SITUA"  , "C" ,  2, 0})
	Aadd(aCampos, {"A5_OPERAD" , "C" , 10, 0})
	Aadd(aCampos, {"A5_PDV"    , "C" , 10, 0})
	Aadd(aCampos, {"A5_DTDIGI" , "D" ,  8, 0})
	Aadd(aCampos, {"A5_DTDISP" , "D" ,  8, 0})
	Aadd(aCampos, {"A5_STATUS" , "C" ,  2, 0})
	
	Aadd(aCpos, {"OK"	   		,,  		})
	Aadd(aCpos, {"A5_FILIAL"	,, "Filial"	})
	Aadd(aCpos, {"A5_NUMERO"	,, "Numero"	})
	Aadd(aCpos, {"A5_VALOR"		,, "Valor"	})
	Aadd(aCpos, {"A5_DATA"		,, "Dta Operacao"	})
	Aadd(aCpos, {"A5_DATA" 		,, "Dta Digt"	})
	Aadd(aCpos, {"A5_DATA" 		,, "Dta Dispon"	})
	
	
	cTrab := CriaTrab(aCampos)
	DBCreate(cTrab, aCampos)
	DBUseArea( .T.,, cTrab, "TMP", .F., .F. )
	
	IndRegua("TMP",cTrab,"A5_FILIAL+A5_NUMERO",,,"Ordenando por Numero")
	
	GeraSql()
	
	DbSelectArea("TMP")
	DbGoTop()
	MarkBrow("TMP","OK","",aCpos,,cMarca,,,,,)
	
	RestArea(aArea)
endif
Return nil



Static Function GeraSql()

cQuery1 := " SELECT * "
cQuery1 += " FROM "+RetSqlName("PA5") +" PA5 (NOLOCK)"
cQuery1 += " WHERE "
cQuery1 += " PA5_STATUS = '' AND "
cQuery1 += " PA5_DATA > '20091231' AND "
cQuery1 += " PA5.D_E_L_E_T_ = '' "
cQuery1 += " ORDER BY PA5_FILIAL, PA5_DATA, PA5_NUMERO "

DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), "QRY", .F., .T.)

DbSelectArea("TMP")

DbSelectArea("QRY")
DbGoTop()
If !Eof()
	While !Eof()
		RecLock("TMP",.T.)
		TMP->A5_FILIAL := QRY->PA5_FILIAL
		TMP->A5_NUMERO := QRY->PA5_NUMERO
		TMP->A5_DATA   := ctod(subst(QRY->PA5_DATA,7,2)+"/"+subst(QRY->PA5_DATA,5,2)+"/"+subst(QRY->PA5_DATA,3,2))
		TMP->A5_RECPAG := 'R'   // QRY->PA5_RECPAG
		TMP->A5_MOEDA  := QRY->PA5_MOEDA
		TMP->A5_VALOR  := QRY->PA5_VALOR
		TMP->A5_SITUA  := QRY->PA5_SITUA
		TMP->A5_OPERAD := QRY->PA5_OPERAD
		TMP->A5_PDV    := QRY->PA5_PDV
		TMP->A5_DTDIGI := ctod(subst(QRY->PA5_DTDIGI,7,2)+"/"+subst(QRY->PA5_DTDIGI,5,2)+"/"+subst(QRY->PA5_DTDIGI,3,2))
		TMP->A5_DTDISP := ctod(subst(QRY->PA5_DTDISP,7,2)+"/"+subst(QRY->PA5_DTDISP,5,2)+"/"+subst(QRY->PA5_DTDISP,3,2))
		TMP->A5_STATUS := QRY->PA5_STATUS
		
		MsUnLock()
		DbSelectArea("QRY")
		DbSkip()
	EndDo
EndIf

Return nil




Static Function Pesqui()

Private cRom	:= Space(8)
Private oDlgPsq

DEFINE MSDIALOG oDlgPsq TITLE "Pesquisa" FROM 129,047 TO 250,280 PIXEL

@ 08,20 SAY OemToAnsi("Filial+Numero")	PIXEL OF oDlgPsq
@ 06,50 MSGET oRom VAR cRom PICTURE "@!"	PIXEL OF oDlgPsq
@ 30,20 BUTTON "Ok"  		SIZE 31,10 ACTION PsqRom()			PIXEL OF oDlgPsq
@ 30,70 BUTTON "Cancela"	SIZE 30,10 ACTION oDlgPsq:End()		PIXEL OF oDlgPsq

ACTIVATE MSDIALOG oDlgPsq CENTERED
Return nil


Static Function PsqRom()

DbSelectArea("TMP")
IndRegua("TMP",cTrab,"A5_FILIAL+A5_NUMERO",,,"Ordenando por Numeros")
If !DbSeek(cRom,.F.)
	MsgStop("Nao encontrado!")
EndIf
MarkBRefresh()
oDlgPsq:End()

Return(Nil)



Static Function Libera()

Local aArea := GetArea()

// PEDIR PRO USUARIO A DATA QUE DESEJA UTILIZAR NA DATA DO EXTRATO.

Private cPerg := Padr("FATA02",len(SX1->X1_GRUPO)," ")
_pergunt()

If !Pergunte(cPerg,.T.)
	Return
Endif

dbselectarea("SM0")
SM0->(dbsetorder(1))
SM0->(dbgotop())

DbSelectArea("TMP")
DbGoTop()
While !Eof()
	
	If !Marked("OK")
		DbSelectArea("TMP")
		DbSkip()
		Loop
	EndIf
	
	MsAguarde({|lEnd| },"Aguarde...","Liberando Movimento nro. "+Alltrim(TMP->A5_NUMERO),.T.)
	
	Begin Transaction
	
	SE5->(DbSetOrder(4))
	//E5_FILIAL+E5_NATUREZ+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+DTOS(E5_DTDIGIT)+E5_RECPAG+E5_CLIFOR+E5_LOJA
	//                          --FILIAL------ --Natureza--------------------------       -Prefixo  ---NUMERO---- -Parcela -Tipo  --DATA DIGIT --  --REC/PAG
	lGrava := !SE5->(DbSeek(TMP->A5_FILIAL+Iif(TMP->A5_RECPAG=="P","SANGRIA","TROCO") + " "   + TMP->A5_NUMERO + " " + " "  + dtos(TMP->A5_DTDIGI) + TMP->A5_RECPAG))
	
	SM0->(dbseek("01"+TMP->A5_FILIAL))
	
	RecLock("SE5",lGrava)
	
	SE5->E5_FILIAL 	    := TMP->A5_FILIAL
	SE5->E5_NUMERO      := TMP->A5_NUMERO
	SE5->E5_PARCELA	    :=	" "
	SE5->E5_DATA 		:= MV_PAR01  // STOD(TMP->PA5_DATA)
	SE5->E5_DTDIGIT 	:= MV_PAR01  //STOD(TMP->PA5_DATA)
	SE5->E5_DTDISPO 	:= MV_PAR01  //STOD(TMP->PA5_DATA)
	SE5->E5_RECPAG   	:= TMP->A5_RECPAG
	SE5->E5_MOEDA 		:= TMP->A5_MOEDA
	SE5->E5_TIPO 		:= " "
	SE5->E5_VALOR 		:= TMP->A5_VALOR
	SE5->E5_SITUA 		:= TMP->A5_SITUA
	SE5->E5_PREFIXO 	:= "" //NAO PREENCHER POR ENQUANTO "If(_lAppend,_cSerie,_cSerieAnt)"})
	SE5->E5_BANCO 		:= MV_PAR02
	SE5->E5_AGENCIA 	:= MV_PAR03
	SE5->E5_CONTA 		:= MV_PAR04
	SE5->E5_HISTOR   	:= Iif(TMP->A5_RECPAG=="P","PAGAMENTO VIA SANGRIA DO CAIXA (FFX)  ","SANGRIA PARA ABASTECIMENTO DO FUNDO FIXO")
	SE5->E5_TIPODOC 	:= "TR"
	//		SE5->E5_BENEF 		:= "LASELVA"
	SE5->E5_BENEF       := SM0->M0_NOME
	SE5->E5_CLIFOR		:= "      "
	SE5->E5_LOJA		:= "  "
	SE5->E5_SEQ			:= "  "
	SE5->E5_NATUREZ 	:= Iif(TMP->A5_RECPAG=="P","SANGRIA","TROCO")
	SE5->E5_DOCUMEN 	:= TMP->A5_FILIAL+'-'+SM0->M0_NOME  // CONFORME SOLICITACAO DO MARCELO EM 28/07/09
	//  	SE5->E5_DEBITO
	
	//KK
	SE5->(MsUnlock())
	
	DbSelectArea("PA5")
	PA5->(DbSetOrder(1))
	
	PA5->(DbSeek(TMP->A5_FILIAL+ dtos(TMP->A5_DATA)+ TMP->A5_OPERAD+ TMP->A5_PDV+ TMP->A5_RECPAG+ TMP->A5_NUMERO))
	IF PA5->(FOUND())
		RecLock("PA5",.F.)
		PA5->PA5_STATUS := "TX"
		MsUnLock()
		
		RecLock("TMP",.F.)
		TMP->(DBDELETE())
		MsUnLock()
		
	endif
	
	End Transaction
	
	tmp->(dbskip())
EndDo

RestArea(aArea)

Return NIL


/*

Static Function LibRom(cNumRom)

Local aArea			:= GetArea()
Local nCont			:= 0
Local nQtde			:= 0
Local nPrcTot		:= 0
Local nRegDiv		:= 0
Local cUpdPA6		:= " "
Local cUpdPA7		:= " "
Local _lInclui		:= .F.
Local _aIteDiv 		:= {}
Private _aCabPv		:= {}
Private _aItemTemp 	:= {}
Private _aItemPv	:= {}
Private lMsErroAuto	:= .F.

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(DbSeek(xFilial("SC5")+Substr(cNumRom,1,6)))

_aCabPv	:= {{"C5_FILIAL"	,	xFilial("SC5")	,Nil},;
{"C5_NUM"		,   SC5->C5_NUM					,Nil},;
{"C5_TIPO"		,   SC5->C5_TIPO	  			,Nil},;
{"C5_CLIENTE"	,	SC5->C5_CLIENTE				,Nil},;
{"C5_LOJACLI"	,	SC5->C5_LOJACLI				,Nil},;
{"C5_TIPOCLI"	,	SC5->C5_TIPOCLI				,Nil},;
{"C5_TRANSP"	,	SC5->C5_TRANSP	  			,Nil},;
{"C5_TPFRETE"	,	SC5->C5_TPFRETE				,Nil},;
{"C5_MOEDA"		,	SC5->C5_MOEDA				,Nil},;
{"C5_CONDPAG"	,	SC5->C5_CONDPAG				,Nil},;
{"C5_EMISSAO"	,	SC5->C5_EMISSAO	 	  	 	,Nil},;
{"C5_VEND1"		,	SC5->C5_VEND1				,Nil}}

DbSelectArea("PA6")
PA6->(DbSetOrder(1))
PA6->(DbSeek(xFilial("PA6")+cNumRom))

'DbSelectArea("PA7")
PA7->(DbSetOrder(2))
PA7->(DbSeek(xFilial("PA7")+cNumRom))

While PA7->(!Eof()) .And. PA7->PA7_NUMROM == cNumRom
RestArea(aArea)
enddo
Return nil


*/

*****
Static function _pergunt()
**************************

_Ordem := 1
_param := '1'

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Data para baixa    ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "D"
SX1->X1_TAMANHO := 8
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)


dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Banco Portador     ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 3
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "SEE"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Agencia            ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 5
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "SEE"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cPerg+strzero(_ordem,2))
If Eof()
	RecLock("SX1",.T.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := strzero(_ordem,2)
Else
	RecLock("SX1",.F.)
End
SX1->X1_PERGUNT := "Conta Corrente   ?"
SX1->X1_VARIAVL := "mv_ch"+_param
SX1->X1_TIPO    := "C"
SX1->X1_TAMANHO := 10
SX1->X1_DECIMAL := 0
SX1->X1_GSC     := "G"
SX1->X1_VAR01   := "mv_par" + strzero(_ordem,2)
SX1->X1_F3      := "SEE"
MsUnLock()
dbCommit()
_Ordem++
_param := Soma1(_param)

Return nil
