#Include "Totvs.ch"

//------------------------------------------------------------------
// Rotina | CN120ITM 	| Autor | Renato Ruy 	  | Data | 29/10/13
//------------------------------------------------------------------
// Descr. | Ponto de Entrada para gravar dados no encerramento
//        | da medição.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------

User Function CN120ITM()
	Local ExpA1 	:= {}
	Local ExpA2 	:= {}
	Local ExpC1 	:= {}
	Local aArea    	:= {} 
	Local nPed		:= 0
	Private aCab 	:= {}
	//Validações do usuário.
	
	aArea := { GetArea(), CN1->( GetArea() ), CN9->( GetArea() ), CNA->( GetArea() ), CND->( GetArea() ), CNE->( GetArea() ) }

	If CN1->CN1_ESPCTR <> "1"
		ExpA1 	:= PARAMIXB[1]
		ExpA2 	:= PARAMIXB[2]
		ExpC1 	:= PARAMIXB[3]
		DbSelectArea("AD1")
		DbSetOrder(1)
		DbSeek( xFilial("AD1") + CN9->CN9_XOPORT)
		
		If AScan(ExpA1,{|x| RTrim(x[1]) == "C5_XNATURE"}) == 0
			
			aAdd(ExpA1,{"C5_XNATURE" , AD1->AD1_XNATUR    , Nil})
			
		EndIf
		
		For nPed:=1 to Len(ExpA2)
			If AScan(ExpA2[nPed],{|x| RTrim(x[1]) == "C6_QTDLIB"}) == 0
				AAdd(ExpA2[nPed],{"C6_QTDLIB",		0				, Nil})
			EndIf
		Next
		
	Else
	
		ExpA1 	:= PARAMIXB[1]
		ExpA2 	:= PARAMIXB[2]
		ExpC1 	:= PARAMIXB[3]
		
		//Renato Ruy - 22/08/2016
		//Nao gerava aprovacao para GCT do Remuneracao - 80000000
		//Ponto de entrada sera usado dentro do CSFA610 para usar conteudo da capa
		//Sera retirado da gravação no metodo utilizado anteriormente.
		
		If IsInCallStack("U_CRPA031")
			ExpA2 := AClone(U_CRPA035(ExpA2))
		EndIf

		If IsInCallStack("U_CRPA079")
			ExpA2 := aClone(ConsolidadoRemuneracao():gravaCapaDespesa(ExpA2))
		EndIf
		
	EndIf
	AEval( aArea, {|xArea| RestArea( xArea ) } )
Return {ExpA1,ExpA2}
