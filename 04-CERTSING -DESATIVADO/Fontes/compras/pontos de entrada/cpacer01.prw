#Include 'Protheus.ch'
STATIC __cC7_FILENT__ := '' // Variável encapsulada para ser usada no MT120FIM.

//-----------------------------------------------------------
// Rotina | cpacer01 | Totvs - David       | Data | 10.12.13
// ----------------------------------------------------------
// Descr. | Rotina para registro de informações complementares
//        | do pedido de compras através de parambox.      
//-----------------------------------------------------------
User Function cpacer01(cNumCpr,lInc,lAlt)
Local lRetPe	:= .T.
Local Conteudo	:= nil
Local nPosCpo	:= 0
Local nPosApr	:= 0

Local nI,nX		:= 0
Local cCpo		:= GetNewPar("MV_XCPOCPR","C7_CC,C7_ITEMCTA,C7_XRECORR,C7_XREFERE,C7_CLVL,C7_XJUST,C7_XOBJ,C7_XCONTRA,C7_XADICON,C7_XVENCTO")
Local aCpoComp	:= StrTokArr(cCpo, ",")

Local aPar		:= {}
Local aRet		:= {}
Local bValid 	:= {|| .T. }
Local lObri		:= .f.

Local aCbx		:= {}

Local bF4 

If (lInc .or. lAlt) .and. !Empty(cCpo)
	bF4 := SetKey( VK_F4 )
	SetKey( VK_F4, NIL )

	SX3->(DbSetOrder(2))
	For nI:=1 to Len(aCpoComp)
		If SX3->(DbSeek(aCpoComp[nI]))
	
			If lInc
				Conteudo := CriaVar(aCpoComp[nI])
			ElseIf lAlt
				Conteudo := &("SC7->"+aCpoComp[nI])
			EndIf
			
			lObri := SX3->X3_CAMPO <> "C7_XADICON" 
			
			If SX3->X3_TIPO == "C" .and. Empty(SX3->X3_CBOX) 
				AAdd( aPar,{ 1 , RTrim(SX3->X3_DESCRIC) , Conteudo , SX3->X3_PICTURE , SX3->X3_VALID        , SX3->X3_F3   , '', 50, lObri } )	
			
			ElseIf SX3->X3_TIPO == "D"
			
				AAdd( aPar,{ 1 , RTrim(SX3->X3_DESCRIC) , DtoC(Conteudo) , '99/99/99' , ''                    , ''   , '', 10, lObri } )
									
			ElseIf SX3->X3_TIPO == "C" .and. !Empty(SX3->X3_CBOX)
			
				aCbx := StrTokArr(SX3->X3_CBOX, ";")
				
				AAdd( aPar,{ 2 , RTrim(SX3->X3_DESCRIC) , Val(Conteudo) , aCbx , 50, '' ,  lObri } )
				
			ElseIf SX3->X3_TIPO == "M"
				
				AAdd( aPar,{ 11 , RTrim(SX3->X3_DESCRIC) , Conteudo , ''                    , ''   ,  lObri } )
				
			EndIf 			
		
		EndIf
	Next
	
	AAdd( aPar, {1,'Qual a filial de entrega',xFilial("SC7"),'','A120FilEnt(MV_PAR11)','SM0_01','',50,.T.} )
	
	lRetPe := ParamBox( aPar, 'Complemento de Pedido de Compras', @aRet, bValid,,,,,,,.F.,.F.)
		 
	If lRetPe .and. Type("aCols") <> "U" .and. Type("aHeader") <> "U" 
		__cC7_FILENT__ := aRet[ 11 ]
		
		For nI:=1 to Len(aCols)
			For nX:=1 to Len(aCpoComp)
				nPosCpo := Ascan(aHeader, {|x| Alltrim(x[2]) == aCpoComp[nX] })
				
				//11/06/14 - Renato Ruy - Alimentar a Coluna do Grupo de Aprovação
				If aCpoComp[nX] == "C7_CC"
					nPosApr := 	Ascan(aHeader, {|x| Alltrim(x[2]) == "C7_APROV" })
					
					DbSelectArea("CTT")
					DbSetOrder(1)
					If DbSeek( xFilial("CTT") + aRet[nX] )
						aCols[nI,nPosApr] := CTT->CTT_XAPROV
					EndIf
					
				EndIf
				//Fim Alteração
				
				If nPosCpo > 0
					If aHeader[nPosCpo,8] == "C" .and. ValType(aRet[nX]) = "N"  
						aCols[nI,nPosCpo] := Alltrim(Str(aRet[nX]))
					ElseIf aHeader[nPosCpo,8] == "D" .and. ValType(aRet[nX]) = "C"
						aCols[nI,nPosCpo] := CtoD(aRet[nX])
					Else
						aCols[nI,nPosCpo] := aRet[nX]
					EndIf
				EndIf	
			Next		
		Next
	EndIf
	SetKey( VK_F4, bF4 )
EndIf
 
Return(lRetPe)

//------------------------------------------------------------------------
// Rotina | R1FILENT | Robson Gonçalves                | Data | 04/02/2015
//------------------------------------------------------------------------
// Descr. | Rotina para devolver o conteúdo da variável STATIC no contexto 
//        | encapsulada, onde será utilizada no ponto de entrada MT120FIM.
//------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A.
//------------------------------------------------------------------------
User Function BR1FILENT()
Return(__cC7_FILENT__)