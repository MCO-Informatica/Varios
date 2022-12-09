#INCLUDE "PROTHEUS.CH"
#Include "rwmake.ch"
User Function FA040ALT()  

Private _cAutoriz	:=	Space(15)
Private _cObserva	:=	Space(500)
Private _cHistAtu	:=	Space(200)
Private _cHistDig	:=	Space(030)
Private _cHistAnt	:=	""
Private _cSeq 		:= "00"

Private _aHistAnt	:= {}
Private _aOpc := {"PRORROGACAO","ABATIMENTO","ACRESCIMO"}
Private _cOpc := ""

dbSelectArea("SZF")
dbSetOrder(1)
If dbSeek(xFilial("SZF")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA),.F.)
	While Eof() == .f. .And. SZF->(ZF_PREFIXO+ZF_NUM+ZF_PARCELA+ZF_TIPO+ZF_CLIENTE+ZF_LOJA) == SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)

		_cSeq			:= SOMA1(_cSeq)
	
		dbSkip()
	EndDo
Else
	_cSeq	:=	SOMA1(_cSeq)
EndIf

//----> PEGA OS HISTORICOS DE ALTERACOES EM ORDEM DECRESCENTE
_cQuery	:= ""
_cQuery	+= "SELECT * FROM SZF010 "
_cQuery	+= "WHERE ZF_PREFIXO = '"+SE1->E1_PREFIXO+"' AND ZF_NUM = '"+SE1->E1_NUM+"' AND ZF_PARCELA = '"+SE1->E1_PARCELA+"' AND ZF_TIPO = '"+SE1->E1_TIPO+"' AND ZF_CLIENTE = '"+SE1->E1_CLIENTE+"' AND ZF_LOJA = '"+SE1->E1_LOJA+"' "
_cQuery	+= "ORDER BY ZF_PREFIXO,ZF_NUM,ZF_PARCELA,ZF_TIPO,ZF_CLIENTE,ZF_LOJA,ZF_SEQ DESC "

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
dbGoTop()
While Eof() == .f.

		_cHistAnt	+= TRB->ZF_OBSERVA+Space(200-Len(Alltrim(TRB->ZF_OBSERVA)))

	dbSkip()
EndDo

dbSelectArea("TRB")
dbCloseArea("TRB")

DEFINE MSDIALOG _oDlg FROM 015,015 TO 580,700 TITLE "Titulo a Receber" OF oMainWnd PIXEL

@ 020,016 SAY   "Prefixo" OF _oDlg PIXEL SIZE 030,010
@ 030,015 MSGET SE1->E1_PREFIXO  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 030,010

@ 020,051 SAY   "No Titulo" OF _oDlg PIXEL SIZE 050,010
@ 030,050 MSGET SE1->E1_NUM  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 050,010

@ 020,101 SAY   "Parcela" OF _oDlg PIXEL SIZE 010,010
@ 030,100 MSGET SE1->E1_PARCELA  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 010,010
                                                                        
@ 020,151 SAY   "Tipo" OF _oDlg PIXEL SIZE 020,010
@ 030,150 MSGET SE1->E1_TIPO  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 020,010

@ 050,016 SAY   "Cliente" OF _oDlg PIXEL SIZE 050,010
@ 060,015 MSGET SE1->E1_CLIENTE  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 050,010

@ 050,051 SAY   "Loja" OF _oDlg PIXEL SIZE 020,010
@ 060,050 MSGET SE1->E1_LOJA  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 020,010

@ 050,101 SAY   "No Cliente" OF _oDlg PIXEL SIZE 200,010
@ 060,100 MSGET SE1->E1_NOMCLI  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 200,010

@ 080,016 SAY   "Vencimento" OF _oDlg PIXEL SIZE 050,010
@ 090,015 MSGET SE1->E1_VENCTO  PICTURE "@D" WHEN .F. OF _oDlg PIXEL SIZE 050,010

@ 080,101 SAY   "Vencto Real" OF _oDlg PIXEL SIZE 050,010
@ 090,100 MSGET SE1->E1_VENCREA  PICTURE "@D" WHEN .F. OF _oDlg PIXEL SIZE 050,010

@ 080,201 SAY   "Valor" OF _oDlg PIXEL SIZE 100,010
@ 090,200 MSGET SE1->E1_VALOR  PICTURE "@E 999,999,999.99" WHEN .F. OF _oDlg PIXEL SIZE 100,010

@ 110,016 SAY   "Hist. Título" OF _oDlg PIXEL SIZE 150,010
@ 120,015 MSGET SE1->E1_HIST  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 150,010

//@ 140,191 SAY   "Ocorrencia" OF _oDlg PIXEL SIZE 038,010
//@ 150,190 MSGET SE1->E1_OCORR  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 040,010

//@ 140,016 SAY   "Data Alteracao" OF _oDlg PIXEL SIZE 050,010
//@ 150,015 MSGET dDataBase  PICTURE "@D" WHEN .F. OF _oDlg PIXEL SIZE 050,010

//@ 140,071 SAY   "Usuario" OF _oDlg PIXEL SIZE 100,010
//@ 150,070 MSGET subs(cUsuario,7,15)  PICTURE "@!" WHEN .F. OF _oDlg PIXEL SIZE 100,010

@ 110,171 SAY   "Autorizacao" OF _oDlg PIXEL SIZE 100,010
@ 120,170 MSGET _cAutoriz  PICTURE "@!" WHEN .T.  Valid BuscaUsr() OF _oDlg PIXEL SIZE 130,010
  
@ 140,016 SAY   "Motivo Alteração" OF _oDlg PIXEL SIZE 200,010
@ 150,015 ComboBox _cOpc Items _aOpc Size 050,010 OF _oDlg PIXEL

@ 140,100 SAY   "Justificativa" OF _oDlg PIXEL SIZE 200,010
@ 150,100 MSGET _cHistDig  PICTURE "@!" WHEN .T. OF _oDlg PIXEL SIZE 200,010

@ 170,016 SAY   "Últimos Históricos" OF _oDlg PIXEL SIZE 200,010

@ 180,015 GET oHist Var _cHistAnt MEMO SIZE 285,100 PIXEL OF _oDlg 
  
ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar( _oDlg, { || Processa( {|| fProcessa()},"Gravando Tabela SZF"  ),_oDlg:End()}, {||_oDlg:End()},,) CENTERED	

Return(.t.)

Static Function fProcessa()

dbSelectArea("SZF")
RecLock("SZF",.t.)
SZF->ZF_FILIAL 		:= XFILIAL('SZF')
SZF->ZF_PREFIXO 		:= SE1->E1_PREFIXO
SZF->ZF_NUM 			:= SE1->E1_NUM
SZF->ZF_PARCELA 		:= SE1->E1_PARCELA
SZF->ZF_TIPO 			:= SE1->E1_TIPO
SZF->ZF_PORTADO 		:= SE1->E1_PORTADO
SZF->ZF_AGEDEP 		:= SE1->E1_AGEDEP
SZF->ZF_CLIENTE 		:= SE1->E1_CLIENTE
SZF->ZF_LOJA 			:= SE1->E1_LOJA
SZF->ZF_NOMCLI 		:= SE1->E1_NOMCLI
SZF->ZF_EMISSAO 		:= SE1->E1_EMISSAO
SZF->ZF_VENCTO 		:= SE1->E1_VENCTO
SZF->ZF_VENCREA 		:= SE1->E1_VENCREA
SZF->ZF_VALOR 			:= SE1->E1_VALOR
SZF->ZF_NUMBCO 		:= SE1->E1_NUMBCO
SZF->ZF_NUMBOR 		:= SE1->E1_NUMBOR
SZF->ZF_DATABOR 		:= SE1->E1_DATABOR
SZF->ZF_HIST 			:= SE1->E1_HIST
SZF->ZF_SITUACA 		:= SE1->E1_SITUACA
SZF->ZF_SALDO 			:= SE1->E1_SALDO
SZF->ZF_DESCONT 		:= SE1->E1_DESCONT
SZF->ZF_MULTA 			:= SE1->E1_MULTA
SZF->ZF_JUROS 			:= SE1->E1_JUROS
SZF->ZF_OCORREN 		:= SE1->E1_OCORREN
SZF->ZF_INSTR1 		:= SE1->E1_INSTR1
SZF->ZF_INSTR2 		:= SE1->E1_INSTR2
SZF->ZF_DATA 			:= dDataBase
SZF->ZF_USUARIO 		:= Subs(cUsuario,7,15)

If Alltrim(_cOpc)$"PRORROGACAO"
	SZF->ZF_OBSERVA 		:= Dtoc(dDataBase)+" - "+Alltrim(_cOpc)+" - "+Alltrim(_cHistDig)+" - "+Upper(Alltrim(Subs(cUsuario,7,15)))+" - "+Alltrim(_cAutoriz)+" - "+"VCTO ORIG "+DTOC(SE1->E1_VENCREA)+" - "+"VCTO NOVO "+DTOC(M->E1_VENCREA)
ElseIf Alltrim(_cOpc)$"ABATIMENTO"
	SZF->ZF_OBSERVA 		:= Dtoc(dDataBase)+" - "+Alltrim(_cOpc)+" - "+Alltrim(_cHistDig)+" - "+Upper(Alltrim(Subs(cUsuario,7,15)))+" - "+Alltrim(_cAutoriz)+" - "+"ABAT R$ "+Alltrim(Transform(M->E1_DECRESC,"@E 999,999,999.99"))
ElseIf Alltrim(_cOpc)$"ACRESCIMO"
	SZF->ZF_OBSERVA 		:= Dtoc(dDataBase)+" - "+Alltrim(_cOpc)+" - "+Alltrim(_cHistDig)+" - "+Upper(Alltrim(Subs(cUsuario,7,15)))+" - "+Alltrim(_cAutoriz)+" - "+"ACRES R$ "+Alltrim(Transform(M->E1_ACRESC,"@E 999,999,999.99"))
EndIf

SZF->ZF_AUTORIZ 		:= _cAutoriz
SZF->ZF_SEQ		 		:= _cSeq           

MsUnLock()

Return

Static Function BuscaUsr()

If Empty(_cAutoriz)
   _lRetorno := .f.
    MsgBox("O usuário autorizante não foi preenchido","Valida Autorização","Stop")
Else
    _lRetorno := .t.
EndIF

SysRefresh()

Return(_lRetorno)

Return