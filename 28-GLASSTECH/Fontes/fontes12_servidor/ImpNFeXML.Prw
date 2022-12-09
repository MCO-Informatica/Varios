/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออหออออออัออออออออออปฑฑ
ฑฑบPrograma  ณ IMPNFEXMLบ Autor ณ S้rgio Santana        บ Data ณ27/08/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออสออออออฯออออออออออนฑฑ
ฑฑบDescricao ณ Importacao Arquivo XML para gera็ใo de Pre-Nota            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบALTERACAO ณ                                                            บฑฑ 
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ThermoGlass                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//-- Ponto de Entrada para incluir botใo na Pr้-Nota de Entrada

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function ImpNFeXML()
LOCAL aTipo      :={ 'N','B','D' }
LOCAL cFile      := Space( 10 )
Local n:= 0
Local nX := 0
PRIVATE CPERG    :="NOTAXML"
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

PutMV("MV_PCNFE",.F.)

nTipo   := 1
aFiles  := Directory(Caminho+"\*.XML", "D")	
_nFiles := Len( aFiles )
MV_PAR01 := 1

For n := 1 To _nFiles

    cFile := Caminho + aFiles[ n ][ 1 ]
	PRIVATE nHdl := fOpen( cFile, 0 )	
	
	If nHdl == -1

		If !Empty( cFile )

			MsgInfo("O arquivo de nome "+cFile+" nใo pode ser aberto!" + chr( 13 ) + "Por gentileza verifique os parametros.","Aten็ใo!")

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
	oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)
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

	If Type("oNF:_InfNfe:_ICMS")<> "U"

		PRIVATE oICM := oNF:_InfNfe:_ICMS

	Else

		PRIVATE oICM := NIL

	End

	PRIVATE oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",NIL,oNF:_InfNfe:_Cobr)
	PRIVATE cEdit1	   := Space( 30 )
	PRIVATE _DESCdigit := space( 55 )
	PRIVATE _NCMdigit  := space(  8 )
	
	_nFrete := If( Type( "oTotal:_ICMSTot:_vFrete" ) <> 'U', Val( oTotal:_ICMSTot:_vFrete:TEXT ), 0 )
	_nDesp  := If( Type( "oTotal:_ICMSTot:_vOutro" ) <> 'U', Val( oTotal:_ICMSTot:_vOutro:TEXT ), 0 )
		
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)

	If MV_PAR01 = 1
		cTipo := "N"
	ElseIF MV_PAR01 = 2
		cTipo := "B"
	ElseIF MV_PAR01 = 3
		cTipo := "D"
	Endif
		
	// CNPJ ou CPF

	cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))

    If MV_PAR01 = 1 // Nota Normal Fornecedor

       If ! ( SA2->( dbSetOrder( 3 ), dbSeek( _cFilSA2 + cCgc ) ) )

          _xNOME   := AllTrim(oEmitente:_XNOME:TEXT)
          _IE      := AllTrim(oEmitente:_IE:TEXT)
          _CEP     := AllTrim(oEmitente:_ENDEREMIT:_CEP:TEXT)
          _CMUN    := RIGHT(AllTrim(oEmitente:_ENDEREMIT:_CMUN:TEXT),5)
          _CPAIS   := AllTrim( if( Type( "oEmitente:_ENDEREMIT:_CPAIS" ) <> 'U', oEmitente:_ENDEREMIT:_CPAIS:TEXT, '1058' ) )
          _FONE    := AllTrim( if( Type( "oEmitente:_ENDEREMIT:_FONE") <> 'U', oEmitente:_ENDEREMIT:_FONE:TEXT, ' ' ) )
          _NRO     := AllTrim(oEmitente:_ENDEREMIT:_NRO:TEXT)
          _UF      := AllTrim(oEmitente:_ENDEREMIT:_UF:TEXT)
          _XBAIRRO := AllTrim(oEmitente:_ENDEREMIT:_XBAIRRO:TEXT)
          _XLGR    := AllTrim(oEmitente:_ENDEREMIT:_XLGR:TEXT)
          _XMUN    := AllTrim(oEmitente:_ENDEREMIT:_XMUN:TEXT)

          RecLock( 'SA2', .T. )
          SA2->A2_LOJA    := '01'
          SA2->A2_COD     := GetSXENum( 'SA2' )
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
          ConfirmSX8()
          SA2->( dbUnLock() )

       End
       
       If Empty( SA2->A2_NATUREZ ) .Or.;
          Empty( SA2->A2_COND )

          MsgInfo('Fornecedor sem Natureza Financeira ou Condi็ใo de Pagamento cadastrada' + Chr(13) + SA2->A2_COD + ltrim( SA2->A2_NOME ) )

       End

	Else

		If !SA1->( dbSetOrder( 3 ), dbSeek( _cFilSA1 + cCgc ) )

			MsgInfo("CNPJ do cliente nใo localizado..." + cCgc)
			PutMV("MV_PCNFE",lPcNfe)
			Return( NIL )

		End

	End

    cCgc := AllTrim(IIf(Type("oDestino:_CPF")=="U",oDestino:_CNPJ:TEXT,oDestino:_CPF:TEXT))

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
    Else
          _cFilSF2 := '9999'
    End
    
	// -- Nota Fiscal jแ existe na base ?
	If SF1->( dbSeek( _cFilSF2 + Right ("000000000" + Alltrim(OIdent:_nNF:TEXT),9) + Padr(OIdent:_serie:TEXT,3)+ SA2->A2_COD + SA2->A2_LOJA + cTipo ) )

/*       If MV_PAR01 = 1

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
                  'Encontra-se lan็ada no sistema. Importa็ใo interrompida';
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
			      'Encontra-se lan็ada no sistema. Importa็ใo interrompida';
			     )

       End

       PutMV( "MV_PCNFE", lPcNfe )*/

       FreeObj( oNFe )    
       FreeObj( oNF )
        __CopyFile( cFile, Caminho + 'Importados\' + aFiles[ n ][ 1 ] )
       fErase( cFile )

       Loop

	End
	
	aCabec := {}
	aItens := {}

    _cFilSF1 := _cFilSF2
    _cFilSD1 := _cFilSF1

    _cEst := if( MV_PAR01=1, SA2->A2_EST, SA2->A2_EST )
    if ( Type("OIdent:_dEmi")<> 'U')

       cData := Alltrim( OIdent:_dEmi:TEXT )
       dData := CtoD( Right( cData, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )
                    
    Else

       cData := Alltrim( OIdent:_dhEmi:TEXT )
       dData := CtoD( Substr( cData, 9, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )

    End


    RecLock( 'SF1', .T. )
    SF1->F1_FILIAL   := _cFilSF1
	SF1->F1_TIPO     := If( MV_PAR01==1, "N", If( MV_PAR01==2,'B','D' ) )
	SF1->F1_FORMUL   := 'N'
	SF1->F1_DOC      := Right( "000000000" + Alltrim( OIdent:_nNF:TEXT ), 9 )
	SF1->F1_SERIE    := OIdent:_serie:TEXT
	SF1->F1_EMISSAO  := dData
	SF1->F1_FORNECE  := If( MV_PAR01=1, SA2->A2_COD,SA1->A1_COD)
	SF1->F1_LOJA     := If( MV_PAR01=1, SA2->A2_LOJA,SA1->A1_LOJA)
	SF1->F1_RECBMTO  := dData
	SF1->F1_ESPECIE  := 'SPED'
	SF1->F1_EST      := _cEst
	SF1->F1_CHVNFE   := cProt
    SF1->F1_FRETE    := _nFrete
    SF1->F1_DESPESA  := _nDesp
    SF1->F1_RECISS   := '1'
    SF1->F1_MENNOTA  := if( Type("oNF:_InfNfe:_InfAdic:_InfCpl")<> 'U',oNF:_infNFe:_InfAdic:_InfCpl:TEXT	, Space( 600 ) )

    If cTipo = "N"

		aAdd( aCabec,{ "F1_COND" , If( Empty(SA2->A2_COND), '001', SA2->A2_COND ), NIL ,NIL } )
		_cNatur := SA2->A2_NATUREZ

	Else               

		aAdd( aCabec,{ "F1_COND" , If( Empty(SA1->A1_COND), '001', SA1->A1_COND ), NIL, NIL } )
		_cNatur := SA2->A2_NATUREZ

	End

    _nLen  := Len( oDet )
    _nItem := 0
	
	For nX := 1 To _nLen
					
		cProduto := Right( AllTrim( oDet[nX]:_Prod:_cProd:TEXT ), 30 )
		xProduto := cProduto
		ChkProc=.F.

        aAdd( aItens, MontaItem() )

	Next nX
	
	SF1->( dbUnLock() )

    FreeObj( oNFe )    
    FreeObj( oNF )
    __CopyFile( cFile, Caminho + 'Importados\' + aFiles[ n ][ 1 ] )
    fErase( cFile )

Next

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)


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

LOCAL aCompl := {}
LOCAL cCaminho := Caminho
LOCAL lOk := .f.
LOCAL oNf
LOCAL oNfe
Local nArq := 0

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

	MsgInfo("Nenhum Arquivo Encontrado, Por Favor Selecione a Op็ใo Arquivo e Fa็a a Busca na Arvore de Diret๓rios!")

End


Return lOk

Static Function MontaItem()
LOCAL aLinha := {}

_nItem ++

RecLock( 'SD1', .T. )

SD1->D1_FILIAL := _cFilSF2

SD1->D1_FORNECE := SF1->F1_FORNECE
SD1->D1_LOJA    := SF1->F1_LOJA
SD1->D1_TIPO    := SF1->F1_TIPO
SD1->D1_DOC     := SF1->F1_DOC
SD1->D1_SERIE   := SF1->F1_SERIE
SD1->D1_DTDIGIT := SF1->F1_DTDIGIT
SD1->D1_EMISSAO := SF1->F1_EMISSAO

SD1->D1_STSERV := '1'

SD1->D1_ITEM    := StrZero( _nItem, 4, 0 )
SD1->D1_COD     := if( Empty( SB1->B1_COD ), cProduto, SB1->B1_COD )
SD1->D1_ZCODFOR := xProduto
SD1->D1_DESCR   := Right( AllTrim( oDet[nX]:_Prod:_xProd:TEXT ), 80 )

If Val( oDet[nX]:_Prod:_qTrib:TEXT ) <> 0

   SD1->D1_QUANT := Val( oDet[nX]:_Prod:_qCom:TEXT )
   SD1->D1_VUNIT := Val( oDet[nX]:_Prod:_vUnCom:TEXT )

Else

   SD1->D1_QUANT := Val( oDet[nX]:_Prod:_qCom:TEXT )
   SD1->D1_VUNIT := Val( oDet[nX]:_Prod:_vUnCom:TEXT )

End
  
/*
Retirado preenchimento do campo D1_TESACLA pois ao classificar esta preenchendo a aba duplicatas com a TES nใo gerando duplicata
Montes - 07/01/2020
*/
//SD1->D1_TESACLA := if( ! Empty( SB1->B1_TE ), SB1->B1_TE, '   ' )
SD1->D1_TESACLA := '   '
SD1->D1_TOTAL   := round( Val(oDet[nX]:_Prod:_vUnCom:TEXT) * Val(oDet[nX]:_Prod:_qCom:TEXT), 2 )

If Type("oDet[nX]:_Prod:_vDesc")<> "U"

   SD1->D1_VALDESC :=  Val( oDet[nX]:_Prod:_vDesc:TEXT )

Else

   SD1->D1_VALDESC := 0

End

If Type("oDet[nX]:_Imposto:_IPI:_IPITrib:_vIPI") <> "U"

   SD1->D1_BASEIPI := if( Type("oDet[nX]:_Imposto:_IPI:_IPITrib:_vBC") <> "U" , Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_vBC:TEXT  ), 0)
   SD1->D1_IPI     := if( Type("oDet[nX]:_Imposto:_IPI:_IPITrib:_pIPI") <> "U", Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_pIPI:TEXT ), 0)
   SD1->D1_VALIPI  := if( Type("oDet[nX]:_Imposto:_IPI:_IPITrib:_vIPI") <> "U", Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_vIPI:TEXT ), 0)

Else

   SD1->D1_BASEIPI := 0
   SD1->D1_IPI     := 0
   SD1->D1_VALIPI  := 0

End

Do Case
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS00")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS00
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS10")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS10
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS20")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS20
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS30")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS30
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS40")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS40
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS51")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS51
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS60")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS60
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS70")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS70
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS90")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS90
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN101")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN101
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN102")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN102
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN201")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN201
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN202")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN202
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN500")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN500
   Case Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN900")<> "U"
      oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN900
End


If ( Type( 'oICM:_CST:TEXT' ) ) <> 'U'

   CST_Aux := Alltrim( oICM:_orig:TEXT ) + Alltrim( oICM:_CST:TEXT )

Else

   CST_Aux := '  '

End

SD1->D1_UM      := Alltrim( oDet[nX]:_Prod:_uTrib:TEXT )
SD1->D1_CLASFIS := CST_Aux

SD1->D1_LOTECTL := Space( Len( SD1->D1_LOTECTL ) )
SD1->D1_DTVALID := CtoD( ' /  /    ' )

If Type("oICM:_vCredICMSSN") <> "U"

   SD1->D1_BASEICM := Val(  oDet[nX]:_Prod:_vProd:TEXT )
   SD1->D1_PICM    := Val( oICM:_pCredSN:TEXT )
   SD1->D1_VALICM  := Val( oICM:_vCredICMSSN:TEXT )

ElseIf Type("oICM:_vICMS") <> "U"

   SD1->D1_BASEICM := if( Type("oICM:_vBC") <> "U", Val( oICM:_vBC:TEXT   ), 0 )
   SD1->D1_PICM    := if( Type("oICM:_pIcms") <> "U", Val( oICM:_pIcms:TEXT ), 0 )
   SD1->D1_VALICM  := if( Type("oICM:_vIcms") <> "U", Val( oICM:_vIcms:TEXT ), 0 )

Else

   SD1->D1_BASEICM := 0
   SD1->D1_PICM    := 0
   SD1->D1_VALICM  := 0

End

SD1->D1_ALIQSOL := 0
   
If Type("oDet[nX]:_Prod:_vOutro:TEXT") <> "U"

   SD1->D1_DESPESA := Val( oDet[nX]:_Prod:_vOutro:TEXT )

Else

   SD1->D1_DESPESA := 0

End
		
Return( aLinha )
