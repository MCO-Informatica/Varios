# include 'Protheus.Ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN130TOK  ºAutor  ³Jose Carlos	    º Data ³ 27/07/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação da medição, apresentar mensagem quando existir   º±±
±±º          ³ adiantamento sem que usuario tenha relacionado.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RENOVA                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CN130TOK() 
Local lRetorno 		:= .T. 
Local lMontaTela	:= .F.
Local cAliasQry		:= ""
Local cQuery		:= ""             
Local cEspCtr		:= ""
Local aAreaAtu		:= GetArea()
Local aCN9			:= CN9->(GetArea()) 
Local nSaldoContr	:= 0
Local nVlrSldAdi	:= 0                 
Local nVlrAdiant	:= 0
Local aValor		:= {}
Local lAdiant		:= .F.


// 08/07/2021 - Luiz - Início do novo bloco de execução incluido oGetAdia     aAdiants     aColsAux   ogetdados acols

if M->CND_TOTADT <> 0			// Se foi informado adiantamento, OK - não precisa verificar ogetdados:obrowse
   Return(lRetorno)
endif

// Verifica se há adiantamento com saldo para o contrato
cAliasQry := GetNextAlias()
cQuery := "SELECT CNX_NUMERO, CNX_VLADT,CNX_SALDO "
cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
cQuery += "  WHERE CNX_CONTRA ='"+M->CND_CONTRA+ "'"
cQuery += "  AND CNX_XFILOR = '"+cFilAnt+"'"
cQuery += "  AND CNX_SALDO > 0 "
cQuery += "  AND CNX.D_E_L_E_T_=' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
(cAliasQry)->(DbGoTop())

nContReg := 0
while !(cAliasQry)->(EOF())
      nContreg += 1
	  (cAliasQry)->(DbSkip())
EndDo

if nContReg > 0
   cMsg := "Atenção, existe(m) "+AllTrim(Str(nContReg))+" adiantamento(s) para esse contrato."+CHR(13)+CHR(10)+CHR(13)+CHR(10)
   cmsg += "Deseja sair sem utilizar adiantamento(s)?"
   if !MsgYesNo(cMsg, "Confirmação")
	  cMsg := "Clique em 'Outras Ações' e em seguinda em 'Adiantam.' para"+CHR(13)+CHR(10)
	  cmsg += "visualizar o(s) adiantamento(s) existente(s)."
	  MessageBox(cMsg,"Retornar à Medição",64)
      lRetorno := .F.
   endif
endif

Return(lRetorno)


/*

//
//[Jose Carlos][19/10/2015]
//Avaliar as movimentações anteriores a data do parametro FS_DTVLDAD
lRetorno := VldDtAdt()  
iF lRetorno
	For nX:=1 To Len( aListBox )
		aListBox[nX,1] := .F.
	Next nX  
	Return(lRetorno)					                                                                                                            
EndIf

DbSelectArea("CN9")             
DbSetOrder(1)
If DbSeek(xFilial("CN9")+M->CND_CONTRA+M->CND_REVISA)
	nSaldoContr := CN9->CN9_SALDO
EndIf   

//aListBox VARIAVEL PUCLIC DECLARADA NO FONTE PADRAO CNTA130.PRW
For nX:=1 To Len( aListBox )
	If aListBox[nX,1]
		lMontaTela := .T.	
	EndIf
Next nX  

//Se o aListBox estiver vazio, quer dizer que já foram consumidos todos os PAs.
If Len(aListBox) == 0
	lAdiant	:= .T.	
EndIf


//	SE FOR ALTERACAO VERIFICAR ITENS MARCADOS NA TABELA, CASO O USUARIO NÃO ATIVOU AINDA A ROTINA PADRÃO DE "ADIANTAMENTO"
//	ASSIM NÃO ATUALIZANDO A VARIAVEL "aListBox".


If ALTERA .And. !lMontaTela 
	
	If FieldPos("CN9_ESPCTR") > 0
		cEspCtr := CN9->CN9_ESPCTR
	ElseIf !Empty(CN9->CN9_CLIENT)
		cEspCtr := "2"
	Else
		cEspCtr := "1"
	EndIf
	
	cAliasQry := GetNextAlias()
	cQuery := "SELECT CNX_FILIAL, CNX_CONTRA, CNX_NUMERO, CNX_DTADT, CNX_VLADT, CNX_NUMMED, CNX_NUMTIT, CNX_XVLORI, CNX_XPERC "
	cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
	cQuery += " WHERE CNX_FILIAL ='"+xFilial("CNX")+"'"
	cQuery += "   AND CNX_CONTRA ='"+M->CND_CONTRA+ "'"
	cQuery += "   AND CNX_NUMMED ='"+M->CND_NUMMED+"' AND "
	If cEspCtr == "1"
		cQuery += "CNX_FORNEC = '"+M->CND_FORNEC+"' AND "
		cQuery += "CNX_LJFORN = '"+M->CND_LJFORN+"' AND "
	Else
		cQuery += "CNX_CLIENT = '"+M->CND_CLIENT+"' AND "
		cQuery += "CNX_LOJACL = '"+M->CND_LOJACL+"' AND "
	EndIf
	cQuery += " CNX.D_E_L_E_T_=' ' "
	cQuery += " ORDER BY CNX_DTADT "
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
 
 	DbSelectArea(cAliasQry)
	(cAliasQry)->(DbGoTop())
			
	If Select(cAliasQry) > 0 .And. (cAliasQry)->( !Eof())
		lMontaTela := .T.
	Endif
	
	DbSelectArea(cAliasQry)
 	DbCloseArea() 
 	
 	RestArea(aAreaAtu) 

EndIf

If !lMontaTela             

	If FieldPos("CN9_ESPCTR") > 0
		cEspCtr := CN9->CN9_ESPCTR
	ElseIf !Empty(CN9->CN9_CLIENT)
		cEspCtr := "2"
	Else
		cEspCtr := "1"
	EndIf

	cAliasQry := GetNextAlias()
	cQuery := "SELECT CNX_FILIAL, CNX_CONTRA, CNX_NUMERO, CNX_DTADT, CNX_VLADT, CNX_NUMMED, CNX_NUMTIT, CNX_XVLORI, CNX_XPERC "
	cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
	cQuery += " WHERE CNX_FILIAL ='"+xFilial("CNX")+"'"
	cQuery += "   AND CNX_CONTRA ='"+M->CND_CONTRA+ "'"
	cQuery += "   AND (CNX_NUMMED IN ('"+Space(TamSx3('CND_NUMMED')[1])+"','"+M->CND_NUMMED+"')) AND "
	If cEspCtr == "1"
		cQuery += "CNX_FORNEC = '"+M->CND_FORNEC+"' AND "
		cQuery += "CNX_LJFORN = '"+M->CND_LJFORN+"' AND "
	Else
		cQuery += "CNX_CLIENT = '"+M->CND_CLIENT+"' AND "
		cQuery += "CNX_LOJACL = '"+M->CND_LOJACL+"' AND "
	EndIf
	cQuery += " CNX.D_E_L_E_T_=' ' "
	cQuery += " ORDER BY CNX_DTADT "
	
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )
	
	If  (cAliasQry )->( Eof() )
		lRetorno := .T.  
		Return(lRetorno)	
	Else
		//Aviso("Adiantamento Renova %", "Existe adiantamento para este contrato,porém não relacionado! ", {" Ok "})     
		//lRetorno := .F.
		lRetorno := VldDtAdt()  
		iF !lRetorno
			Aviso("Adiantamento Renova %", "Existe adiantamento para este contrato,porém não relacionado! ", {" Ok "})				
		EndIf	
	Endif     
	
	DbSelectArea(cAliasQry)
    dbCloseArea() 

 	RestArea(aAreaAtu)

EndIf
    
// nTotVlMed VARIAVEL PRIVATE declarada no fonte CNTA130.PRW
If 	lRetorno .And. lMontaTela .And. nTotVlMed < 0
	Aviso("Adiantamento Renova %", "Valor total da medição negativa, verifique o adiantamento % RENOVA.", {" Ok "})
	lRetorno := .F.  
EndIf



//	VALIDA SALDO DE CONTRATO COM O SALDO DE PA.
//	nSaldoContr 	==> SALDO DO CONTRATO
//	M->CND_VLTOT	==> VALOR TOTAL DOS ITENS
//	nTotVlMed		==> VALOR TOTAL DA MEDICAO
//	M->CND_TOTADT	==> VALOR TOTAL DO ADIANTAMENTO
                         

aValor		:= SldAdiant()
nVlrSldAdi	:= aValor[1]	// Saldo do adiantamento
nVlrAdiant	:= aValor[2] 	// Valor do adiantamento

//If lRetorno .And. ((nSaldoContr - M->CND_VLTOT) == M->CND_VLTOT ) .Or. ((nSaldoContr - M->CND_VLTOT) == 0 )   
If lRetorno .And.  nTotVlMed > 0 .And. (nSaldoContr - M->CND_VLTOT) < (nVlrSldAdi - nTotVlMed  )  
//	If GetAdiant()  
	If nVlrSldAdi == nVlrAdiant
		lRetorno := .T.
	Else
		Aviso("Adiantamento Renova %", "Valor do adiantamento não poderá ser maior que o saldo do contrato.", {" Ok "})
		lRetorno := .F.
	EndIf
//	EndIf
ElseIf lRetorno .And. (nSaldoContr - M->CND_VLTOT) == 0 .And. (nSaldoContr - M->CND_VLTOT) > (nVlrSldAdi - nTotVlMed  )
	If nVlrSldAdi == nVlrAdiant
		lRetorno := .T.		
	Else 
		Aviso("Adiantamento Renova %", "Utilize o saldo restante do adiantamento.", {" Ok "})
		lRetorno := .F.
	EndIf
EndIf
                    
RestArea( aCN9 )                         
RestArea( aAreaAtu )    

Return(lRetorno)          

Static Function GetAdiant() 
Local lRet 		:= .F.
Local aAtu		:= GetArea()   
Local cAliasQry := GetNextAlias()
Local cQuery	:= ""
Local nVlrAdian	:= 0

cQuery := "SELECT CNX_XVLORI "
cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
cQuery += " WHERE CNX_FILIAL ='"+xFilial("CNX")+"'"
cQuery += "   AND CNX_CONTRA ='"+M->CND_CONTRA+ "'"
cQuery += "   AND (CNX_NUMMED IN ('"+Space(TamSx3('CND_NUMMED')[1])+"','"+M->CND_NUMMED+"')) AND"
cQuery += " CNX.D_E_L_E_T_=' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

TCSetField(cAliasQry,"CNX_XVLORI","N",TamSX3("CNX_XVLORI")[1],TamSX3("CNX_XVLORI")[2])
 
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())
While (cAliasQry)->( !Eof())
	nVlrAdian += (cAliasQry)->CNX_XVLORI	
	(cAliasQry)->(DbSkip())
EndDo

DbSelectArea(cAliasQry)
DbCloseArea()

If M->CND_VLTOT <> nVlrAdian
	lRet:= .T. 
EndIf                

RestArea( aAtu )
Return(lRet) 


Static Function SldAdiant() 
Local lRet 		:= .F.
Local aAtu		:= GetArea()   
Local cAliasQry := GetNextAlias()
Local cQuery	:= ""
Local aValores	:= {0,0}

cQuery := "SELECT CNX_VLADT,CNX_XVLORI "
cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
cQuery += " WHERE CNX_FILIAL ='"+xFilial("CNX")+"'"
cQuery += "   AND CNX_CONTRA ='"+M->CND_CONTRA+ "'"
cQuery += "   AND (CNX_NUMMED IN ('"+Space(TamSx3('CND_NUMMED')[1])+"','"+M->CND_NUMMED+"')) AND"
cQuery += " CNX.D_E_L_E_T_=' ' "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cAliasQry, .F., .T. )

TCSetField(cAliasQry,"CNX_VLADT","N",TamSX3("CNX_VLADT")[1],TamSX3("CNX_VLADT")[2])
TCSetField(cAliasQry,"CNX_XVLORI","N",TamSX3("CNX_XVLORI")[1],TamSX3("CNX_XVLORI")[2])
 
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())
While (cAliasQry)->( !Eof())
	aValores[1] += (cAliasQry)->CNX_VLADT	 
	aValores[2] += (cAliasQry)->CNX_XVLORI		
	(cAliasQry)->(DbSkip())
EndDo

DbCloseArea(cAliasQry)

RestArea( aAtu )
Return(aValores)


Static Function VldDtAdt()
Local lRetorno	:= .F.
Local aArea		:= GetArea()
Local cQry 		:= GetNextAlias()
Local cQuery	:= ""                            
Local dDatavld	:= GetMv("FS_DTVLDAD",.F.,Ctod('31/08/2015')) 

cQuery := "SELECT CNX_FILIAL, CNX_CONTRA, CNX_NUMERO, CNX_DTADT, CNX_VLADT, CNX_NUMMED, CNX_NUMTIT, CNX_XVLORI, CNX_XPERC "
cQuery += "  FROM "+RetSqlName("CNX")+" CNX "
cQuery += " WHERE CNX_FILIAL ='"+xFilial("CNX")+"'"
cQuery += "   AND CNX_CONTRA ='"+M->CND_CONTRA+ "'"
cQuery += "   AND (CNX_NUMMED IN ('"+Space(TamSx3('CND_NUMMED')[1])+"','"+M->CND_NUMMED+"')) AND "
cQuery += "CNX_FORNEC = '"+M->CND_FORNEC+"' AND "
cQuery += "CNX_LJFORN = '"+M->CND_LJFORN+"' AND "
cQuery += " CNX_DTADT <= '"+Dtos(dDatavld)+"' AND "
cQuery += " CNX.D_E_L_E_T_=' ' "
cQuery += " ORDER BY CNX_DTADT "

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cQry, .F., .T. )

If  (cQry )->( Eof() )
	lRetorno := .F.  	
Else
	lRetorno := .T.  	
Endif
            
DbSelectArea(cQry)
dbCloseArea() 
                            
RestArea( aArea )    
Return(lRetorno)

*/
