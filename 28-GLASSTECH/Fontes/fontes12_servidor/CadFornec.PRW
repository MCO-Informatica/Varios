#include "PROTHEUS.CH"
Static lAmbTst := At("_TST", Upper(GetEnvServer())) > 0

/*/{Protheus.doc} CadForn
//TODO Descrição auto-gerada.
@author Bruno
@since 19/08/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User function CadForn( _cForn )
DEFAULT _cForn := "SELECT DISTINCT E5_CLIFOR E2_FORNECE FROM SE5010 WHERE D_E_L_E_T_ = '' AND E5_FORNECE = 'XXXXXX'"
                                  
_cFilSA2 := xFilial( 'SA2' )

dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cForn), 'CAD' )
                                                      
While ! ( CAD->( Eof() ) )

    If ! ( SA2->( dbSeek( _cFilSA2 + if( valtype( CAD->E2_FORNECE ) = 'N', StrZero( CAD->E2_FORNECE, 6, 0 ), CAD->E2_FORNECE) +'01', .F. ) ) )

       _cQry := "SELECT ID_CLIENTE, NOME, ENDERECO, BAIRRO, REPLACE(REPLACE(REPLACE( CEP, '-', '' ), ' ', ''),'.','') CEP, REPLACE(REPLACE(REPLACE( CPFCGC, '-',''),'/',''),'.','') CPFCGC , RGINSC, CONTATO, CONVERT( CHAR(8), CADASTRO, 112) CADASTRO, ISNULL( OP.NATUREZA, '99999') NATUREZA, CID.DESCRICAO, CID.UF, CID.MUNICIPIO, "
       _cQry += "NUMERO, TELEFONE FROM "+Iif(lAmbTst, "[TESTE]", "[TPCP]")+".[dbo].[CLIENTE] "
       _cQry += "LEFT OUTER JOIN "+Iif(lAmbTst, "[TESTE]", "[TPCP]")+".[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL "
       _cQry += "LEFT OUTER JOIN "+Iif(lAmbTst, "[TESTE]", "[TPCP]")+".[dbo].[CIDADE] CID ON CID.ID_CIDADE = CLIENTE.ID_CIDADE "
       _cQry += "WHERE ID_CLIENTE = " + if( valtype( CAD->E2_FORNECE ) = 'N', ltrim( Str( CAD->E2_FORNECE, 6, 0 )), Alltrim( Str( Val( CAD->E2_FORNECE ), 6 ) ) )

       dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )

       _cCodFor := StrZero( TMP->ID_CLIENTE, 6 )
       _xNOME   := AllTrim(TMP->NOME)                 
       _IE      := AllTrim(TMP->RGINSC)
       _CEP     := AllTrim(TMP->CEP)
       _CMUN    := RIGHT(AllTrim(TMP->MUNICIPIO), 5)
       _CPAIS   := '1058'
       _FONE    := AllTrim(TMP->TELEFONE)
       _NRO     := AllTrim(TMP->NUMERO)
       _UF      := TMP->UF
       _XBAIRRO := AllTrim(TMP->BAIRRO)
       _XLGR    := AllTrim(TMP->ENDERECO)
       _XMUN    := AllTrim(TMP->DESCRICAO)
       cCgc     := Alltrim(TMP->CPFCGC)
          
       RecLock( 'SA2', .T. )
       SA2->A2_LOJA    := '01'
       SA2->A2_COD     := _cCodFor
       SA2->A2_NOME    := _xNOME
       SA2->A2_NREDUZ  := Substr( _xNome, 1, at( ' ', _xNome) )
       SA2->A2_INSCR   := _IE
       SA2->A2_CGC     := cCGC
       SA2->A2_CEP     := _CEP
       SA2->A2_MUN     := _XMUN
       SA2->A2_COD_MUN := _CMUN
       SA2->A2_PAIS    := SUBSTR( _CPAIS,1,3 )
       SA2->A2_CODPAIS := '0' + _CPAIS
       SA2->A2_TELRE   := _FONE
       SA2->A2_END     := _XLGR

       If at( ',', _XLGR ) = 0

          SA2->A2_END := rTrim( SA2->A2_END ) + ', ' + Alltrim( Str( Val( _NRO ), 5, 0) )
       
       End

       SA2->A2_EST    := _UF
       SA2->A2_BAIRRO := _XBAIRRO
       SA2->A2_TIPO := if( Len(cCGC) <> 14, 'F', 'J' )
       SA2->( dbUnLock() )
       TMP->( dbCloseArea() )

    End   

    CAD->( dbSkip() )

End

CAD->( dbCloseArea() )

Return( NIL )