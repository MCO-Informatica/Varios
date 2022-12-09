Static cBDGSTQ	:= ""
Static cBDPROT	:= ""
Static cBVGstq	:= ""

/*/{Protheus.doc} PuxaCliG
//TODO Busca um cliente determinado no Gestoq e grava no Protheus caso não exista.
@author Pirolo
@since 26/12/2019
@return return, return_description
/*/
User Function PuxaCliG()
Local cCdCli := ""
Local aPergs   := {}
Local cCodRec  := space(08)
Local cRecDest := space(06)
Local cArquivo := padr("",150)
Local aRet	   := {}

//RPCSETTYPE(3)
//RPCSETENV("01", "0101")

aAdd( aPergs ,{1, "Cód Cliente Gestoq", cRecDest,"@!",'!Empty(mv_par01)',,'.T.',40,.T.})

If !ParamBox(aPergs ,"Integrar Cliente Gestoq",aRet)
    Return
EndIf

cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
cBDPROT	:= GetMv("MV_TWINENV")
cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)


   _qCli := "SELECT ID_CLIENTE, NOME, FANTASIA, ENDERECO, COMPL_END, REPLACE(REPLACE(CEP,'.',''),'-','') CEP, BAIRRO, ATIV.SUBST_TRIB SUBTRIB, "
   _qCli += "RGINSC, INTERNET eMail, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-','') TELEFONE, CONTATO, CONVERT(CHAR(8),CADASTRO,112) CADASTRO, CONVERT( CHAR(8), ULT_COMPRA,112) ULT_COMPRA, CLIENTE.SUFRAMA,"
   _qCli += "REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') CPFCGC, CIDADE.DESCRICAO, UF, COD_UF, MUNICIPIO , PAIS, REPLACE(ISNULL(PLANO.CODIGO,'112010001'),'.','') CONTA"
   _qCli += ' FROM ['+cBDGSTQ+'].[dbo].[CLIENTE] '
   _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = CLIENTE.ID_CIDADE '
   _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '
   _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ATIVIDADE] ATIV ON ATIV.ID_ATIVIDADE = CLIENTE.ID_ATIVIDADE '
   _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO] ON PLANO.ID_PLANO = OP.ID_PLANO_CR '
   _qCli += "WHERE (CLIENTE.ID_CLIENTE = "+aRet[1]+" )" 

   dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qCli),"CLI",.T.,.T.)

   DbSelectArea("SA1")
   SA1->(DbSetOrder(1))

   While CLI->(!Eof())
   		cCdCli := StrZero( CLI->ID_CLIENTE, 6 )
   
		If !SA1->(DbSeek(xFilial("SA1")+cCdCli+"01"))
			RecLock( 'SA1', .T. )
			
				SA1->A1_LOJA    := '01'
				SA1->A1_COD     := cCdCli
				SA1->A1_NOME    := CLI->NOME
				SA1->A1_NREDUZ  := CLI->FANTASIA
				SA1->A1_INSCR   := UPPER(CLI->RGINSC)
				SA1->A1_CGC     := CLI->CPFCGC
				SA1->A1_CEP     := CLI->CEP
				SA1->A1_MUN     := CLI->DESCRICAO
				SA1->A1_COD_MUN := CLI->MUNICIPIO
				SA1->A1_PAIS    := SUBSTR( CLI->PAIS,1,3 )
				SA1->A1_CODPAIS := '0' + SUBSTR( CLI->PAIS,1, 4 )	
				SA1->A1_TEL     := CLI->TELEFONE
				SA1->A1_END     := CLI->ENDERECO
				SA1->A1_EST     := CLI->UF
				SA1->A1_BAIRRO  := CLI->BAIRRO
				SA1->A1_PESSOA  := if( Len(RTRIM(CLI->CPFCGC)) <> 14, 'F', 'J' )
				SA1->A1_TIPO    := iif( CLI->SUBTRIB <> 'S', 'R', 'S' )
				SA1->A1_PRICOM  := STOD( CLI->CADASTRO ) 
				SA1->A1_ULTCOM  := STOD( '20160329' )
				SA1->A1_CONTA   := CLI->CONTA
				SA1->A1_NATUREZ := '10101'
				
			SA1->( dbUnLock() )
		Else
			RecLock( 'SA1', .F. )
				SA1->A1_NOME    := CLI->NOME
				SA1->A1_NREDUZ  := CLI->FANTASIA
				SA1->A1_INSCR   := UPPER(CLI->RGINSC)
				SA1->A1_CEP     := CLI->CEP
				SA1->A1_MUN     := CLI->DESCRICAO
				SA1->A1_COD_MUN := CLI->MUNICIPIO
				SA1->A1_PAIS    := SUBSTR( CLI->PAIS,1,3 )
				SA1->A1_CODPAIS := '0' + SUBSTR( CLI->PAIS,1, 4 )	
				SA1->A1_TEL     := CLI->TELEFONE
				SA1->A1_END     := CLI->ENDERECO
				SA1->A1_EST     := CLI->UF
				SA1->A1_BAIRRO  := CLI->BAIRRO
				SA1->A1_TIPO    := iif( CLI->SUBTRIB <> 'S', 'R', 'S' )
				SA1->A1_PRICOM  := STOD( CLI->CADASTRO ) 
			SA1->( dbUnLock() )
		EndIf
		
		CLI->(DbSkip())   
	EndDo
CLI->( dbCloseArea() )

Return( NIL )
