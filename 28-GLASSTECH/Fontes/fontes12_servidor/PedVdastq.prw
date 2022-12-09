Static cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PedVdastq º Autor ³ Sérgio Santana       º Data ³22/08/2015º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao Base de Dados                                   º±±
±±º          ³ Importação dos pedidos de vendas                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºALTERACAO ³                                                            º±± 
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ThermoGlass                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//U_PedVdastq( '20150101', '20151231' )
#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function PedVdastq( _cDtIni, _cDtFim  )

	LOCAL  i     := 0
	LOCAL _cItem := '00'
	
	DEFAULT _cDtIni := DtoS( dDataBase )
	DEFAULT _cDtFim := DtoS( dDataBase )
	
	PRIVATE _oPed    := Space(6)
	PRIVATE _qPed    := ' '
	PRIVATE _nVlrPed := 0
	PRIVATE _aItem   := {}
	PRIVATE _cFilSB1 := xFilial( 'SB1' )
	PRIVATE _cFilSB2 := xFilial( 'SB2' )
	PRIVATE _cFilSB5 := xFilial( 'SB5' )
	PRIVATE _cFilSA1 := xFilial( 'SA1' )
	PRIVATE _cFilSC9 := xFilial( 'SC9' )
	PRIVATE _cFilCB7 := xFilial( 'CB7' )
	PRIVATE _cFilCB8 := xFilial( 'CB8' )
	PRIVATE _cFilCB9 := xFilial( 'CB9' )
	PRIVATE _cFilDA0 := xFilial( 'DA0' )
	PRIVATE _cFilDA1 := xFilial( 'DA1' )
	PRIVATE _cFilNNR := xFilial( 'NNR' )
	PRIVATE _cFilSA4 := xFilial( 'SA4' )	
	PRIVATE _cFilSA3 := xFilial( 'SA3' )	
	
	PRIVATE _nRegIni := 0
	PRIVATE _cClient := '0'

    Pergunte( 'M460FFM', .T. )
	
	For i := 1 To 500
	
	   _cItem := Soma1( _cItem, 2 )
	   aAdd( _aItem, _cItem )
	
	Next 
	
	dbSelectArea( 'DA0' )

	If DA0->( RecCount() ) = 0

       TabPrc()               

	End

    _cDtIni := '20140101'

	_qPed := 'SELECT '
	_qPed += "Case"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 1) Then '0101'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 2) Then '0102'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 3) Then '0201'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 4) Then '0601'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 5) Then '0103'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 6) AND (ISNULL(PEDIDO.PEDIDO_ESPECIAL,'N') <> 'E') Then '0202'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 6) AND (ISNULL(PEDIDO.PEDIDO_ESPECIAL,'N') =  'E') Then '0701'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 16) AND (ISNULL(PEDIDO.PEDIDO_ESPECIAL,'N') =  'E') Then '0801'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 7) Then '0301'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 8) Then '0401'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 9) Then '0501'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 12) Then '0701'"
	_qPed += " When (PEDIDO.ID_EMPRESA_LOCADO_PED = 15) Then '0215'"
	_qPed += " Else '0000' End  C5_FILIAL,"
	_qPed += " CAST(REPLICATE( '0', 6 - LEN(CAST( PEDIDO.ID_PEDIDO AS VARCHAR(6) ))) + CAST( PEDIDO.ID_PEDIDO AS VARCHAR(6) ) AS CHAR(6)) C5_NUM,"
	_qPed += " CAST(REPLICATE( '0', 6 - LEN(CAST( PEDIDO.ID_VENDEDOR AS VARCHAR(6) ))) + CAST( PEDIDO.ID_VENDEDOR AS VARCHAR(6) ) AS CHAR(6)) C5_VEND,"
	_qPed += " CAST(TES AS CHAR(3)) C6_TES,CFO.ID_CFO,CAST(REPLACE( CFO.COD_CFO,'.','') AS CHAR(4)) C6_CF,"
	_qPed += " ISNULL( E4_CODIGO, '000' ) C5_CONDPAG,"
	_qPed += " CAST(REPLICATE( '0', 6 - LEN(CAST( PEDIDO.ID_CLIENTE AS VARCHAR(6) ))) + CAST( PEDIDO.ID_CLIENTE AS VARCHAR(6) ) AS CHAR(6)) C5_CLIENTE,"
	_qPed += " CAST(CONVERT( CHAR(8), EMISSAO, 112) AS CHAR(8)) C5_EMISSAO,CAST(CONVERT( CHAR(8), PEDIDO.PREVISAO, 112) AS CHAR(8)) C6_DTPRZ,"
	_qPed += " CAST(CONVERT( CHAR(8), PEDIDO.CADASTRO, 112) AS CHAR(8)) C6_DTLANC,"
	_qPed += " CAST(REPLICATE( '0', 6 - LEN(CAST( PEDIDO.ID_TRANSPORTADORA AS VARCHAR(6) ))) + CAST( PEDIDO.ID_TRANSPORTADORA AS VARCHAR(6) ) AS CHAR(6)) C5_TRANSP,"
	_qPed += " CAST(REPLICATE( '0', 3 - LEN(CAST( PEDIDO.ID_TABELA AS VARCHAR(3) ))) + CAST( PEDIDO.ID_TABELA AS VARCHAR(3) ) AS CHAR(3)) C6_TABELA,"
	_qPed += " CAST(ISNULL(PEDIDO.CLASSE,0) AS CHAR(1)) C5_CLASSE,"
	_qPed += " CAST(PEDIDO.FRETE_POR AS CHAR(1)) C5_CIF,ISNULL(ITEM.ITEM,0) C6_ITEM,"
	_qPed += " CAST(ISNULL(PRODUTO.CATALOGO, '') AS CHAR(30)) C6_PRODUTO,ISNULL(PRODUTO.DESCRICAO, '') C6_DESCRI,"
	_qPed += " QTD C6_QUANT,"
	_qPed += " UN_MEDIDA.UN C6_UM,"
	_qPed += " (ITEM.QTD * DIMENSIONAL.M2_REAL) C6_UNSVEN,"

	_qPed += " Case ISNULL(PEDIDO.PEDIDO_ESPECIAL, 'N' ) when 'E' then ROUND((ITEM.VLR_UN * (case PEDIDO.CLASSE WHEN 2 THEN 2 ELSE 1 END)) + (case isnull(ITEM.QTD,0) when 0 then 0 else ITEM.VlrSubTrib / ITEM.QTD end) + (case isnull(ITEM.QTD,0) when 0 then 0 else ITEM.VLR_IPI / ITEM.QTD end), 2) else vlr_un End C6_PRCVEN,"
	_qPed += " Case ISNULL(PEDIDO.PEDIDO_ESPECIAL, 'N' ) when 'E' then ROUND((ITEM.VLR_UN * (case PEDIDO.CLASSE WHEN 2 THEN 2 ELSE 1 END)) + (case isnull(ITEM.QTD,0) when 0 then 0 else ITEM.VlrSubTrib / ITEM.QTD end) + (case isnull(ITEM.QTD,0) when 0 then 0 else ITEM.VLR_IPI / ITEM.QTD end), 2) else vlr_un End C6_PRUNIT,"

	_qPed += " QTD_FATURADA C6_QTDENT,"
	_qPed += " CAST(ISNULL(ITEM.ORIGEM+ITEM.CST_ICMS, ' ' ) AS CHAR(3)) C6_CLASSIF,"
	_qPed += " ITEM.FCI C6_FCI,"
	_qPed += " ITEM.ORD_COMPRA C6_PEDCOM,"
	_qPed += " ISNULL( ITEM.ITEM_ORD_COMPRA, ' ') C6_ITPC,"
	_qPed += " ISNULL( ITEM.OBS, '') C6_VDOBS,"
	_qPed += " ISNULL( DIMENSIONAL.DIM_A, 0 ) DIM_A,"
	_qPed += " ISNULL( DIMENSIONAL.DIM_B, 0 ) DIM_B,"
	_qPed += " ISNULL( DIMENSIONAL.ESPESSURA, 0 ) ESPESSURA,"
	_qPed += " ISNULL( DIMENSIONAL.M2_REAL, 0 ) M2_REAL,"
	_qPed += " ISNULL( DIMENSIONAL.PESO_UN, 0 ) PESO_UN,"
	_qPed += " CONVERT( CHAR(8), CLIENTE.CADASTRO, 112 ) A1_DTCAD,"
	_qPed += " ISNULL( CLIENTE.INATIVO, ' ' ) A1_MSBLQL,"
	_qPed += " ISNULL( CLIENTE.VALOR_CREDITO, 0 ) A1_LC,"
	_qPed += " ISNULL( CLIENTE.ID_VENDEDOR, 0 ) A1_VEND,"
	_qPed += " REPLACE(REPLACE(ISNULL( CLIENTE.SUFRAMA, ' ' ),'.',''),'-','') A1_SUFRAMA,"
	_qPed += " CASE WHEN ISNULL( CLIENTE.SIMPLES_NACIONAL, ' ' ) <> 'S' THEN '1' ELSE '2' END A1_SIMPLES,MARCA.DESCRICAO B5_MARCA,PRODUTO.ID_ARMAZEM B1_LOCPAD,"
	_qPed += " REPLACE( ISNULL( CLASFIS.CLASSIFICACAO, ' ' ),'.','') B1_POSIPI,"
	_qPed += " ISNULL( CLASFIS.IPI, 0 ) B1_IPI, ISNULL( PRODUTO.POS, ' ' ) POS,"
	_qPed += " (ITEM.DESC_ACUMULADO * CASE WHEN ITEM.DESC_ACUMULADO < 1 THEN 0 ELSE 1 END ) C6_DESCONT, "

	_qPed += " Case ISNULL(PEDIDO.PEDIDO_ESPECIAL, 'N' ) when 'E' then 0 else case isnull(ITEM.QTD,0) when 0 then 0 else (ITEM.VlrSubTrib / ITEM.QTD) end end C6_SUBSTR,"
	_qPed += " Case ISNULL(PEDIDO.PEDIDO_ESPECIAL, 'N' ) when 'E' then 0 else case isnull(ITEM.QTD,0) when 0 then 0 else (ITEM.VLR_IPI / ITEM.QTD) end end C6_VLRIPI,"

    _qPed += " ISNULL(PRODUTO.POSICAO, ' ' ) B1_LOCALIZ,"
    _qPed += " ROW_NUMBER() over(order by PEDIDO.ID_EMPRESA, PEDIDO.ID_PEDIDO) idItem"
    
	_qPed += " FROM "+cBDGSTQ+".dbo.PEDIDO "
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.CLIENTE ON CLIENTE.ID_CLIENTE = PEDIDO.ID_CLIENTE"
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.CFO ON PEDIDO.ID_CFO = CFO.ID_CFO"
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.ITEM_PEDIDO ITEM ON PEDIDO.ID_PEDIDO = ITEM.ID_PEDIDO"
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.DIMENSIONAL ON DIMENSIONAL.ID_DIMENSIONAL = ITEM.ID_DIMENSIONAL"
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.PRODUTO ON DIMENSIONAL.ID_PRODUTO = PRODUTO.ID_PRODUTO"
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.UN_MEDIDA ON PRODUTO.ID_UN_MEDIDA = UN_MEDIDA.ID_UN_MEDIDA"
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.CLASS_FISCAL CLASFIS ON CLASFIS.ID_CLASS_FISCAL = PRODUTO.ID_CLASS_FISCAL"
	_qPed += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.MARCA MARCA ON MARCA.ID_MARCA = PRODUTO.ID_MARCA"
	_qPed += " LEFT OUTER JOIN TOTVSCTB.dbo.SE4010 SE4 ON SE4.E4_CODGST = PEDIDO.ID_CONDPAG"	
//	_qPed += "--REPLICATE( '0', 4 - LEN(CAST( PEDIDO.ID_EMPRESA AS VARCHAR(4) ))) + CAST( PEDIDO.ID_EMPRESA AS VARCHAR(4) ) C5_FILIAL,"
//	_qPed += " WHERE (CONVERT(CHAR(8),PEDIDO.EMISSAO,112) BETWEEN '"+ _cDtIni +"' AND '"+ _cDtFim +"')" 
    _qPed += " WHERE (PEDIDO.ID_PEDIDO = '" + StrZero( MV_PAR01, 6,0 ) + "')" 
//	_qPed += " ORDER BY PEDIDO.ID_EMPRESA, PEDIDO.ID_PEDIDO"

    If AllTrim( UPPER( GetEnvServer() ) ) = 'COMPRAS'
    
       _qPed += " AND ("
	   _qPed += " ((PEDIDO.ID_EMPRESA_LOCADO_PED =  6) AND (ISNULL(PEDIDO.PEDIDO_ESPECIAL,'N') = 'E')) OR "
	   _qPed += " ((PEDIDO.ID_EMPRESA_LOCADO_PED = 16) AND (ISNULL(PEDIDO.PEDIDO_ESPECIAL,'N') = 'E')) OR "
	   _qPed += " (PEDIDO.ID_EMPRESA_LOCADO_PED = 12)"
	   _qPed += " )"
    
    End
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, _qPed ),"PED", .T., .T. )

	_nRec :=  1

    If _nRec <> 0 
       PED->( dbGoTop() )
       Processa( { || InsPedFFM() }, 'Aguarde...','Importando pedidos...' )
    End
    
	PED->( dbCloseArea() )
	

Return( NIL )

Static Function InsPedFFM()

    ProcRegua( _nRec )
    _nIdxCB9 := CB9->( IndexOrd() )
    CB9->( dbSetOrder( 11 ) )

	While ! ( PED->( Eof() ) )

	   If _oPed <> PED->C5_NUM

   	      _cFilSB1 := if( ! Empty( _cFilSB1 ), PED->C5_FILIAL ,  _cFilSB1 )
	      _cFilSB2 := if( ! Empty( _cFilSB2 ), PED->C5_FILIAL ,  _cFilSB2 )
	      _cFilSB5 := if( ! Empty( _cFilSB5 ), PED->C5_FILIAL ,  _cFilSB5 )
	      _cFilSA1 := if( ! Empty( _cFilSA1 ), PED->C5_FILIAL ,  _cFilSA1 )
	      _cFilSC9 := if( ! Empty( _cFilSC9 ), PED->C5_FILIAL ,  _cFilSC9 )
	      _cFilCB7 := if( ! Empty( _cFilCB7 ), PED->C5_FILIAL ,  _cFilCB7 )
	      _cFilCB8 := if( ! Empty( _cFilCB8 ), PED->C5_FILIAL ,  _cFilCB8 ) 
	      _cFilCB9 := if( ! Empty( _cFilCB9 ), PED->C5_FILIAL ,  _cFilCB9 ) 
	      _cFilDA0 := if( ! Empty( _cFilDA0 ), PED->C5_FILIAL ,  _cFilDA0 ) 
	      _cFilDA1 := if( ! Empty( _cFilDA1 ), PED->C5_FILIAL ,  _cFilDA1 ) 
 	      _cFilNNR := if( ! Empty( _cFilNNR ), PED->C5_FILIAL ,  _cFilNNR )
 	      _cFilSA3 := if( ! Empty( _cFilSA3 ), PED->C5_FILIAL ,  _cFilSA3 )
	   
	      If ! ( SC5->( dbSeek( PED->C5_FILIAL + PED->C5_NUM, .F. ) ) )
	   
	         RecLock( 'SC5', .T. )
	         SC5->C5_FILIAL  := PED->C5_FILIAL
	         SC5->C5_NUM     := PED->C5_NUM
	         SC5->C5_TIPO    := 'N'
	         SC5->C5_TIPOCLI := 'R'
	         SC5->C5_VEND1   := PED->C5_VEND
	         SC5->C5_CONDPAG := PED->C5_CONDPAG
	         SC5->C5_TABELA  := PED->C6_TABELA
	         SC5->C5_CLIENTE := PED->C5_CLIENTE
	         SC5->C5_LOJACLI := '01'
	         SC5->C5_CLIENT  := PED->C5_CLIENTE
	         SC5->C5_LOJAENT := '01'
	         SC5->C5_EMISSAO := StoD( PED->C5_EMISSAO )
	         SC5->C5_TIPLIB  := '1'
	         SC5->C5_TXMOEDA := 1
	         SC5->C5_TPCARGA := '2'
	         SC5->C5_DTLANC  := StoD( PED->C6_DTLANC )
	         SC5->C5_TRANSP  := PED->C5_TRANSP
	         SC5->C5_TPFRETE := 'C'
	         SC5->C5_MOEDA   := 1
	         SC5->C5_MSBLQL  := '2'
	         SC5->C5_GERAWMS := '2'
	         SC5->C5_SOLOPC  := '1'
	         SC5->C5_CLASSE  := PED->C5_CLASSE

	         _nVlrPed := 0

	         If ( _nRegIni = 0 )

	             _nRegIni := SC5->( RecNo() )

	         Else

                OrdSep( lTrim( Str( _nRegIni, 10, 0 ) ), lTrim( Str( _nRegIni, 10, 0 ) ) )
                
                If _cClient <> '0' 

				   SC5->C5_LIBEROK := 'S'                

                   If  ! ( Empty( CB9->CB9_NOTA ) )

				       SC5->C5_NOTA    := CB7->CB7_NOTA
				       SC5->C5_SERIE   := CB7->CB7_SERIE

				   End

                End
                
                _nRegIni := SC5->( RecNo() )

	         End

	         SC5->( MsUnLock() )
	
			 If ! SA1->( dbSeek( _cFilSA1 + PED->C5_CLIENTE + '01', .F. ) )

		        _qCli := "SELECT ID_CLIENTE, NOME, FANTASIA, ENDERECO, COMPL_END, REPLACE(REPLACE(CEP,'.',''),'-','') CEP, BAIRRO, ATIV.SUBST_TRIB SUBTRIB, "
		        _qCli += "RGINSC, INTERNET eMail, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-','') TELEFONE, CONTATO, CONVERT(CHAR(8),CADASTRO,112) CADASTRO, CONVERT( CHAR(8), ULT_COMPRA,112) ULT_COMPRA, CLIENTE.SUFRAMA,"
		        _qCli += "REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') CPFCGC, CIDADE.DESCRICAO, UF, COD_UF, MUNICIPIO , PAIS, REPLACE(ISNULL(PLANO.CODIGO,'112010001'),'.','') CONTA"
		        _qCli += ' FROM ['+cBDGSTQ+'].[dbo].[CLIENTE] '
		        _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = CLIENTE.ID_CIDADE '
		        _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '
		        _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ATIVIDADE] ATIV ON ATIV.ID_ATIVIDADE = CLIENTE.ID_ATIVIDADE '
		        _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO] ON PLANO.ID_PLANO = OP.ID_PLANO_CR '
		        _qCli += "WHERE (CLIENTE.ID_CLIENTE = " + PED->C5_CLIENTE + ")"
		
		        dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qCli),"CLI",.T.,.T.)
		
		        RecLock( 'SA1', .T. )
		
		        SA1->A1_LOJA    := '01'
		        SA1->A1_COD     := PED->C5_CLIENTE
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
		        SA1->A1_TIPO    := if( CLI->SUBTRIB <> 'S', 'R', 'S' )
		        SA1->A1_PRICOM  := STOD( CLI->CADASTRO ) 
		        SA1->A1_CONTA   := CLI->CONTA
		       
		        CLI->( dbCloseArea() )

		     Else

				RecLock( 'SA1', .F. )

		     End
				
			 SA1->A1_LC      := PED->A1_LC
			 SA1->A1_MOEDALC := 1
			 SA1->A1_DTCAD   := StoD( PED->A1_DTCAD )
			 SA1->A1_VEND    := StrZero( PED->A1_VEND, 6 )
			 SA1->A1_TPFRET  := 'C'
			 SA1->A1_MSBLQL  := if( PED->A1_MSBLQL <> 'S', '2', '1' )
			 SA1->A1_RISCO   := if( PED->A1_MSBLQL <> 'A', ' ', 'E' )
			 SA1->A1_COND    := SUBSTR(PED->C5_CONDPAG,2,3)
			 SA1->A1_SUFRAMA := PED->A1_SUFRAMA
			 SA1->A1_SIMPLES := PED->A1_SIMPLES
	
			 If SA1->A1_RECCOFI <> 'S'
				
	   		    SA1->A1_RECCOFI := 'N'
	   		    SA1->A1_RECPIS  := 'N'
	   		    SA1->A1_RECCSLL := 'N'
	
	   		 End
	   			
	   		 SA1->A1_MINIRF  := '2'
	   		 SA1->A1_TPDP    := '2' // Pernambuco sem regra especial
	   		 SA1->A1_REGESIM  := if( SA1->A1_EST <> 'MT', '1', '2' ) // Matogrosso
	   		 SA1->A1_PERCATM := if( SA1->A1_EST <> 'MT', 0, 18 )
	   		 SA1->A1_USADDA  := '2'
	   		 SA1->A1_IRBAX   := '2'
	   		 SA1->A1_TRANSP  := PED->C5_TRANSP
	   			
	   		 SA1->( MsUnLock() )

	   		 If ! ( SA4->( dbSeek( _cFilSA4 + PED->C5_TRANSP, .F. ) ) )

		        _qTransp := "SELECT ID_FORNEC, ISNULL( NOME, ' ') NOME , ISNULL( FANTASIA, ' ') FANTASIA, ISNULL( ENDERECO, ' ') ENDERECO, ISNULL(REPLACE(REPLACE(CEP,'.',''),'-',''),' ') CEP, ISNULL(BAIRRO, ' ') BAIRRO, ISNULL(INTERNET, ' ') eMail,"
		        _qTransp += "ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-',''), ' ') TELEFONE, ISNULL(CONTATO, ' ') CONTATO, ISNULL( CONVERT(CHAR(8),CADASTRO,112), ' ') CADASTRO,"
		        _qTransp += "ISNULL(REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-',''), ' ' ) CGC, ISNULL(CIDADE.DESCRICAO, ' ') DESCRICAO, ISNULL(UF, ' ') UF, ISNULL( COD_UF, ' ' ) COD_UF, ISNULL(SUBSTRING(MUNICIPIO,3,5),' ') COD_MUN "
		        _qTransp += "FROM ["+cBDGSTQ+"].[dbo].[FORNEC] "
		        _qTransp += "LEFT OUTER JOIN ["+cBDGSTQ+"].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = FORNEC.ID_CIDADE "
		        _qTransp += "WHERE (FORNEC.ID_FORNEC = " + PED->C5_TRANSP + ")"
		        dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qTransp),"TRANSP",.T.,.T.)

	   		    RecLock( 'SA4', .T. )
	   		    SA4->A4_FILIAL  := _cFilSA4
	   		    SA4->A4_COD     := PED->C5_TRANSP
	   		    SA4->A4_NOME    := TRANSP->NOME
	   		    SA4->A4_NREDUZ  := Substr(TRANSP->NOME,1,20)
	   		    SA4->A4_END     := TRANSP->ENDERECO
	   		    SA4->A4_MUN     := TRANSP->DESCRICAO
	   		    SA4->A4_COD_UF  := TRANSP->COD_UF
	   		    SA4->A4_EST     := TRANSP->UF
	   		    SA4->A4_CEP     := TRANSP->CEP
	   		    SA4->A4_CGC     := TRANSP->CGC
	   		    SA4->A4_INSEST  := TRANSP->INSC_ESTADUAL
	   		    SA4->A4_COD_MUN := TRANSP->COD_MUN
	   		    SA4->A4_TPTRANS := '1'
	   		    SA4->( MSUnLock() )	   		 
	   		    SA4->( dbCloseArea() )
	   		 
	   		 End

	   		 If ! ( SA3->( dbSeek( _cFilSA3 + PED->C5_VEND, .F. ) ) )

		        _qVdor := "SELECT ISNULL( APELIDO, ' ') NOME , ISNULL(EMAIL, ' ') EMAIL,"
		        _qVdor += "ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-',''), ' ') TELEFONE "
		        _qVdor += "FROM ["+cBDGSTQ+"].[dbo].[VENDEDOR] "
		        _qVdor += "WHERE (VENDEDOR.ID_VENDEDOR = " + PED->C5_VEND + ")"
		        dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qVdor),"VDOR",.T.,.T.)

	   		    RecLock( 'SA3', .T. )
	   		    SA3->A3_FILIAL  := _cFilSA3
	   		    SA3->A3_COD     := PED->C5_VEND
	   		    SA3->A3_NOME    := VDOR->NOME
	   		    SA3->A3_NREDUZ  := Substr(VDOR->NOME,1,20)
	   		    SA3->A3_ACREFIN := 'N'
	   		    SA3->A3_HAND    := '2'
	   		    SA3->A3_SINCTAF := 'S'
	   		    SA3->A3_SINCAGE := 'S'
	   		    SA3->A3_SINCCON := 'S'
	   		    SA3->A3_PERAGE  := 'S'
	   		    SA3->A3_PERTAF  := 'S'
	   		    SA3->A3_TEL     := VDOR->TELEFONE
	   		    SA3->A3_EMAIL   := VDOR->EMAIL
	   		    SA3->( MSUnLock() )	   		 
	   		    VDOR->( dbCloseArea() )
	   		 
	   		 End

          Else

	         If ( _nRegIni = 0 )
	            _nRegIni := SC5->( RecNo() )
   	         End
	                             
	      End	
	   
	   End
	
	   If PED->C6_ITEM <> 0

	      _oPed    := SC5->C5_NUM	   
	      ImpItem()
	
	   End
	   
	   PED->( dbSkip() )
       IncProc()
	
	End

    OrdSep( lTrim( Str( _nRegIni, 10, 0 ) ), lTrim( Str( _nRegIni, 10, 0 ) ) )
    CB9->( dbSetOrder( _nIdxCB9 ) )
		
Return( NIL ) 


Static Function ImpItem()

   If ! ( SC6->( dbSeek( PED->C5_FILIAL + PED->C5_NUM + _aItem[ PED->C6_ITEM ] + PED->C6_PRODUTO, .F. ) ) )

      RecLock( 'SC6', .T. )
      SC6->C6_FILIAL  := PED->C5_FILIAL
      SC6->C6_NUM     := PED->C5_NUM
      SC6->C6_ITEM    := _aItem[ PED->C6_ITEM ]
      SC6->C6_CLI     := PED->C5_CLIENTE
      SC6->C6_LOJA    := '01'
      SC6->C6_PRODUTO := PED->C6_PRODUTO

      If ! ( SB1->( dbSeek( _cFilSB1 + PED->C6_PRODUTO, .F. ) )  )

         RecLock( 'SB1', .T. )
   
         SB1->B1_FILIAL  := _cFilSB1
         SB1->B1_COD     := PED->C6_PRODUTO
         SB1->B1_TIPO    := 'PA'
         SB1->B1_UM      := PED->C6_UM

      Else

         RecLock( 'SB1', .F. )

      End

      If PED->M2_REAL <> 0

         SB1->B1_SEGUM   := 'MT'
         SB1->B1_TIPCONV := 'M'
         SB1->B1_CONV    := PED->M2_REAL
         SB1->B1_LOCALIZ := 'N'

      Else

         SB1->B1_SEGUM   := ' '
         SB1->B1_TIPCONV := ' '
         SB1->B1_CONV    := 0
         SB1->B1_LOCALIZ := 'N'

      End
         
      SB1->B1_DESC    := PED->C6_DESCRI
      SB1->B1_MCUSTD  := '1'
      SB1->B1_IMPORT  := 'N'
      SB1->B1_LOCPAD  := if( PED->B1_LOCPAD <> 0, StrZero(PED->B1_LOCPAD, 2), '01' )
      SB1->B1_IPI     := PED->B1_IPI

      If PED->POS <> 'I'
         
         SB1->B1_MSBLQL := '2'
      
      Else

         SB1->B1_MSBLQL := '1'

      End

      SB1->B1_SOLICIT := 'N'
      SB1->B1_QTDSER  := 1
      SB1->B1_CPOTENC := '2'
      SB1->B1_USAFEFO := '1'  
      SB1->B1_RICM65  := '2'
      SB1->B1_INSS    := 'N'
      SB1->B1_CSLL    := '2'
      SB1->B1_PRN944I := 'S'
      SB1->B1_TIPODEC := 'N'
      SB1->B1_MRP     := 'S'
      SB1->B1_TIPOCQ  := 'M'
      SB1->B1_GARANT  := '2'
      SB1->B1_DESPIMP := 'N'
      SB1->B1_CRICMS  := '0'
      SB1->B1_FETHAB  := 'N'
      SB1->B1_POSIPI  := PED->B1_POSIPI
      SB1->B1_ORIGEM  := Substr( PED->C6_CLASSIF, 1, 1 )
      SB1->B1_GARANT  := '2'
      SB1->B1_PESO    := PED->PESO_UN
      SB1->B1_DESBSE3 := PED->B1_LOCALIZ
      SB1->( MsUnLock() )

      If ! ( SB5->( dbSeek( _cFilSB5 + PED->C6_PRODUTO, .F. ) )  )

         RecLock( 'SB5', .T. )
      
         SB5->B5_FILIAL  := _cFilSB5
         SB5->B5_COD     := PED->C6_PRODUTO
         SB5->B5_CEME    := PED->C6_DESCRI
         SB5->B5_FORMMRP := '1'
         SB5->B5_AGLUMRP := '1'
         SB5->B5_ROTACAO := '1'
         SB5->B5_COMPEND := '1'
         SB5->B5_PORTMS  := '2'
         SB5->B5_TIPUNIT := '1'
         SB5->B5_IMPETI  := '1'
         SB5->B5_NSERIE  := 'N'
         SB5->B5_QTDVAR  := '2'
         SB5->B5_VLDOPER := '1' 
         SB5->B5_CTRWMS  := '2'
         SB5->B5_DEC7174 := '2'
         SB5->B5_TIPO    := '1'
         SB5->B5_INTDI   := '2'
         SB5->B5_MONTA   := '2'
         SB5->B5_SEMENTE := '2'
         SB5->B5_TPISERV := '5'
         SB5->B5_ECFLAG  := '2'
         SB5->B5_REVPROD := '1'
         SB5->B5_BLQINVA := '2' 
         SB5->B5_INSPAT  := '2'  // Desoneração
         
         // SB5->B5_CODATIV Desoneração
         // Atualizar INSPAT 

      Else

         RecLock( 'SB5', .F. )

      End

      SB5->B5_COMPR   := PED->DIM_A
      SB5->B5_ESPESS  := PED->ESPESSURA
      SB5->B5_LARG    := PED->DIM_B
      SB5->B5_UMDIPI  := PED->C6_UM
      SB5->B5_MARCA   := PED->B5_MARCA

      SB5->( MsUnLock() )

      If ! ( SB2->( dbSeek( _cFilSB2 + PED->C6_PRODUTO + if( PED->B1_LOCPAD <> 0, StrZero(PED->B1_LOCPAD, 2), '01' ) , .F. ) )  )

         NNR->( dbSeek( _cFilNNR + if( PED->B1_LOCPAD <> 0, StrZero(PED->B1_LOCPAD, 2), '01' ), .F. ) )
         
         RecLock( 'SB2', .T. )
   
         SB2->B2_FILIAL  := _cFilSB2
         SB2->B2_COD     := PED->C6_PRODUTO
         SB2->B2_LOCAL   := if( PED->B1_LOCPAD <> 0, StrZero(PED->B1_LOCPAD, 2), '01' )
         SB2->B2_LOCALIZ := NNR->NNR_DESCRI
         
         SB2->( MsUnLock() )

      End

      SC6->C6_DESCRI  := PED->C6_DESCRI
      SC6->C6_QTDVEN  := PED->C6_QUANT 
      SC6->C6_UM      := PED->C6_UM    
      SC6->C6_SEGUM   := 'MT'
      SC6->C6_UNSVEN  := PED->C6_UNSVEN
      SC6->C6_PRCVEN  := PED->C6_PRCVEN
      SC6->C6_PRUNIT  := PED->C6_PRUNIT
      SC6->C6_VALOR   := ROUND( PED->C6_PRCVEN * PED->C6_QUANT, 2 )
      SC6->C6_TES     := if( ! PED->C5_FILIAL $ '0701;0801', PED->C6_TES, '506' )
      SC6->C6_CF      := if( ! PED->C5_FILIAL $ '0701;0801', PED->C6_CF , '5405' )
      SC6->C6_CLASFIS := PED->C6_CLASSIF
      SC6->C6_LOCAL   := SB1->B1_LOCPAD
      SC6->C6_TPOP    := 'F'
      SC6->C6_OP      := '06'
      SC6->C6_ENTREG  := StoD( PED->C6_DTPRZ )
      SC6->C6_SUGENTR := StoD( PED->C6_DTPRZ )
      SC6->C6_PEDCLI  := PED->C6_PEDCOM
      SC6->C6_ITEMPC  := PED->C6_ITPC
      SC6->C6_VDOBS   := PED->C6_VDOBS
      SC6->C6_RATEIO  := '2'
      SC6->( MsUnLock() )
      
      _nVlrPed += SC6->C6_VALOR + ( PED->C6_QUANT * PED->C6_VLRIPI ) + ( PED->C6_QUANT * PED->C6_SUBSTR )

   End
	                                                                              
Return( NIL )

Static Function OrdSep( _nRegIni, _nRegFim )

	_qRom := "SELECT "
	_qRom += " ROM.ID_ROMANEIO,"
	_qRom += " ROM.ID_CLIENTE,"
	_qRom += " ISNULL( ITPED.ID_PEDIDO, ' ') ID_PEDIDO,"
	_qRom += " CONVERT(CHAR(8),ROM.EMISSAO,112) EMISSAO,"
	_qRom += " CAST(substring(CONVERT(CHAR(12),"
	_qRom += " ROM.EMISSAO, 114),1,5) AS CHAR(5)) HORA,"
	_qRom += " ISNULL( ITPED.ITEM, 0 ) ITEM,"
	_qRom += " CAST(ISNULL(ITPED.Catalogo, ' ') AS CHAR(30)) CATALOGO,"
	_qRom += " qtd_exp,"
	_qRom += " ISNULL(NOTA.ID_FORNEC,0) TRANSP,"
	_qRom += " ISNULL(NOTA.NRO_NF,0) NRONF,"
	_qRom += " ISNULL(NOTA.SERIE, ' ') SERIE,"
	_qRom += " Case ISNULL(PED.PEDIDO_ESPECIAL, 'N' ) when 'E' then ROUND((ITPED.VLR_UN * (case PED.CLASSE WHEN 2 THEN 2 ELSE 1 END)) + (case isnull(ITPED.QTD,0) when 0 then 0 else ITPED.VlrSubTrib / ITPED.QTD end) + (case isnull(ITPED.QTD,0) when 0 then 0 else ITPED.VLR_IPI / ITPED.QTD end), 2) else ITPED.vlr_un End PRC_UN, "
	_qRom += " ISNULL(ITPRE.ID_NOTA,0) PRENOTA,"
	_qRom += " ISNULL(ITNOT.QTD,0) QTD,"	
	_qRom += " ROM.POS, "
	_qRom += " B1_LOCPAD, "
	_qRom += " CASE PED.ID_CONDPAG WHEN 10 THEN CASE ISNULL(ITPGT.ID_NOTA,0) WHEN 0 THEN '02' ELSE '  ' END ELSE '  ' END C9_BLCRED "	
	_qRom += "FROM SC5010 SC5 "
	_qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.PEDIDO PED ON PED.ID_PEDIDO = CAST(SC5.C5_NUM AS INT) "
	_qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.ITEM_PEDIDO ITPED ON ITPED.ID_PEDIDO = CAST(SC5.C5_NUM AS INT) "
	_qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.ITEM_ROMANEIO ITROM ON ITROM.ID_ITEM_PEDIDO = ITPED.ID_ITEM_PEDIDO "
	_qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.ROMANEIO ROM ON ROM.ID_ROMANEIO = ITROM.ID_ROMANEIO "
	_qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.ITEM_NOTA ITNOT ON ITNOT.ID_ROMANEIO = ITROM.ID_ROMANEIO AND ITNOT.ID_PEDIDO = ITPED.ID_PEDIDO AND ITNOT.PEDIDO_ITEM = ITPED.ITEM "
	_qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.NOTA ON NOTA.ID_NOTA = ITNOT.ID_NOTA "
	_qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.PRE_ITEM_NOTA ITPRE ON ITPRE.ID_ROMANEIO = ITROM.ID_ROMANEIO AND ITROM.ID_ITEM_NOTA = ITPRE.ID_ITEM_NOTA "
    _qRom += " LEFT OUTER JOIN "+cBDGSTQ+".dbo.PRE_NOTA_PGTO ITPGT ON ITPGT.ID_NOTA = ITPRE.ID_NOTA"	
    _qRom += " LEFT OUTER JOIN SB1010 SB1 ON SB1.D_E_L_E_T_ = '' AND B1_COD = ITPED.CATALOGO COLLATE Latin1_General_100_BIN "
	_qRom += "WHERE (SC5.R_E_C_N_O_ BETWEEN '" + _nRegIni + "' AND '" + _nRegFim + "') AND (ROM.ID_ROMANEIO IS NOT NULL)"
	_qRom += " AND (ISNULL(NOTA.SERIE,'') <> '4') AND (ROM.DATA_CANCEL IS NULL)"  
	_qRom += " ORDER BY ROM.ID_ROMANEIO, ITROM.ID_ITEM_ROMANEIO"
 
	dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qRom),"ROM",.T.,.T.)
	_nOrdSep := 0
	_cClient := '0'

	SC9->( dbSetOrder( 2 ) )

	While ! ( ROM->( Eof() ) )

	   _cNroNf  := iif( ROM->NRONF  <> 0, StrZero( ROM->NRONF, 9,0 ), ' ')
	   _cOrdSep := StrZero( ROM->ID_ROMANEIO, 6, 0 )
	   _cPedido := StrZero( ROM->ID_PEDIDO, 6, 0 )
	   _cClient := StrZero( ROM->ID_CLIENTE, 6,0 )
	   
	   CB7->( dbSeek( _cFilCB7 + _cOrdSep, .F. ) )

	   If _cOrdSep <> CB7->CB7_ORDSEP
   
	      _nOrdSep := ROM->ID_ROMANEIO
	
	      RecLock( 'CB7', .T. )

	      CB7->CB7_FILIAL  := _cFilCB7
	      CB7->CB7_ORDSEP  := _cOrdSep
	      CB7->CB7_PEDIDO  := _cPedido
	      CB7->CB7_CLIENT  := _cClient
	      CB7->CB7_LOJA    := '01'
	      CB7->CB7_DTEMIS  := StoD( ROM->EMISSAO )
	      CB7->CB7_HREMIS  := ROM->HORA
	      CB7->CB7_PRIORI  := '1'
	      CB7->CB7_ORIGEM  := '1'
	      CB7->CB7_TIPEXP  := '01*02*03*04*05*06*07*08*09*10*'
	      CB7->CB7_NUMITE  := 1

       Else

	      RecLock( 'CB7', .F. )

	   End

	   CB7->CB7_STATUS  := iif( Empty( _cNroNF ), '4', '9')
	   CB7->CB7_NOTA    := _cNroNF
	   CB7->CB7_SERIE   := ROM->SERIE
	   CB7->CB7_TRANSP  := iif( ROM->TRANSP <> 0, StrZero( ROM->TRANSP, 6,0 ), ' ')
       CB7->( MsUnLock() ) 

	   If ROM->ITEM <> 0

	      If ! ( CB8->( dbSeek( _cFilCB8 + CB7->CB7_ORDSEP + _aItem[ ROM->ITEM ] + '01' + ROM->CATALOGO, .F. ) ) )

	         RecLock( 'CB8', .T. )
	         CB8->CB8_FILIAL  := _cFilCB8   
    	     CB8->CB8_ORDSEP  := _cOrdSep
	         CB8->CB8_ITEM    := _aItem[ ROM->ITEM ]
    	     CB8->CB8_PEDIDO  := _cPedido
	         CB8->CB8_SEQUEN  := '01'
	         CB8->CB8_PROD    := ROM->CATALOGO
 	         CB8->CB8_LOCAL   := ROM->B1_LOCPAD
	         CB8->CB8_CFLOTE  := '1'
	         CB8->CB8_NOTA    := _cNroNF
	         CB8->CB8_SERIE   := ROM->SERIE
	         CB8->CB8_TIPSEP  := '1'
	         CB8->CB8_QTDORI  := ROM->qtd_exp
	         CB8->CB8_SALDOS  := if( ROM->NRONF <> 0, ROM->qtd_exp, 0 )

	      Else

   	         RecLock( 'CB8', .F. )

	         If CB8->CB8_SALDOS <> 0 
	            CB8->CB8_SALDOS  := CB8->CB8_SALDOS - if( ROM->NRONF <> 0, ROM->qtd_exp, 0 )
	         End

	      End
	      
	      CB8->( MsUnLock() )

          If ! ( CB9->( dbSeek( _cFilCB9 + CB7->CB7_ORDSEP + CB8->CB8_ITEM + CB8->CB8_PEDIDO , .F. ) ) )

		     RecLock( 'CB9', .T. )
		     CB9->CB9_FILIAL := _cFilCB9
		     CB9->CB9_ORDSEP := CB7->CB7_ORDSEP
		     CB9->CB9_CODETI := ' '
		     CB9->CB9_PROD   := CB8->CB8_PROD
		     CB9->CB9_CODSEP := CB7->CB7_CODOPE
		     CB9->CB9_ITESEP := CB8->CB8_ITEM
		     CB9->CB9_SEQUEN := CB8->CB8_SEQUEN
		     CB9->CB9_LOCAL  := CB8->CB8_LOCAL
		     CB9->CB9_LCALIZ := CB8->CB8_LCALIZ
		     CB9->CB9_LOTECT := ' '
		     CB9->CB9_NUMLOT := ' '
		     CB9->CB9_NUMSER := CB8->CB8_NUMSER
		     CB9->CB9_LOTSUG := CB8->CB8_LOTECT
		     CB9->CB9_SLOTSU := CB8->CB8_NUMLOT
		     CB9->CB9_PEDIDO := CB8->CB8_PEDIDO

		  Else

		     RecLock( 'CB9', .F. )
		     _cPedido := '000000'
		  
          End

          CB9->CB9_QTESEP := ROM->qtd_exp //if( ROM->NRONF <> 0, ROM->qtd_exp, 0 )
          CB9->CB9_STATUS := if( ROM->NRONF <> 0, '3', '2' )

          CB9->( MsUnlock() )

	      If _cPedido <> '000000'

	         If SC9->( dbSeek( _cFilSC9 + _cClient + '01' + _cPedido + _aItem[ ROM->ITEM ], .F. ) )
         
	            While ( ( _cFilSC9 + _cClient + '01' + _cPedido + _aItem[ ROM->ITEM ]) = SC9->(C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM) )

	               _cSequen := Soma1( SC9->C9_SEQUEN, 2 )
    	           SC9->( dbSkip() )

        	    End

	         Else

    	        _cSequen := '01'
      
	         End
      
	         RecLock( 'SC9', .T. )

	         SC9->C9_FILIAL  := _cFilSC9
	         SC9->C9_PEDIDO  := _cPedido
	         SC9->C9_ITEM    := _aItem[ ROM->ITEM ]
	         SC9->C9_CLIENTE := _cClient
	         SC9->C9_LOJA    := '01'
	         SC9->C9_PRODUTO := ROM->CATALOGO
	         SC9->C9_QTDLIB  := ROM->qtd_exp
	         SC9->C9_NFISCAL := _cNroNf

    	     If ! Empty( _cNroNF )

	            SC9->C9_BLCRED  := '10'
	            SC9->C9_BLEST   := '10'

             Else

                SC9->C9_BLCRED := ROM->C9_BLCRED

    	     End

	         SC9->C9_SERIENF := ROM->SERIE               
	         SC9->C9_DATALIB := StoD( ROM->EMISSAO )
	         SC9->C9_SEQUEN  := _cSequen
	         SC9->C9_PRCVEN  := ROM->PRC_UN
	         SC9->C9_LOCAL   := ROM->B1_LOCPAD
	         SC9->C9_TPCARGA := '2'
	         SC9->C9_RETOPER := '1'
	         SC9->C9_TPOP    := '1'
	         SC9->C9_DATENT  := StoD( ROM->EMISSAO )
	         SC9->C9_ORDSEP  := _cOrdSep
	         //SC9->C9_FILAGRU := StrZero( ROM->PRENOTA, 6, 0 )
   
	         SC9->( MsUnLock() )
	         
	         If Empty( _cNroNF )

	            If ( SC6->( dbSeek( _cFilSC9 + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO, .F. ) ) )

	                RecLock( 'SC6', .F. )
	             
				    SC6->C6_QTDEMP  += SC9->C9_QTDLIB
	                SC6->C6_QTDLIB  += SC9->C9_QTDLIB
	             
	                SC6->( MSUnLock() )

	            End
	         
	         End

	      End

	   End
   
	   ROM->( dbSkip() )

	End

	SC9->( dbSetOrder( 1 ) )
	ROM->( dbCloseArea() )


Return( NIL )


Static Function TabPrc()

_qTab := 'SELECT '
_qTab += "CAST(REPLICATE( '0',3-LEN(CAST(TAB.ID_TABELA AS VARCHAR(3))))+CAST(TAB.ID_TABELA AS VARCHAR(3)) AS CHAR(3)) DA0_CODTAB,"
_qTab += 'TAB.DESCRICAO DA0_DESCRI,'

_qTab += "isnull(CONVERT( CHAR(8), CLPRC.ATUALIZADO, 112),'        ') DA0_DATDE,"
_qTab += "isnull(SUBSTRING(CONVERT( CHAR(8), CLPRC.ATUALIZADO, 114), 1, 5),'     ') DA0_HORADE,"
_qTab += "CASE DESCONTO1 WHEN 0 THEN 1 + ( ACRESCIMO / 100) ELSE (DESCONTO1 /100) END DA1_PERDES,"
_qTab += 'CONVERT( CHAR(8), TAB.VALIDADE, 112) DA0_DATATE,'
_qTab += 'SUBSTRING(CONVERT( CHAR(8), TAB.VALIDADE, 114), 1, 5) DA0_HORATE,'
_qTab += 'PRD.CATALOGO DA1_CODPRO,'
_qTab += 'CASE PRD.VLR_BASE WHEN 0 THEN (CASE ISNULL(VLR_BASE_TMP,0) WHEN 0 THEN ISNULL(VLR_ULT_VEND,0) ELSE ISNULL(VLR_BASE_TMP,0) END) ELSE ISNULL(PRD.VLR_BASE,0) END DA1_PRCVEN '

_qTab += ' FROM '+cBDGSTQ+'.dbo.PRODUTO PRD '

_qTab += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.TAB_SERIE TBSER ON TBSER.ID_SERIE = PRD.ID_SERIE '
_qTab += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.CLASS_PRECO CLPRC  ON CLPRC.ID_CLASS_PRECO = PRD.ID_CLASS_PRECO '
_qTab += 'LEFT OUTER JOIN '+cBDGSTQ+'.dbo.TABELA TAB  ON TAB.ID_TABELA = TBSER.ID_TABELA '

_qTab += "WHERE TAB.ID_TABELA IS NOT NULL AND PRD.POS <> 'I' "
_qTab += 'ORDER BY TAB.ID_TABELA, PRD.CATALOGO'

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qTab),"TAB",.T.,.T.)

_cTab  := '   '
_nItem := 0
                                                         
While ! TAB->( Eof() )

   If  _cTab <> TAB->DA0_CODTAB
       
       RecLock( 'DA0', .T. )
       DA0->DA0_FILIAL := _cFilDA0
       DA0->DA0_CODTAB := TAB->DA0_CODTAB
       DA0->DA0_DESCRI := TAB->DA0_DESCRI
       DA0->DA0_DATDE  := StoD( if( empty(TAB->DA0_DATDE),'20140101', TAB->DA0_DATDE ) )
       DA0->DA0_HORADE := if( empty(TAB->DA0_HORADE),'00:00',TAB->DA0_HORADE )
       DA0->DA0_DATATE := StoD( TAB->DA0_DATATE )
       DA0->DA0_HORATE := '23:59'
       DA0->DA0_TPHORA := '1'
       DA0->DA0_ATIVO  := '1'
       DA0->( MsUnLock() )

       _cTab := DA0->DA0_CODTAB
       _nItem := 0
   
   End
    
   If ( TAB->DA1_PRCVEN <> 0 )

	   RecLock( 'DA1', .T. )
	   _nItem ++
	   DA1->DA1_FILIAL := _cFilDA1
	   DA1->DA1_ITEM   := StrZero( _nItem, 4 )
	   DA1->DA1_CODTAB := DA0->DA0_CODTAB
	   DA1->DA1_CODPRO := TAB->DA1_CODPRO
	   DA1->DA1_PRCVEN := TAB->DA1_PRCVEN
	   DA1->DA1_PERDES := TAB->DA1_PERDES
	   DA1->DA1_ATIVO  := '1'
	   DA1->DA1_TPOPER := '4'
	   DA1->DA1_QTDLOT := 999999.99
	   DA1->DA1_INDLOT := '00000000000999999.99'
	   DA1->DA1_MOEDA  := 1
	   DA1->DA1_DATVIG := StoD( TAB->DA0_DATDE )
	   DA1->( MsUnLock() )

   End

   TAB->( dbSkip() )

End

TAB->( dbCloseArea() )

Return( NIL )
