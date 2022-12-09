
Static cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)
Static cBDPROTG	:= GetMv("MV_TWINENF")
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ NFENTRADAº Autor ³ Sérgio Santana        º Data ³17/07/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao arquivos notas fiscal de entrada Folhamatic     º±±
±±º          ³ Carga realizada via DTS SQL utilizando ODBC Visual Fox     º±±
±±º          ³ Pro                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºALTERACAO ³                                                            º±± 
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ThermoGlass                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function NotaFhaM()
LOCAL aTipo      :={ 'N','B','D' }
LOCAL cFile      := Space( 10 )
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
PRIVATE _cFilSD1 := xFilial( 'SD1' )

SB1->( dbSetOrder( 1 ) )
SA2->( dbSetOrder( 3 ) )

PutMV("MV_PCNFE",.F.)


If cFilAnt = '0101' // THM
   cCod := '0001'
ElseIf cFilAnt = '0102' // THF
   cCod := '0279'
ElseIf cFilAnt = '0201' // TWM
   cCod := '0150'
ElseIf cFilAnt = '0202' // TWF
   cCod := '0411'
Else 
   cCod := '0000'
End 

_cQryCb := "select replace( especie , '-', '' ) F1_ESPECIE, numinici F1_DOC, serie F1_SERIE, "
_cQryCb += "dtemiss F1_EMISSAO,dtdocum F1_DTDIGIT,uf F1_EST,'N' F1_FORMUL,'N' F1_TIPO,vlrcont F1_VALBRUT,"
_cQryCb += '(vlrcont - ipivlr - icmsst ) F1_VALMERC,icmsbas F1_BASEICM,icmsvlr F1_VALICM,ipibas F1_BASEIPI,'
_cQryCb += 'ipivlr F1_VALIPI,stbas F1_BRICMS,icmsst F1_ICMSRET,ovbascof F1_BASIMP5,ovcofins F1_VALIMP5, Ice.chave PK_Idx,'
_cQryCb += 'ovaliqcof F1_ALQIMP5,ovbaspis F1_BASIMP6,ovpis F1_VALIMP6,ovaliqpis F1_ALQIMP6,chnfecte F1_CHVNFE,'
_cQryCb += "icmssittra F1_ORIGEM,icmssittrb F1_CSTICMS,ipisittri  F1_CSTIPI,cfop F1_CFOP,substring(replace(replace(replace(nfe.cnpj,'-',''),'.',''),'/',''),1,14) cnpj,nfe.fk_clifor F1_FORNEC "
_cQryCb += 'from [nfentrad' + cCod + '] nfe '
_cQryCb += 'left outer join [lcentrad' + cCod + '] Ice on Ice.chave = nfe.chave '
_cQryCb += "where nfe.dtdocum > '2014-00-00'"

dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQryCb),"CAB",.T.,.T.)
CAB->( dbGoTop() )

While ! CAB->( Eof() )

	cProt   := CAB->F1_CHVNFE
	cAut    := ' '
	_nFrete := 0
	_nDesp  := 0
    cTipo   := CAB->F1_TIPO
    _UF     := CAB->F1_EST

/*    cCgc := SF1->F1_CNPJ

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
*/    
    SA2->( dbSeek( _cFilSA2 + CAB->CNPJ, .F. ) )

	If SF1->( dbSeek( _cFilSF1 + Right ("000000000" + alltrim( CAB->F1_DOC ), 9 ) + Padr(CAB->F1_SERIE,3)+ SA2->A2_COD + SA2->A2_LOJA ) )

/*       MsgInfo('Nota Fiscal no. '+;
               Right("000000000" + Alltrim(CAB->F1_DOC),9)+;
               '/'               +;
               CAB->F1_SERIE+;
               Chr( 13 )         +;
               'Fornecedor '      +;
               SA2->A2_COD + '/'      +;
               SA2->A2_LOJA + ' - '   +;
               rTrim( SA2->A2_NREDUZ )+;
               Chr( 13 ) +;
               'Encontra-se lançada no sistema. Importação interrompida';
              )*/

       PutMV( "MV_PCNFE", lPcNfe )
       CAB->( dbSkip() )
       Loop

	End

    _cEst := CAB->F1_EST
	cData := CAB->F1_EMISSAO
	dData := CtoD( Right( cData, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )

	cData := CAB->F1_DTDIGIT
	dDtDg := CtoD( Right( cData, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )

    RecLock( 'SF1', .T. )

    SF1->F1_FILIAL  := _cFilSF1
    SF1->F1_DOC     := Right( "000000000" + Alltrim( CAB->F1_DOC ), 9 )
    SF1->F1_SERIE   := CAB->F1_SERIE
    SF1->F1_PREFIXO := CAB->F1_SERIE
    SF1->F1_FORNECE := SA2->A2_COD
    SF1->F1_LOJA    := SA2->A2_LOJA
    SF1->F1_COND    := ''
    SF1->F1_EMISSAO := dData
    SF1->F1_DTDIGIT := dDtDg
    SF1->F1_EST     := CAB->F1_EST
    SF1->F1_VALBRUT := CAB->F1_VALBRUT
    SF1->F1_VALICM  := CAB->F1_VALICM
    SF1->F1_BASEICM := CAB->F1_BASEICM
    SF1->F1_VALIPI  := CAB->F1_VALIPI
    SF1->F1_BASEIPI := CAB->F1_BASEIPI
    SF1->F1_VALMERC := CAB->F1_VALMERC
    SF1->F1_ESPECIE := CAB->F1_ESPECIE
    SF1->F1_CHVNFE  := cProt
    SF1->F1_CODNFE  := cAut
    SF1->F1_DAUTNFE := dData 
//    SF1->F1_DESCZFR := 0
    SF1->F1_TIPO    := cTipo
    SF1->F1_ICMSRET := CAB->F1_ICMSRET
    SF1->F1_BRICMS  := CAB->F1_BRICMS
//    SF1->F1_DTLANC  := dData
    
    SF1->F1_VALIMP5 := CAB->F1_VALIMP5
    SF1->F1_BASIMP5 := CAB->F1_BASIMP5
    
    SF1->F1_VALIMP6 := CAB->F1_VALIMP6
    SF1->F1_BASIMP6 := CAB->F1_BASIMP6

    SF1->F1_VALCOFI := 0
    SF1->F1_BASCOFI := 0
    SF1->F1_VALPIS  := 0
    SF1->F1_BASPIS  := 0
    
    SF1->F1_RECISS  := '2'
//    SF1->F1_RECFAUT := '1'
    SF1->F1_MOEDA   := 1

    SF1->( dbUnLock() )

    RecLock( 'SF3', .T. )
	SF3->F3_FILIAL  := _cFilSD1
	SF3->F3_NFISCAL := SF1->F1_DOC		
	SF3->F3_SERIE   := SF1->F1_SERIE
	SF3->F3_EMISSAO := dData
	SF3->F3_ENTRADA := dDtDg
	SF3->F3_CLIEFOR := SA2->A2_COD
	SF3->F3_LOJA    := SA2->A2_LOJA
	SF3->F3_ESPECIE := CAB->F1_ESPECIE
	SF3->F3_CLIENT  := SA2->A2_COD
	SF3->F3_LOJENT  := SA2->A2_LOJA
	SF3->F3_TIPO    := SF1->F1_TIPO
	SF3->F3_ESTADO  := CAB->F1_EST
    SF3->F3_VALCONT := CAB->F1_VALBRUT
    SF3->F3_BASERET := CAB->F1_BRICMS
    SF3->F3_ICMSRET := CAB->F1_ICMSRET
    SF3->F3_ICMSCOM := CAB->F1_ICMSRET
    SF3->F3_DESCZFR := 0
    SF3->F3_BASEICM := CAB->F1_BASEICM
    SF3->F3_VALICM  := CAB->F1_VALICM
    SF3->F3_BASEIPI := CAB->F1_BASEIPI
    SF3->F3_VALIPI  := SF1->F1_VALIPI
    SF3->F3_RECISS  := '2'
    SF3->F3_IDENTFT := '000001'
    SF3->F3_CHVNFE  := cProt
    SF3->F3_CODNFE  := cAut
    SF3->F3_CODRSEF := if( cProt <> ' ', '100', ' ')

    _cItem := '0000'

    _cQryIt := 'select lce.codlanc D1_ITEM, codprod D1_COD, codunicom D1_UM, quantida D1_QUANT, vlruni  D1_VUNIT,lce.chave PK_Idx,'
    _cQryIt += 'vlrmerc D1_TOTAL, icmsbas D1_BASEICM, icmsvlr D1_VALICM, staicms D1_ORIGEM, stbicms D1_CSTICM,'
    _cQryIt += 'ipibas D1_BASEIPI, icmsali D1_PICM, ipivlr D1_VALIPI, sittribipi D1_CSTIPI, lce.cfop D1_CF, stbas  D1_BRICMS,'
    _cQryIt += 'icmsst D1_ICMSRET, out_cofins D1_BASIMP5, out_alicof D1_ALQIMP5, out_valcof D1_VALIMP5,'
    _cQryIt += 'out_stpis  D1_CSTPIS,out_baspis D1_BASIMP6,out_alipis D1_ALQIMP6,out_valpis D1_VALIMP6,out_stcof D1_CSTCOF'
    _cQryIt += ' from [lcereg54' + cCod + '] lce'
//--    _cQryIt += ' left outer join [nfentrad0001] nfe on nfe.chave = lce.chave'
//--    _cQryIt += " where nfe.dtdocum > '2014-00-00' and nfe.chave"
    _cQryIt += " where lce.chave = '" + CAB->PK_Idx + "'"

    dbUseArea( .T.,"TOPCONN",TcGenQry(,,_cQryIt),"ITE",.T.,.T.)
    _pICMS := 999
                                                                                         
    While CAB->PK_Idx = ITE->PK_Idx

        _cCST    := ITE->D1_ORIGEM
        _cCST    += ITE->D1_CSTICM
        _pICMS   := ITE->D1_PICM
        _vBC     := ITE->D1_BASEICM
        _vIcms   := ITE->D1_VALICM
        _cMotDes := ' '
        
        _vIcmsRet := ITE->D1_ICMSRET
        _vIcmsBse := ITE->D1_BRICMS
        _vIcmsMVA := 0
        _vIcmsPer := 0
        
        _vBCIPI := ITE->D1_BASEIPI

        If ITE->D1_VALIPI <> 0

           _pIPI   := (ITE->D1_VALIPI / ITE->D1_BASEIPI) * 100

        Else

        _pIPI   := 0

        End

        _vIPI   := ITE->D1_VALIPI
		cProduto   := ITE->D1_COD

        If  ! ( SB1->( dbSeek( _cFilSB1 + cProduto, .F. ) )  )

           RecLock( 'SB1', .T. )
   
           SB1->B1_COD  := cProduto
           SB1->B1_TIPO := 'PA'
           SB1->B1_LOCPAD := '01'
           SB1->B1_ORIGEM := Substr( _cCST, 1, 1 )
           SB1->B1_GARANT := '2'
           SB1->( dbUnLock() )   
           
           _cUpd := "update SB1010 SET B1_DESC = descricao, B1_UM = codunicom, B1_POSIPI = replace(nbmsh,'.','') from PROD_FHM PRO where B1_COD = '" 
           _cUpd += cProduto + "' and PRO.codigo = '"+ cProduto + "'"
           tcsqlexec( _cUpd )
           SB1->( dbSeek( _cFilSB1 + cProduto, .F. ) )

        End

		RecLock( 'SD1', .T. )
		SD1->D1_FILIAL  := _cFilSD1
		SD1->D1_DOC     := SF1->F1_DOC		
		SD1->D1_SERIE   := SF1->F1_SERIE
		SD1->D1_EMISSAO := SF1->F1_EMISSAO
		SD1->D1_FORNECE := SA2->A2_COD
		SD1->D1_LOJA    := SA2->A2_LOJA
//		SD1->D1_ESPECIE := CAB->F1_ESPECIE
		SD1->D1_NUMSEQ  := ProxNum()
		SD1->D1_CF      := ITE->D1_CF
		SD1->D1_TIPO    := 'N'
		SD1->D1_TP      := 'PA'
		SD1->D1_LOCAL   := '01'
//		SD1->D1_EST     :=  CAB->F1_EST
		_cItem := Soma1( _cItem )
		SD1->D1_ITEM    := _cItem
	    SD1->D1_COD     := cProduto
        SD1->D1_DESCR   := SB1->B1_DESC
        SD1->D1_UM      := ITE->D1_UM
        SD1->D1_QUANT   := ITE->D1_QUANT
        SD1->D1_VUNIT   := ITE->D1_VUNIT
        SD1->D1_TOTAL   := ITE->D1_TOTAL
        SD1->D1_ICMSRET := _vIcmsRet
        SD1->D1_ICMSCOM := _vIcmsRet
        SD1->D1_BRICMS  := _vIcmsBse
        SD1->D1_MARGEM  := _vIcmsMVA
        SD1->D1_ALIQSOL := _vIcmsPer
//        SD1->D1_DESCZFR := 0

        SD1->D1_CSTCOF  := ITE->D1_CSTCOF
        SD1->D1_ALQIMP5 := ITE->D1_ALQIMP5
        SD1->D1_BASIMP5 := ITE->D1_BASIMP5
        SD1->D1_VALIMP5 := ITE->D1_VALIMP5

        SD1->D1_CSTPIS  := ITE->D1_CSTPIS
        SD1->D1_ALQIMP6 := ITE->D1_ALQIMP6
        SD1->D1_BASIMP6 := ITE->D1_BASIMP6
        SD1->D1_VALIMP6 := ITE->D1_VALIMP6

        SD1->D1_CLASFIS := _cCST
        SD1->D1_CSTIPI  := ITE->D1_CSTIPI

        SD1->D1_PICM    := _pICMS
        SD1->D1_BASEICM := _vBC
        SD1->D1_VALICM  := _vIcms
        SD1->D1_BASEIPI := _vBCIPI
        SD1->D1_IPI     := _pIPI
        SD1->D1_VALIPI  := _vIPI

        SD1->( dbUnLock() )

        If (SD1->D1_ICMSRET <> 0)

           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV   := 'E'
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODFOR   := SA2->A2_COD
           CD2->CD2_LOJFOR   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'SOL'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
           CD2->CD2_MVA      := SD1->D1_MARGEM
           CD2->CD2_BC       := SD1->D1_BRICMS
           CD2->CD2_ALIQ     := SD1->D1_ALIQSOL
           CD2->CD2_VLTRIB   := SD1->D1_ICMSRET
           CD2->CD2_QTRIB    := SD1->D1_QUANT
//           CD2->CD2_DESCZF   := SD1->D1_DESCZFR
           CD2->( dbUnLock() )
        End

/*        If (SD1->D1_DESCZFR <> 0)

           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV    := 'E'
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODCLI   := SA2->A2_COD
           CD2->CD2_LOJCLI   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'ZFM'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
           CD2->CD2_MVA      := 0
           CD2->CD2_BC       := 0
           CD2->CD2_ALIQ     := 0
           CD2->CD2_VLTRIB   := 0
           CD2->CD2_QTRIB    := SD1->D1_QUANT
           CD2->CD2_DESCZF   := SD1->D1_DESCZFR
           CD2->( dbUnLock() )
        End*/
    
        If (SD1->D1_VALICM <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV    := 'E'
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODFOR   := SA2->A2_COD
           CD2->CD2_LOJFOR   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'ICM'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
           CD2->CD2_BC       := SD1->D1_BASEICM
           CD2->CD2_ALIQ     := SD1->D1_PICM
           CD2->CD2_VLTRIB   := SD1->D1_VALICM
           CD2->CD2_QTRIB    := SD1->D1_QUANT
           CD2->( dbUnLock() )
        End

        If (SD1->D1_VALIPI <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV    := 'E'
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODFOR   := SA2->A2_COD
           CD2->CD2_LOJFOR   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'IPI'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD1->D1_CSTIPI
           CD2->CD2_BC       := SD1->D1_BASEIPI
           CD2->CD2_ALIQ     := SD1->D1_IPI
           CD2->CD2_VLTRIB   := SD1->D1_VALIPI
           CD2->CD2_QTRIB    := SD1->D1_QUANT                  
           CD2->( dbUnLock() )
        End

        If (SD1->D1_VALIMP5 <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV    := 'E'
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODFOR   := SA2->A2_COD
           CD2->CD2_LOJFOR   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'CF2'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD1->D1_CSTCOF
           CD2->CD2_BC       := SD1->D1_BASIMP5
           CD2->CD2_ALIQ     := SD1->D1_ALQIMP5
           CD2->CD2_VLTRIB   := SD1->D1_VALIMP5
           CD2->CD2_QTRIB    := SD1->D1_QUANT
           CD2->( dbUnLock() )
        End

        If (SD1->D1_VALIMP6 <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV    := 'E'
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODFOR   := SA2->A2_COD
           CD2->CD2_LOJFOR   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'PS2'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD1->D1_CSTPIS
           CD2->CD2_BC       := SD1->D1_BASIMP6
           CD2->CD2_ALIQ     := SD1->D1_ALQIMP6
           CD2->CD2_VLTRIB   := SD1->D1_VALIMP6
           CD2->CD2_QTRIB    := SD1->D1_QUANT
           CD2->( dbUnLock() )
        End

        If (SD1->D1_VALPIS <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV    := 'E'
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODFOR   := SA2->A2_COD
           CD2->CD2_LOJFOR   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'PIS'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD1->D1_CSTPIS
           CD2->CD2_BC       := SD1->D1_BASEPIS
           CD2->CD2_ALIQ     := SD1->D1_ALQPIS
           CD2->CD2_VLTRIB   := SD1->D1_VALPIS
           CD2->CD2_QTRIB    := SD1->D1_QUANT
           CD2->( dbUnLock() )
        End

        If (SD1->D1_VALCOF <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD1
           CD2->CD2_TPMOV    := 'E'    
           CD2->CD2_ITEM     := SD1->D1_ITEM
           CD2->CD2_CODPRO   := SD1->D1_COD
           CD2->CD2_DOC      := SF1->F1_DOC
           CD2->CD2_SERIE    := SF1->F1_SERIE
           CD2->CD2_CODFOR   := SA2->A2_COD
           CD2->CD2_LOJFOR   := SA2->A2_LOJA
           CD2->CD2_IMP      := 'COF'
           CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD1->D1_CSTCOF
           CD2->CD2_BC       := SD1->D1_BASECOF
           CD2->CD2_ALIQ     := SD1->D1_ALQCOF
           CD2->CD2_VLTRIB   := SD1->D1_VALCOF
           CD2->CD2_QTRIB    := SD1->D1_QUANT
           CD2->( dbUnLock() )
        End

		RecLock( 'SFT', .T. )
		SFT->FT_FILIAL  := _cFilSD1
		SFT->FT_NFISCAL := SF1->F1_DOC		
		SFT->FT_SERIE   := SF1->F1_SERIE
		SFT->FT_EMISSAO := SF1->F1_EMISSAO
		SFT->FT_ENTRADA := SF1->F1_DTDIGIT
		SFT->FT_CLIEFOR := SA2->A2_COD
		SFT->FT_LOJA    := SA2->A2_LOJA
		SFT->FT_CLIENT  := SA2->A2_COD
		SFT->FT_LOJENT  := SA2->A2_LOJA
		SFT->FT_ESPECIE := SF1->F1_ESPECIE
		SFT->FT_CFOP    := ITE->D1_CF
		SFT->FT_TIPO    := 'N'
		SFT->FT_ESTADO  := CAB->F1_EST
		SFT->FT_TIPOMOV := 'E'
		SFT->FT_ITEM    := SD1->D1_ITEM
	    SFT->FT_PRODUTO := cProduto
        SFT->FT_DESCZFR := 0
        SFT->FT_QUANT   := ITE->D1_QUANT

        SFT->FT_TOTAL   := ITE->D1_TOTAL + ITE->D1_VALIPI + ITE->D1_ICMSRET

        If SFT->FT_DESCZFR <> 0

           SFT->FT_PRCUNIT := (SFT->FT_TOTAL - SFT->FT_DESCZFR) / SFT->FT_QUANT

        Else

           SFT->FT_PRCUNIT := ITE->D1_VUNIT

        End

        SFT->FT_VALCONT := ITE->D1_TOTAL
        SFT->FT_ICMSRET := _vIcmsRet
        SFT->FT_ICMSCOM := _vIcmsRet
        SFT->FT_CREDST  := iif( _vIcmsRet <> 0, '4', ' ')
        SFT->FT_BASERET := _vIcmsBse
        SFT->FT_MARGEM  := _vIcmsMVA
        SFT->FT_ALIQSOL := _vIcmsPer
//        SFT->FT_FCICOD  := 
        SFT->FT_CSTCOF  := ITE->D1_CSTCOF
        SFT->FT_ALIQCOF := ITE->D1_ALQIMP5
        SFT->FT_BASECOF := if( ITE->D1_BASIMP5 <> 0, ITE->D1_BASIMP5, ITE->D1_TOTAL )
        SFT->FT_VALCOF  := ITE->D1_VALIMP5
        SFT->FT_CSTPIS  := ITE->D1_CSTPIS
        SFT->FT_ALIQPIS := ITE->D1_ALQIMP6
        SFT->FT_BASEPIS := if( ITE->D1_BASIMP6 <> 0, ITE->D1_BASIMP6, ITE->D1_TOTAL )
        SFT->FT_VALPIS  := ITE->D1_VALIMP6

        If SFT->FT_BASEICM = 0

           If Substr( SFT->FT_CFOP, 2, 1 ) <> '9'

              SFT->FT_ISENICM := SFT->FT_VALCONT

           Else

              SFT->FT_OUTRICM := SFT->FT_VALCONT

           End

        End

        If SFT->FT_BASEIPI = 0

           If Substr( SFT->FT_CFOP, 2, 1 ) <> '9'

              SFT->FT_ISENIPI := SFT->FT_VALCONT

           Else

              SFT->FT_OUTRIPI := SFT->FT_VALCONT

           End

        End

        SFT->FT_CLASFIS := _cCST
        SFT->FT_CTIPI   := SD1->D1_CSTIPI
        SFT->FT_POSIPI  := SB1->B1_POSIPI
        SFT->FT_ESTOQUE := 'N'
        SFT->FT_ALIQICM := _pICMS
        SFT->FT_BASEICM := _vBC
        SFT->FT_VALICM  := _vIcms
        SFT->FT_BASEIPI := _vBCIPI
        SFT->FT_ALIQIPI := _pIPI
        SFT->FT_VALIPI  := _vIPI
        SFT->FT_RECISS  := '2'
        SFT->FT_DESPIPI := iif( SFT->FT_OUTRIPI <> 0, 'N', 'S' )
        SFT->FT_MOTICMS := _cMotDes
        SFT->FT_AGREG   := 'S'
        SFT->FT_IDENTF3 := '000001'
        SFT->FT_CHVNFE  := cProt
        SFT->FT_CODNFE  := cAut
        SFT->( dbUnLock() )
        
        ITE->( dbSkip() )
		
	End

	If _pICMS = 999

	   _pICMS := 0

    End

	SF3->F3_CFO     := SFT->FT_CFOP
    SF3->F3_ALIQICM := _pICMS

    If SF3->F3_BASEICM = 0

       If Substr( SF3->F3_CFO, 2, 1 ) <> '9'

          SF3->F3_ISENICM := SF3->F3_VALCONT

       Else

          SF3->F3_OUTRICM := SF3->F3_VALCONT

       End

    End

    If SF3->F3_BASEIPI = 0

       If Substr( SF3->F3_CFO, 2, 1 ) <> '9'

          SF3->F3_ISENIPI := SF3->F3_VALCONT

       Else

          SF3->F3_OUTRIPI := SF3->F3_VALCONT

       End

    End

    SF3->( dbUnLock() )
    ITE->( dbCloseArea() )

    CAB->( dbSkip() )
    
/*    If ! (MsgYesNo( 'Continua ?' ))
       Exit
    End*/
	
End

PutMV("MV_PCNFE",lPcNfe)
fErase( cArqNtx + OrdBagExt() ) //Deletando arquivo de trabalho

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

Static Function AchaFile( cCodBar )
Local nArq := 0
LOCAL aCompl := {}
LOCAL cCaminho := Caminho
LOCAL lOk := .f.
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

aFiles := Directory(cCaminho+"\*.XML", "D")

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

