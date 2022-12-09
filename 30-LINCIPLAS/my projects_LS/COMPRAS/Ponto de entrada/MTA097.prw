#Include "Protheus.ch"

/*
+========================================================+
|Programa: MTA097 |Autor: Antonio Carlos |Data: 29/06/05 |
+========================================================+
|Descricao: Ponto de Entrada executado na Liberacao do   |
|Pedido de Compra para envio de email ao Comprador       |
+========================================================+
|Uso: Expand Group Brasil S/A                            |
+========================================================+
*/

User Function MTA097()

Local cPedido		:= SCR->CR_NUM
Local cUser			:= RetCodUsr()
Local cAprovador	:= SCR->CR_APROV
Local dEmissao		:= SCR->CR_EMISSAO
Local cFornece		:= SC7->C7_FORNECE
Local DatHor		:= DToC(Date())+" - "+Time()
Local nValPed		:= SCR->CR_TOTAL
Local cAprov
Local nTotal		:= 0
Local _cHtm			:= ""
Local _cObs			:= ""
Local _cCondPg		:= ""
Local _cCompr		:= ""
Public _aAProv		:= {}

cFil := SM0->M0_FILIAL

If SAL->AL_NIVEL == "01"
	U_APV097("02",cPedido,.T.)
ElseIf SAL->AL_NIVEL == "02"
	U_APV097("03",cPedido,.T.)
ElseIf ( SAL->AL_NIVEL == "03" )//.And. SCR->CR_TOTAL <= GetMv("MV_VLRGER") )
	U_APV097("04",cPedido,.T.)
ElseIf ( SAL->AL_NIVEL == "04" )//.And. SCR->CR_TOTAL <= GetMv("MV_VLRGER") )
	U_APV097("05",cPedido,.T.)
ElseIf SAL->AL_NIVEL == "05"
	U_APV097("06",cPedido,.T.)
ELSE
	U_APV097("07",cPedido,.T.)
EndIf

Return(.T.)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Ponto de entrada após a liberação final do pedido - altera o status do pagamento adiantado para liberação pelo financeiro. (FIE)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MT097END
//////////////////////
_aAlias := GetArea()

DbSelectArea('FIE')
If DbSeek(SC7->C7_FILIAL + 'P' + SC7->C7_NUM,.f.)
	RecLock('FIE',.f.)
	FIE->FIE_SITUA := 'L'
	MsUnLock()
EndIf

RestArea(_aAlias)

Return


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tem a função de verificar o proximo aprovador, e se não houver, deve realizar a liberação do pedido de compras
// Thiago Queiroz - 20/01/2014
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function APV097(cNvlAp,cPedido,lBrowse)
//////////////////////
Public _cNumPed 	:= ALLTRIM(cPedido)
Public _CFILIAL 	:= IIF(lBrowse,SM0->M0_CODFIL+"-"+Alltrim(SM0->M0_FILIAL),_cFilial)
Private _xFilial	:= Substr(_cFilial,1,2)
_aAlias 			:= GetArea()

DbSelectArea("SC7")
SC7->( DbSetOrder(1) )
SC7->( DbSeek( IIF(lBROWSE,xFilial("SC7"),_xFilial)+Alltrim(cPedido) ) )

_cGrupo := SC7->C7_APROV

DbSelectArea("SY1")
SY1->( DbSetOrder(3) )
If SY1->( Dbseek(IIF(lBROWSE,xFilial("SY1"),"  ")+SC7->C7_USER) )
	
	DbSelectarea("SAL")
	SAL->( DbSetOrder(1) )
	If SAL->( DbSeek(IIF(lBROWSE,xFilial("SAL"),"  ")+IIF(EMPTY(_cGrupo),SY1->Y1_GRAPROV,_cGrupo)) )
		
		While SAL->( !Eof() ) .And. (IIF(lBROWSE,xFilial("SAL"),"  ") == SAL->AL_FILIAL) .And. (SAL->AL_COD == IIF(EMPTY(_cGrupo),SY1->Y1_GRAPROV,_cGrupo) )//SY1->Y1_GRAPROV
			
			If SAL->AL_NIVEL == cNvlAp 
		   		if u__CValAlc( SAL->AL_APROV, SAL->AL_AUTOLIM )         
					Aadd(_aAProv,{SAL->AL_USER,UsrRetMail(SAL->AL_USER)})
				Endif
			EndIf
			SAL->( Dbskip() )
			
		EndDo
		
		If !FunName(0) $ "HQCOM01/U_HQCOM01"
			IF LEN(_aAprov) > 0
				For _nI := 1 To Len(_aAprov)
					
					//U_WFPC()
					IF EMPTY(GetAdvFval("SCR","CR_USER",IIF(lBROWSE,xFilial("SCR"),_xFilial)+"PC"+SC7->C7_NUM+SPACE(44)+_aAprov[_nI][1],2))
						U_AWFPC()
						/*
						DbSelectArea("SC7")
						SC7->( DbSetOrder(1) )
						SC7->( DbSeek( xFilial("SC7")+Alltrim(cPedido) ) )
						While SC7->( !Eof() ) .And. xFilial("SC7") == SC7->C7_FILIAL .And. SC7->C7_NUM == Alltrim(cPedido)
						RecLock("SC7",.F.)
						SC7->C7_CONAPRO := "L"
						SC7->( MsUnLock() )
						SC7->( DbSkip() )
						EndDo
						*/
					ELSE
						U_WFPC()
					ENDIF
				Next _nI
				
			ELSE
				U_AWFPC()
			ENDIF
		ENDIF
	EndIf
EndIf

RestArea(_aAlias)

Return
