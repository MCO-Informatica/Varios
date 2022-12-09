#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CRPAJOB  บ Autor ณ Tatiana Pontes     บ Data ณ  28/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualizacao tabela SZ5 com dados complementares do GAR     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Certisign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                 
User Function CRPAJOB(_lJob)

	Local aPedGar	:= {}     
	
	Local cJobEmp	:= GETJOBPROFSTRING ( "JOBEMP" , "01" )   //Empresa que sera usada para abertura do atendimento
	Local cJobFil 	:= GETJOBPROFSTRING ( "JOBFIL" , "02" )   //Filial que sera usada para abertura do atendimento     
	Local cSqlRet 	:= ""
	Local oObj

	Default _lJob 		:= .T. //Executa o acesso ao Servidor 

	oWSObj := WSIntegracaoGARERPImplService():New()   

	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp,cJobFil)
	EndIf

	cSqlRet := " SELECT SZ5.R_E_C_N_O_ SZ5REC "
	cSqlRet += " FROM " + RetSqlName("SZ5") + " SZ5 "           
	cSqlRet += " WHERE SZ5.Z5_FILIAL = '" + xFilial("SZ5")+ "' "
	cSqlRet += " AND SZ5.Z5_FLAGA <> 'A' " 
	cSqlRet += " AND SZ5.Z5_PEDGAR <> '' "          
	cSqlRet += " AND SZ5.Z5_DATVER >= '20130807' "
	cSqlRet += " AND SZ5.D_E_L_E_T_ = ' '"
	
	cSqlRet := ChangeQuery(cSqlRet)
	TCQUERY cSqlRet NEW ALIAS "TMPSZ5"

	DbSelectArea("TMPSZ5")

	If TMPSZ5->(!Eof())

		TMPSZ5->(DbGoTop())
	
		While TMPSZ5->(!Eof())
	    
			DbselectArea("SZ5")
			SZ5->(DbGoto(TMPSZ5->SZ5REC))              
	    
			IF oWSObj:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
									   eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
									   Val( SZ5->Z5_PEDGAR ) )	
				SZ5->(Reclock("SZ5"))		
	
				//Codigo do parceiro
				If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO) <> "U" .AND. oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO <> 0
					SZ5->Z5_CODPAR	:= Alltrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO))
				EndIf   

				//Descricao do Parceiro		
				If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO) <> "U"
					SZ5->Z5_NOMPAR	:= AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO)
				EndIf       

				//Codigo do Revendedor
				If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR) <> "U" .AND. oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR <> 0
					SZ5->Z5_CODVEND	:= Alltrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR))
				EndIf   

				//Descricao do Revendedor
				If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR) <> "U"
					SZ5->Z5_NOMVEND := AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR)	
				EndIf                           
						     
				//Tipo de parceiro
				If ValType(oWSObj:OWSDADOSPEDIDO:NTIPOPARCEIRO) <> "U" .AND. oWSObj:OWSDADOSPEDIDO:NTIPOPARCEIRO <> 0
					SZ5->Z5_TIPOPAR := Alltrim(Str(oWSObj:OWSDADOSPEDIDO:NTIPOPARCEIRO))
				Endif
				
	   			SZ5->Z5_FLAGA := "A"
		
				SZ5->(MsUnlock())	
			
				Conout("Pedido GAR "+Alltrim(SZ5->Z5_PEDGAR)+" atualizado com sucesso")
		
			Else
	
				Conout("Erro ao conectar com WS IntegracaoERP. Pedido GAR "+Alltrim(SZ5->Z5_PEDGAR)+" nao atualizado")			
	
			Endif

        	DbselectArea("TMPSZ5")
			TMPSZ5->(DbSkip())
		
		Enddo

	Endif     

	TMPSZ5->(DbCloseArea())

Return()