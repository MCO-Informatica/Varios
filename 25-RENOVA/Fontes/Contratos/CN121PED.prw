#include "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
 
 // Os campos da CND para código de fornecedor/cliente e número da planilha = OK
User Function CN121PED()   
    
Local aResult   := Array(2)
Local oModel    := Nil
Local lVenda    := .F.
Local lCompra   := .F.
Local aArea		:= GetArea()

Private aCab      := PARAMIXB[1] 
Private aItens    := PARAMIXB[2]
 
If !(Empty(aCab) .Or. Empty(aItens))

    oModel := FwModelActive()//Modelo do CNTA121 
    /*
    Para obter dados do modelo, usar oModel:GetValue(cModelId, cCampo).
    Exemplo: oModel:GetValue("CNDMASTER", "CND_CONTRA")        
    */
    lVenda  := Cn121RetSt( "VENDA"  , 0, /*cPlan*/, /*cContra*/, .T., oModel )
    lCompra := Cn121RetSt( "COMPRA" , 0, /*cPlan*/, /*cContra*/, .T., oModel )     
 
EndIf

if lVenda
    CtrVenda()
else
    if lCompra
        CtrCompra()
    endif
endif

aResult[1] := aCab
aResult[2] := aItens

RestArea(aArea)

Return aResult



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

Local nPIteMed  := aScan( aItens[1], { |x|  AllTrim( x[1] ) == "C6_ITEMED" } )
Local cIteMed	:= ""
Local nx        := 0
Local nPosCpo   := 0
Local _nDescont := 0

For nx := 1 to Len(aItens)

	//cIteMed		:= aItens[nx, nPIteMed, 2]                                    
	cIteMed		:= StrZero(Val(aItens[nx, nPIteMed, 2]),TamSX3("CNE_ITEM")[1])

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

		If(nPosCpo:=aScan(aItens[nx],{|x|x[1] == "C6_CC"})) > 0			//CC - Verifica se o campo ja existe no array
			aItens[nx,nPosCpo,2] := CNE->CNE_CC						//Altera informacao 
		  Else
			aAdd(aItens[nx],{"C6_XCCUSTO", CNE->CNE_CC, Nil})				//Inclui o campo                    
		endif	
		
		If(nPosCpo:=aScan(aItens[nx],{|x|x[1] == "C6_ITEMCTA"})) > 0			//Projeto - Verifica se o campo ja existe no array
			aItens[nx,nPosCpo,2] := CNE->CNE_ITEMCT						//Altera informacao 
		  Else
			aAdd(aItens[nx],{"C6_XITEM", CNE->CNE_ITEMCT, Nil})				//Inclui o campo   
		endif	
			
		If(nPosCpo:=aScan(aItens[nx],{|x|x[1] == "C6_CLVL"})) > 0			//Camada - Verifica se o campo ja existe no array
			aItens[nx,nPosCpo,2] := CNE->CNE_CLVL						//Altera informacao 
		  Else
			aAdd(aItens[nx],{"C6_XCLASS",CNE->CNE_CLVL, Nil})				//Inclui o campo
		endif	
	   /*	If(nPosCpo:=aScan(aItens[nx],{|x|x[1] =="C6_EC05DB"})) > 0			//Verifica se o campo ja existe no array
			aItens[nx,nPosCpo,2] := TRABCNE->CNE_EC05DB						//Altera informacao 
		Else
			aAdd(aItens[nx],{"C6_EC05DB", TRABCNE->CNE_EC05DB, Nil})				//Inclui o campo	
		endif	*/
		If(nPosCpo:=aScan(aItens[nx],{|x|x[1] =="C6_EC05CR"})) > 0			//Entidade - Verifica se o campo ja existe no array
			aItens[nx,nPosCpo,2] := CNE->CNE_EC05DB						//Altera informacao 
		Else
			aAdd(aItens[nx],{"C6_EC05CR",CNE->CNE_EC05DB, Nil})				//Inclui o campo		
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
	aAdd(aCab,{"C5_DESCONT",_nDescont,NIL})                // Reajuste
	
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

Local nx        := 0
Local nPosCpo   := 0
Local nPIteMed  := 0  	// Posição na Array - Item da Medição (C7_ITEMED)
Local nPPlan    := 0    // Posição da Array - Código da Planilha (C7_PLANILH)
Local cIteMed   := ""

CNE->(DbSetOrder(1))	// 	CNE_FILIAL + CNE_CONTRA + CNE_REVISA + CNE_NUMERO + CNE_NUMMED + CNE_ITEM
//CNE->(DbSetOrder(5))	// 	CNE_FILIAL + CNE_CONTRA + CNE_REVISA + CNE_NUMMED


For nx := 1 to Len(aItens)
	
	nPIteMed := aScan(aItens[nx], { |x| AllTrim( x[1] ) == "C7_ITEMED" } )
	nPPlan   := aScan(aItens[nx], { |x| AllTrim( x[1] ) == "C7_PLANILH" } )
	// De aoordo com o item (nx) do Pedido, a posição deste campo dentro da array pode variar
	// Deve-se considerar que aItens terá tantos elementos quantos forem os itens na SC7 e não do CNE
	cIteMed := AllTrim(aItens[nx, nPIteMed, 2])
	cPlanilh:= AllTrim(aItens[nX, nPPlan, 2])

//  CNE->( DbSeek(xFilial("CNE") + CND->CND_CONTRA + CND->CND_REVISA + CND->CND_NUMERO + CND->CND_NUMMED + cIteMed) )
//  Tanto faz do CND quanto pegar do array do Pedido (no CND tbm está gravando agora)
    CNE->( DbSeek(xFilial("CNE") + CND->CND_CONTRA + CND->CND_REVISA + cPlanilh + CND->CND_NUMMED + cIteMed) )

	If !CNE->(Eof())
       
        If	(nPosCpo := aScan(aItens[nx],{|x|x[1] == "C7_XIMCURS"})) > 0
			aItens[nx,nPosCpo,2] := Alltrim(CNE->CNE_XIMCUR)
		Else
			aAdd(aItens[nx],{"C7_XIMCURS",Alltrim(CNE->CNE_XIMCUR),Nil})
		Endif
        
		If	(nPosCpo := aScan(aItens[nx],{|x|x[1] == "C7_XPROJIM"})) > 0
			aItens[nx,nPosCpo,2] := Alltrim(CNE->CNE_XPROJI)
		Else
			aAdd(aItens[nx],{"C7_XPROJIM",Alltrim(CNE->CNE_XPROJI),Nil})
		Endif
			
		If !Empty(CND->CND_XOBSPA)
			If	(nPosCpo := aScan(aItens[nx],{|x|x[1] == "C7_XOBSPA"})) > 0
				aItens[nx,nPosCpo,2] := Alltrim(CND->CND_XOBSPA)
			Else
				aAdd(aItens[nx],{"C7_XOBSPA",Alltrim(CND->CND_XOBSPA),Nil})
			Endif
		Endif

	Endif

Next

RETURN
