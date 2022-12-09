#INCLUDE "rwmake.ch"
#Include "PROTHEUS.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA410LEG บAutor  ณLuiz Alberto Totalsiga    Data  07/03/12 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para alterar as cores das legendas.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ METALACRE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA410COR()   

Local aArea  := GetArea()
Local _acores := {}      
local alegend:= {} 

alegend := paramixb             

If cEmpAnt <> '01'
	Return alegend
Endif  


PROCESSA({||VEROP()},"Aguarde", "Analisando Bloqueio Cr้dito")
/*
aadd(_aCores ,{"C5_TEMOP    =='S' .AND. !(!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ))", "BR_PINK"}) 
aadd(_aCores ,{"C5_TEMOP    =='X' "                                                               , "BR_PRETO"})     

For nX:=1 To Len(alegend)
	AADD(_aCores,{alegend[nX,1],alegend[nX,2]} )
Next nX
*/
Return  alegend


Static Function VerOP()
      
local SC2T := GETNEXTALIAS()   

// LIMPA BLOQUEIO DE CREDITO
IF SELECT(SC2T) <> 0
	(SC2T)->(DBCLOSEAREA())
ENDIF   
/*
CQRY := ""
CQRY += " SELECT DISTINCT(C6_NUM) AS PEDIDO FROM "
CQRY += RETSQLNAME("SC6") + " C6 (NOLOCK) "
CQRY += ", " + RETSQLNAME("SC5") + " C5 (NOLOCK) " 
CQRY += ", " + RETSQLNAME("SC9") + " C9 (NOLOCK) " 
CQRY += " WHERE C5.D_E_L_E_T_ = ''  AND C6.D_E_L_E_T_ = '' AND C9.D_E_L_E_T_ = '' "
CQRY += " AND C6_NUM = C5_NUM AND C5_CLIENTE = C6_CLI AND C6_NUM = C9_PEDIDO AND C5_NUM = C9_PEDIDO " 
CQRY += " AND C6_PRODUTO =  C9_PRODUTO AND C6_ITEM = C9_ITEM AND C5_TEMOP = 'X' "
CQRY += " AND C9_BLCRED = '' AND C9_NFISCAL = '' AND C6_NOTA = ''  "
CQRY += " AND C5_FILIAL = '" + XFILIAL("SC5") + "' " 
CQRY += " AND C6_FILIAL = '" + XFILIAL("SC6") + "' "  
CQRY += " AND C9_FILIAL = '" + XFILIAL("SC9") + "' "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), SC2T )   

DBSELECTAREA(SC2T)
DBGOTOP()
DO WHILE !EOF()
	// Corre็ใo Limpeza Campo OP - 3L Systems - 17-01-18 - Luiz Alberto

	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+(SC2T)->PEDIDO))
		If RecLock("SC5",.f.)
			SC5->C5_TEMOP	:=	''
			SC5->(MsUnlock())
			SC5->(dbCommit())
		Endif
	Endif

	//U_UPDCAMPO('SC5','C5_TEMOP', "C5_NUM", (SC2T)->PEDIDO, '')
	DBSELECTAREA(SC2T)
	DBSKIP()
ENDDO  

IF SELECT(SC2T) <> 0
	(SC2T)->(DBCLOSEAREA())
ENDIF
       
// LIMPA TEM OP
CCQRY := ""
CQRY += " SELECT DISTINCT(C6_NUM) AS PEDIDO FROM "
CQRY += RETSQLNAME("SC6") + " C6 (NOLOCK) "
CQRY += ", " + RETSQLNAME("SC5") + " C5 (NOLOCK) " 
CQRY += " WHERE C5.D_E_L_E_T_ = ''  AND C6.D_E_L_E_T_ = '' "
CQRY += " AND C6_NUM = C5_NUM AND C5_CLIENTE = C6_CLI "
CQRY += " AND C6_NUMOP = '' AND C6_NOTA = ''  AND C5_TEMOP = 'S' "
CQRY += " AND C5_FILIAL = '" + XFILIAL("SC5") + "' " 
CQRY += " AND C6_FILIAL = '" + XFILIAL("SC6") + "' "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), SC2T )   

DBSELECTAREA(SC2T)
DBGOTOP()
DO WHILE !EOF()
	// Corre็ใo Limpeza Campo OP - 3L Systems - 17-01-18 - Luiz Alberto

	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+(SC2T)->PEDIDO))
		If RecLock("SC5",.f.)
			SC5->C5_TEMOP	:=	''
			SC5->(MsUnlock())     
			SC5->(dbCommit())
		Endif
	Endif

//	U_UPDCAMPO('SC5','C5_TEMOP', "C5_NUM", (SC2T)->PEDIDO, '')
	DBSELECTAREA(SC2T)
	DBSKIP()
ENDDO   

IF SELECT(SC2T) <> 0
	(SC2T)->(DBCLOSEAREA())
ENDIF  


// VERIFICA SE TEM OP
CQRY := ""
CQRY += " SELECT DISTINCT(C6_NUM) AS PEDIDO FROM "
CQRY += RETSQLNAME("SC6") + " C6 (NOLOCK) "
CQRY += ", " + RETSQLNAME("SC5") + " C5 (NOLOCK) " 
CQRY += " WHERE C5.D_E_L_E_T_ = ''  AND C6.D_E_L_E_T_ = '' "
CQRY += " AND C6_NUM = C5_NUM AND C5_CLIENTE = C6_CLI "
CQRY += " AND C6_NOTA = '' AND C6_NUMOP <> '' AND C5_TEMOP <> 'S' "
CQRY += " AND C5_FILIAL = '" + XFILIAL("SC5") + "' " 
CQRY += " AND C6_FILIAL = '" + XFILIAL("SC6") + "' "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), SC2T )   

DBSELECTAREA(SC2T)
DBGOTOP()
DO WHILE !EOF()
	// Corre็ใo Grava็ใo Campo OP - 3L Systems - 17-01-18 - Luiz Alberto

	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+(SC2T)->PEDIDO))
		If RecLock("SC5",.f.)
			SC5->C5_TEMOP	:=	'S'
			SC5->(MsUnlock())
			SC5->(dbCommit())
		Endif
	Endif

	//U_UPDCAMPO('SC5','C5_TEMOP', "C5_NUM", (SC2T)->PEDIDO, 'S')
	DBSELECTAREA(SC2T)
	DBSKIP()
ENDDO   
    
IF SELECT(SC2T) <> 0
	(SC2T)->(DBCLOSEAREA())
ENDIF

// VERIFICA SE TEM BLOQ CREDITO

CQRY := ""
CQRY += " SELECT DISTINCT(C6_NUM) AS PEDIDO FROM "
CQRY += RETSQLNAME("SC6") + " C6 (NOLOCK) "
CQRY += ", " + RETSQLNAME("SC5") + " C5 (NOLOCK) " 
CQRY += ", " + RETSQLNAME("SC9") + " C9 (NOLOCK) " 
CQRY += " WHERE C5.D_E_L_E_T_ = ''  AND C6.D_E_L_E_T_ = '' AND C9.D_E_L_E_T_ = '' "
CQRY += " AND C6_NUM = C5_NUM AND C5_CLIENTE = C6_CLI AND C6_NUM = C9_PEDIDO AND C5_NUM = C9_PEDIDO " 
CQRY += " AND C6_PRODUTO =  C9_PRODUTO AND C6_ITEM = C9_ITEM AND C5_TEMOP <> 'X' "
CQRY += " AND C9_BLCRED <> '' AND C9_NFISCAL = '' AND C6_NOTA = ''  "
CQRY += " AND C5_FILIAL = '" + XFILIAL("SC5") + "' " 
CQRY += " AND C6_FILIAL = '" + XFILIAL("SC6") + "' "  
CQRY += " AND C9_FILIAL = '" + XFILIAL("SC9") + "' "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), SC2T )   

DBSELECTAREA(SC2T)
DBGOTOP()
DO WHILE !EOF()
	// Corre็ใo Limpeza Campo OP - 3L Systems - 17-01-18 - Luiz Alberto

	If SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+(SC2T)->PEDIDO))
		If RecLock("SC5",.f.)
			SC5->C5_TEMOP	:=	'X'
			SC5->(MsUnlock())
			SC5->(dbCommit())
		Endif
	Endif

//	U_UPDCAMPO('SC5','C5_TEMOP', "C5_NUM", (SC2T)->PEDIDO, 'X')
	DBSELECTAREA(SC2T)
	DBSKIP()
ENDDO   
 
*/
IF SELECT(SC2T) <> 0
	(SC2T)->(DBCLOSEAREA())
ENDIF

// VERIFICA OS LIBERADOS
CQRY := ""
CQRY += " SELECT C6_NUM, C6_PRODUTO, C6_ITEM FROM "
CQRY += RETSQLNAME("SC6") + " C6 (NOLOCK) "
CQRY += ", " + RETSQLNAME("SC9") + " C9 (NOLOCK) " 
CQRY += " WHERE C9.D_E_L_E_T_ = ''  AND C6.D_E_L_E_T_ = '' "
CQRY += " AND C6_NUM = C9_PEDIDO AND C6_PRODUTO = C9_PRODUTO  "
CQRY += " AND C9_ITEM = C6_ITEM  AND C9_NFISCAL = '' AND C6_LIBERAD = ''  "
//CQRY += " AND C9_BLEST = '' AND C9_BLCRED = '' "  // APENAS PEDIDOS LIBERADOS NO ESTOQUE E NO CREDITO
CQRY += " AND C9_FILIAL = '" + XFILIAL("SC9") + "' " 
CQRY += " AND C6_FILIAL = '" + XFILIAL("SC6") + "' "
DbUseArea( .t.		, "TOPCONN"		, TcGenQry(,, cQry), SC2T )   

DBSELECTAREA(SC2T)
DBGOTOP()
DO WHILE !EOF()
	lCredito := .f.
	
	If SC9->(dbSetOrder(1), dbSeek(xFilial("SC9")+(SC2T)->C6_NUM))
		While SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == (SC2T)->C6_NUM
			If SC9->C9_BLCRED $ '01*02*04*05*06'
				lCredito := .t.
			Endif

			SC9->(dbSkip(1))
		Enddo     
	Else                       
		lCredito := .t.
	Endif
		
	If lCredito
		// Corre็ใo Limpeza Campo OP - 3L Systems - 17-01-18 - Luiz Alberto
		
		If SC6->(FieldPos("C6_ULTACAO")) > 0
			If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+(SC2T)->C6_NUM+(SC2T)->C6_ITEM+(SC2T)->C6_PRODUTO))
				If RecLock("SC6",.f.)
					SC6->C6_LIBERAD := ''
					SC6->C6_ULTACAO := 'Bloqueado Credito ' + DtoC(Date()) + ' as ' + Left(Time(),5)
					SC6->(MsUnlock())
					SC6->(dbCommit())
				Endif
			Endif
		Endif
	Else
		If SC6->(FieldPos("C6_ULTACAO")) > 0
			If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+(SC2T)->C6_NUM+(SC2T)->C6_ITEM+(SC2T)->C6_PRODUTO))
				If RecLock("SC6",.f.)
					SC6->C6_LIBERAD := 'S'
					SC6->C6_ULTACAO := 'Liberado Credito ' + DtoC(Date()) + ' as ' + Left(Time(),5)
					SC6->(MsUnlock())
					SC6->(dbCommit())
				Endif
			Endif
		Endif
	Endif
	DBSELECTAREA(SC2T)
	DBSKIP()
ENDDO   

IF SELECT(SC2T) <> 0
	(SC2T)->(DBCLOSEAREA())
ENDIF  

Return