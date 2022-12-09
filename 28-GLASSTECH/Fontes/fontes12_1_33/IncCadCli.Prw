Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

User Function IncCadCli( _cQry )

If ValType( _cQry ) = 'U'

   _cQry := "SELECT DISTINCT E1_CLIENTE FROM SE1010 SE1 LEFT OUTER JOIN SA1010 SA1 ON A1_COD = E1_CLIENTE AND SA1.D_E_L_E_T_ = '' WHERE SE1.D_E_L_E_T_ = '' AND SA1.A1_COD IS NULL"

End

dbUseArea( .T., "TOPCONN", TCGenQry(,,_cQry), "TMP", .T., .T. )

_cFilSA1 := xFilial( 'SA1' )

While ! TMP->( Eof() )

    If ! SA1->( dbSeek( _cFilSA1 + iif( ValType( TMP->E1_CLIENTE ) = 'N', StrZero( TMP->E1_CLIENTE, 6,0 ), TMP->E1_CLIENTE) + '01', .F. ) )

       _qCli := "SELECT ID_CLIENTE, NOME, FANTASIA, ENDERECO, COMPL_END, REPLACE(REPLACE(CEP,'.',''),'-','') CEP, BAIRRO, ATIV.SUBST_TRIB SUBTRIB, "
       _qCli += "RGINSC, INTERNET eMail, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-','') TELEFONE, CONTATO, CONVERT(CHAR(8),CADASTRO,112) CADASTRO, CONVERT( CHAR(8), ULT_COMPRA,112) ULT_COMPRA, CLIENTE.SUFRAMA,"
       _qCli += "REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') CPFCGC, CIDADE.DESCRICAO, UF, COD_UF, MUNICIPIO , PAIS, REPLACE(ISNULL(PLANO.CODIGO,'112010001'),'.','') CONTA"
       _qCli += ' FROM ['+cBDGSTQ+'].[dbo].[CLIENTE] '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = CLIENTE.ID_CIDADE '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ATIVIDADE] ATIV ON ATIV.ID_ATIVIDADE = CLIENTE.ID_ATIVIDADE '
       _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO] ON PLANO.ID_PLANO = OP.ID_PLANO_CR '
       _qCli += "WHERE (CLIENTE.ID_CLIENTE = " + iif( ValType( TMP->E1_CLIENTE ) = 'N', StrZero( TMP->E1_CLIENTE, 6,0 ), TMP->E1_CLIENTE) + ")"

       dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qCli),"CLI",.T.,.T.)

       RecLock( 'SA1', .T. )

       SA1->A1_LOJA    := '01'
       SA1->A1_COD     := StrZero( CLI->ID_CLIENTE, 6 )
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
       
       CLI->( dbCloseArea() )

    End
   
    TMP->( dbSkip() )

End
         
TMP->( dbCloseArea() )

Return( NIL )
