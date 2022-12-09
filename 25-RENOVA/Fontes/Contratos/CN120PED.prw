#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN120PED ³ Autor ³  Totvs                ³ Data ³ junho/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada executado no momento do encerramento da    ³±±
±±³          ³medicao, quando o sistema gera o pedido.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CN120PED()

Local aArea		:= GetArea()
Local _cTipo    := ""

If ! (ValType(PARAMIXB) == "A" .And. Len(PARAMIXB) >= 3 .And. ValType(PARAMIXB[2]) == "A" .And. Len(PARAMIXB[2]) > 0)
	Return
Endif

Private _aCab	  := PARAMIXB[1]	//Cabecalho
Private _aItm	  := PARAMIXB[2]
Private cAliasCNE := PARAMIXB[3]

dbSelectArea("CN9")
dbSetOrder(1)
dbSeek(xFilial("CN9") + CND->CND_CONTRA + CND->CND_REVISA)

dbSelectArea("CN1")
dbSetOrder(1)
dbSeek(xFilial("CN1") + CN9->CN9_TPCTO)
_cTipo := CN1->CN1_ESPCTR


Do Case
	Case _cTipo == "1"
		CtrCompra()
	Case _cTipo == "2"
		CtrVenda()
EndCase

RestArea(aArea)

Return({_aCab,_aItm,cAliasCNE})

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CtrVenda  ³ Autor ³ TOTVS                 ³ Data ³ Fev/08   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tratamento para geracao de pedidos de venda.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CtrVenda()

Local nPIteMed  := aScan( _aItm[1], { |x|  AllTrim( x[1] ) == "C6_ITEMED" } )
Local cIteMed	:= ""
Local cQry      := ""
Local nx        := 0
Local nPosCpo   := 0
Local _nDescont := 0

For nx := 1 to Len(_aItm)

	//cIteMed		:= _aItm[nx, nPIteMed, 2]                                    
	cIteMed		:= StrZero(Val(_aItm[nx, nPIteMed, 2]),TamSX3("CNE_ITEM")[1])

	// Fabio Jadao Caires - 01/12/2017 - Substituicao da query da CNE apartir da CND por um posicionamento na CNE apartir da CND.
	CNE->( DbSeek(xFilial("CNE") + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMERO + CND->CND_NUMMED + cIteMed) )

	/*
	cQry	:= " SELECT CNE.CNE_CC, CNE.CNE_CONTA, CNE.CNE_ITEMCT, CNE.CNE_CLVL,CNE.CNE_EC05DB" 
	cQry	+= " FROM " + RetSqlName( "CNE" ) + " CNE"
	cQry	+= " WHERE CNE.CNE_FILIAL = '" + xFilial( "CNE" ) + "'"
	cQry	+= " AND CNE.CNE_CONTRA = '" + CND->CND_CONTRA + "'"
	cQry	+= " AND CNE.CNE_REVISA = '" + CND->CND_REVISA + "'"
	cQry	+= " AND CNE.CNE_NUMERO = '" + CND->CND_NUMERO + "'"
	cQry	+= " AND CNE.CNE_NUMMED = '" + CND->CND_NUMMED + "'"
	cQry	+= " AND CNE.CNE_ITEM = '" + cIteMed + "'"
	cQry	+= " AND CNE.D_E_L_E_T_ = ' '"

	If Select( "TRABCNE" ) > 0
		dbSelectArea( "TRABCNE")
		dbCloseArea()
	EndIf

	cQry	:= ChangeQuery( cQry )
	dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQry ), "TRABCNE", .F., .T. )
	*/

	If !CNE->(Eof())

		If(nPosCpo:=aScan(_aItm[nx],{|x|x[1] == "C6_CC"})) > 0			//CC - Verifica se o campo ja existe no array
			_aItm[nx,nPosCpo,2] := CNE->CNE_CC						//Altera informacao 
		  Else
			aAdd(_aItm[nx],{"C6_XCCUSTO", CNE->CNE_CC, Nil})				//Inclui o campo                    
		endif	
		
		If(nPosCpo:=aScan(_aItm[nx],{|x|x[1] == "C6_ITEMCTA"})) > 0			//Projeto - Verifica se o campo ja existe no array
			_aItm[nx,nPosCpo,2] := CNE->CNE_ITEMCT						//Altera informacao 
		  Else
			aAdd(_aItm[nx],{"C6_XITEM", CNE->CNE_ITEMCT, Nil})				//Inclui o campo   
		endif	
			
		If(nPosCpo:=aScan(_aItm[nx],{|x|x[1] == "C6_CLVL"})) > 0			//Camada - Verifica se o campo ja existe no array
			_aItm[nx,nPosCpo,2] := CNE->CNE_CLVL						//Altera informacao 
		  Else
			aAdd(_aItm[nx],{"C6_XCLASS",CNE->CNE_CLVL, Nil})				//Inclui o campo
		endif	
	   /*	If(nPosCpo:=aScan(_aItm[nx],{|x|x[1] =="C6_EC05DB"})) > 0			//Verifica se o campo ja existe no array
			_aItm[nx,nPosCpo,2] := TRABCNE->CNE_EC05DB						//Altera informacao 
		Else
			aAdd(_aItm[nx],{"C6_EC05DB", TRABCNE->CNE_EC05DB, Nil})				//Inclui o campo	
		endif	*/
		If(nPosCpo:=aScan(_aItm[nx],{|x|x[1] =="C6_EC05CR"})) > 0			//Entidade - Verifica se o campo ja existe no array
			_aItm[nx,nPosCpo,2] := CNE->CNE_EC05DB						//Altera informacao 
		Else
			aAdd(_aItm[nx],{"C6_EC05CR",CNE->CNE_EC05DB, Nil})				//Inclui o campo		
		Endif
	EndIf

	//TRABCNE->(dbCloseArea())

Next  
	dbSelectArea("CNQ") // DESCONTOS
	CNQ->(dbGoTop())
	
	CNQ->(dbSetOrder(1)) // CNQ_FILIAL+CNQ_NUMMED+CNQ_TPDESC - 
	
	If CNQ->(dbSeek(xFilial("CNQ")+CND->CND_NUMMED))
	
		While !CNQ->(eof()) .AND. CNQ->CNQ_CONTRA == CND->CND_CONTRA .AND. CNQ->CNQ_NUMMED == CND->CND_NUMMED    
			_nDescont := CNQ->CNQ_VALOR
			CNQ->(dbSkip())
		EndDo
	
	Endif     
	
	// Adiciona desconto do contrato ao desconto do pedido (idenizacao - C5_DESCONT)
	aAdd(_aCab,{"C5_DESCONT",_nDescont,NIL})                // Reajuste
	
	CNQ->(dbCloseArea())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³CtrCompra ³ Autor ³ Wellington Mendes ³ Data ³ Fev/08   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±

±±³Descri‡…o ³Tratamento para geracao de pedidos de compra.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Renova                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CtrCompra()

Local cQry      := ""
Local nx        := 0
Local nPosCpo   := 0
Local aCN9Alias	:= GetArea('CN9')

For nx := 1 to Len(_aItm)
                
                cQry      := " SELECT CNE.CNE_XIMCUR, CNE.CNE_XIMCUR, CNE.CNE_XPROJI "
				cQry      += " FROM " + RetSqlName( "CNE" ) + " CNE"
                cQry      += " WHERE CNE.CNE_FILIAL = '" + xFilial( "CNE" ) + "'"
                cQry      += " AND CNE.CNE_CONTRA = '" + CND->CND_CONTRA + "'"
                cQry      += " AND CNE.CNE_REVISA = '" + CND->CND_REVISA + "'"
                cQry      += " AND CNE.CNE_NUMERO = '" + CND->CND_NUMERO + "'"
                cQry      += " AND CNE.CNE_NUMMED = '" + CND->CND_NUMMED + "'"
                cQry      += " AND CNE.D_E_L_E_T_ = ' '"

                If Select( "TRABCNE" ) > 0
                               dbSelectArea( "TRABCNE")
                               dbCloseArea()
                EndIf

                cQry      := ChangeQuery( cQry )
                dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQry ), "TRABCNE", .F., .T. )
                
                If !Eof() 

                       If (nPosCpo := aScan(_aItm[nx],{|x|x[1] == "C7_XIMCURS"})) > 0
				
							_aItm[nx,nPosCpo,2] := Alltrim(CNE->CNE_XIMCUR)
					   Else
							aAdd(_aItm[nx],{"C7_XIMCURS",Alltrim(CNE->CNE_XIMCUR),Nil})
					   Endif
        
						If	(nPosCpo := aScan(_aItm[nx],{|x|x[1] == "C7_XPROJIM"})) > 0
							_aItm[nx,nPosCpo,2] := Alltrim(CNE->CNE_XPROJI)
						Else
							aAdd(_aItm[nx],{"C7_XPROJIM",Alltrim(CNE->CNE_XPROJI),Nil})
						Endif
                EndIf

                TRABCNE->(dbCloseArea())

Next
		//Compilar em produção
				DbSelectArea("CN9")
				DbSetOrder(1)
				If 	CN9->(MsSeek(xFilial("CND")+CND->(CND_CONTRA+CND_REVISA),.T.))
					If	(nPosCpo := aScan(_aItm[nx],{|x|x[1] == "C7_XTPCOM"})) > 0
						_aItm[nx,nPosCpo,2] := Alltrim(CN9->CN9_TPCONT)
					Else
						aAdd(_aItm[nx],{"C7_XTPCOM",Alltrim(CN9->CN9_TPCONT),Nil})
					Endif
				EndIf
				RestArea( aCN9Alias )
				
				//Final da Inclusão
				If !Empty(CND->CND_XOBSPA)
					If	(nPosCpo := aScan(_aItm[nx],{|x|x[1] == "C7_XOBSPA"})) > 0
						_aItm[nx,nPosCpo,2] := Alltrim(CND->CND_XOBSPA)
					Else
						aAdd(_aItm[nx],{"C7_XOBSPA",Alltrim(CND->CND_XOBSPA),Nil})
					Endif

				Endif
			


Return               

