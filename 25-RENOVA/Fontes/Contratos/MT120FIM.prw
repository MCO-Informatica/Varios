# include 'protheus.ch'

User Function MT120FIM()
Local aAreaAtu	:= GetArea()  
Local cNumPC	:= ""
Local aAreaSC7	:= SC7->(GetArea()) 
Local aAreaCNX	:= CNX->(GetArea())
Local aNumTit	:= {}
Local cNumContr	:= ""
Local cRevisao	:= ""
Local nVlrPerc	:= 0
Local nVlrTit	:= 0
Local nVlrAdi	:= 0     
Local aDadosCNX	:= {} 
Local lGeraCNX	:= .F.
Local nSaldoCNX	:= 0  
Local cNumMed	:= ""
Local cNovoNumero := ""        
Local aRegAtu	:= {}
                                 
If IsInCallStack("CNTA121") .And. !IsInCallStack('CN120MedEst') .and. !IsInCallStack("CN121MEDEST")

 	if CND->CND_TOTADT > 0 

		DbSelectArea('SC7')
		SC7->(DbSetOrder(1))
 
		cNumPC		:= PARAMIXB[2] 
	
		cNumContr 	:= CND->CND_CONTRA
		cRevisao	:= CND->CND_REVISA
		cNumMed		:= CND->CND_NUMMED

// Inicio - Inclusão de bloco para localizar problema - Luiz - 19/10/2021
// Operação cancelada peo Execauto - provavel problema do Projeto - Não gera PC
		if PARAMIXB[3] = 0
		   DbSelectArea("SZE")
		   RecLock("SZE", .T.)
		   ZE_FILIAL := ""
		   ZE_DATA   := dDataBase
		   ZE_HORA   := SubStr(Time(),1,8)
		   ZE_CONTRA := cNumContr
		   ZE_NUMMED := cNumMed
		   cMsg := "Proc cancelado EXECAUTO - Contr/Med.: " + cNumContr + "/" + CZY->CZY_NUMERO
		   cMsg += " - Filial logada: " + cFilAnt + " - Fiial CND: " + CND->CND_FILIAL + " - Pedido " + cNumPC
		   ZE_MENSA  := cMsg
		   MsUnlock()
		   cMsg := "Atenção: Erro no Encerramento foi localizado."+chr(13)+chr(10)
		   cMsg += "Esse Encerramento não foi executado."+chr(13)+chr(10)
		   cMsg += "Favor avisar T.I."
		   MessageBox(cMsg, "Erro no Processo de Encerramento", 16)
		endif	
// Fim -  Inclusão de bloco para localizar problema - Luiz - 19/10/2021			

		dbSelectArea("CZY")
		dbSetOrder(1)
		dbSeek(xFilial("CZY")+cNumContr+cRevisao+cNumMed)

    	While CZY->CZY_CONTRA = cNumContr .and. CZY->CZY_REVISA = cRevisao .and. CZY->CZY_NUMMED = cNumMed

// Bloco de verificação desabilitado em 11/11/2021
//			DbSelectArea('CNX')
//			CNX->(DbSetOrder(1))

// Inicio - Inclusão de bloco para localizar problema - Luiz - 19/10/2021
// Problema de não encontrar CNX para localizar o título PA a utilizar no PC (FIE)
//		    if !CNX->(DbSeek(xFilial('CNX') + cNumContr + CZY->CZY_NUMERO))
//			   DbSelectArea("SZE")
//			   RecLock("SZE", .T.)
//			   ZE_FILIAL := ""
//			   ZE_DATA   := dDataBase
//			   ZE_HORA   := SubStr(Time(),1,8)
//			   ZE_CONTRA := cNumContr
//			   ZE_NUMMED := cNumMed
//			   cMsg := "CNX NÃO ENCONTRADO - Chave: " +xFilial('CNX') + cNumContr + CZY->CZY_NUMERO
//			   cMsg += " - Filial logada: " + cFilAnt + " - Fiial CND: " + CND->CND_FILIAL
//			   ZE_MENSA  := cMsg
//			   MsUnlock()
//			   cMsg := "Atenção: Erro no Encerramento foi localizado."+chr(13)+chr(10)
//			   cMsg += "Será necessário estonar esse Encerramento e refazer."+chr(13)+chr(10)
//			   cMsg += "Favor avisar T.I."
//			   MessageBox(cMsg, "Erro no Processo de Encerramento", 16)
//			   exit
//			endif
// Fim -  Inclusão de bloco para localizar problema - Luiz - 19/10/2021		

//			CNX->(DbSeek(xFilial('CNX') + cNumContr + CZY->CZY_NUMERO)) (11/11/2021 - Luiz)

//			aNumTit	:= GetTitulo(cNumContr,cRevisao,CNX->CNX_NUMTIT,CNX->CNX_PREFIX)  (11/11/2021 - Luiz)
//       

            aNumTit	:= GetCNX(cNumContr,cRevisao,CZY->CZY_NUMERO)
			nVlrAdi := nVlrAdi + CZY->CZY_VALOR

// Inicio - Inclusão de bloco para localizar problema - Luiz - 19/10/2021
// 
		    if len(aNumTit) = 0
			   DbSelectArea("SZE")
			   RecLock("SZE", .T.)
			   ZE_FILIAL := ""
			   ZE_DATA   := dDataBase
			   ZE_HORA   := SubStr(Time(),1,8)
			   ZE_CONTRA := cNumContr
			   ZE_NUMMED := cNumMed
			   //cTitulo   := cNumContr+"/"+cRevisao+"/"+CZY->CZY_NUMERO
			   cMsg := "CNX NÃO ENCONTRADO - Chave (Fil+Ctr+NMed): " +xFilial('CNX') + cNumContr + CZY->CZY_NUMERO
			   cmsg += " - Medição: " + CZY->CZY_NUMMED 
			   cMsg += " - Filial logada: " + cFilAnt + " - Fiial CND: " + CND->CND_FILIAL
			   ZE_MENSA  := cMsg
			   MsUnlock()
			   cMsg := "Atenção: Erro no Encerramento foi localizado."+chr(13)+chr(10)
			   cMsg += "Será necessário estonar esse Encerramento e refazer."+chr(13)+chr(10)
			   cMsg += "Favor avisar T.I."
			   MessageBox(cMsg, "Erro no Processo de Encerramento", 16)
			   exit
			endif
// Fim -  Inclusão de bloco para localizar problema - Luiz - 19/10/2021		

			If Len(aNumTit) > 0 .And. SC7->( DbSeek(xFilial("SC7") + cNumPC ) )
					
			    RecLock("FIE",.T.)
			   	FIE_FILIAL := xFilial('FIE')
			    FIE_CART   := "P"
			    FIE_PEDIDO := SC7->C7_NUM
			    FIE_PREFIX := aNumTit[1,1]
			    FIE_NUM    := aNumTit[1,2]
			    FIE_PARCEL := aNumTit[1,3]
			    FIE_TIPO   := "PA"
			    FIE_CLIENT := ""
			    FIE_FORNEC := SC7->C7_FORNECE
			    FIE_LOJA   := SC7->C7_LOJA
			    FIE_VALOR  := CZY->CZY_VALOR 		// Valor do Adiantamento
			    FIE_SALDO  := CZY->CZY_VALOR		
				FIE->(MSUnLock())	
					
			EndIf		  		

			DBSelectArea("CZY")
			DBSetOrder(1)
			DBSkip()

		EndDo  		  		  

	EndIf 
	 
EndIf

RestArea( aAreaCNX )
RestArea( aAreaSC7 )

Return()                               



Static Function GetTitulo(cNumContr,cRevisao,cNumTit,cPrefTit)
Local cQuery	:= ""
Local cAliasQry := GetNextAlias()
Local aAreaAtu	:= GetArea()
Local aRetorno	:= {}    

cQuery := "SELECT E2_PREFIXO, E2_NUM, E2_PARCELA "
cQuery += "FROM "+RetSqlName("SE2")
cQuery += " WHERE E2_FILIAL  = '"+xFilial("SE2")+"'"
cQuery += "   AND E2_NUM = '"+cNumTit+ "'"+ " AND E2_PREFIXO = '"+cPrefTit+"'"
cQuery += "   AND E2_MDCONTR = '"+cNumContr+ "'"
//cQuery += "   AND E2_MDREVIS = '"+cRevisao+ "'"     -- Comentando: não pode considerar a revisão para os títulos 
cQuery += "   AND D_E_L_E_T_  = ' ' "
cQuery := ChangeQuery( cQuery )

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. )
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())

While (cAliasQry)->(!Eof())
    Aadd(aRetorno,{ (cAliasQry)->E2_PREFIXO, (cAliasQry)->E2_NUM, (cAliasQry)->E2_PARCELA })
    (cAliasQry)->(dbSkip())
EndDo

(cAliasQry)->(DbCloseArea())

Return( aRetorno )  



// Bloco criado pelo André - corrigido por Luiz (11/11/2021)
// Pegar dados do titulo na CNX          
Static Function GetCNX(cNumContr,cRevisao,cNumCNX)
Local cQuery1	:= ""
Local cAliasQry := GetNextAlias()
Local aRet	    := {}    

cQuery1 := "SELECT CNX_FILIAL, CNX_CONTRA, CNX_NUMERO, CNX_PREFIX,CNX_NUMTIT"
cQuery1 += " FROM "+RetSqlName("CNX")
cQuery1 += " WHERE CNX_FILIAL ='"+xFilial("CNX")+"'"
cQuery1 += " AND CNX_CONTRA ='"+cNumContr+ "'"
cQuery1 += " AND CNX_NUMERO ='"+cNumCNX+ "'"
cQuery1 += " AND D_E_L_E_T_ <> '*'"

cQuery1 := ChangeQuery(cQuery1)

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery1 ), cAliasQry, .F., .T. )
DbSelectArea(cAliasQry)
(cAliasQry)->(DbGoTop())

// Deverá econtrar sempre apenas um registro ou nenhum - pois o campo cNumCNX é justamente o 
// número do adiantamento usado - se não encontrar é porque houve amarração incorreta na rotina da inclusão
// da medição
//While (cAliasQry)->(!Eof())
if (cAliasQry)->(!Eof())
    Aadd(aRet,{ (cAliasQry)->CNX_PREFIX,(cAliasQry)->CNX_NUMTIT,"001"})  // Retornando "001" na Parcela
endif
//    (cAliasQry)->(dbSkip())
//EndDo

(cAliasQry)->(DbCloseArea())

Return(aRet ) 
