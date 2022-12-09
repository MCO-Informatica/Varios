#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUMOVRP  บAutor  ณMicrosiga           บ Data ณ  11/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Programa que Atualiza a tabela SZ5 buscando informacoes    บฑฑ
ฑฑบ          ณ complementares de PedGAR no GAR para                       บฑฑ
ฑฑบ          ณ Atualiza info de Voucher na SZ5.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Opvs / Certisign                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
   <soap:Body>
      <ns2:findDadosPedidoResponse xmlns:ns2="http://ws.integracaogarerp.certisign.com.br/">
         <return>
            <acDesc>AC Certisign RFB V2</acDesc>
            <arDesc>AR VESCHI</arDesc>
            <arId>ARVES</arId>
            <arValidacao>ARVES</arValidacao>
            <arValidacaoDesc>AR VESCHI</arValidacaoDesc>
            <cnpjCert>2549051000100</cnpjCert>
            <codigoParceiro>0</codigoParceiro>
            <codigoRevendedor>0</codigoRevendedor>
            <comissaoParceiroHW>0</comissaoParceiroHW>
            <comissaoParceiroSW>0</comissaoParceiroSW>
            <cpfAgenteValidacao>25175514806</cpfAgenteValidacao>
            <cpfAgenteVerificacao>8894456803</cpfAgenteVerificacao>
            <cpfTitular>462353885</cpfTitular>
            <dataEmissao>27/05/2014 00:00:00</dataEmissao>
            <dataPedido>11/02/2010 18:10:58</dataPedido>
            <dataValidacao>28/05/2014 15:30:36</dataValidacao>
            <dataVerificacao>28/05/2014 15:36:59</dataVerificacao>
            <emailTitular>coordenador.ti@ademirtransportes.com.br</emailTitular>
            <grupo>PUBLI</grupo>
            <grupoDescricao>Varejo AC Certisign RFB</grupoDescricao>
            <idRede>6</idRede>
            <nomeAgenteValidacao>SILVANA APARECIDA GUIMARAES VESCHI</nomeAgenteValidacao>
            <nomeAgenteVerificacao>JOSE ANTONIO VESCHI</nomeAgenteVerificacao>
            <nomeTitular>ADEMIR DA SILVA</nomeTitular>
            <pedido>669045</pedido>
            <pedidoANTIGO></pedidoantigo>
            <postoValidacaoDesc>AR VESCHI</postoValidacaoDesc>
            <postoValidacaoId>8039</postoValidacaoId>
            <postoVerificacaoDesc>AR VESCHI</postoVerificacaoDesc>
            <postoVerificacaoId>8039</postoVerificacaoId>
            <produto>SRFA1PJHV2</produto>
            <produtoDesc>e-CNPJ A1 - AC Certisign RFB Validade de 1 ano</produtoDesc>
            <razaoSocialCert>ATADIESEL COMERCIO DE DIESEL E LUBRIFICANTES LTDA</razaoSocialCert>
            <rede>AC SINCOR</rede>
            <status>3</status>
            <statusDesc>Pronto para Emitir</statusDesc>
            <tipoParceiro>0</tipoParceiro>
         </return>
      </ns2:findDadosPedidoResponse>
   </soap:Body>
</soap:Envelope>

*/

User Function AtuMovRP(aParSch)

	Local aPedGar 	:= {}
	Local aGrLog	:= {}
	Local cJobEmp	:= IIf(Type("aParSch[1]") <> "U"  ,aParSch[1], '01')
	Local cJobFil	:= IIf(Type("aParSch[2]") <> "U"  ,aParSch[2], '02')
	Local cSqlRet 	:= ""
	Local cGrNLog	:= ""
	Local cGrSLog	:= ""
	Local cArqLog	:= "PEDIDOS_SZ5.log"
	Local cLogPedGar:= ""
	Local _lJob 	:= (Select("SX6") == 0)
	Local nDiasAtras := 30 
	Local oObj

	If _lJob
		RpcSetType(3)
		RpcSetEnv(cJobEmp,cJobFil)
	EndIf                  
    nDiasAtras := SuperGetMv("MV_DIASATR",.F.,30)
    
    //Renato Ruy - 26/09/14 - Gera็ใo de Dados na SZ5 para serem verificados no GAR
    
    cQuery := " SELECT C5_CHVBPAG,C5_EMISSAO "
    cQuery += " FROM " + RetSqlName("SC5") 
	cQuery += " SC5 LEFT JOIN " + RetSqlName("SZ5") 
	cQuery += " SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR = C5_CHVBPAG AND SZ5.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE "
	cQuery += " C5_FILIAL = '" + xFilial("SC5") + "' AND "
	cQuery += " C5_EMISSAO >= '" + DtoS(dDataBase - nDiasAtras)+ "' AND "
	cQuery += " (C5_XNFHRD <> ' ' OR C5_XNFSFW <> ' ' ) AND "
	cQuery += " C5_CHVBPAG <> ' ' AND "
	cQuery += " SZ5.Z5_PEDGAR IS NULL AND "
	cQuery += " SC5.D_E_L_E_T_ = ' ' "
	cQuery += " UNION "
	cQuery += " SELECT ZG_NUMPED C5_CHVBPAG,ZG_DATAMOV C5_EMISSAO "
	cQuery += " FROM " + RetSqlName("SZG") 
	cQuery += " SZG LEFT JOIN " + RetSqlName("SZ5") 
	cQuery += " SZ5 ON SZ5.Z5_FILIAL = ' ' AND SZ5.Z5_PEDGAR = ZG_NUMPED AND SZ5.D_E_L_E_T_ = ' ' 
	cQuery += " WHERE " 
	cQuery += " ZG_FILIAL = ' ' AND "
	cQuery += " ZG_DATAMOV >= '" + DtoS(dDataBase - nDiasAtras)+ "' AND "
	cQuery += " ZG_NUMPED BETWEEN '1000000   ' AND '9999999999' AND "
	cQuery += " SZ5.Z5_PEDGAR IS NULL AND "
	cQuery += " SZG.D_E_L_E_T_ = ' ' "
	
	TCQUERY cQuery NEW ALIAS "TMPSC5"
	
	While TMPSC5->(!Eof())
	    
		SZ5->(DbSetOrder(1))
		If !SZ5->(DbSeek( xFilial("SZ5") + TMPSC5->C5_CHVBPAG )) .And. !Empty(TMPSC5->C5_CHVBPAG)
			
			DbSelectArea("SZ5")
			RecLock("SZ5",.T.)
				SZ5->Z5_PEDGAR  := TMPSC5->C5_CHVBPAG
				SZ5->Z5_EMISSAO := StoD(TMPSC5->C5_EMISSAO)
				SZ5->Z5_TIPO 	:= 'VALIDA'
			SZ5->(MsUnlock())
				
		EndIf
		
		TMPSC5->(DbSkip())
	EndDo
	    
    cSqlRet := "SELECT SZ5.R_E_C_N_O_ SZ5REC FROM " + RetSqlName("SZ5") + " SZ5"
	cSqlRet += " WHERE SZ5.Z5_FILIAL = '" + xFilial("SZ5")+ "'  AND SZ5.Z5_PEDGAR <> ' ' AND SZ5.D_E_L_E_T_ = ' ' "
	cSqlRet += " AND SZ5.Z5_EMISSAO >= '" +DtoS(dDataBase - nDiasAtras)+ "'"
	cSqlRet += " AND Z5_TIPO = 'VALIDA' "

	cSqlRet += " Union "
	//Fim da Customiza็ใo  
	
	cSqlRet := "SELECT SZ5.R_E_C_N_O_ SZ5REC FROM " + RetSqlName("SZ5") + " SZ5"
	cSqlRet += " WHERE SZ5.Z5_FILIAL = '" + xFilial("SZ5")+ "'  AND SZ5.Z5_PEDGAR <> ' ' AND SZ5.D_E_L_E_T_ = ' ' "
	cSqlRet += " AND SZ5.Z5_DATVER >= '" +DtoS(dDataBase - nDiasAtras)+ "'"
	cSqlRet += " AND (SZ5.Z5_FLAGA <> 'A' And SZ5.Z5_FLAGA <> 'E')"

	cSqlRet += " Union "

	cSqlRet += "SELECT SZ5.R_E_C_N_O_ SZ5REC FROM " + RetSqlName("SZ5") + " SZ5"
	cSqlRet += " WHERE SZ5.Z5_FILIAL = '" + xFilial("SZ5")+ "'  AND SZ5.Z5_PEDGAR <> ' ' AND SZ5.D_E_L_E_T_ = ' ' "
	cSqlRet += " AND SZ5.Z5_DATEMIS >= '" +DtoS(dDataBase - nDiasAtras)+ "'"
	cSqlRet += " AND SZ5.Z5_FLAGA <> 'E' "
      
    
//	cSqlRet := ChangeQuery(cSqlRet)
	TCQUERY cSqlRet NEW ALIAS "TMPSZ5"

	oWSObj := WSIntegracaoGARERPImplService():New()
	
	DbSelectArea("TMPSZ5")

	If TMPSZ5->(!Eof())
		TMPSZ5->(DbGoTop())
		While TMPSZ5->(!Eof())
    	 Begin Sequence

			DbselectArea("SZ5")
			SZ5->(DbGoto(TMPSZ5->SZ5REC))

			// Busca os dados do pedido de GAR

			IF oWSObj:findDadosPedido( eVal({|| oObj:=loginUserPassword():get('USERERPGAR'), oObj:cReturn }),;
																 eVal({|| oObj:=loginUserPassword():get('PASSERPGAR'), oObj:cReturn }),;
																 Val( SZ5->Z5_PEDGAR ) )
   				
				//aAdd(aGrLog,{"","Pedido Gar --> " + Alltrim(SZ5->Z5_PEDGAR),.T.})   					
   				
				SZ5->(Reclock("SZ5"))

		   		//Pedido GAR Anterior
				If ValType(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO) <> "U"
					SZ5->Z5_PEDGANT	:= Iif(Empty(SZ5->Z5_PEDGANT),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPEDIDOANTIGO)),SZ5->Z5_PEDGANT)
				EndIf

				//Certificado
				If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTO) <> "U"
					SZ5->Z5_PRODGAR := Iif(Empty(SZ5->Z5_PRODGAR),AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTO),SZ5->Z5_PRODGAR)  
					SZ5->Z5_PRODUTO := Iif(Empty(SZ5->Z5_PRODUTO),GetAdvFval('PA8','PA8_CODMP8',XFILIAL('PA8')+ALLTRIM(SZ5->Z5_PRODGAR), 1,''), SZ5->Z5_PRODUTO)
				EndIf

				//DECRICAO do Certificado
				If ValType(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC) <> "U"
					SZ5->Z5_DESPRO := Iif(Empty(SZ5->Z5_DESPRO),AllTrim(oWSObj:OWSDADOSPEDIDO:CPRODUTODESC),SZ5->Z5_DESPRO)  
				EndIf


				//CNPJ do Certificado
				If ValType(oWSObj:OWSDADOSPEDIDO:NCNPJCERT) <> "U"
					SZ5->Z5_CNPJ := Iif(Empty(SZ5->Z5_CNPJ),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT)),SZ5->Z5_CNPJ)  
					SZ5->Z5_CNPJCER := Iif(Empty(SZ5->Z5_CNPJCER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCNPJCERT)),SZ5->Z5_CNPJCER)  
				EndIf
				
				//Status do Pedido
				If ValType(oWSObj:OWSDADOSPEDIDO:cStatus) <> "U"
					SZ5->Z5_STATUS := AllTrim(oWSObj:OWSDADOSPEDIDO:cStatus)
				EndIf
		 
				//Codigo do Parceiro
				If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO) <> "U"
					SZ5->Z5_CODPAR := Iif(Empty(SZ5->Z5_CODPAR),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOPARCEIRO)),SZ5->Z5_CODPAR)  
				EndIf
				
				//Codigo do Parceiro
				If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO) <> "U"
					SZ5->Z5_NOMPAR := Iif(Empty(SZ5->Z5_NOMPAR),AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOPARCEIRO),SZ5->Z5_NOMPAR)
				EndIf
				
				//Codigo do Parceiro
				If ValType(oWSObj:OWSDADOSPEDIDO:cdescricaoRedeParceiro) <> "U"
					SZ5->Z5_DESREDE := Iif(Empty(SZ5->Z5_DESREDE),AllTrim(oWSObj:OWSDADOSPEDIDO:CREDEPARCEIRO),SZ5->Z5_DESREDE)
				EndIf

		  		//Descricao AC do Pedido
				If ValType(oWSObj:OWSDADOSPEDIDO:CACDESC) <> "U"
					SZ5->Z5_DESCAC	:= Iif(Empty(SZ5->Z5_DESCAC),AllTrim(oWSObj:OWSDADOSPEDIDO:CACDESC),SZ5->Z5_DESCAC)  
				EndIf


		 		//Descricao AR de Pedido
				If ValType(oWSObj:OWSDADOSPEDIDO:CARDESC) <> "U"
					SZ5->Z5_DESCARP	:= Iif(Empty(SZ5->Z5_DESCARP),AllTrim(oWSObj:OWSDADOSPEDIDO:CARDESC),SZ5->Z5_DESCARP)  
				EndIf

		  		//Codigo AR de Pedido
				If ValType(oWSObj:OWSDADOSPEDIDO:CARID) <> "U"
					SZ5->Z5_CODARP := Iif(Empty(SZ5->Z5_CODARP),AllTrim(oWSObj:OWSDADOSPEDIDO:CARID),SZ5->Z5_CODARP)  
				EndIf

		  		//Deve ser a AR de VERIFICACAO
		  		//Descricao AR de Validacao
				If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC) <> "U"
					SZ5->Z5_DESCAR	:= Iif(Empty(SZ5->Z5_DESCAR),AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAODESC),SZ5->Z5_DESCAR)  
				EndIf

				//Deve ser a AR de VERIFICACAO
				//Codigo AR de Validacao
				If ValType(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO) <> "U"
					SZ5->Z5_CODAR := Iif(Empty(SZ5->Z5_CODAR),AllTrim(oWSObj:OWSDADOSPEDIDO:CARVALIDACAO),SZ5->Z5_CODAR)  
				EndIf
                
				/* PRECISA INCLUIR NO INTEGRACAOFARERP_CLIENT.PRW VER NOVA ESTRUTURA NO INICIO  DESTE PROGRAMA
				//Data de Emissao do Pedido GAR
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO) <> "U" 
					SZ5->Z5_DATPED := Iif(Empty(SZ5->Z5_DATPED),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAPEDIDO),1,10)),SZ5->Z5_DATPED)
				EndIf
				*/
				//Data de Emissao do Pedido GAR
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO) <> "U" 
					SZ5->Z5_DATEMIS := Iif(Empty(SZ5->Z5_DATEMIS),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAEMISSAO),1,10)) + 1,SZ5->Z5_DATEMIS)
				EndIf
				//Data da Validacao
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO) <> "U"
					SZ5->Z5_DATVAL := Iif(Empty(SZ5->Z5_DATVAL),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVALIDACAO),1,10)),SZ5->Z5_DATVAL)  
				EndIf
				
				If ValType(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO) <> "U"
					SZ5->Z5_DATVER := Iif(Empty(SZ5->Z5_DATVER),CtoD(SubStr(AllTrim(oWSObj:OWSDADOSPEDIDO:CDATAVERIFICACAO),1,10)),SZ5->Z5_DATVER)  
				EndIf             
				
				//Grupo
				If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPO) <> "U"
					SZ5->Z5_GRUPO := Iif(Empty(SZ5->Z5_GRUPO),AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPO),SZ5->Z5_GRUPO)  
				EndIf

				//Descricao do Grupo
				If ValType(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO) <> "U"
					SZ5->Z5_DESGRU := Iif(Empty(SZ5->Z5_DESGRU),AllTrim(oWSObj:OWSDADOSPEDIDO:CGRUPODESCRICAO),SZ5->Z5_DESGRU)  
				EndIf

				//Deve ser o Posto de VERIFICACAO
				//Descricao do Posto de Valida๏ฟฝ๏ฟฝo
				If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC) <> "U"
					SZ5->Z5_DESPOS	:= Iif(Empty(SZ5->Z5_DESPOS),AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVALIDACAODESC),SZ5->Z5_DESPOS)  
				EndIf
				
				//If ValType(oWSObj:OWSDADOSPEDIDO:CPOSTOVERIFICACAODESC) <> "U"
				//	SZ5->Z5_DESPOS	:= Iif(Empty(SZ5->Z5_DESPOS),AllTrim(oWSObj:OWSDADOSPEDIDO:CPOSTOVERIFICACAODESC),SZ5->Z5_DESPOS)  
				//EndIf

				//Deve ser o Posto de VERIFICACAO
				//Codigo do posto de validacao
				If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID) <> "U"
					SZ5->Z5_CODPOS	:= Iif(Empty(SZ5->Z5_CODPOS),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVALIDACAOID)),SZ5->Z5_CODPOS)  
				EndIf
				
				If ValType(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID) <> "U"
					SZ5->Z5_POSVER	:= Iif(Empty(SZ5->Z5_POSVER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NPOSTOVERIFICACAOID)),SZ5->Z5_POSVER)  
				EndIf

				//Rede
				If ValType(oWSObj:OWSDADOSPEDIDO:CREDE) <> "U"
					SZ5->Z5_REDE	:= Iif(Empty(SZ5->Z5_REDE),AllTrim(oWSObj:OWSDADOSPEDIDO:CREDE),SZ5->Z5_REDE) 
				EndIf

				//Codigo do Revendedor
				If ValType(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR) <> "U"
					SZ5->Z5_CODVEND := Iif(Empty(SZ5->Z5_CODVEND),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCODIGOREVENDEDOR)),SZ5->Z5_CODVEND)  
				EndIf

				//Nome do revendedor
				If ValType(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR) <> "U"
					SZ5->Z5_NOMVEND := Iif(Empty(SZ5->Z5_NOMVEND),AllTrim(oWSObj:OWSDADOSPEDIDO:CDESCRICAOREVENDEDOR),SZ5->Z5_NOMVEND)  
				EndIf

                //Comissใo hardware do parceiro
				If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW) <> "U"
					SZ5->Z5_COMHW := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROHW
				EndIf

				//Comissใo software do parceiro
				If ValType(oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW) <> "U"
					SZ5->Z5_COMSW := oWSObj:OWSDADOSPEDIDO:NCOMISSAOPARCEIROSW
				EndIf

				//Definicao do tipo de movimento de remuneracao de parceiros

				//Mudara para agende de verifica็ใo
				//CPF do Agente de Validacao
				If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO) <> "U"
				   SZ5->Z5_CPFAGE	:= Iif(Empty(SZ5->Z5_CPFAGE),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVALIDACAO)),SZ5->Z5_CPFAGE)   
				EndIf
				
				If ValType(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO) <> "U"
				   SZ5->Z5_AGVER	:= Iif(Empty(SZ5->Z5_AGVER),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFAGENTEVERIFICACAO)),SZ5->Z5_AGVER)  
				EndIf

				//CPF do Titular do Certificado
				If ValType(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR) <> "U"
					SZ5->Z5_CPFT := Iif(Empty(SZ5->Z5_CPFT),AllTrim(Str(oWSObj:OWSDADOSPEDIDO:NCPFTITULAR)),SZ5->Z5_CPFT)  
				EndIf

				//Email do titular
				If ValType(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR) <> "U"
					SZ5->Z5_EMAIL := Iif(Empty(SZ5->Z5_EMAIL),AllTrim(oWSObj:OWSDADOSPEDIDO:CEMAILTITULAR),SZ5->Z5_EMAIL)  
				EndIf

				//Nome do Agente de Valida๏ฟฝ๏ฟฝo
				If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO) <> "U"
					SZ5->Z5_NOMAGE	:= Iif(Empty(SZ5->Z5_NOMAGE),AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVALIDACAO),SZ5->Z5_NOMAGE)  
				EndIf
				
				If ValType(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO) <> "U"
					SZ5->Z5_NOAGVER	:= Iif(Empty(SZ5->Z5_NOAGVER),AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMEAGENTEVERIFICACAO),SZ5->Z5_NOAGVER)  
				EndIf

				//Nome do Titular do Certificado
				If ValType(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR) <> "U"
					SZ5->Z5_NTITULA	:= Iif(Empty(SZ5->Z5_NTITULA),AllTrim(oWSObj:OWSDADOSPEDIDO:CNOMETITULAR),SZ5->Z5_NTITULA)  
				EndIf

				If ValType(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT) <> "U"
					SZ5->Z5_RSVALID	:= Iif(Empty(SZ5->Z5_RSVALID),AllTrim(oWSObj:OWSDADOSPEDIDO:CRAZAOSOCIALCERT),SZ5->Z5_RSVALID)  
				EndIf

               
				If !EMPTY(SZ5->Z5_DATEMIS)
					SZ5->Z5_FLAGA := "E"
				ElseIf !EMPTY(SZ5->Z5_DATVER)
					SZ5->Z5_FLAGA := "A"
				EndIf
			
				SZ5->(MsUnlock())

				//conout("Pedido GAR "+Alltrim(SZ5->Z5_PEDGAR)+" atualizado com sucesso")

			Else

				//aAdd(aGrLog,{"","Pedido Gar --> " + Alltrim(SZ5->Z5_PEDGAR),.F.})   					
			    
				Conout("Erro ao conectar com WS IntegracaoERP. Pedido GAR " + Alltrim(SZ5->Z5_PEDGAR) + " nใo atualizado")
			Endif
                                                              
			DbselectArea("TMPSZ5")
			TMPSZ5->(DbSkip())
         /*	   
		   If Len(aGrLog) == 100
				GRVLOGSZ5(@aGrLog,cArqLog)//Chamada da rotina para grava็ใo de um logo de pedidos GAR atualizados com sucesso
		   EndIf
		 */  
            DelClassIntF()
           End Sequence
   
		Enddo
	EndIf
	
	DbSelectArea("TMPSZ5")
	DbCloseArea()
	/*
  If Len(aGrLog) < 100
		GRVLOGSZ5(@aGrLog,cArqLog)//Chamada da rotina para grava็ใo de um logo de pedidos gar atualizados com sucesso
   EndIf
     */
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUMOVRP  บAutor  ณMicrosiga           บ Data ณ  10/08/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GRVLOGSZ5(aGrLog,cArqLog)

Local cGrEnter	:= Chr(13) + Chr(10)
Local cNCabec	:= Replicate(" - ",20) + " Pedidos nใo atualizados " + Replicate(" - ",20) + DtoC(Date()) + Chr(13) + Chr(10)
Local cSCabec	:= Replicate(" - ",20) + " Pedidos atualizados com sucesso " + Replicate(" - ",20) + DtoC(Date()) + Chr(13) + Chr(10)
Local lNgrvLog	:= .T.
Local lSgrvLog	:= .T.
Local nSeek		:= 0
Local nHdl		:= 0
Local nS		:= 0

aSort(aGrLog,,,{|x,y| x[03] > y[03]})

For nS := 1 To Len(aGrLog)
	If aGrLog[nS][03]
		If File(cArqLog)
			If nHdl == 0
				nHdl	:= fOpen(cArqLog,2)
				nSeek	:= fSeek(nHdl,0,2)
				fWrite(nHdl,cSCabec,nSeek + Len(cSCabec))	
				fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02]))	
				lSgrvLog := .F.
			Else
				If lSgrvLog
					nSeek	:= fSeek(nHdl,0,2)
					fWrite(nHdl,cSCabec,nSeek + Len(cSCabec))	
					fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02]))
					lSgrvLog := .F.
				Else
					nSeek	:= fSeek(nHdl,0,2)
					fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02]))
				EndIf                                                       
			EndIf
		Else
			nHdl := fCreate(cArqLog)
			fSeek(nHdl,0,2)  
			fWrite(nHdl,cSCabec,nSeek + Len(cSCabec))	
			fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02]))
			lSgrvLog := .F.
		EndIf
	Else
		If File(cArqLog)
			If nHdl == 0
				nHdl	:= fOpen(cArqLog,2)
				nSeek	:= fSeek(nHdl,0,2)
				fWrite(nHdl,cNCabec,nSeek + Len(cNCabec))	
				fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02]))	  
				lNgrvLog := .F.
			Else 
				If lNgrvLog
					//nHdl	:= fOpen(cArqLog,2)
					nSeek	:= fSeek(nHdl,0,2)
					fWrite(nHdl,cNCabec,nSeek + Len(cNCabec))	
					fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02]))
					lNgrvLog := .F.
				Else                                                   
					nSeek	:= fSeek(nHdl,0,2)
					fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02]))
				EndIf
			EndIf
		Else
			nHdl := fCreate(cArqLog)
			fSeek(nHdl,0,2)
			fWrite(nHdl,cNCabec,nSeek + Len(cNCabec))	
			fWrite(nHdl,aGrLog[nS][02] + cGrEnter,nSeek + Len(aGrLog[nS][02])) 
			lNgrvLog := .F.
		EndIf			
	EndIf
Next nS

fClose(nHdl)		        

aGrLog := {}//Limpado array para carregar novas informa็๕es dos pedidos GAR

Return