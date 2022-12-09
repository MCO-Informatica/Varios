Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PRENOTA  º Autor ³ Sérgio Santana        º Data ³20/11/2012º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao Arquivo XML para geração de Pre-Nota            º±±
±±º          ³                                                            º±±
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

//-- Ponto de Entrada para incluir botão na Pré-Nota de Entrada

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function PreNotaImp

LOCAL aTipo      :={ 'N','B','D' }
LOCAL cFile      := Space( 10 )
Local nX		 := 0
Local ni		 := 0
Local nItem		 := 0

PRIVATE cTpCompl := ' '
PRIVATE CPERG    :="NOTAXML"
PRIVATE cPerg1	 :="MTR170"
PRIVATE Caminho  := superGetMV( "MV_ZZXML",,"C:\temp\xml_entrada\")
PRIVATE _cMarca  := GetMark()
PRIVATE aFields  := {}
PRIVATE aFields2 := {}
PRIVATE lPcNfe   := GETMV( "MV_PCNFE" )
PRIVATE _cFilSA1 := xFilial( 'SA1' )
PRIVATE _cFilSA2 := xFilial( 'SA2' )
PRIVATE _cFilSA5 := xFilial( 'SA5' )
PRIVATE _cFilSA7 := xFilial( 'SA7' )
PRIVATE _cFilSB1 := xFilial( 'SB1' )
PRIVATE _cFilSC7 := xFilial( 'SC7' )
PRIVATE _cFilSF1 := xFilial( 'SF1' )
PRIVATE _cFilSF2 := xFilial( 'SF2' )
PRIVATE _cFilSF4 := xFilial( 'SF4' )

PRIVATE cArq2
PRIVATE cArq

PRIVATE	cNFiscal 	                                  
PRIVATE	cSerieNF 
Private nAux	:= 0

SetFunName("IMPXML")
PutMV("MV_PCNFE",.F.)

nTipo := 1
_iSA5   := SA5->( IndexOrd() )
_iSA7   := SA7->( IndexOrd() )

Do While .T.
	
	cCodBar := Space(44)
	
	DEFINE MSDIALOG _oPT00005 FROM  50, 050 TO 250,500 TITLE OemToAnsi('Busca de XML de Notas Fiscais de Entrada') PIXEL
	
	@ 003,005 Say OemToAnsi("Cod Barra NFE") Size 040,030
	@ 030,005 Say OemToAnsi("Tipo Nota Entrada:") Size 070,030
	
	@ 003,060 Get cCodBar  Picture "@!S80" Valid (AchaFile(@cCodBar),If(!Empty(cCodBar),_oPT00005:End(),.t.))  Size 150,030
	@ 020,060 RADIO oTipo VAR nTipo ITEMS "Nota Normal","Nota Beneficiamento","Nota Devolução" SIZE 70,10 OF _oPT00005
	
	
	@ 075,060 Button OemToAnsi("Arquivo") Size 036,016 Action (GetArq(@cCodBar),_oPT00005:End())
	@ 075,110 Button OemToAnsi("Ok")  Size 036,016 Action (_oPT00005:End())
	@ 075,160 Button OemToAnsi("Sair")   Size 036,016 Action Fecha()
	
	Activate Dialog _oPT00005 CENTERED
	
	MV_PAR01 := nTipo
	
	cFile := cCodBar
	
	If ! File( cFile ) .And.;
	   ! ( Empty( cFile ) )

		MsgInfo("Arquivo não encontrado no LOCAL de especificado!")
		PutMV("MV_PCNFE",lPcNfe)
		Return( NIL )

	End
	
	PRIVATE nHdl := fOpen( cFile, 0 )	
	
	aCamposPE:={}
	
	If nHdl == -1

		If !Empty( cFile )

			MsgInfo("O arquivo de nome "+cFile+" não pode ser aberto!" + chr( 13 ) + "Por gentileza verifique os parametros.","Atenção!")

		End

		PutMV("MV_PCNFE",lPcNfe)

		Return( NIL )

	End

	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)

	cAviso := ""
	cErro  := ""  
	if Substr( cBuffer, 1, 38 ) <> '<?xml version="1.0" encoding="UTF-8"?>'

       oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)

	else

       oNfe := XmlParser( Substr( cBuffer, 39 ) ,"_",@cAviso,@cErro)

	end

	PRIVATE oNF
	
	If Type("oNFe:_NfeProc") <> "U"

		oNF := iif( Type( 'oNFe:_NFeProc:_NFe' ) <> 'U', oNFe:_NFeProc:_NFe, ' ')
		cProt := iif( type( 'oNFe:_NFeProc:_protNFe:_infProt:_chNFe:TEXT' ) <> 'U', oNFe:_NFeProc:_protNFe:_infProt:_chNFe:TEXT, ' ')
		cAut  := iif( type( 'oNFe:_NFeProc:_protNFe:_infProt:_nProt:TEXT' ) <> 'U', oNFe:_NFeProc:_protNFe:_infProt:_nProt:TEXT, ' ')

	Else                    

		oNF   := iif( Type( 'oNFe:_NFe' ) <> 'U', oNFe:_NFe, ' ' )
		cProt := iif( Type( 'oNFe:_protNFe:_infProt:_chNFe:TEXT' ) <> 'U', oNFe:_protNFe:_infProt:_chNFe:TEXT, ' ')
		cAut  := iif( Type( 'oNFe:_protNFe:_infProt:_nProt:TEXT' ) <> 'U', oNFe:_protNFe:_infProt:_nProt:TEXT, ' ' )

	End
	
	If Type( 'oNF' ) = 'C'
	   
	   oNFe := NIL
	   Loop
	
	End

	PRIVATE oEmitente  := oNF:_InfNfe:_Emit
	PRIVATE oIdent     := oNF:_InfNfe:_IDE
	PRIVATE oDestino   := oNF:_InfNfe:_Dest
	PRIVATE oTotal     := oNF:_InfNfe:_Total
	PRIVATE oTransp    := oNF:_InfNfe:_Transp
	PRIVATE oDet       := oNF:_InfNfe:_Det 
	PRIVATE _lRaz      := .F.
	PRIVATE _aLote     := {} 
	
	If (MV_PAR01 == 3)

       If Type("oEmitente:_CPF")  <> 'U' .Or.;
          Type("oEmitente:_CNPJ") <> 'U'

          cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))

       End

       If cCgc = '48254858000109' .Or.;
          cCgc = '48254858000290' .Or.;
          cCgc = '48254858000451' .Or.;
          cCgc = '03061254000108' .Or.;
          cCgc = '03061254000299' .Or.;
          cCgc = '67313247000139' .Or.;
          cCgc = '04051564000104' .Or.;
          cCgc = '09158959000124' .Or.;
          cCgc = '04657999000105' .Or.;
          cCgc = '03061254000370' .Or.;
          cCgc = '11175943000171' .Or.;
		  cCgc = '36360406000122' .Or.;
		  cCgc = '47958868000162' .Or.;
		  cCgc = '36360406000203'                    

	      oEmitente  := oNF:_InfNfe:_Dest
	      oDestino   := oNF:_InfNfe:_Emit

       End
	
	End

	If Type("oNF:_InfNfe:_ICMS")<> "U"

		PRIVATE oICM := oNF:_InfNfe:_ICMS

	Else

		PRIVATE oICM := NIL

	End

	PRIVATE oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",NIL,oNF:_InfNfe:_Cobr)
	PRIVATE cEdit1	   := Space( 15 )
	PRIVATE _DESCdigit := space( 55 )
	PRIVATE _NCMdigit  := space(  8 )
	
	_nFrete := If( Type( "oTotal:_ICMSTot:_vFrete" ) <> 'U', Val( oTotal:_ICMSTot:_vFrete:TEXT ), 0 )
	_nDesp  := If( Type( "oTotal:_ICMSTot:_vOutro" ) <> 'U', Val( oTotal:_ICMSTot:_vOutro:TEXT ), 0 )
		
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)

	If MV_PAR01 == 1
		cTipo := "N"
	ElseIF MV_PAR01 == 2
		cTipo := "B"
	ElseIF MV_PAR01 == 3
		cTipo := "D"
	Endif
		
	// CNPJ ou CPF

    If Type("oDestino:_CPF")  = 'U' .And.;
       Type("oDestino:_CNPJ") = 'U'

       _cIdEstr := AllTrim(IIf(Type("oDestino:_idEstrangeiro")=="U",'',StrZero(Val(oDestino:_idEstrangeiro:TEXT),6,0)))

    Else
    
       _cIdEstr := ''

	End
    
	cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))

    If MV_PAR01 = 1 // Nota Normal Fornecedor

       If ! iif( Empty( _cIdEstr ), SA2->( dbSetOrder( 3 ), dbSeek( _cFilSA2 + cCgc ) ), SA2->( dbSetOrder( 1 ), dbSeek( _cFilSA2 + _cIdEstr ) )  )

          _xNOME   := AllTrim(oEmitente:_XNOME:TEXT)
          _IE      := AllTrim( if( Type( "oEmitente:_IE:TEXT" ) <> 'U', oEmitente:_IE:TEXT, ' ') )
          _CEP     := AllTrim(oEmitente:_ENDEREMIT:_CEP:TEXT)
          _CMUN    := RIGHT(AllTrim(oEmitente:_ENDEREMIT:_CMUN:TEXT),5)
          _CPAIS   := AllTrim( if( Type( "oEmitente:_ENDEREMIT:_CPAIS" ) <> 'U', oEmitente:_ENDEREMIT:_CPAIS:TEXT, '1058' ) )
          _FONE    := AllTrim( if( Type( "oEmitente:_ENDEREMIT:_FONE") <> 'U', oEmitente:_ENDEREMIT:_FONE:TEXT, ' ' ) )
          _NRO     := AllTrim(oEmitente:_ENDEREMIT:_NRO:TEXT)
          _UF      := AllTrim(oEmitente:_ENDEREMIT:_UF:TEXT)
          _XBAIRRO := AllTrim(oEmitente:_ENDEREMIT:_XBAIRRO:TEXT)
          _XLGR    := AllTrim(oEmitente:_ENDEREMIT:_XLGR:TEXT)
          _XMUN    := AllTrim(oEmitente:_ENDEREMIT:_XMUN:TEXT)

          _cQry := "SELECT ID_CLIENTE FROM ["+cBDGSTQ+"].[dbo].[CLIENTE] WHERE REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') = '" + cCgc + "'"
          dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )

		If TMP->(Eof())
			MsgInfo("Fornecedor não localizado no Gestoq para importação, efetue o cadastro no Gestoq e tente novamente.", "Forncedeor não cadastrado")
			Return
		EndIf

          _cCodFor := StrZero( TMP->ID_CLIENTE, 6 )
          TMP->( dbCloseArea() )
          
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

       End

	Else

		If ! SA1->( dbSetOrder( 3 ), dbSeek( _cFilSA1 + cCgc ) )

			MsgInfo("CNPJ do cliente não localizado..." + cCgc)
			PutMV("MV_PCNFE",lPcNfe)
			Return( NIL )

		End

	End

    If Type("oDestino:_CPF")  <> 'U' .Or.;
       Type("oDestino:_CNPJ") <> 'U'

       cCgc := AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:TEXT,oDestino:_CPF:TEXT))

    Else

       cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))

    End

    If     cCgc = '48254858000109' 
        _cFilSF2 := '0101'
    ElseIf cCgc = '48254858000290'
        _cFilSF2 :='0102' 
    ElseIf cCgc = '48254858000451'
        _cFilSF2 :='0103' 
    ElseIf cCgc = '03061254000108'
        _cFilSF2 :='0201'
    ElseIf cCgc = '03061254000299'
        _cFilSF2 :='0202'
    ElseIf cCgc = '67313247000139'
        _cFilSF2 :='0301' 
    ElseIf cCgc = '04051564000104'
        _cFilSF2 :='0401'
    ElseIf cCgc = '09158959000124'
        _cFilSF2 :='0501'
    ElseIf cCgc = '04657999000105'
        _cFilSF2 :='0601'
    ElseIf cCgc = '03061254000370'
        _cFilSF2 :='0215'
    ElseIf cCgc = '11175943000171'                    
        _cFilSF2 :='0701'
    Elseif cCgc = '32648870000168'
		_cFilSF2 :='1101'
    Elseif cCgc = '36360406000122'
		_cFilSF2 :='1601'
    Elseif cCgc = '36360406000203'
		_cFilSF2 :='1602'
	Elseif cCgc = '47958868000162'
		_cFilSF2 :='2001'
	Else
		MsgAlert("Não existe amarração de filial para o CNPJ "+cCgc+" na rotina PreNotaImp, entre em contato com a TI.")
        Return
		_cFilSF2 := '9999'
    EndIf

	If _cFilSF2 <> U_SM0DePar(cCgc)
		Alert("Diferença no de para do CNPJ "+cCgc+" filial "+_cFilSF2+" na funcao SM0DePar("+U_SM0DePar(cCgc)+")")
	EndIf
	
	_cNFiscal := Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)	                                  
	_cSerieNF := Padr(OIdent:_serie:TEXT,3)
	
	// -- Nota Fiscal já existe na base ?
	If SF1->( dbSeek( _cFilSF2 + _cNFiscal + _cSerieNF + SA2->A2_COD + SA2->A2_LOJA + cTipo ) )

       If MV_PAR01 = 1

          MsgInfo('Nota Fiscal no. '+;
                  Right("000000000" + Alltrim(OIdent:_nNF:TEXT),9)+;
                  '/'               +;
                  OIdent:_serie:TEXT+;
                  Chr( 13 )         +;
                  'Fornecedor '      +;
                  SA2->A2_COD + '/'      +;
                  SA2->A2_LOJA + ' - '   +;
                  rTrim( SA2->A2_NREDUZ )+;
                  Chr( 13 ) +;
                  'Encontra-se lançada no sistema. Importação interrompida';
                 )

       Else

		  MsgInfo('Nota Fiscal no. ' + ;
			      Right('000000000' + Alltrim(OIdent:_nNF:TEXT),9) +;
			      '/' +;
			      OIdent:_serie:TEXT +;
			      Chr( 13 )+;
			      'Cliente '+;
			      SA1->A1_COD+"/"+;
			      SA1->A1_LOJA+' - '+;
			      rTrim( SA1->A1_NREDUZ ) +;
			      Chr( 13 )+;
			      'Está lançada no sistema. Importação interrompida.';
			     )

       End

       PutMV( "MV_PCNFE", lPcNfe )
       Return( NIL )

	End
	
	aCabec := {}
	aItens := {}

    _cEst := if( MV_PAR01=1, SA2->A2_EST, SA2->A2_EST )

    if ( Type("OIdent:_dEmi")<> 'U')

       cData := Alltrim( OIdent:_dEmi:TEXT )
       dData := CtoD( Right( cData, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )
                    
    Else

       cData := Alltrim( OIdent:_dhEmi:TEXT )
       dData := CtoD( Substr( cData, 9, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )

    End

	aAdd( aCabec, { "F1_TIPO"   , If( MV_PAR01==1, "N", If( MV_PAR01==2,'B','D' ) )	     , NIL, NIL } )
	aAdd( aCabec, { "F1_FORMUL" , "N"													 , NIL, NIL } )
	aAdd( aCabec, { "F1_DOC"    , Right( "000000000" + Alltrim( OIdent:_nNF:TEXT ), 9 )  , NIL, NIL } )
	aAdd( aCabec, { "F1_SERIE"  , OIdent:_serie:TEXT									 , NIL, NIL } )	
	aAdd( aCabec, { "F1_EMISSAO", dData													 , NIL, NIL } )
	aAdd( aCabec, { "F1_FORNECE", If( MV_PAR01=1, SA2->A2_COD,SA1->A1_COD)				 , NIL, NIL } )
	aAdd( aCabec, { "F1_LOJA"   , If( MV_PAR01=1, SA2->A2_LOJA,SA1->A1_LOJA)			 , NIL, NIL } )
	aAdd( aCabec, { "F1_ESPECIE", "SPED"												 , NIL, NIL } )
	aAdd( aCabec, { "F1_EST"	, _cEst													 , NIL, NIL } )
	aAdd( aCabec, { "F1_CHVNFE"	, cProt													 , NIL, NIL } )
    aAdd( aCabec, { "F1_FRETE"	, _nFrete												 , NIL, NIL } )
    aAdd( aCabec, { "F1_DESPESA", _nDesp												 , NIL, NIL } )
    aAdd( aCabec, { "F1_MENNOTA", if( Type("oNF:_InfNfe:_InfAdic:_InfCpl")<> 'U',oNF:_infNFe:_InfAdic:_InfCpl:TEXT	, Space( 600 ) ), NIL, NIL } )

    If cTipo = "N"

		aAdd( aCabec,{ "F1_COND" , If( Empty(SA2->A2_COND), '001', SA2->A2_COND ), NIL ,NIL } )
		_cNatur := SA2->A2_NATUREZ

	Else               

		aAdd( aCabec,{ "F1_COND" , '132', NIL, NIL } )
		_cNatur := if( Empty( SA1->A1_NATUREZ ), '10101' + Space( Len( SA1->A1_NATUREZ ) - 5 ), SA1->A1_NATUREZ )

	End

    If Empty( _cNatur )
       

       MsgInfo( 'Importação cancelada!!!' +;
               Chr( 13 ) + Chr( 13 ) +;
               'Por gentileza, realize o cadastramento a Natureza Financeira no cadastro do Fornecedor para dar prosseguimento na Nota Fiscal.' + Chr( 13 ) +;
               if( cTipo <> 'D', 'Fornecedor:'+SA2->A2_COD+'/'+SA2->A2_LOJA+' - '+SA2->A2_NREDUZ,'Cliente:'+SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+SA1->A1_NREDUZ),;
               'Condições de Pagamento e Natureza';
              ) 
      Return( NIL )
    
    End	

	// Primeiro Processamento
	// Busca de Informações para Pedidos de Compras
	
	cProds  := ''
	aPedIte := {}
	_nLen   := Len( oDet )
    SA5->( dbSetOrder( 14 ) )    // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR	

	For nX := 1 To _nLen

		cEdit1     := Space( 30 )
		_DESCdigit := Space( 55 )
		_NCMdigit  := Space( 8 )
		
		cProduto   := PadR( AllTrim( oDet[nX]:_Prod:_cProd:TEXT ), TAMSX3("A5_CODPRF")[1] )
		xProduto   := cProduto
		
		//Para que o Type funcione a variavel indice do array não pode ser Local
		nAux	:= nX
		
		cNCM       := If( Type( "oDet[nAux]:_Prod:_NCM")<>"U", oDet[nX]:_Prod:_NCM:TEXT, Space( 12 ) )
		ChkProc    := .F.
		
		If MV_PAR01 = 1

			If ! ( SA5->( dbSeek( _cFilSA5 + SA2->A2_COD + SA2->A2_LOJA + cProduto ) ) )

               If ! ( MsgYesNo( 'Produto Cod. [ '+;
								 cProduto+;
								 '] não localizado!' +;
								 Chr( 13 ) +;
								 ' Deseja digitar o Código de Substituição?';
				     )          )

				   PutMV( "MV_PCNFE", lPcNfe )
				   Return( NIL )

			   Else

                   _lGrv := .F.

                   DEFINE MSDIALOG _oDlg TITLE "Produto x Fornecedores" FROM C(177),C(192) TO C(329),C(659) PIXEL
//                   DEFINE FONT oFont NAME "Tahoma" Size 9,9 //BOLD 
                   // Cria as Groups do Sistema
                   @ C(002),C(003) TO C(071),C(186) LABEL "Digitação De/Para " PIXEL OF _oDlg
                   // Cria Componentes Padroes do Sistema
                   @ C(012),C(010) Say "Produto: " + cProduto + " - NCM: " + cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
                   @ C(020),C(010) Say "Descrição: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
                   @ C(028),C(060) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid( ValProd() ) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
                   @ C(040),C(010) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
                   @ C(048),C(010) Say "Descrição: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
                   @ C(004),C(194) Button "Gravar" When _lGrv Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
                   @ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
                   oEdit1:SetFocus()

                   ACTIVATE MSDIALOG _oDlg CENTERED

                   If ! ( ChkProc )

                      MsgInfo('Produto Cod.[' + cProduto + '] inválido...' )
                      PutMV( "MV_PCNFE", lPcNfe )

				   Else

					  If ! ( SA5->( dbSeek( _cFilSA5 + SA2->A2_COD + SA2->A2_LOJA +  xProduto ) ) )

						 _cQry := 'SELECT Count(*) as QDE FROM ' + RetSQLName( 'SA5' )
						 _cQry += " WHERE (D_E_L_E_T_ <> '*') AND (A5_FILIAL = '" + _cFilSA5 + "') AND "
						 _cQry += "(A5_FORNECE = '" + SA2->A2_COD  + "') AND "
						 _cQry += "(A5_LOJA = '" + SA2->A2_LOJA + "') AND "
						 _cQry += "(A5_PRODUTO = '" + cProduto + "')"
						 
						 dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )

						 If TMP->QDE > 0

						    _cQde := StrZero( TMP->QDE + 1, 3, 0 )

						 Else

						    _cQde := ' '

						 End

						 TMP->( dbClosearea() )

						 RecLock( 'SA5', .T. )
						 SA5->A5_FILIAL  := _cFilSA5
						 SA5->A5_FORNECE := SA2->A2_COD
						 SA5->A5_LOJA 	 := SA2->A2_LOJA
						 SA5->A5_NOMEFOR := SA2->A2_NOME
						 SA5->A5_PRODUTO := UPPER(cProduto)
						 SA5->A5_NOMPROD := Alltrim( oDet[nX]:_Prod:_xProd:TEXT )
						 SA5->A5_CODPRF  := UPPER(xProduto)
						 SA5->A5_REFGRD  := _cQde
						 SA5->( MsUnlock() )

					  End

				   End
					
				End

/*             Else
				
			    If ! ( Empty( cNCM ) )      .And.;
			       ( cNCM != '00000000' ) .And.;
				   ( SB1->B1_POSIPI <> cNCM )

				   RecLock( 'SB1', .F. )
				   SB1->B1_POSIPI := cNCM
				   SB1->( MSUnLock() )

			   End*/

		    End

        End
/*		Else
			
		   SA7->( dbOrderNickName( 'SA7CODCLI' ) )   // FILIAL + CLIENTE + LOJA + CODIGO PRODUTO NO FORNECEDOR
			
		   If ! ( SA7->( dbSeek(_cFilSA7 + SA1->A1_COD + SA1->A1_LOJA + xProduto ) ) )

              If ! ( MsgYesNo( 'Produto Cod [ '+;
							    cProduto+;
							    '] não localizado!' +;
							    Chr( 13 ) +;
							    'Deseja digitar o Código de Substituição?';
			        )          )


				 PutMV("MV_PCNFE",lPcNfe)
				 Return( NIL )

              Else

				 _lGrv := .F.
				 DEFINE MSDIALOG _oDlg TITLE 'Produtos x Clientes' FROM C(177),C(192) TO C(329),C(659) PIXEL
//                 DEFINE FONT oFont NAME "Tahoma" Size 9,9 //BOLD 
				 // Cria as Groups do Sistema
				 @ C(002),C(003) TO C(071),C(186) LABEL 'Digitação De/Para' PIXEL OF _oDlg
				 // Cria Componentes Padroes do Sistema
				 @ C(012),C(010) Say "Produto: "+cProduto+" - NCM: "+cNCM Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				 @ C(020),C(010) Say "Descrição: "+oDet[nX]:_Prod:_xProd:TEXT Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				 @ C(028),C(060) MsGet oEdit1 Var cEdit1 F3 "SB1" Valid(ValProd()) Size C(060),C(009) COLOR CLR_HBLUE PIXEL OF _oDlg
				 @ C(040),C(010) Say "Produto digitado: "+cEdit1+" - NCM: "+_NCMdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				 @ C(048),C(010) Say "Descrição: "+_DESCdigit Size C(150),C(008) COLOR CLR_HBLUE PIXEL OF _oDlg
				 @ C(004),C(194) Button "Gravar" Size C(037),C(012) PIXEL OF _oDlg Action(Troca())
				 @ C(025),C(194) Button "Cancelar" Size C(037),C(012) PIXEL OF _oDlg Action(_oDlg:End())
				 oEdit1:SetFocus()

				 ACTIVATE MSDIALOG _oDlg CENTERED

				 If ! ( Chkproc )

					MsgInfo('Produto Cod. [' + cProduto + '] não localizado...' )
					PutMV( "MV_PCNFE", lPcNfe )
				    Return( NIL )

				 Else

					SA7->( dbSetOrder( 1 ) )

					If ( dbSeek( _cFilSA7 + SA1->A1_COD + SA1->A1_LOJA + cProduto ) )

						RecLock( 'SA7', .F. )
						SA7->A7_DESCCLI := Alltrim( oDet[nX]:_Prod:_xProd:TEXT )
						SA7->A7_CODCLI  := xProduto
						SA7->( MsUnlock() )

					Else
					
					    SA7->( dbOrderNickName( 'SA7CODCLI' ) )

						If ! ( dbSeek( _cFilSA7 + SA1->A1_COD + SA1->A1_LOJA + xProduto ) )

						   RecLock( 'SA7', .T. )
						   SA7->A7_FILIAL  := _cFilSA7
						   SA7->A7_CLIENTE := SA1->A1_COD
						   SA7->A7_LOJA 	:= SA1->A1_LOJA	
						   SA7->A7_DESCCLI := Alltrim( oDet[nX]:_Prod:_xProd:TEXT )
						   SA7->A7_PRODUTO := cProduto
						   SA7->A7_CODCLI  := xProduto
						   SA7->( MsUnlock() )

					    End
					
				    End

                 End

			  End 

           End

		End*/

		SB1->( dbSetOrder( 1 ) )
		
		cProds += Alltrim( SB1->B1_COD ) + '/'

		aAdd( aPedIte, { SB1->B1_COD,;
						 Val(oDet[nX]:_Prod:_qTrib:TEXT),Round(Val(oDet[nX]:_Prod:_vUnCom:TEXT)*Val(oDet[nX]:_Prod:_qCom:TEXT),6),;
						 Val(oDet[nX]:_Prod:_vUnCom:TEXT);
					   };
			)
		
	Next nX
	
	// Retira a Ultima "/" da Variavel cProds
	
	cProds := Left(cProds,Len(cProds)-1)
	
	aCampos  := {}
	aCampos2 := {}
	
	AADD(aCampos,{'T9_OK'		,'#'		,'@!','2','0'})
	AADD(aCampos,{'T9_PEDIDO'	,'Pedido'	,'@!','6','0'})
	AADD(aCampos,{'T9_ITEM'		,'Item'		,'@!','3','0'})
	AADD(aCampos,{'T9_PRODUTO'	,'Produto'	,'@!','15','0'})
	AADD(aCampos,{'T9_DESC'		,'Descrição','@!','40','0'})
	AADD(aCampos,{'T9_UM'		,'Un'		,'@!','02','0'})
	AADD(aCampos,{'T9_QTDE'		,'Qtde'		,'@EZ 999,999.9999','10','4'})
	AADD(aCampos,{'T9_UNIT'		,'Unitário'	,'@EZ 9,999,999.99','12','2'})
	AADD(aCampos,{'T9_TOTAL'	,'Total'	,'@EZ 99,999,999.99','14','2'})
	AADD(aCampos,{'T9_DTPRV'	,'Dt.Prev'	,'','10','0'})
	AADD(aCampos,{'T9_ALMOX'	,'Alm'		,'','2','0'})
	AADD(aCampos,{'T9_OBSERV'	,'Observação','@!','30','0'})
	AADD(aCampos,{'T9_CCUSTO'	,'C.Custo'	,'@!','6','0'})
	
	aAdd( aCampos2, {'T8_NOTA'		,'N.Fiscal'	,'@!','9','0' } )
	aAdd( aCampos2, {'T8_SERIE'		,'Serie'	,'@!','3','0' } )
	aAdd( aCampos2, {'T8_PRODUTO'	,'PRODUTO'	,'@!','15','0' } )
	aAdd( aCampos2, {'T8_DESC'		,'Descrição','@!','40','0' } )
	aAdd( aCampos2, {'T8_UM'		,'Un'		,'@!','02','0' } )
	aAdd( aCampos2, {'T8_QTDE'		,'Qtde'		,'@EZ 999,999.9999','10','4' } )
	aAdd( aCampos2, {'T8_UNIT'		,'Unitario' ,'@EZ 9,999,999.99','12','2' } )
	aAdd( aCampos2, {'T8_TOTAL'		,'Total'	,'@EZ 99,999,999.99','14','2' } )
	
	Cria_TC9()
	_nLen := Len( aPedIte )
	
	For ni := 1 To _nLen

		RecLock( 'TC8', .T. )
		TC8->T8_NOTA 	:= Right("000000000"+Alltrim(OIdent:_nNF:TEXT),9)
		TC8->T8_SERIE 	:= OIdent:_serie:TEXT
		TC8->T8_PRODUTO := UPPER(aPedIte[nI,1])
		TC8->T8_DESC	:= Posicione( 'SB1', 1,_cFilSB1 + UPPER(aPedIte[nI,1]), "B1_DESC" )
		TC8->T8_UM		:= SB1->B1_UM
		TC8->T8_QTDE	:= aPedIte[nI,2]
		TC8->T8_UNIT	:= aPedIte[nI,3]
		TC8->T8_TOTAL	:= aPedIte[nI,4]
		TC8->(MSUnLock())

	Next

	TC8->( dbGoTop() )
	
	Monta_TC9()
	
	If ! Empty( TC9->( RecCount() ) )
		
		lOk := .F.
		
		DbSelectArea('TC9')
		@ 100,005 TO 500,750 DIALOG oDlgPedidos TITLE "Pedidos de Compras Associados a Nota de Importação"
		
		@ 006,005 TO 100,325 BROWSE "TC9" MARK "T9_OK" FIELDS aCampos Object _oBrwPed
		
		@ 066,330 BUTTON "Marcar"         SIZE 40,15 ACTION MsAguarde({||MarcarTudo()},'Marcando Registros...')
		@ 086,330 BUTTON "Desmarcar"      SIZE 40,15 ACTION MsAguarde({||DesMarcaTudo()},'Desmarcando Registros...')
		@ 106,330 BUTTON "Processar"	  SIZE 40,15 ACTION MsAguarde({|| lOk := .t. , Close(oDlgPedidos)},'Gerando e Enviando Arquivo...')
		@ 183,330 BUTTON "_Sair"          SIZE 40,15 ACTION Close(oDlgPedidos)
		
		//			Processa({||  } ,"Selecionando Informacoes de Pedidos de Compras...")
		
		DbSelectArea('TC8')
		
		@ 100,005 TO 190,325 BROWSE "TC8" FIELDS aCampos2 Object _oBrwPed2
		
		DbSelectArea('TC9')
		
		_oBrwPed:bMark := {|| Marcar()}
		
		ACTIVATE DIALOG oDlgPedidos CENTERED
		
	End
	
	
	// Verifica se o usuario selecionou algum pedido de compra
	
	dbSelectArea( "TC9" )
	dbGoTop()
	ProcRegua( Reccount() )
	
	lMarcou := .F.
	
	While ! TC9->( Eof() ) .And. lOk

		IncProc()

		If TC9->T9_OK  <> _cMarca

			dbSelectArea("TC9")
			TC9->( dbSkip( 1 ) )
			Loop

		Else

			lMarcou := .t.
			Exit

		End
		
		TC9->( dbSkip( 1 ) )

	End

    _nLen  := Len( oDet )
    _nItem := 0
	
	For nX := 1 To _nLen
					
		cProduto := Right( AllTrim( oDet[nX]:_Prod:_cProd:TEXT ), TAMSX3("A5_CODPRF")[1] )
		xProduto := cProduto
		ChkProc  = .F.

        If ( MV_PAR01 == 1 )

		   SA5->( dbSetOrder( 14 ) )   // FILIAL + FORNECEDOR + LOJA + CODIGO PRODUTO NO FORNECEDOR
		   SA5->( dbSeek( _cFilSA5 + SA2->A2_COD + SA2->A2_LOJA + cProduto ) )
		   SB1->( dbSetOrder( 1 ) )
		   
		   If SB1->(!dbSeek(_cFilSB1 + SA5->A5_PRODUTO ))
		       MsgAlert("Não localizada a amarração do Produto x Fornecedor, verifique o cadastro do produto "+SA5->A5_PRODUTO)
			   Return
		   EndIf
	    Else

		   SA7->( dbSetOrder( 3 ) )
		   SA7->( dbSeek( _cFilSA7 + SA1->A1_COD + SA1->A1_LOJA + cProduto ) )
		   SB1->( dbSetOrder( 1 ) , dbSeek(_cFilSB1 + SA7->A7_PRODUTO ) )

	    End

        aAdd( aItens, MontaItem(nX) )

	Next nX

	SA5->( dbSetOrder( _iSA5 ) )
	SA7->( dbSetOrder( _iSA7 ) )	
	
	If lMarcou
		
		dbSelectArea("TC9")
		dbGoTop()
		ProcRegua(Reccount())
		
		While !Eof() .And. lOk
			IncProc()
			If TC9->T9_OK  <> _cMarca
				dbSelectArea("TC9")
				TC9->(dbSkip(1));Loop
			Endif
			
			For nItem := 1 To Len(aItens)
				If AllTrim(aItens[nItem,1,2]) == AllTrim(TC9->T9_PRODUTO) .And. Empty(aItens[nItem,7,2])
					If !Empty(TC9->T9_QTDE)
						aItens[nItem,6,2] := TC9->T9_PEDIDO
						aItens[nItem,7,2] := TC9->T9_ITEM
						
						If RecLock('TC9', .F. )
							If (TC9->T9_QTDE-aItens[nItem,2,2]) < 0
								TC9->T9_QTDE := 0
							Else
								TC9->T9_QTDE := (TC9->T9_QTDE - aItens[nItem,2,2])
							End
							TC9->(MsUnlock())
						End
					End
				End
			Next
			
			
			TC9->( dbSkip(1) )

		End	             
		
		TC8->( dbCloseArea() )
		TC9->( dbCloseArea() )

	End
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Teste de Inclusao                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    _nItens := Len(aItens)

	If _nItens > 0

		PRIVATE lMsErroAuto := .F.
		PRIVATE lMsHelpAuto := .T.
		
		SB1->( dbSetOrder( 1 ) )
		SA2->( dbSetOrder( 1 ) )
				
//		nModulo := 4  //ESTOQUE

//cCgc := AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:TEXT,oDestino:_CPF:TEXT))
//cCgc := AllTrim(iif(Type("oDestino:_idEstrangeiro")!="U","",iif(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:TEXT,oDestino:_CPF:TEXT)))

If Type("oDestino:_CPF")  <> 'U' .Or.;
   Type("oDestino:_CNPJ") <> 'U'

       cCgc := AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:TEXT,oDestino:_CPF:TEXT))

    Else

       cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))

    End

        If     cCgc = '48254858000109' 
            _cFilSF2 := '0101'
        ElseIf cCgc = '48254858000290'
            _cFilSF2 :='0102' 
        ElseIf cCgc = '48254858000451'
            _cFilSF2 :='0103' 
        ElseIf cCgc = '03061254000108'
            _cFilSF2 :='0201'
        ElseIf cCgc = '03061254000299'
            _cFilSF2 :='0202'
        ElseIf cCgc = '67313247000139'
            _cFilSF2 :='0301' 
        ElseIf cCgc = '04051564000104'
           _cFilSF2 :='0401'
        ElseIf cCgc = '09158959000124'
           _cFilSF2 :='0501'
        ElseIf cCgc = '04657999000105'
           _cFilSF2 :='0601'
        ElseIf cCgc = '11175943000171'
           _cFilSF2 :='0701'
		Elseif cCgc = '32648870000168'
		   _cFilSF2 :='1101'
		Elseif cCgc = '36360406000122'   
		   _cFilSF2 :='1601'
    	Elseif cCgc = '36360406000203'
		   _cFilSF2 :='1602'			
		Elseif cCgc = '47958868000162'
		   _cFilSF2 :='2001'
        Else
            _cFilSF2 := '9999'
        End

		If _cFilSF2 <> U_SM0DePar(cCgc)
			Alert("Diferença no de para do CNPJ "+cCgc+" filial "+_cFilSF2+" na funcao SM0DePar("+U_SM0DePar(cCgc)+")")
		EndIf
        
        _oFilAnt := cFilAnt
        _oEmpAnt := cEmpAnt
        cFilAnt  := _cFilSF2

		/*Esse tratamento se da devido a inclusão dos titulos a Pgar ocorrer pelo Gestoq e não pela TES
		  O padrão possui uma pré validação que mesmo que a TES não calculo Financeiro, ele não deixa gerar se já existir um titulo na chave em questão.
		  A validação em questão ocorre no MATA103x.PRX */
		  
		//PutMv("MV_2DUPREF", "' '")

        SB1->( dbSeek( _cFilSB1 + '00' + Space(28), .F. ) )
        BEGIN SEQUENCE
        	MSExecAuto( { |x,y,z,w,v| Mata140(x,y,z,w,v) }, aCabec, aItens, 3, .F., 1 )
		
        	RECOVER
        		Alert("Ocorreu um erro no processamento, entre em contato com suporte.")
		END SEQUENCE
		//PutMv("MV_2DUPREF", "SF1->F1_SERIE")
		
        cFilAnt := _oFilAnt
        cEmpAnt := _oEmpAnt
		
		IF lMsErroAuto
			MsgInfo('Erro na visualizacao da Nota Fiscal')
			MostraErro()

		Else

			If SF1->F1_DOC == _cNFiscal
			   
			    RecLock( 'SF1', .F. ) 
			    SF1->F1_CHVNFE := cProt
			    SF1->( dbUnLock() )			   

				xFile := STRTRAN(Upper(cFile),"XMLNFE\", "XMLNFe\Processadas\")
				COPY FILE &cFile TO &xFile
				FErase(cFile)                                   
				PswOrder( 1 )
				PswSeek(__cUserId,.T.)
				aInfo := PswRet(1)
				cAssunto := 'Geração do Documento de Entrada '+Alltrim(aCabec[3,2])+' Serie '+Alltrim(aCabec[4,2])
				cTexto   := 'Nota Fiscal de Entrada '+Alltrim(aCabec[3,2])+' Serie: '+Alltrim(aCabec[4,2]) +' do tipo '+Alltrim(aCabec[1,2]) + ' do fornecedor '+ Alltrim(aCabec[6,2])+' loja ' + Alltrim(aCabec[7,2]) + ' foi incluida via XML pelo usuário '+ aInfo[1,4]
				cPara    := 'sergio.santana@bluetreesolutions.com.br'
				cCC      := ''
				cArquivo := ''
//			   	U_EnvMailto(cAssunto,cTexto,cPara,cCC,cArquivo) //para que seja enviado um arquivo em anexo o arquivo deve estar dentro da pasta protheus_data


cCnt01 := SF1->F1_DTDIGIT
cCnt02 := _cNFiscal

_cFil  := SF1->F1_FILIAL
_cNota := SF1->F1_DOC
_cSerie:= SF1->F1_SERIE
_cForn := SF1->F1_FORNECE
_cLoja := SF1->F1_LOJA


SX1->( dbSetOrder( 1 ) )
	_cPerg := PadR( cPerg1, 10 )
	IF SX1->( dbSeek( _cPerg + '01' ) )
		SX1->( RecLock( 'SX1', .F. ) )
		SX1->X1_CNT01 := DtoS(cCnt01)
		SX1->( MsUnLock() )
	EndIF

SX1->( dbSetOrder( 1 ) )
	_cPerg := PadR( cPerg1, 10 )
	IF SX1->( dbSeek( _cPerg + '02' ) )
		SX1->( RecLock( 'SX1', .F. ) )
		SX1->X1_CNT01 := DtoS(cCnt01)
		SX1->( MsUnLock() )
	EndIF

SX1->( dbSetOrder( 1 ) )
	_cPerg := PadR( cPerg1, 10 )
	IF SX1->( dbSeek( _cPerg + '03' ) )
		SX1->( RecLock( 'SX1', .F. ) )
		SX1->X1_CNT01 := cCnt02
		SX1->( MsUnLock() )
	EndIF

SX1->( dbSetOrder( 1 ) )
	_cPerg := PadR( cPerg1, 10 )
	IF SX1->( dbSeek( _cPerg + '04' ) )
		SX1->( RecLock( 'SX1', .F. ) )
		SX1->X1_CNT01 := cCnt02
		SX1->( MsUnLock() )
	EndIF


			Else

				MsgInfo(Alltrim(aCabec[3,2])+' / '+Alltrim(aCabec[4,2])+" - Inclusão via XML cancelado pelo usuário")

			End

		End

	End

End

PutMV("MV_PCNFE",lPcNfe)

Return

Static Function C(nTam)
LOCAL nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

Static Function ValProd()
_DESCdigit=Alltrim(GetAdvFVal("SB1","B1_DESC",_cFilSB1+cEdit1,1,""))
_NCMdigit=GetAdvFVal("SB1","B1_POSIPI",_cFilSB1+cEdit1,1,"")
_lGrv := .T.
Return 	ExistCpo("SB1")

Static Function Troca()

ChkProc  := .T.
cProduto := cEdit1

If Empty(SB1->B1_POSIPI) .and. !Empty(cNCM)

   RecLock( "SB1", .F. )
   SB1->B1_POSIPI := cNCM
   SB1->( MSUnLock() )

End

_oDlg:End()

Return( NIL )


******************************************
Static Function MarcarTudo()
DbSelectArea('TC9')
dbGoTop()
While !Eof()
	MsProcTxt('Aguarde...')
	RecLock('TC9',.F.)
	TC9->T9_OK := _cMarca
	MsUnlock()
	DbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgPedidos)
SysRefresh()
Return(.T.)

******************************************
Static Function DesmarcaTudo()
Private _nX := 0

DbSelectArea('TC9')
dbGoTop()
While !Eof()
	MsProcTxt('Aguarde...')
	RecLock('TC9',.F.)
	TC9->T9_OK := ThisMark()
	MsUnlock()
	DbSkip()
EndDo
DbGoTop()
DlgRefresh(oDlgPedidos)
SysRefresh()
Return(.T.)


******************************************
Static Function Marcar()
DbSelectArea('TC9')
RecLock('TC9',.F.)
If Empty(TC9->T9_OK)
	TC9->T9_OK := _cMarca
Endif
MsUnlock()
SysRefresh()
Return(.T.)

******************************************************
Static FUNCTION Cria_TC9()

If Select("TC9") <> 0
	TC9->(dbCloseArea())
Endif
If Select("TC8") <> 0
	TC8->(dbCloseArea())
Endif


aFields   := {}
AADD(aFields,{"T9_OK"     ,"C",02,0})
AADD(aFields,{"T9_PEDIDO" ,"C",06,0})
AADD(aFields,{"T9_ITEM"   ,"C",04,0})
AADD(aFields,{"T9_PRODUTO","C",15,0})
AADD(aFields,{"T9_DESC"   ,"C",40,0})
AADD(aFields,{"T9_UM"     ,"C",02,0})
AADD(aFields,{"T9_QTDE"   ,"N",6,0})
AADD(aFields,{"T9_UNIT"   ,"N",12,2})
AADD(aFields,{"T9_TOTAL"  ,"N",14,2})
AADD(aFields,{"T9_DTPRV"  ,"D",08,0})
AADD(aFields,{"T9_ALMOX"  ,"C",02,0})
AADD(aFields,{"T9_OBSERV" ,"C",30,0})
AADD(aFields,{"T9_CCUSTO" ,"C",06,0})
AADD(aFields,{"T9_REG" ,"N",10,0})
cArq:=Criatrab(aFields,.T.)
DBUSEAREA(.t.,,cArq,"TC9")

aFields2   := {}
AADD(aFields2,{"T8_NOTA" ,"C",09,0})
AADD(aFields2,{"T8_SERIE"   ,"C",03,0})
AADD(aFields2,{"T8_PRODUTO","C",15,0})
AADD(aFields2,{"T8_DESC"   ,"C",40,0})
AADD(aFields2,{"T8_UM"     ,"C",02,0})
AADD(aFields2,{"T8_QTDE"   ,"N",6,0})
AADD(aFields2,{"T8_UNIT"   ,"N",12,2})
AADD(aFields2,{"T8_TOTAL"  ,"N",14,2})
cArq2:=Criatrab(aFields2,.T.)
DBUSEAREA(.t.,,cArq2,"TC8")
Return


********************************************
Static Function Monta_TC9()
Local _nX := 0

// Irá efetuar a checagem de pedidos de compras
// em aberto para este fornecedor e os itens desta nota fiscal a ser importa
// será demonstrado ao usuário se o pedido de compra deverá ser associado
// a entrada desta nota fiscal

cQuery := ""
cQuery += " SELECT  C7_NUM T9_PEDIDO,     "
cQuery += " 		C7_ITEM T9_ITEM,    "
cQuery += " 	    C7_PRODUTO T9_PRODUTO, "
cQuery += " 		B1_DESC T9_DESC,    "
cQuery += " 		B1_UM T9_UM,		"
cQuery += " 		C7_QUANT T9_QTDE,   "
cQuery += " 		C7_PRECO T9_UNIT,   "
cQuery += " 		C7_TOTAL T9_TOTAL,   "
cQuery += " 		C7_DATPRF T9_DTPRV,  "
cQuery += " 		C7_LOCAL T9_ALMOX, "
cQuery += " 		C7_OBS T9_OBSERV, "
cQuery += " 		C7_CC T9_CCUSTO, "
cQuery += " 		SC7.R_E_C_N_O_ T9_REG "
cQuery += " FROM " + RetSqlName("SC7") + " SC7, " + RetSqlName("SB1") + " SB1 "
cQuery += " WHERE C7_FILIAL = '" + _cFilSC7 + "' "
cQuery += " AND B1_FILIAL = '" + _cFilSB1 + "' "
cQuery += " AND SC7.D_E_L_E_T_ = ' ' "
cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
cQuery += " AND C7_QUANT > C7_QUJE  "
cQuery += " AND C7_RESIDUO = ''  "
cQuery += " AND C7_CONAPRO <> 'B'  "
cQuery += " AND C7_ENCER = '' "
cQuery += " AND C7_PRODUTO = B1_COD "
cQuery += " AND C7_FORNECE = '" + SA2->A2_COD + "' "
cQuery += " AND C7_LOJA = '" + SA2->A2_LOJA + "' "
cQuery += " AND C7_PRODUTO IN" + FormatIn( cProds, "/")

If MV_PAR01 <> 1

   cQuery += " AND 1 > 1 "

End

cQuery += " ORDER BY C7_NUM, C7_ITEM, C7_PRODUTO "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CAD",.T.,.T.)
TcSetField("CAD","T9_DTPRV","D",8,0)

Dbselectarea("CAD")

While CAD->(!EOF())
	RecLock("TC9",.T.)
	For _nX := 1 To Len(aFields)
		If !(aFields[_nX,1] $ 'T9_OK')
			If aFields[_nX,2] = 'C'
				_cX := 'TC9->'+aFields[_nX,1]+' := Alltrim(CAD->'+aFields[_nX,1]+')'
			Else
				_cX := 'TC9->'+aFields[_nX,1]+' := CAD->'+aFields[_nX,1]
			Endif
			_cX := &_cX
		Endif
	Next
	TC9->T9_OK := _cMarca //ThisMark()
	MsUnLock()
	
	DbSelectArea('CAD')
	CAD->(dBSkip())
EndDo

Dbselectarea("CAD")
DbCloseArea()
Dbselectarea("TC9")
DbGoTop()

_cIndex:=Criatrab(NIL,.F.)
_cChave:="T9_PEDIDO"
Indregua("TC9",_cIndex,_cChave,,,"Ordenando registros selecionados...")
DbSetIndex(_cIndex+ordbagext())
SysRefresh()
Return


Static Function GetArq( cFile )

cFile:= cGetFile( "Arquivos XML   (*.xml)  | *.XML | Todos os Arquivos (*.*)    | *.* ",;
				  "Selecione o Arquivo de Nota Fiscal XML",;
				  ,;
				  ,;
				  .T.,;
				  GETF_LOCALHARD+GETF_NETWORKDRIVE;
				 )
Return cFile


StatiC Function Fecha()

Close(_oPT00005)

Return

Static Function AchaFile( cCodBar )
Local nArq 		:= 0
LOCAL aCompl 	:= {}
LOCAL cCaminho 	:= Caminho
LOCAL lOk 		:= .f.
LOCAL oNf
LOCAL oNfe

If Empty(cCodBar)
	Return .t.
Endif

/*AAdd(aCompl,'_v1.10-procNFe.xml')
AAdd(aCompl,'-nfe.xml')
AAdd(aCompl,'.xml')
AAdd(aCompl,'-procnfe.xml')

For nC := 1 To Len(aCompl)
If File(cCaminho+AllTrim(cCodBar)+aCompl[nC])
cCodBar := AllTrim(cCaminho+AllTrim(cCodBar)+aCompl[nC])
lOk := .t.
Exit
Endif
Next

*/

aFiles := Directory(cCaminho+"*.XML", "D")

For nArq := 1 To Len(aFiles)

	cFile := AllTrim(cCaminho+aFiles[nArq,1])
	nHdl  := fOpen(cFile,0)
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
	nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
	fClose(nHdl)

	If At( AllTrim(cCodBar), AllTrim(cBuffer) ) > 0

		cCodBar := cFile
		lOk := .t.
		Exit

	End
Next

If !lOk

	MsgInfo("Nenhum Arquivo Encontrado, Por Favor Selecione a Opção Arquivo e Faça a Busca na Arvore de Diretórios!")

End


Return lOk


Static Function MontaItem(nX)
LOCAL aLinha := {}
Private nAux := nX
_nItem ++

aAdd( aLinha, { "D1_ITEM", StrZero( _nItem, 4, 0 ), NIL, NIL } )
aAdd( aLinha, { "D1_COD"  , if( Empty( SB1->B1_COD ), '00' + space(28), SB1->B1_COD ), NIL, NIL } )
aAdd( aLinha, { "D1_LOCAL", '01', NIL, NIL } )

aAdd( aLinha, { "D1_TP", 'PA', NIL, NIL } )

aAdd( aLinha, { "D1_DESCR", oDet[nX]:_Prod:_xProd:TEXT, NIL, NIL } )


Do Case
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS00")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS00
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS10")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS10
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS20")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS20
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS30")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS30
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS40")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS40
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS51")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS51
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS60")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS60
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS70")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS70
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMS90")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS90
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN101")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN101
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN102")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN102
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN201")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN201
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN202")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN202
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN500")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN500
   Case Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN900")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN900
End

If Val( oDet[nX]:_Prod:_qTrib:TEXT ) <> 0

   If Val( oDet[nX]:_Prod:_vUnCom:TEXT ) <> 0

      aAdd( aLinha, { "D1_QUANT", Val( oDet[nX]:_Prod:_qCom:TEXT ), NIL, NIL } )
      aAdd( aLinha, { "D1_VUNIT", Round( Val( oDet[nX]:_Prod:_vUnCom:TEXT ),8 ), NIL, NIL } )
      aAdd( aLinha, { "D1_TOTAL", Val(oDet[nX]:_Prod:_vUnCom:TEXT)*Val(oDet[nX]:_Prod:_qCom:TEXT), NIL, NIL } )

   Else

      aAdd( aLinha, { "D1_QUANT", Val( oDet[nX]:_Prod:_qTrib:TEXT ), NIL, NIL } )
      aAdd( aLinha, { "D1_VUNIT", Round( Val( oICM:_vICMSST:TEXT ),8 ), NIL, NIL } )
      aAdd( aLinha, { "D1_TOTAL", Round( Val( oICM:_vICMSST:TEXT ),2 ), NIL, NIL } )

   End

Else

   aAdd( aLinha, { "D1_QUANT", Val( oDet[nX]:_Prod:_qCom:TEXT ), NIL, NIL } )
   aAdd( aLinha, { "D1_VUNIT", Round( Val( oDet[nX]:_Prod:_vUnCom:TEXT ), 8 ), NIL, NIL } )
   aAdd( aLinha, { "D1_TOTAL", Val(oDet[nX]:_Prod:_vUnCom:TEXT)*Val(oDet[nX]:_Prod:_qCom:TEXT), NIL, NIL } )

End
                                      
/*
Retirado preenchimento do campo D1_TESACLA pois ao classificar esta preenchendo a aba duplicatas com a TES não gerando duplicata
Montes - 07/01/2020
*/
//aAdd( aLinha, { "D1_TESACLA"  , if( ! Empty( SB1->B1_TE ), SB1->B1_TE, '   ' ), NIL, NIL } )
aAdd( aLinha, { "D1_TESACLA"  , '   ' , NIL, NIL } )

If Type("oDet[nAux]:_Prod:_vDesc")<> "U"

   aAdd( aLinha, { "D1_VALDESC", Val( oDet[nX]:_Prod:_vDesc:TEXT ), NIL, NIL } )

Else

   aAdd( aLinha, { "D1_VALDESC", 0, NIL, NIL } )

End

If Type("oDet[nAux]:_Imposto:_IPI:_IPITrib:_vBC") <> "U"

   aAdd( aLinha, { "D1_BASEIPI", Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_vBC:TEXT ), NIL, NIL } )
   aAdd( aLinha, { "D1_IPI"    , Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_pIPI:TEXT ), NIL, NIL } )
   aAdd( aLinha, { "D1_VALIPI" , Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_vIPI:TEXT ), NIL, NIL } )

Else

   aAdd( aLinha,{ "D1_BASEIPI", 0, NIL, NIL } )
   aAdd( aLinha,{ "D1_IPI"	  , 0, NIL, NIL } )
   aAdd( aLinha,{ "D1_VALIPI" , 0, NIL, NIL } )

End

If ( Type( 'oICM:_CST:TEXT' ) ) <> 'U'

   CST_Aux := Alltrim( oICM:_orig:TEXT ) + Alltrim( oICM:_CST:TEXT )

Else

   CST_Aux := '  '

End

aAdd( aLinha, { "D1_CLASFIS", CST_Aux, NIL, NIL } )

//aAdd( aLinha, { "D1_LOTECTL", Space( Len( SD1->D1_LOTECTL ) ), NIL, NIL } )
//aAdd( aLinha, { "D1_DTVALID", CtoD( ' /  /    ' )			  , NIL, NIL } )

If Type("oICM:_vCredICMSSN") <> "U"

   aAdd( aLinha, { "D1_BASEICM", Val(  oDet[nX]:_Prod:_vProd:TEXT )    , NIL, NIL } )
   aAdd( aLinha, { "D1_PICM"   , Val( oICM:_pCredSN:TEXT )    , NIL, NIL } )
   aAdd( aLinha, { "D1_VALICM" , Val( oICM:_vCredICMSSN:TEXT ), NIL, NIL } )


ElseIf Type("oICM:_vICMS") <> "U"

   aAdd( aLinha, { "D1_BASEICM", Val( oICM:_vBC:TEXT   ), NIL, NIL } )
   aAdd( aLinha, { "D1_PICM"   , Val( oICM:_pIcms:TEXT ), NIL, NIL } )
   aAdd( aLinha, { "D1_VALICM" , Val( oICM:_vIcms:TEXT ), NIL, NIL } )

Else

   aAdd( aLinha, { "D1_BASEICM", 0, NIL, NIL } )
   aAdd( aLinha, { "D1_PICM"   , 0, NIL, NIL } )
   aAdd( aLinha, { "D1_VALICM" , 0, NIL, NIL } )
//   aLinha[ 5 ][ 2 ] := '009'

End

aAdd( aLinha, { "D1_ALIQSOL" , 0, NIL, NIL } )
   
If Type("oDet[nAux]:_Prod:_vOutro:TEXT") <> "U"

   aAdd( aLinha, { "D1_DESPESA", Val( oDet[nX]:_Prod:_vOutro:TEXT ), NIL, NIL } )

Else

   aAdd( aLinha, { "D1_DESPESA", 0, NIL, NIL } )

End

aAdd( aLinha, { "D1_FORPRD", AllTrim( oDet[nX]:_Prod:_cProd:TEXT ), NIL , NIL } )

If lMarcou

   aAdd( aLinha, { "D1_PEDIDO", Space( 6 ), NIL, NIL } )
   aAdd( aLinha, { "D1_ITEMPC", Space( Len( SD1->D1_ITEMPC ) ), NIL, NIL } )

End        
		
Return( aLinha )

/*/{Protheus.doc} SM0DePar
	(Informa o numero da filial relativo ao CNPJ informado)
	@type  Static Function
	@author Pirolo
	@since 19/01/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function SM0DePar(cCNPJ)
Local cFilRet 	:= ""
Local aAreaSM0	:= SM0->(GetArea())

DbSelectArea("SM0")

While SM0->(!Eof())
	//Percorre o SIGAMAT procurando a filial relacionada ao CNPJ
	If SM0->(AllTrim(M0_CGC) == AllTrim(cCNPJ))
		cFilRet := AllTrim(SM0->M0_CODFIL)
		Exit
	EndIf

	SM0->(DbSkip())
EndDo

RestArea(aAreaSM0)
Return cFilRet
