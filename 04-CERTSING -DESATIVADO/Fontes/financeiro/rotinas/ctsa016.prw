#INCLUDE "PROTHEUS.CH"      
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTSA016   �Autor  �OPVSCA (Giovanni)   � Data �  12/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a baixa  dos titulos de cartao anteriores a 14042010���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CTSA016()

Local oDlg											// Dialog para escolha da Lista
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local nI		:= 0
Local cAux		:= ""
Local lRet		:= .F.
Local cTexto	:= ""
Local nContb	:= 0
Local nContOn	:= 0
Local bValDtCtb	:= {|dtCtb| Iif(!Empty(dtCtb),Iif(VlDtCal(dtCtb,dtCtb,2,"01","234",.T.),.T.,.F.),.F.)}
Private cSomLog	:= ""
Private lMsErroAuto := .F.
Private lMsHelpAuto := .F.
Private _dDtCtb	:= cTod("  /  /    ")


DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Baixa de titulos de Cart�es (BPAG)" PIXEL

@ 010,10 SAY "Rotina para Baixa Automatica de Titulos em Aberto BPAG " OF oDlg PIXEL
//@ 015,10 SAY "a Cart�es comde Cr�dito"

//@ 025,10 SAY "Data Contabiliza��o" OF oDlg PIXEL
//@ 025,70 MSGET _dDtCtb SIZE 40,5 OF oDlg PIXEL VALID !Empty(_dDtCtb)

@ 025,120 SAY "Somente LOG" OF oDlg PIXEL
@ 025,180 COMBOBOX oCbox var cSomLog ITEMS {"0=N�o","1=Sim"} SIZE 40,5 OF oDlg PIXEL 

@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1 //.or. !Pergunte("FIN070",.T.)
	Return(.F.)
EndIf

cFile := cGetFile("\", "Diret�rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD )
cFile		+= "CTSA016.CSV"

// Comeca o processamento de alteracao dos pedidos
If !File(cFile)
	nHandle := FCREATE(cFile,1)
Else
	While FERASE(cFile)==-1
	End
	nHandle := FCREATE(cFile,1)
Endif


Processa( { || CTS016Proc(nHandle) } )

FClose(nHandle)

MsgStop("Rotina conclu�da com sucesso."+CRLF+"Verifique log de processamento em "+cFile )

Return(.T.)



Static Function CTS016Proc(nHandle)

Local cSql
Local cBanco
Local cAgencia
Local cConta
Local nRecAtu	:= 0
Local nRectot	:= 0

cSql := " SELECT "+CRLF 
cSql += " 	SE1.R_E_C_N_O_ E1_RECNO,  "+CRLF
cSql += " 	SC5.R_E_C_N_O_ C5_RECNO,  "+CRLF
cSql += " 	E1_SALDO,  "+CRLF
cSql += " 	E1_VENCREA,  "+CRLF
cSql += " 	C5_XBANDEI  "+CRLF
cSql += " FROM  "+CRLF
cSql += " 	SC5010 SC5 LEFT JOIN SC6010 ON "+CRLF
cSql += " 	C5_FILIAL = C6_FILIAL AND "+CRLF
cSql += " 	C5_NUM = C6_NUM LEFT JOIN SE1010 SE1 ON "+CRLF
cSql += " 	E1_NUM = C6_NOTA AND "+CRLF
cSql += " 	E1_PREFIXO = 'SP'||SUBSTR(C6_SERIE,1,1) "+CRLF
cSql += " WHERE "+CRLF
//cSql += " 	C5_CHVBPAG <> '' AND "+CRLF
cSql += " 	C5_XBANDEI<> '' AND  "+CRLF
cSql += " 	SC5.D_E_L_E_T_ = ' ' AND "+CRLF
cSql += " 	SC6010.D_E_L_E_T_ = ' ' AND "+CRLF
cSql += " 	E1_FILIAL = '  ' AND "+CRLF
//cSql += " 	E1_PEDGAR <> '' AND "+CRLF
cSql += " 	E1_VENCREA<='20101231' AND "+CRLF 
cSql += " 	E1_SALDO > 0 AND  "+CRLF
cSql += " 	SE1.D_E_L_E_T_ = ' ' "+CRLF
cSql += " GROUP BY "+CRLF
cSql += " 	SE1.R_E_C_N_O_ ,  "+CRLF
cSql += " 	SC5.R_E_C_N_O_ ,  "+CRLF
cSql += " 	E1_SALDO,  "+CRLF
cSql += " 	E1_VENCREA,  "+CRLF
cSql += " 	C5_XBANDEI  "+CRLF

If select("TMPE1") > 0
	TMPE1->(DbCloseArea())				
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"TMPE1",.F.,.T.)				

TcSetField("TMPE1", "E1_SALDO", "N", TamSx3("E1_SALDO")[1], TamSx3("E1_SALDO")[2])

If TMPE1->(Eof())                 	
	cMsgLog :=" Nao foram encontrados Titulos de cartoes com vencimento real anterior a 31/12/2010 "+CRLF
	FWrite(nHandle, cMsgLog  )

EndIf

TMPE1->(DbEval({|| nRecTot++  }))

ProcRegua( nRecTot )   

TMPE1->(DbGoTop())

nRecAtu++

cMsgLog := "PedGar;Cartao;Observacao;Titulo;Valor;Data Compra;Data Baixa Titulo;Data Vencto Titulo"+CRLF
FWrite(nHandle, cMsgLog  )

While !TMPE1->(Eof())
    
	Incproc( "Baixa dos t�tulos BPAG "+AllTrim(Str(nRecAtu++))+"/"+AllTrim(Str(nRecTot))+iif(substr(cSomLog,1,1)=="0", "", " (somente LOG) ") )
	ProcessMessage()
	
	cBanco		:='000'
	cAgencia	:='00000'
	lMsErroAuto := .F.
	lMsHelpAuto := .F.

	IF AllTrim(TMPE1->C5_XBANDEI)=='AME'
		cConta		:= 'AMEX'
	ELSEIF AllTrim(TMPE1->C5_XBANDEI)=='RED'
		cConta		:= 'REDECARD'
	ELSEIF AllTrim(TMPE1->C5_XBANDEI)=='VIS'
		cConta		:= 'VISA'
	Endif

	SE1->(DbGoto(TMPE1->E1_RECNO))
	SC5->(DbGoto(TMPE1->C5_RECNO))
    
    IF !SE1->(EOF()) .And. AllTrim(TMPE1->C5_XBANDEI) $ ('AME|RED|VIS')
		nSaldo:=SE1->E1_SALDO
		dDataBaixa:=SE1->E1_VENCREA
		ndiasUteis:=0
		While ndiasUteis<2
        	dDataBaixa+=1
		    IF dDataBaixa==DataValida(dDataBaixa)
				ndiasUteis+=1		    
		    Endif
		EndDo		
        if substr(cSomLog,1,1)=="0"
			aBaixa	:=	{}          
			AADD( aBaixa, { "E1_PREFIXO" 	, SE1->E1_PREFIXO						  , Nil } )	// 01
			AADD( aBaixa, { "E1_NUM"     	, SE1->E1_NUM		 					  , Nil } )	// 02
			AADD( aBaixa, { "E1_PARCELA" 	, SE1->E1_PARCELA					 	  , Nil } )	// 03
			AADD( aBaixa, { "E1_TIPO"    	, SE1->E1_TIPO							  , Nil } )	// 04
			AADD( aBaixa, { "E1_CLIENTE"	, SE1->E1_CLIENTE						  , Nil } )	// 05
			AADD( aBaixa, { "E1_LOJA"    	, SE1->E1_LOJA							  , Nil } )	// 06
			AADD( aBaixa, { "AUTMOTBX"  	, "NOR"									  , Nil } )	// 07
			AADD( aBaixa, { "AUTBANCO"  	, PadR(cBanco  ,TamSx3("E8_BANCO"  )[1]) , Nil } )	// 08
			AADD( aBaixa, { "AUTAGENCIA"  	, PadR(cAgencia,TamSx3("E8_AGENCIA")[1]) , Nil } )	// 09
			AADD( aBaixa, { "AUTCONTA"  	, PadR(cConta  ,TamSx3("E8_CONTA"  )[1]) , Nil } )	// 10
			AADD( aBaixa, { "AUTDTBAIXA"	, dDataBaixa 							  , Nil } )	// 11
			AADD( aBaixa, { "AUTHIST"   	, "Bx. II autom(CTSA016)"				  , Nil } )	// 12 
			AADD( aBaixa, { "AUTDESCONT" 	, 0										  , Nil } )	// 13
			AADD( aBaixa, { "AUTMULTA"	 	, 0										  , Nil } )	// 14
			AADD( aBaixa, { "AUTJUROS"		, 0										  , Nil } )	// 15
			AADD( aBaixa, { "AUTOUTGAS" 	, 0										  , Nil } )	// 16
			AADD( aBaixa, { "AUTVLRPG"  	, 0        								  , Nil } )	// 17
			AADD( aBaixa, { "AUTVLRME"  	, 0										  , Nil } )	// 18
			AADD( aBaixa, { "AUTCHEQUE"  	, ""									  , Nil } )	// 19
			AADD( aBaixa, { "AUTVALREC"  	, SE1->E1_SALDO							  , Nil } )	// 20
			AADD( aBaixa, { "AUTDTCREDITO"	, dDataBaixa							  , Nil } )	// 21
			
			lMsErroAuto := .F.
			lMsHelpAuto := .F.
			
			PutMv("MV_ANTCRED","T")
			SuperGetMv("MV_ANTCRED",.T.,.T.)
			
			MSExecAuto({|x,y| Fina070(x,y)},aBaixa,3)
			
			PutMv("MV_ANTCRED","F")
	    EndIf
	               
	    
		If lMsErroAuto  
		    MOSTRAERRO()
			DisarmTransaction()
			cMsgLog := SE1->E1_PEDGAR + ";"+Alltrim(SC5->C5_XCARTAO)+";N�o foi possivel baixar titulo;"+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)+";"+Transform(nSaldo,"@E 999,999.99")+";"+DtoC(SC5->C5_EMISSAO)+";"+DtoC(dDataBaixa)+";"+DtoC(SE1->E1_VENCREA)+CRLF
			FWrite(nHandle, cMsgLog  )		
		Else
        if substr(cSomLog,1,1)=="0"
		   	cMsgLog := SE1->E1_PEDGAR + ";"+Alltrim(SC5->C5_XCARTAO)+";Titulo Baixado com Sucesso;"+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)+";"+Transform(nSaldo,"@E 999,999.99")+";"+DtoC(SC5->C5_EMISSAO)+";"+DtoC(dDataBaixa)+";"+DtoC(SE1->E1_VENCREA)+CRLF
        else
		   	cMsgLog := SE1->E1_PEDGAR + ";"+Alltrim(SC5->C5_XCARTAO)+";Simulacao de baixa de titulo;"+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)+";"+Transform(nSaldo,"@E 999,999.99")+";"+DtoC(SC5->C5_EMISSAO)+";"+DtoC(dDataBaixa)+";"+DtoC(SE1->E1_VENCREA)+CRLF
        endif
			FWrite(nHandle, cMsgLog  )
	    EndIf
	EndIf
	TMPE1->(DbSkip()) 
EndDo		   	 	

cMsgLog :=  " Fim do processamento" + CRLF
FWrite(nHandle, cMsgLog  )

Return(.T.)