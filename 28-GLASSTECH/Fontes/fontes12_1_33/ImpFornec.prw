
Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
Static cBDPROTG	:= GetMv("MV_TWINENF")

User Function ImpFornec()

_cQry := 'SELECT CODIGO A2_COD, NOME A2_NOME, LOGRADOURO A2_END, NUMERO A2_NR_END, BAIRRO A2_BAIRRO, CC2_MUN A2_MUN, ESTADO A2_EST,  substring(CliFor.CIDADE, 3, 5) A2_COD_MUN, '
_cQry += "REPLACE(CEP,'-','') A2_CEP, REPLACE(REPLACE(REPLACE( CNPJCPF, '.', ''),'/',''),'-','') A2_CGC, CASE INSCRESTAD WHEN ' ' THEN 'ISENTO' ELSE INSCRESTAD END A2_INSCR, "
_cQry += "SUBSTRING(PAIS,2,3) A2_PAIS, PAIS A2_CODPAIS, REPLACE(REPLACE(REPLACE(TELEFONE,'(',''),')',''),'-','') A2_TEL, CONTATO A2_CONTATO, FK_CLIFOR A2_TELRE, "
_cQry += " DATADAALT A2_ULTCOM "
_cQry += 'FROM '+cBDPROTG+'.dbo.CLI_FOR CliFor, CC2010 CC2 '
_cQry += "WHERE CC2.CC2_EST = CliFor.ESTADO  and CC2.CC2_CODMUN = substring(CliFor.CIDADE, 3, 5) "

                                     
dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQry),"TMP",.T.,.T.)
SA2->( dbSetOrder( 3 ) )
_cFilSA2 := xFilial( 'SA2' )

While ! TMP->( Eof() )

   if  ! ( SA2->( dbSeek( _cFilSA2 + TMP->A2_CGC, .F. ) ) )

       RecLock( 'SA2', .T. )
         SA2->A2_LOJA   := '01'
         SA2->A2_COD    := GetSXENum( 'SA2' )
         SA2->A2_NOME   := TMP->A2_NOME
         SA2->A2_NREDUZ := Substr( TMP->A2_NOME, 1, at( ' ', TMP->A2_NOME) )
         SA2->A2_INSCR  := TMP->A2_INSCR
         SA2->A2_CGC    := TMP->A2_CGC
         SA2->A2_CEP    := TMP->A2_CEP
         SA2->A2_MUN    := TMP->A2_MUN
         SA2->A2_COD_MUN := TMP->A2_COD_MUN
         SA2->A2_PAIS    := TMP->A2_PAIS
         SA2->A2_CODPAIS := TMP->A2_CODPAIS
         SA2->A2_TEL    := if( Len(ALLTRIM(TMP->A2_TEL)) > 9, SUBSTR( TMP->A2_TEL, 3, 8 ), TMP->A2_TEL )
         SA2->A2_DDD    := if( Len(ALLTRIM(TMP->A2_TEL)) > 9, SUBSTR( TMP->A2_TEL, 1, 2 ), '' )
         SA2->A2_END    := TMP->A2_END
         SA2->A2_NR_END := TMP->A2_NR_END
         SA2->A2_CONTATO := TMP->A2_CONTATO
         SA2->A2_TELRE   := TMP->A2_TELRE
         SA2->A2_MSBLQL  := '2'

         /*   If at( ',', _XLGR ) = 0
         
                  SA2->A2_END := rTrim( SA1->A1_END ) + ', ' + Alltrim( Str( Val( TMP->A2_NRO ), 5, 0) )
         
               End
         */
         SA2->A2_EST    := TMP->A2_EST
         SA2->A2_BAIRRO := TMP->A2_BAIRRO
         SA2->A2_TIPO   := if( Len(TMP->A2_CGC) <> 14, 'F', 'J' )
         SA2->A2_ULTCOM := stod( TMP->A2_ULTCOM )
       ConfirmSX8()
       SA2->( dbUnLock() )

   else
     
      If TMP->A2_ULTCOM > dtos( SA2->A2_ULTCOM )
         RecLock( 'SA2', .F. )
            SA2->A2_NOME   := TMP->A2_NOME
            SA2->A2_NREDUZ := Substr( TMP->A2_NOME, 1, at( ' ', TMP->A2_NOME) )
            SA2->A2_INSCR  := TMP->A2_INSCR
            SA2->A2_CGC    := TMP->A2_CGC
            SA2->A2_CEP    := TMP->A2_CEP
            SA2->A2_MUN    := TMP->A2_MUN
            SA2->A2_COD_MUN := TMP->A2_COD_MUN
            SA2->A2_PAIS    := TMP->A2_PAIS
            SA2->A2_CODPAIS := TMP->A2_CODPAIS
            SA2->A2_TEL    := if( Len(ALLTRIM(TMP->A2_TEL)) > 9, SUBSTR( TMP->A2_TEL, 3, 8 ), TMP->A2_TEL )
            SA2->A2_DDD    := if( Len(ALLTRIM(TMP->A2_TEL)) > 9, SUBSTR( TMP->A2_TEL, 1, 2 ), '' )
            SA2->A2_END    := TMP->A2_END
            SA2->A2_NR_END := TMP->A2_NR_END
            SA2->A2_CONTATO := TMP->A2_CONTATO
            SA2->A2_TELRE   := TMP->A2_TELRE
            SA2->A2_EST    := TMP->A2_EST
            SA2->A2_BAIRRO := TMP->A2_BAIRRO
            SA2->A2_TIPO := if( Len(TMP->A2_CGC) <> 14, 'F', 'J' )
         SA2->( dbUnLock() )                                   
      End

   End

   TMP->( dbSkip() )

End

TMP->( dbCloseArea() )

Return( NIL )
