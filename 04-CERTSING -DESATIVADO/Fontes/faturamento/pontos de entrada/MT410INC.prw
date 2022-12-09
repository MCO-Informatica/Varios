#Include 'totvs.ch'
#Include 'protheus.ch'

//+-------------------------------------------------------------------+
//| Rotina | MT410INC | Autor | Rafael Beghini | Data | 21.07.2015 
//+-------------------------------------------------------------------+
//| Descr. | PE na gravação do Pedido de Venda
//|        | Altera alguns campos
//+-------------------------------------------------------------------+
//| Uso    | CertiSign Certificadora Digital
//+-------------------------------------------------------------------+
User Function MT410INC()
	Local aArea1	:= GetArea()
	Local aArea2	:= { SC5->( GetArea() ), SC6->( GetArea() ), SA1->( GetArea() ), SA2->( GetArea() ) }
	Local aCFO		:= {}
	Local aItemPV	:= {}
	Local cNumPv   	:= SC5->C5_NUM
	Local cFunName 	:= FunName()
	Local cFilOld	:= cFilAnt
	Local cHardware := GetNewPar("MV_GARHRD", "1")
	Local cC6_CF	:= ''
	Local cTRB		:= ''
	Local lSeek		:= SC5->( dbSeek( xFilial( 'SC5' ) + cNumPv ) )
		
	IF lSeek
		IF cFunName == 'MATA410' //-- Pedido Manual
			IF Alltrim(SC5->C5_XNATURE) == 'FT020001' //-- Estoque 
				SC5->( RecLock( 'SC5', .F. ) )
				SC5->C5_INDPRES := '0'
				SC5->( MsUnLock() )
			ElseIF Alltrim(SC5->C5_XNATURE) == 'FT010001' .AND. SC5->C5_CONDPAG == '020' //-- SAV
				SC5->( RecLock( 'SC5', .F. ) )
				SC5->C5_INDPRES := '3'
				SC5->( MsUnLock() )
			EndIF
		ElseIF cFunName == 'CNTA120' //-- Gestão de Contratos
			SC5->( RecLock( 'SC5', .F. ) )
			SC5->C5_INDPRES := '3'
			SC5->( MsUnLock() )
		ElseIF cFunName == 'CSFS0006' //-- Atendimento Externo
			SC5->( RecLock( 'SC5', .F. ) )
			SC5->C5_INDPRES := '1'
			SC5->( MsUnLock() )
		EndIF

		/*
		Retirado em 22.11.2019 pós Release 25
		//Tratamento para alteração da filial de faturamento caso conte com produto de hardware
		//e o cliente se enquadre na regra de faturamento por filial
		cTRB := GetNextAlias()

		BeginSql Alias cTRB
			SELECT	SC6.R_E_C_N_O_ AS RECNO
			FROM 
				%Table:SC6% SC6
			INNER JOIN %Table:SB1% SB1
				ON B1_FILIAL = %xFilial:SB1%
				AND B1_COD = C6_PRODUTO
				AND B1_CATEGO = %Exp:cHardware%
				AND SB1.%NotDel%
			WHERE
				C6_FILIAL = %Exp:xFilial("SC6")% AND
				C6_NUM = %Exp:cNumPv% AND
				SC6.%NotDel%
		EndSql
		
		IF SC5->C5_TIPO $ "DB"
			SA2->( dbSeek( xFilial( 'SA2' ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
			cUFDEST	:= SA2->A2_EST
			cINSCR	:= SA2->A2_INSCR
			cCONTR	:= SA2->A2_CONTRIB
		Else
			SA1->( dbSeek( xFilial( 'SA1' ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
			cUFDEST	:= SA1->A1_EST
			cINSCR	:= SA1->A1_INSCR
			cCONTR	:= SA1->A1_CONTRIB
		EndIF
		
		Aadd( aCFO, { 'OPERNF'	 , 'S'				} )
		Aadd( aCFO, { 'TPCLIFOR' , SC5->C5_TIPOCLI	} )					
		Aadd( aCFO, { 'UFDEST'	 , cUFDEST			} )
		Aadd( aCFO, { 'INSCR'	 , cINSCR			} )
		Aadd( aCFO, { 'CONTR'	 , cCONTR			} ) 

		IF cUFDEST == 'RJ'
			STATICCALL( VNDA190, FATFIL, cNumPv, '01' )
		EndIF
		cC6_CF := MaFisCfo( , SF4->F4_CF, aCFO )

		IF cFilOld <> cFilAnt
			STATICCALL( VNDA190, FATFIL, cNumPv, cFilOld )
		EndIF

		While (cTRB)->( .NOT. EOF() )
			SC6->( dbGoto( (cTRB)->RECNO ) )
			SC6->( RecLock('SC6',.F.) )
			SC6->C6_CF	:= cC6_CF
			SC6->( MsUnLock() )

			(cTRB)->( dbSkip() )
		End
		(cTRB)->( dbCloseArea() )
		FErase( cTRB + GetDBExtension() )
		*/
	EndIF
	AEval( aArea2, {|xArea| RestArea( xArea ) } )
	RestArea( aArea1 )
Return