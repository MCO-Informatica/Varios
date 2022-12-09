#INCLUDE "topconn.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RQUA007  º Autor ³ JAR                º Data ³ 30/09/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ ESPECIFICAÇÃO DE PRODUTO                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MAKENI                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RQUA007()

	Local cCodProd := SPACE(15)
	Local cLote := space(6)    
	Local oDlg
	Local nOpc  
	Local cQuery

	Static oDlg
	Static oButton1
	Static oButton2
	Static oGetCP
	Static oSay1
	Static oSay2

	Local nOpc := 1

	//oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "RQUA007" , __cUserID )

	while nOpc == 1

		DEFINE MSDIALOG oDlg TITLE "Especificação de Produto" FROM 000, 000  TO 200, 300 COLORS 0, 16777215 PIXEL

		@ 032, 016 MSGET oGetCP VAR cCodProd SIZE 060, 009 OF oDlg COLORS 0, 16777215 PIXEL F3 "SB1"

		DEFINE SBUTTON FROM 029, 106 TYPE 01 ENABLE OF oDlg ACTION (nOpc := 1, oDlg:End())
		DEFINE SBUTTON FROM 049, 107 TYPE 02 ENABLE OF oDlg ACTION (nOpc := 0, oDlg:End())

		@ 022, 015 SAY oSay1 PROMPT "Produto:" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL

		ACTIVATE MSDIALOG oDlg

		if nOpc == 1          

			Processa( { || U_RQ4Proc(cCodProd) }, "Gerando Especificação de Produto..." )

		endif 

	enddo


Return



User function RQ4Proc( cCodProd )

	Local cQuery
	Local aEnsaios := {}
	Local nPosEns                                        
	Local cRev
	Local cDtVige

	Local cProduto := AllTrim( Posicione("SB1",1,xFilial("SB1") + cCodProd,"B1_DESC") )

	// busca revisao e data vigencia
	cQuery := "SELECT QE6_REVI, QE6_DTINI FROM " + RetSQLName( "QE6" ) + " QE6 " 
	cQuery += " WHERE QE6_FILIAL = '" + xFilial( "QE6" ) + "' "
	cQuery += "   AND QE6_PRODUT = '" + cCodProd + "' "
	cQuery += "   AND QE6_SITREV = '0' "
	cQuery += "   AND QE6.D_E_L_E_T_ = ' '    

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"Itens",.F.,.T.)

	if !Itens->( eof() )  
		cRev 	:= Itens->QE6_REVI
		cDtVige	:= Substr(Itens->QE6_DTINI,7,2) + "/" + Substr(Itens->QE6_DTINI,5,2) + "/" + Substr(Itens->QE6_DTINI,1,4)
	Endif                    

	Itens->( DBCloseArea() ) 

	// busca os ensaios
	cQuery := "SELECT DISTINCT QE6_PRODUT, QE6_DESCPO, QE7_PRODUT, QE7_MINMAX, QE7_NOMINA, QE7_LIE, QE7_LSE, QE7_UNIMED, QE7_ENSAIO, QE1_ENSAIO, QE1_DESCPO "
	cQuery += "  FROM " + RetSQLName( "QE6" ) + " QE6 "
	cQuery += "  JOIN " + RetSQLName( "QE7" ) + " QE7 ON QE7_FILIAL = '" + xFilial( "QE7" ) + "' AND QE7_PRODUT = QE6_PRODUT AND QE7_REVI = QE6_REVI AND QE7.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "QE1" ) + " QE1 ON QE1_FILIAL = '" + xFilial( "QE1" ) + "' AND QE1_ENSAIO = QE7_ENSAIO AND QE1.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE QE6_FILIAL = '" + xFilial( "QE6" ) + "' "
	cQuery += "   AND QE6_PRODUT = '" + cCodProd + "' "
	cQuery += "   AND QE6_SITREV = '0' "
	cQuery += "   AND QE6.D_E_L_E_T_ = ' '
	cQuery += " ORDER BY QE1_DESCPO

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"Itens",.F.,.T.)

	if !Itens->( eof() )   

		do while !Itens->( eof() )
			Aadd(aEnsaios, Array(2))
			nPosEns := Len( aEnsaios ) 

			aEnsaios[nPosEns,1] := Itens->QE1_DESCPO		

			If Itens->QE7_MINMAX == "1"					
				aEnsaios[nPosEns,2] := "Entre " + Alltrim(Itens->QE7_LIE) + " e " + Alltrim(Itens->QE7_LSE)

			ElseIf Itens->QE7_MINMAX == "2"
				aEnsaios[nPosEns,2] := "Minimo " + Alltrim(Itens->QE7_LIE)

			ElseIf Itens->QE7_MINMAX == "3"
				aEnsaios[nPosEns,2] := "Maximo " + Alltrim(Itens->QE7_LSE)

			EndIf

			Itens->( DBSkip() )
		enddo

	endif

	Itens->( DBCloseArea() ) 

	//Busca os ensaios em Texto               
	cQuery := "SELECT DISTINCT QE8_PRODUT, QE8_ENSAIO, QE8_TEXTO, QE1_ENSAIO, QE1_DESCPO, QE1_CARTA "
	cQuery += "  FROM " + RetSQLName( "QE8" ) + " QE8 "
	cQuery += "  JOIN " + RetSQLName( "QE1" ) + " QE1 ON QE1_FILIAL = '" + xFilial( "QE1" ) + "' AND QE1_ENSAIO = QE8_ENSAIO AND QE1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSQLName( "QE6" ) + " QE6 ON QE6_FILIAL = '" + xFilial( "QE6" ) + "' AND QE6_PRODUT = QE8_PRODUT AND QE6_REVI = QE8_REVI AND QE6_SITREV = '0' AND QE6.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE QE8_FILIAL = '" + xFilial( "QE8" ) + "' "
	cQuery += "   AND QE8_PRODUT = '" + cCodProd + "' "
	cQuery += "   AND QE8.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY QE8_PRODUT "

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"Itens",.F.,.T.)

	if !Itens->( eof() ) 

		do while !Itens->( eof() )
			Aadd(aEnsaios, Array(2))
			nPosEns := Len( aEnsaios )     

			aEnsaios[nPosEns,1] := Itens->QE1_DESCPO	
			aEnsaios[nPosEns,2] := Itens->QE8_TEXTO		

			Itens->( DBSkip() )
		enddo		

	endif

	Itens->( DBCloseArea() )  

	U_RQUA008(cCodProd, cProduto, aEnsaios, cRev, cDtVige)

return