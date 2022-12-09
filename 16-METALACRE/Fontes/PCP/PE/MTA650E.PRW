#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "MsgOpManual.ch"
#INCLUDE "RWMAKE.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650E   ºAutor  ³Bruno Daniel Abrigo º Data ³  29/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apos deletar o registro do SC2 (OP)						  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA650E() 
Local aAreaSC2    := SC2->(GetArea())
Local aAreaSC5    := SC5->(GetArea())
Local aAreaSC6    := SC6->(GetArea())
Local aAreaSC9    := SC9->(GetArea())
Local aAreaSB1    := SB1->(GetArea())
Local lRet:=.T. 
LOCAL LRES := .T. 
LOCAL CQRYS := "" 

Local cNumOPx := ALLTRIM(SC2->C2_NUM)  // PEGA O NUMERO DA OP QUE ESTA SENDO EXCLUIDA
Local cItem   := ALLTRIM(SC2->C2_ITEM) // PEGA O ITEM DA OP
Local cProd   := ALLTRIM(SC2->C2_PRODUTO)  // PEGA O PRODUTO
Local cSeq    := ALLTRIM(SC2->C2_SEQUEN)  // PEGA A SEQUENCIA
Local cProdx  := SUBSTR(cProd, 1,1) // PEGA A PRIMEIRA LETRA DO PRODUTO PRA SABER SE EH UM PA
Local cQryx   := ""

Local cNumOPZ := ALLTRIM(SC2->C2_NUM)   // TRECHO DE CODIGO PARA VOLTAR A LEGENDA  - MATEUS HENGLE - 22-04-14

// TRECHO DE CODIGO DESENVOLVIDO POR MATEUS HENGLE - 22/07/13

IF cProdx == 'L' .AND. cSeq == '001'  // SE ESTIVER DELETANDO UM LACRE ELE ENTRA NA ROTINA, SENAO RETORNA .T.
	
	cQryx := " SELECT C2_NUM, C2_QUJE, C2_PRODUTO, C2_SEQUEN "
	cQryx += " FROM "+RETSQLNAME("SC2")+" SC2"
	cQryx += " WHERE C2_NUM = '"+cNumOPx+"'"
	cQryx += " AND C2_FILIAL = '"+xFilial("SC2")+"'"
	cQryx += " AND C2_ITEM = '"+cItem+"'"
	cQryx += " AND C2_SEQUEN <> '"+cSeq+"'"
	cQryx += " AND C2_QUJE <> 0 "
	cQryx += " AND D_E_L_E_T_='' " // TRAZ TUDO QUE SE REFERE A OP DELETADA, SE TRAZER ALGUMA COISA EH PORQUE TEM OP PRA SER BAIXADA
	
	TCQUERY cQryx New Alias "TRX1"

	Count To nReg
	
	TRX1->(dbCloseArea())
	
	If !Empty(nReg)
		ALERT("Favor verificar se existe apontamento para as OPs filhas, estornar primeiro os apontamentos e depois excluir a OP Pai !")
		lRes := .F.
		RestArea(aAreaSC2)
		RestArea(aAreaSC5)
		RestArea(aAreaSC6)
		RestArea(aAreaSC9)
		RestArea(aAreaSB1)
		Return(lRes)
	ENDIF
	
ENDIF

U_CargaPed(SC2->C2_NUM) // Ajusta Saldo Carga Fabrica Producao

// FIM DO TRECHO DE CODIGO DESENVOLVIDO POR MATEUS HENGLE
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Bruno Abrigo em 31.05.12
If SC2->C2_XOP#'2'.AND. !Empty(Alltrim(SC2->C2_XLACRE ))
	fSeekLacre()// Bruno ABrigo em 04.06.12 
	lres := .T.
Else
	If !Empty(Alltrim(SC2->C2_XLACRE ))
		LRES := Ajuste(@lRet) 
	Else
		Msginfo("OP sem personalização será excluida normalmente!","Atenção. . . ")
	Endif
Endif

// Se Passou por Todas as Validações então limpa Pedido - Luiz Alberto 27-11-14
If lRes	
	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+cNumOPZ)) .And. SC5->(FieldPos("C5_TEMOP")) > 0
		If RecLock("SC5",.f.)
			SC5->C5_TEMOP	:= ''
			SC5->C5_LIBEROK	:= ''
			SC5->(MsUnlock())
		Endif
	Endif                  

	// Limpa OP no Atendimento CALL CENTER - Luiz Alberto = 23-06-15
	
	If SUB->(dbSetOrder(3), dbSeek(xFilial("SUB")+cNumOPx+cItem))
		If RecLock("SUB",.f.)
			SUB->UB_NUMOP	:=	''
			SUB->UB_ITEMOP	:=	''
			SUB->(MsUnlock())
		Endif
	Endif
Endif


If !Empty(SC2->C2_XFORNEC) .And. !Empty(SC2->C2_XPRSERV) .And. SC2->C2_SEQUEN = '001'
	// Ordem de Produção Beneficiamento, gera previas no contas a pagar
	
	cCond 		:= 	SC2->C2_XCONDPG
	cFornece	:=	SC2->C2_XFORNEC
	cLoja		:=	SC2->C2_XLOJA
	cDocto		:=	PadL(AllTrim(SC2->C2_NUM)+SC2->C2_ITEM,9,'0')
	nTotal		:=	Round(SC2->C2_QUANT * SC2->C2_XPRSERV,2)
	dDtPrevi	:=	SC2->C2_DATPRF
	
	// Exclui Todos os Titulos Provisorios do Pedido

	If SE2->(dbSetOrder(1), dbSeek(xFilial("SE2")+'PRE'+cDocto))
		While SE2->(!Eof()) .And. SE2->E2_FILIAL == xFilial("SE2") .And. SE2->E2_NUM == cDocto
			If Alltrim(SE2->E2_TIPO) $ 'PR*PRE' .And. SE2->E2_FORNECE == cFornece .And. SE2->E2_LOJA == cLoja
				If RecLock("SE2",.f.)
					SE2->(dbDelete())
					SE2->(MsUnlock())
				Endif
			Endif
				
			SE2->(dbSkip(1))
		Enddo
	Endif
Endif

RestArea(aAreaSC2)
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSB1)
Return(lReS)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650E   ºAutor  ³Microsiga           º Data ³  05/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Ajuste(lRet)
Local cQry			:=''
Local aAreaSC2  	:= SC2->(GetArea())
Local nCont:=0
Local _cChave:=SC2->C2_XLACRE+SC2->C2_NUM+SC2->C2_ITEM
Local lOk // Bruno Abrigo em 20-08-12
Local nRecno
Local _nItens:=0
LOCAL LPODE := .t.
local lCopy := .F.
local recZ01 

// pega o recno da Z01 DA OP QUE ESTA SENDO EXCLUIDA
cQry:= "SELECT (Z01.R_E_C_N_O_) FROM "+RetSqlName("Z01")+" Z01 WITH(NOLOCK)"
cQry+= " LEFT OUTER JOIN "+RetSqlName("SC2")+" SC2 WITH(NOLOCK) ON C2_FILIAL = Z01.Z01_FILIAL AND C2_NUM = Z01_PV "
cQry+= " AND C2_ITEM = Z01_ITEMPV AND SC2.D_E_L_E_T_ <> '*' "+CRLF
cQry+= " LEFT OUTER JOIN "+RetSqlName("SC6")+" SC6 WITH(NOLOCK) ON C6_FILIAL = Z01.Z01_FILIAL AND C2_NUM = Z01_PV "
cQry+= " AND C6_ITEM = Z01_ITEMPV AND SC6.D_E_L_E_T_ <> '*' "+CRLF
cQry+= " WHERE Z01_COD = '"+Substr(_cChave,1,9) +"' "+CRLF
CQRY+= " AND Z01_OP = '" + SC2->C2_NUM + "' " +CRLF  
CQRY+= " GROUP BY  Z01.R_E_C_N_O_ "+CRLF   
cQry+= " ORDER BY Z01.R_E_C_N_O_ "+CRLF

TcQuery cQry New Alias "TRB"
DbSelectArea("TRB")
TRB->(DbGoTop())

// Verifica se existem pedidos superiores. . .
If TRB->(!EOF())
	While TRB->(!EOF())		
		RECZ01:= TRB->R_E_C_N_O_
		TRB->(DbSkip(1))
	Enddo
Endif

TRB->(dbCloseArea())


If Empty(RECZ01)
	Return .t.
Endif

// Bruno Abrigo em 20-08-12    verifica pedido superior com status = 1
cQry:= "SELECT Z01_COD,Z01_PV, Z01_ITEMPV,Z01.R_E_C_N_O_ FROM "+RetSqlName("Z01")+" Z01 WITH(NOLOCK)"
cQry+= " LEFT OUTER JOIN "+RetSqlName("SC2")+" SC2 WITH(NOLOCK) ON C2_FILIAL = Z01.Z01_FILIAL AND C2_NUM = Z01_PV "
cQry+= " AND C2_ITEM = Z01_ITEMPV AND SC2.D_E_L_E_T_ <> '*' "+CRLF
cQry+= " LEFT OUTER JOIN "+RetSqlName("SC6")+" SC6 WITH(NOLOCK) ON C6_FILIAL = Z01.Z01_FILIAL AND C2_NUM = Z01_PV "
cQry+= " AND C6_ITEM = Z01_ITEMPV AND SC6.D_E_L_E_T_ <> '*' "+CRLF
cQry+= " WHERE Z01_COD = '"+Substr(_cChave,1,9) +"' "+CRLF
CQRY+= " AND Z01_COPIA = '' " +CRLF        
CQRY+= " AND Z01_STAT= '1'  "
CQRY+= " AND Z01.R_E_C_N_O_ > " + ALLTRIM(STR(RECZ01)) + " 
cQry+= "   AND Z01.D_E_L_E_T_ <> '*' "+CRLF
cQry+= " GROUP BY Z01_COD,Z01_PV, Z01_ITEMPV, Z01.R_E_C_N_O_ "+CRLF
cQry+= " ORDER BY Z01.R_E_C_N_O_ "+CRLF

TcQuery cQry New Alias "TRB"

lOk := .f.

DbSelectArea("TRB")
TRB->(DbGoTop())

// Verifica se existem pedidos superiores. . .
If TRB->(!EOF())
	nRecno:= 0
	While TRB->(!EOF())		
/*
		if SC2->C2_NUM == TRB->Z01_PV //Val(Right(TRB->Z01_PV,len(TRB->Z01_PV)-1)) > Val(Right(SC2->C2_NUM,len(SC2->C2_NUM)-1))
			nRecno:= TRB->R_E_C_N_O_
		Endif
*/		
//		If nRecno > 0
			If TRB->R_E_C_N_O_ > RECZ01
				lOk := .t.
				Exit
			Endif
//		Endif
		_nItens++
		TRB->(DbSkip(1))
		loop
	Enddo
Endif

TRB->(dbCloseArea())

//  possui OPs\Pedidos superiores. . .
If lOk 
		cmsg := "Atenção existem pedidos (s) com sequencia superior em aberto, "
		cMsg += "para retornar a numeração exclua o pedido antes de excluir a OP. Para ajustar a numeração exclua o pedido superior em aberto"
		msgAlert(cmsg)
		lpode:=.F.
		Return(lpode)
Else         
	// AQUI VERIFICA SE TEM PEDIDOS SUPERIORES EM PRODUCAO.
	cQry:= "SELECT Z01_COD,Z01_PV, Z01_ITEMPV,Z01.R_E_C_N_O_ FROM "+RetSqlName("Z01")+" Z01 WITH(NOLOCK)"
	cQry+= " LEFT OUTER JOIN "+RetSqlName("SC2")+" SC2 WITH(NOLOCK) ON C2_FILIAL = Z01.Z01_FILIAL AND C2_NUM = Z01_PV "
	cQry+= " AND C2_ITEM = Z01_ITEMPV AND SC2.D_E_L_E_T_ <> '*' "+CRLF
	cQry+= " LEFT OUTER JOIN "+RetSqlName("SC6")+" SC6 WITH(NOLOCK) ON C6_FILIAL = Z01.Z01_FILIAL AND C2_NUM = Z01_PV "
	cQry+= " AND C6_ITEM = Z01_ITEMPV AND SC6.D_E_L_E_T_ <> '*' "+CRLF
	cQry+= " WHERE Z01_COD = '"+Substr(_cChave,1,9) +"' "+CRLF
	CQRY+= " AND Z01_COPIA = '' " +CRLF        
	CQRY+= " AND Z01_STAT > '1' " +CRLF                    
	CQRY+= " AND Z01.R_E_C_N_O_ > " + ALLTRIM(STR(RECZ01)) + " 	
	cQry+= "   AND Z01.D_E_L_E_T_ <> '*' "+CRLF
	cQry+= " GROUP BY Z01_COD,Z01_PV, Z01_ITEMPV, Z01.R_E_C_N_O_ "+CRLF
	cQry+= " ORDER BY Z01.R_E_C_N_O_ "+CRLF
		
		TcQuery cQry New Alias "TRB"
		
		lOk := .f.
		
		DbSelectArea("TRB")
		TRB->(DbGoTop())
		
		// Verifica se existem pedidos superiores. . .
		If TRB->(!EOF())
			nRecno:= 0
			While TRB->(!EOF())		
				If TRB->R_E_C_N_O_ > RECZ01
					lOk := .t.
					Exit
				Endif
				_nItens++
				TRB->(DbSkip(1))
				loop
			Enddo
		Endif
		
	  		if SELECT("TRB") > 0
		    	TRB->(dbCloseArea())
		   ENDIF
		
		//  possui OPs\Pedidos superiores COM STATUS EM PRODUCAO
		If lOk 
			CMSG := "Atenção existem  Pedidos (s) com sequencia superior "
			CMSG += " em produção, deseja prosseguir? A numeração não será corrigida. Para corrigir a numeração estorne o registro posterior"
			IF MSGYESNO(CMSG)	
	        	dbSelectAREA("Z01")
	        	DBSETORDER(2)
	        	IF DBSEEK(XFILIAL("Z01") + SC2->C2_NUM )
 //	        		DO WHILE !EOF() .AND. SC2->C2_NUM == Z01->Z01_
	        		RECLOCK("Z01",.F.)
	        			Z01->(DBDELETE())
	        		Z01->(MSUNLOCK())
	        		lPode := .T.
	        	ENDIF        
	        ELSE
	        	lPode := .F.	
	  		ENDIF    
	  		if SELECT("TRB") > 0
		    	TRB->(dbCloseArea())
		   ENDIF
	    ELSE	
			if msgyesno("Deseja confirmar a Exclusão da Ordem de Producao?")
				fReprocessa(_cChave,_nItens)                                
				lPode := .T.
			else
				lpode := .f. 
		  		if SELECT("TRB") > 0
			    	TRB->(dbCloseArea())
			   ENDIF
				return (lpode)
			endif  
	  		if SELECT("TRB") > 0
		    	TRB->(dbCloseArea())
		   ENDIF
		ENDIF
Endif

RestArea(aAreaSC2)
Return(Lpode)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650E   ºAutor  ³Microsiga           º Data ³  09/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fReprocessa(_cChave,_nItens)
Local cQry 		:= " "
Local nLACRE	:=0
Local aAreaZ00
Local _aAreaZ01

DbSelectArea("Z00")
DBSelectArea("Z01")// Bruno ABrigo em 04.06.12

Z00->(DBSetOrder(1))
Z01->(dbSetOrder(1))

If !Z01->(dbSeek(xFilial("Z01")+_cChave ))
	Return  .F.
Else
	_aAreaZ01	:=Z01->(GetArea())
	Z01->(RecLock("Z01",.F.))
	Z01->(DBDelete())// Exclui o registro - Bruno Abrigo em 10/09/12
	Z01->(Msunlock())
	RestArea(_aAreaZ01)
Endif

If !Z00->(dbSeek(xFilial("Z00")+Z01->Z01_COD )) // Senao econtrar registro na tabela Z00 retorna FALSO
	Return .F.
Endif



cQry+= " SELECT TOP 1 R_E_C_N_O_, Z01_FIM FROM Z01010 WITH(NOLOCK) "+CRLF
cQry+= "  WHERE D_E_L_E_T_ <> '*' AND Z01_COD = '"+ Z01->Z01_COD +"'  ORDER BY Z01_FIM DESC "+CRLF

TCQuery cQry New Alias "TRB"
DbSelectArea("TRB")
TRB->(DBGotop())

If TRB->(!Eof())
	nLACRE:= TRB->Z01_FIM + 1
Else
	nLACRE:= Z00->Z00_LACINI
Endif
aAreaZ00	:=Z01->(GetArea())
Z00->(RecLock("Z00",.F.))
Z00->Z00_LACRE	:=	nLACRE
Z00->(Msunlock())

//U_ChkLacre(Z00->Z00_COD)

RestArea(aAreaZ00)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA650E   ºAutor  ³Microsiga           º Data ³  06/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Se o status for igual a diferente de OP manual estorna o   º±±
±±º          ³ status de 4 pra 1                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Metalacre                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fSeekLacre()             

Local _cChave	:= Alltrim(SC2->C2_XLACRE)+Alltrim(SC2->C2_NUM)+Alltrim(SC2->C2_ITEM)
Local cQry		:= " "
Local aAreaZ01

DBSelectArea("Z01")// Bruno ABrigo em 04.06.12
Z01->(dbSetOrder(1))
If Z01->(dbSeek(xFilial("Z01")+_cChave ))
	aAreaZ01:=Z01->(GetArea())
	Z01->(RecLock("Z01",.F.))
		Z01->Z01_STAT	:='1'
		Z01->Z01_OP		:=''
	Z01->(MsUnlock())
	RestArea(aAreaZ01)
Endif

Return 


