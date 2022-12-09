#INCLUDE 'TOPCONN.CH'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

Static cBDGSTQ	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_TST", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

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

User Function PreNotaXML

PRIVATE cFile    := Space( 10 )   
PRIVATE _nRecSF3 := 0
PRIVATE nCnt     := 0
PRIVATE _cTes    := ''
PRIVATE _cSdaTes := ' '  
PRIVATE _cEST    := '  '

//					   TS    TE   TPS TPE  Cfop   Natureza da Operação
PRIVATE _aTES    := {;
					 {'567','103','N','N','5101','Venda de Producao do Estabelecimento'},;
					 {'51D','117','N','N','5124','Industrializacao efetuada para outra empresa'},;
					 {'518','142','N','N','5124','Industrializacao efetuada para outra empresa'},;
					 {'51G','14B','N','N','5124','Industrializacao efetuada para outra empresa'},;
					 {'517','152','N','N','5125','Industrialização efetuada p/outra empresa qdo merc rec p/util no proc de indl não transitar p/estab adq da merc'},;
					 {'558','10D','N','N','5151','Transferencia de Producao do Estabelecimento'},;
					 {'569','10D','N','N','5151','Transferencia de Producao do Estabelecimento'},;
					 {'51A','10J','N','N','5151','Transferencia de Producao do Estabelecimento'},;					 
					 {'56A','10E','N','N','5152','Transferencia Mercadoria Adquirida ou Recebida Terceiro'},;
			         {'544','10D','N','N','5152','Transferencia Mercadoria Adquirida ou Recebida Terceiro'},;
			         {'55B','10C','N','N','5152','Transferencia Mercadoria Adquirida ou Recebida Terceiro'},;
					 {'53B','146','B','N','5208','Devolucao Mercadoria Receb. em Transf. Industrializacao'},;
					 {'510','116','N','N','5552','Transferência de bem do ativo imobilizado'},;
					 {'56C','109','N','N','5556','Devolução de compra de material de uso ou consumo'},;
					 {'563','10F','N','N','5557','Transferencia de Material de Uso ou Consumo'},;
					 {'55C','10F','N','N','5557','Transferencia de Material de Uso ou Consumo'},;
					 {'52C','14F','N','N','5602','Transf. Saldo Credor de Icms p/Outro Estabelecimento'},;
					 {'532','147','N','N','5605','Transferência de saldo devedor de ICMS de outro estabelecimento da mesma empresa'},;
					 {'556','10A','B','B','5901','Remessa para industrializacao por encomenda'},;
					 {'564','10A','B','B','5901','Remessa para industrializacao por encomenda'},;
					 {'546','10A','B','B','5901','Remessa para industrializacao por encomenda'},;
					 {'50F','10A','B','B','5901','Remessa para industrializacao por encomenda'},; 
					 {'50A','10A','B','B','5901','Remessa para industrializacao por encomenda'},;
					 {'543','136','N','N','5902','Retorno de Merc. Utiliz. Industrializacao p/Encomenda'},;
					 {'545','136','N','N','5902','Retorno de Merc. Utiliz. Industrializacao p/Encomenda'},;
					 {'565','136','N','N','5902','Retorno de Merc. Utiliz. Industrializacao p/Encomenda'},;
					 {'565','136','N','N','5902','Retorno de Merc. Utiliz. Industrializacao p/Encomenda'},;
					 {'52B','150','N','N','5903','Retorno Merc. Receb. Industrializ. Nao Aplic. Processo'},;
					 {'504','150','N','N','5903','Retorno Merc. Receb. Industrializ. Nao Aplic. Processo'},;
					 {'522','14C','N','N','5908','remessa de bem por conta de contrato de comodato'},;
					 {'560','118','B','B','5920','Remessa de vasilhame ou sacaria'},;
					 {'571','101','N','N','5921','Devolucao de vasilhame ou sacaria'},;
					 {'535','151','N','N','5925','Retorno de Mercadoria Recebida p/indl por conta e ordem do adq da merc, qdo aquela não transitar p/estab do adq'},;
					 {'530','107','N','N','5949','Outras Saídas não especificadas'},;
					 {'507','153','N','N','5102','Venda Merc Adq por terceiros'},;
					 {'550','123','N','N','5102','Venda Merc Adq por terceiros'},;
					 {'50C','10G','N','N','5401','Venda producao com subst tributaria'};
                    }
/* alterado em 04/07 550-153 para 550-123 */


PRIVATE CPERG    :="NOTAXML"
PRIVATE aTipo    := { 'N','B','D' }
PRIVATE Caminho  := 'C:\Temp\Xml Contabilidade\'
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
PRIVATE _cFilSF6 := xFilial( 'SF6' )
PRIVATE _lTransf := .F.
PRIVATE _pICMS
PRIVATE cTipo    := ' '

SB1->( dbSetOrder( 1 ) )
SA1->( dbSetOrder( 3 ) )
SA2->( dbSetOrder( 3 ) )

PutMV("MV_PCNFE",.F.)

nTipo   := 1                       
aFiles  := Directory(Caminho+"\*.XML", "D")	
_nFiles := Len( aFiles )
MV_PAR01 := 1
_nTes := Len( _aTes )
    
If _nFiles <> 0
	//BEGIN TRANSACTION
		Processa( { || CargaXML() }, 'Aguarde...','Importando arquivos xmls...' )
	//END TRANSACTION
Else
    MsgAlert("Nenhum arquivo XML encontrado na pasta "+Caminho)
EndIf

Return( NIL )

/*/{Protheus.doc} CargaXML
//TODO Busca dados da NF do xml.
@author Bruno
@since 22/10/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CargaXML()
Local nCnt     := 0
Local n        := 0
Local nX       := 0
Local lPula    := .F.
Private nAux   := 0

ProcRegua( _nFiles )

For n := 1 To _nFiles
   Begin Transaction
      lPula    := .F.
      cFile := Caminho + aFiles[ n ][ 1 ]
      PRIVATE nHdl := fOpen( cFile, 0 )	
      
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

   /*	nTamFile := fSeek(nHdl,0,2)
      fSeek(nHdl,0,0)
      cBuffer  := Space(nTamFile)                // Variavel para criacao da linha do registro para leitura
      nBtLidos := fRead(nHdl,@cBuffer,nTamFile)  // Leitura  do arquivo XML
      fClose(nHdl)
      
      oNfe := XmlParser(cBuffer,"_",@cAviso,@cErro)*/

   //	oNfe := XmlParserFile( cFile, "_", @cErro, @cAviso )

      cAviso := ""
      cErro  := ""
      If Substr( cBuffer, 1, 38 ) <> '<?xml version="1.0" encoding="UTF-8"?>'

         oNFe := U_XmlPar( cBuffer, '_', cErro, cAviso  )

      Else

         oNfe := XmlParser( Substr( cBuffer, 39 ) ,"_",@cAviso,@cErro)

      End
      
      If Type( 'oNFe' ) = 'U'

         oNFe := NIL
         //Loop foi removido para permitir o controle de transação por arquivo
         //Loop

         lPula := .T.	
      Else
         lPula := .F.      
      End

      PRIVATE oNF := NIL
      
      If Type("oNFe:_NfeProc:_InfNFe versao") <> "U"

         oNF := iif( Type( 'oNFe:_NFeProc:_NFe' ) <> 'U', oNFe:_NFeProc:_NFe, ' ')
         cProt := iif( type( 'oNFe:_NFeProc:_protNFe:_infProt:_chNFe:TEXT' ) <> 'U', oNFe:_NFeProc:_protNFe:_infProt:_chNFe:TEXT, ' ')
         cAut  := iif( type( 'oNFe:_NFeProc:_protNFe:_infProt:_nProt:TEXT' ) <> 'U', oNFe:_NFeProc:_protNFe:_infProt:_nProt:TEXT, ' ')
      
      ElseIf Type("oNFe:_NfeProc") <> "U"

         oNF := iif( Type( 'oNFe:_NFeProc:_NFe' ) <> 'U', oNFe:_NFeProc:_NFe, ' ')
         cProt := iif( type( 'oNFe:_NFeProc:_protNFe:_infProt:_chNFe:TEXT' ) <> 'U', oNFe:_NFeProc:_protNFe:_infProt:_chNFe:TEXT, ' ')
         cAut  := iif( type( 'oNFe:_NFeProc:_protNFe:_infProt:_nProt:TEXT' ) <> 'U', oNFe:_NFeProc:_protNFe:_infProt:_nProt:TEXT, ' ')

      Else                    

         oNF   := iif( Type( 'oNFe:_NFe' ) <> 'U', oNFe:_NFe, ' ' )
         cProt := iif( Type( 'oNFe:_protNFe:_infProt:_chNFe:TEXT' ) <> 'U', oNFe:_protNFe:_infProt:_chNFe:TEXT, ' ')
         cAut  := iif( Type( 'oNFe:_protNFe:_infProt:_nProt:TEXT' ) <> 'U', oNFe:_protNFe:_infProt:_nProt:TEXT, ' ' )

      End
      
      If Type( 'oNF' ) = 'C' .Or.;
         ( Type( 'oNFe:_NFe' ) = 'U' .And. Empty( cProt ) .And. Empty( cAut ) )
         
         FreeObj( oNFe )

         __CopyFile( cFile, Caminho + 'Erros\' + aFiles[ n ][ 1 ] )
         fErase( cFile )
         IncProc("Importando arquivo ("+AllTrim(AllToChar(n))+" de "+AllTrim(AllToChar(_nFiles))+") "+StrToKarr(cFile, "\")[Len(StrToKarr(cFile, "\"))])

         //Loop removido para permitir a implementação de begin transaction
         //Loop
         lPula := .T.
      Else
         lPula := .F.
      
      End

      If !lPula
         PRIVATE oEmitente := oNF:_InfNfe:_Emit
         PRIVATE oIdent    := oNF:_InfNfe:_IDE
         PRIVATE oDestino  := oNF:_InfNfe:_Dest
         PRIVATE oTotal    := oNF:_InfNfe:_Total
         PRIVATE oTransp   := oNF:_InfNfe:_Transp
         PRIVATE oDet      := oNF:_InfNfe:_Det 
         PRIVATE _lRaz     := .F.
         PRIVATE _aLote    := {}
         PRIVATE oICM	  := NIL

         If Type("oNF:_InfNfe:_ICMS")<> "U"

            oICM := oNF:_InfNfe:_ICMS

         End

         PRIVATE oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",NIL,oNF:_InfNfe:_Cobr)
         PRIVATE cEdit1	   := Space( 15 )
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

         cCgc := AllTrim(IIf(Type("oDestino:_CNPJ") <> "U", oDestino:_CNPJ:TEXT, IIf(Type("oDestino:_CPF") <> "U", oDestino:_CPF:TEXT, ' ')))		//oDestino:_CPF:TEXT
         // CNPJ ou CPF

         _lEnt := .T.

         If     cCgc = '48254858000109' 
            _cFilSF1 := '0101'
         ElseIf cCgc = '48254858000290'
            _cFilSF1 :='0102' 
         ElseIf cCgc = '48254858000451'
            _cFilSF1 :='0103' 
         ElseIf cCgc = '03061254000108'
            _cFilSF1 :='0201'
         ElseIf cCgc = '03061254000299'
            _cFilSF1 :='0202'
         ElseIf cCgc = '67313247000139'
            _cFilSF1 :='0301' 
         ElseIf cCgc = '04051564000104'
               _cFilSF1 :='0401'
         ElseIf cCgc = '09158959000124'
               _cFilSF1 :='0501'
         ElseIf cCgc = '04657999000105'
               _cFilSF1 :='0601'
         ElseIf cCgc = '11175943000171'                    
               _cFilSF1 :='0701'
         ElseIf cCgc = '03061254000370'
               _cFilSF1 :='0215'
         ElseIf cCgc = '36360406000122'
               _cFilSF1 :='1601'
         Else
               _cFilSF1 := '9999'
               _lEnt    := .F.
         End

         If _cFilSF1 <> U_SM0DePar(cCgc)
            Conout("Diferença no de para do CNPJ "+cCgc+" filial "+_cFilSF1+" na funcao SM0DePar("+U_SM0DePar(cCgc)+")")
         EndIf
         
         _cFilSD1 := _cFilSF1

         If Type('OIdent:_dhEmi') <> "U"
         
            cData := Alltrim( OIdent:_dhEmi:TEXT )	
            dData := CtoD( Substr( cData, 9, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )

         Else

            cData := Alltrim( OIdent:_dEmi:TEXT )
            dData := CtoD( Right( cData, 2 ) + '/' + Substr( cData, 6, 2 ) + '/' + Left( cData, 4 ) )

         End

         _qTES := 'SELECT TOP (1) NOTA.ID_CFO, CAST( CFO.TES AS CHAR(3)) TES '
         //_qTes += 'FROM '+cBDGSTQ+'.dbo.NOTA NOTA, SD2010 SD2, '+cBDGSTQ+'.dbo.CFO '
         _qTes += 'FROM '+cBDGSTQ+'.dbo.NOTA NOTA, '+cBDGSTQ+'.dbo.CFO '
         _qTes += 'WHERE NRO_NF = CAST(' + Alltrim( OIdent:_nNF:TEXT ) + " AS INT) AND SERIE = '" +  Padr(OIdent:_serie:TEXT,3)  + "' "
         //_qTes += "AND CONVERT( CHAR(8), EMISSAO, 112 ) = '" + DtoS( dData ) + "' AND SD2.D_E_L_E_T_ = '' AND NOTA.ID_CFO = CFO.ID_CFO"
         _qTes += "AND CONVERT( CHAR(8), EMISSAO, 112 ) = '" + DtoS( dData ) + "' AND NOTA.ID_CFO = CFO.ID_CFO"

         dbUseArea( .T. ,"TOPCONN",TcGenQry(,,_qTes),"TES",.T.,.T.)    
         
         If TES->(Eof())

            TES->( dbCloseArea() )

            //MsgAlert("Nf não localizada no Gestoq, por favor verifique.")
            If Aviso("Erro","NF "+Alltrim(OIdent:_nNF:TEXT)+" não localizada no Gestoq, por favor verifique.",{"Continuar","Abandonar"}) = 1
                  FreeObj( oNFe )    
                  FreeObj( oNF )
                  IncProc("Importando arquivo ("+AllTrim(AllToChar(n))+" de "+AllTrim(AllToChar(_nFiles))+") "+StrToKarr(cFile, "\")[Len(StrToKarr(cFile, "\"))])

                  //Loop removido para implementar controle de transação
                  //Loop
                  lPula := .T.
            Else
               lPula := .F.
            EndIf
            //Return
         EndIf
         
         //Se não tiver marcado para ser desconsiderado
         If !lPula
            _cTes    := TES->TES
            _cSdaTES := TES->TES
            _lEnt := .F.

            For nCnt := 1 To _nTes

               If _cTes = _aTes[ nCnt ][ 1 ]
                  
                  _cTes := _aTes[ nCnt ][ 2 ]
                  cTipo := _aTes[ nCnt ][ 3 ]
                  _lEnt := .T.
                  Exit
                  
               End
               
            Next
            
            TES->( dbCloseArea() )

            If ( At( cCgc, '48254858000290,48254858000109,03061254000108,04051564000104,03061254000299' ) = 0 )

               If ( _cSdaTES == '571' )

                  cTipo := 'B'
               
               ElseIf _cSdaTES $ '56C,55D,513,576,56B,605,55E,54D,509'
               
                  cTipo  := 'D'
               
               End

            End

            If cTipo <> 'N'                             
               
               IncFornec()
               
            Else
            
               IncClient()  
            
            End
            
            cCgc := AllTrim(IIf(Type("oEmitente:_CPF")=="U",oEmitente:_CNPJ:TEXT,oEmitente:_CPF:TEXT))
            _lSda    := .T.

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
            ElseIf cCgc = '03061254000370'
                  _cFilSF2 :='0215'
            ElseIf cCgc == '36360406000122'
               _cFilSF2 :='1601'
            Else
                  _cFilSF2 := '9999'
                  _lSda    := .F.
            End

            If _cFilSF2 <> U_SM0DePar(cCgc)
               Conout("Diferença no de para do CNPJ "+cCgc+" filial "+_cFilSF2+" na funcao SM0DePar("+U_SM0DePar(cCgc)+")")
            EndIf

            _cFilSD2 := _cFilSF2

            // -- Nota Fiscal já existe na base ?

            If SF2->( dbSeek( _cFilSF2 + Right ("000000000" + Alltrim(OIdent:_nNF:TEXT),9) + Padr(OIdent:_serie:TEXT,3)+;
                           if( cTipo <> 'N', SA2->A2_COD + SA2->A2_LOJA, SA1->A1_COD + SA1->A1_LOJA ) + 'S' + cTipo ) ) .And.;
               ( _lSda )

               _lSda := .F.

               /*If cTipo <> 'B'

                  MsgInfo('Nota Fiscal no. '+;
                           Right("000000000" + Alltrim(OIdent:_nNF:TEXT),9)+;
                           '/'               +;
                           OIdent:_serie:TEXT+;
                           Chr( 13 )         +;
                           'Cliente '        +;
                           SA1->A1_COD + '/'      +;
                           SA1->A1_LOJA + ' - '   +;
                           rTrim( SA1->A1_NREDUZ )+;
                           Chr( 13 ) +;
                           'Encontra-se lançada no sistema. Importação interrompida';
                        )

               Else

               MsgInfo('Nota Fiscal no. ' + ;
                        Right('000000000' + Alltrim(OIdent:_nNF:TEXT),9) +;
                        '/' +;
                        OIdent:_serie:TEXT +;
                        Chr( 13 )+;
                        'Fornecedor '+;
                        SA2->A2_COD+"/"+;
                        SA2->A2_LOJA+' - '+;
                        rTrim( SA2->A2_NREDUZ ) +;
                        Chr( 13 )+;
                        'Encontra-se lançada no sistema. Importação interrompida';
                     )

               End*/

               PutMV( "MV_PCNFE", lPcNfe )
               _lSda := .F.
            
            End

            If _lSda
            
               GrvSda()
               
            End

            If ( _lEnt ) .And.;
               ( _cFilSF1 <> '9999' )
               
               _nRecSF3 := SF3->( RecNo() )
               
               If ( cTipo <> 'N' )

                  IncClient()
         
               Else

                  IncFornec()

               End
               
               
               SA2->( dbSeek( _cFilSA2 + cCgc , .F. ) )

               if ! ( SF1->( dbSeek(  _cFilSF1 +;
                                       SF2->F2_DOC +;
                                       SF2->F2_SERIE +; 
                                       If( cTipo <> 'N', SA1->A1_COD+SA1->A1_LOJA,SA2->A2_COD+SA2->A2_LOJA ) +;
                                       cTipo,;
                                       .F.;
                              );
                           );
                     )

                  GrvCabec()   

               Else

                  _lEnt := .F.

               End

               SF3->( dbGoTo( _nRecSF3 )  )
               
            End

            _nLen  := Len( oDet )
            _cItem := '00'

            For nX := 1 To _nLen
               nAux := nX
               
               If Type("oDet[nAux]:_Imposto:_ICMS:_ICMS00")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS00
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS10")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS10
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS20")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS20
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS30")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS30
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS40")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS40
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS51")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS51
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS60")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS60
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS70")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS70
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMS90")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS90
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN101")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN101
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN102")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN102
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN201")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN201
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN202")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN202
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN500")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN500
               ElseIf Type("oDet[nAux]:_Imposto:_ICMS:_ICMSSN900")<> "U"
                  oICM:=oDet[nX]:_Imposto:_ICMS:_ICMSSN900
               Else
                  //MsgInfo( cFile )
               End

               _cCST    := iif( type("oICM:_ORIG"  ) <> 'U', oICM:_ORIG:TEXT      , ' ')
               _cCST    += iif( type("oICM:_CST"  )  <> 'U', oICM:_CST:TEXT       , '  ')
               _pICMS   := iif( type("oICM:_PICMS")  <> 'U', val(oICM:_PICMS:TEXT), 0 ) 
               _vBC     := iif( type("oICM:_VBC"  )  <> 'U', val(oICM:_VBC:TEXT)  , 0 ) 
               _vIcms   := iif( type("oICM:_VICMS")  <> 'U', val(oICM:_VICMS:TEXT), 0 ) 
               _cMotDes := iif( type("oICM:_MOTDESICMS"  )  <> 'U', oICM:_MOTDESICMS:TEXT, ' ')
               
               _vIcmsRet := iif( type("oICM:_VICMSST") <> 'U', val(oICM:_VICMSST:TEXT), 0 ) 
               _vIcmsBse := iif( type("oICM:_VBCST")   <> 'U', val(oICM:_VBCST:TEXT)  , 0 ) 
               _vIcmsMVA := iif( type("oICM:_PMVAST")  <> 'U', val(oICM:_PMVAST:TEXT) , 0 ) 
               _vIcmsPer := iif( type("oICM:_PICMSST") <> 'U', val(oICM:_PICMSST:TEXT), 0 )
               
               If _vIcms <> 0 .And. _vBC = 0
               
                  _vIcms := 0
               
               End

               If Type("oDet[nAux]:_Imposto:_IPI:_IPITrib:_vIPI") <> "U"
         
                  _vBCIPI := Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_vBC:TEXT )
                  _pIPI   := Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_pIPI:TEXT )
                  _vIPI   := Val( oDet[nX]:_Imposto:_IPI:_IPITrib:_vIPI:TEXT )

               Else

                  _vBCIPI := 0
                  _pIPI   := 0
                  _vIPI   := 0

               End

               cProduto   := Upper(PadR( AllTrim( oDet[nX]:_Prod:_cProd:TEXT ), 30 ))

               If ! ( SB1->( dbSeek( _cFilSB1 + cProduto, .F. ) )  )

                  RecLock( 'SB1', .T. )

                  _cNCM   := oDet[nX]:_Prod:_NCM:TEXT
                  _cDesc  := oDet[nX]:_Prod:_XPROD:TEXT
                  _cUnid  := oDet[nX]:_Prod:_UTRIB:TEXT
            
                  SB1->B1_COD  := cProduto
                  SB1->B1_DESC := _cDesc
                  SB1->B1_TIPO := 'PA'
                  SB1->B1_UM   := _cUnid
                  SB1->B1_LOCPAD := '01'
                  SB1->B1_POSIPI := _cNCM
                  SB1->B1_ORIGEM := Substr( _cCST, 1, 1 )
                  SB1->B1_GARANT := '2'
                  SB1->( MsUnLock() )

               End

               If _lSda
               
                  GrvItSda(nX)
               
               End
               
               If ( _lEnt )  .And.;
                  ( _cFilSD1 <> '9999' )
               
                  GrvItEnt(nX)
               
               End
               
            Next nX

            If _lSda

               SF3->F3_CFO     := oDet[ _nLen ]:_Prod:_CFOP:TEXT
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

               SF3->( MsUnLock() )

               If (SF2->F2_ICMSRET <> 0)

                  RecLock( 'SF6', .T. )
                  SF6->F6_FILIAL   := SF2->F2_FILIAL
                  SF6->F6_NUMERO   := SF2->F2_DOC
                  SF6->F6_DOC      := SF2->F2_DOC
                  SF6->F6_SERIE    := SF2->F2_SERIE
                  SF6->F6_EST      := SF2->F2_EST
                  SF6->F6_CLIFOR   := SF2->F2_CLIENTE
                  SF6->F6_LOJA     := SF2->F2_LOJA
                  SF6->F6_TIPODOC  := SF2->F2_TIPO

                  If SF6->F6_EST  = 'AL'
                     _cConv := '244228299'
                  elseif SF6->F6_EST  = 'AM' 
                     _cConv := '049015303'
                  elseif SF6->F6_EST  = 'BA' 
                     _cConv := '123103712'
                  elseif SF6->F6_EST  = 'CE' 
                     _cConv := '065583663'
                  elseif SF6->F6_EST  = 'DF' 
                     _cConv := '0771271000140'
                  elseif SF6->F6_EST  = 'ES' 
                     _cConv := '000025143'
                  elseif SF6->F6_EST  = 'GO' 
                     _cConv := '106317644'
                  elseif SF6->F6_EST  = 'MG' 
                     _cConv := '0010891440178'
                  elseif SF6->F6_EST  = 'PA' 
                     _cConv := '154903370'
                  elseif SF6->F6_EST  = 'PB' 
                     _cConv := '169009556'
                  elseif SF6->F6_EST  = 'PI' 
                     _cConv := '195596048'
                  elseif SF6->F6_EST  = 'PR' 
                     _cConv := '0990465622'
                  elseif SF6->F6_EST  = 'RJ' 
                     _cConv := '92007847'
                  elseif SF6->F6_EST  = 'RS' 
                     _cConv := '0963392565'
                  elseif SF6->F6_EST  = 'SC' 
                     _cConv := '256145962'
                  else 
                     _cConv := ' '
                  End

                  SF6->F6_INSC     := _cConv
                  SF6->F6_OPERNF   := '2'
                  SF6->F6_TIPOIMP  := '3'
                  SF6->F6_PROCESS  := '2'
                  SF6->F6_DTARREC  := SF2->F2_EMISSAO
                  SF6->F6_DTVENC   := (SF2->F2_EMISSAO + 7)
                  SF6->F6_MESREF   := Month( SF2->F2_EMISSAO )
                  SF6->F6_ANOREF   := Year( SF2->F2_EMISSAO )
                  SF6->F6_CODREC   := '100099'
                  SF6->F6_VALOR    := SF2->F2_ICMSRET
                  SF6->( MsUnLock() )

                  RecLock( 'CDC', .T. )
                  CDC->CDC_FILIAL := SF2->F2_FILIAL
                  CDC->CDC_TPMOV  := 'S'
                  CDC->CDC_DOC    := SF2->F2_DOC
                  CDC->CDC_SERIE  := SF2->F2_SERIE
                  CDC->CDC_CLIFOR := SF2->F2_CLIENTE
                  CDC->CDC_LOJA   := SF2->F2_LOJA
                  CDC->CDC_GUIA   := SF2->F2_DOC
                  CDC->CDC_UF     := SF2->F2_EST
                  CDC->CDC_IFCOMP := '000001'
                  CDC->( MsUnLock() )
                  
               End
            
            End
         Endif
      EndIf

      FreeObj( oNFe )    
      FreeObj( oNF )
      __CopyFile( cFile, Caminho + 'Importados\' + aFiles[ n ][ 1 ] )
      fErase( cFile )
      IncProc("Importando arquivo ("+AllTrim(AllToChar(n))+" de "+AllTrim(AllToChar(_nFiles))+") "+StrToKarr(cFile, "\")[Len(StrToKarr(cFile, "\"))])

   END Transaction
   
   //Se for um numero muito alto, efetua uma pausa de 2 segundos para equilibrar a performance do BD.
   If _nFiles > 100
      sleep(2000)
   EndIf
Next n

PutMV("MV_PCNFE",lPcNfe)

Return

/*
  []----------------------------------------------------------------------------------------------------------------------------[]
  
                                          Inclusão do cabeçalho nota fiscal de saída
  
  []----------------------------------------------------------------------------------------------------------------------------[]
*/

Static Function GrvSda()

    RecLock( 'SF2', .T. )

    SF2->F2_FILIAL  := _cFilSF2
    SF2->F2_DOC     := Right( "000000000" + Alltrim( OIdent:_nNF:TEXT ), 9 )
    SF2->F2_SERIE   := OIdent:_serie:TEXT
    SF2->F2_PREFIXO := OIdent:_serie:TEXT
    SF2->F2_CLIENTE := if( cTipo <> 'B', SA1->A1_COD, SA2->A2_COD )
    SF2->F2_CLIENT  := if( cTipo <> 'B', SA1->A1_COD, SA2->A2_COD )
    SF2->F2_LOJA    := if( cTipo <> 'B', SA1->A1_LOJA, SA2->A2_LOJA )
    SF2->F2_LOJENT  := if( cTipo <> 'B', SA1->A1_LOJA, SA2->A2_LOJA )
    SF2->F2_FORMUL  := 'S'
    SF2->F2_COND    := ''
    SF2->F2_EMISSAO := dData
    SF2->F2_EST     := if( cTipo <> 'B', SA1->A1_EST , SA2->A2_EST  )
    SF2->F2_TIPOCLI := if( cTipo <> 'B', SA1->A1_TIPO, SA2->A2_TIPO )
    SF2->F2_VALBRUT := Val( oTotal:_ICMSTOT:_VNF:TEXT )
    SF2->F2_VALICM  := Val( oTotal:_ICMSTOT:_VICMS:TEXT )
    SF2->F2_BASEICM := Val( oTotal:_ICMSTOT:_VBC:TEXT )
    SF2->F2_VALIPI  := Val( oTotal:_ICMSTOT:_VIPI:TEXT )
    SF2->F2_BASEIPI := iif( SF2->F2_VALIPI <> 0, Val( oTotal:_ICMSTOT:_VPROD:TEXT ), 0 )
    SF2->F2_VALMERC := Val( oTotal:_ICMSTOT:_VPROD:TEXT )
    SF2->F2_VALFAT  := Val( oTotal:_ICMSTOT:_VNF:TEXT )
    SF2->F2_ESPECIE := 'SPED'
    SF2->F2_CHVNFE  := cProt
    SF2->F2_CODNFE  := cAut
    SF2->F2_DAUTNFE := dData 
    SF2->F2_DESCZFR := Val( oTotal:_ICMSTOT:_VDESC:TEXT )
    SF2->F2_TIPO    := cTipo
    SF2->F2_ICMSRET := Val( oTotal:_ICMSTOT:_VST:TEXT )
    SF2->F2_BRICMS  := Val( oTotal:_ICMSTOT:_VBCST:TEXT )
    SF2->F2_DTLANC  := dData
    
    SF2->F2_VALIMP5 := Val( oTotal:_ICMSTOT:_VCOFINS:TEXT )
    SF2->F2_BASIMP5 := iif( SF2->F2_VALIMP5 <> 0, SF2->F2_VALMERC, 0)
    
    SF2->F2_VALIMP6 := Val( oTotal:_ICMSTOT:_VPIS:TEXT )
    SF2->F2_BASIMP6 := iif( SF2->F2_VALIMP6 <> 0, SF2->F2_VALMERC, 0)

    SF2->F2_VALCOFI := iif( type( "oTotal:_RETTRIB:_VRETCOFINS:TEXT" ) <> 'U', val( oTotal:_RETTRIB:_VRETCOFINS:TEXT),0)
    SF2->F2_BASCOFI := iif( SF2->F2_VALCOFI <> 0, SF2->F2_VALMERC, 0 )
    SF2->F2_VALPIS  := iif( type( "oTotal:_RETTRIB:_VRETPIS:TEXT" ) <> 'U', val( oTotal:_RETTRIB:_VRETPIS:TEXT),0)
    SF2->F2_BASPIS  := iif( SF2->F2_VALPIS <> 0, SF2->F2_VALMERC, 0 )
    
    SF2->F2_RECISS  := '2'
    SF2->F2_RECFAUT := '1'
    SF2->F2_MOEDA   := 1
    SF2->F2_FIMP    := 'S'

    SF2->( MsUnLock() )

    RecLock( 'SF3', .T. )
	SF3->F3_FILIAL  := _cFilSD2
	SF3->F3_NFISCAL := SF2->F2_DOC		
	SF3->F3_SERIE   := SF2->F2_SERIE
	SF3->F3_EMISSAO := SF2->F2_EMISSAO
	SF3->F3_ENTRADA := SF2->F2_EMISSAO
	SF3->F3_CLIEFOR := SF2->F2_CLIENTE
	SF3->F3_LOJA    := SF2->F2_LOJA
	SF3->F3_ESPECIE := SF2->F2_ESPECIE
	SF3->F3_CLIENT  := SF2->F2_CLIENTE
	SF3->F3_LOJENT  := SF2->F2_LOJA
	SF3->F3_TIPO    := SF2->F2_TIPO
	SF3->F3_ESTADO  := SF2->F2_EST
	
    SF3->F3_VALCONT := Val( oTotal:_ICMSTOT:_VNF:TEXT )
    SF3->F3_BASERET := val( oTotal:_ICMSTOT:_vBCST:TEXT ) 
    SF3->F3_ICMSRET := val( oTotal:_ICMSTOT:_VST:TEXT )
    SF3->F3_ICMSCOM := val( oTotal:_ICMSTOT:_VST:TEXT )
    SF3->F3_DESCZFR := Val( oTotal:_ICMSTOT:_VDESC:TEXT )

    SF3->F3_BASEICM := iif( Val( oTotal:_ICMSTOT:_VICMS:TEXT ) <> 0  ,val( oTotal:_ICMSTOT:_VBC:TEXT ), 0 )

    SF3->F3_VALICM  := Val( oTotal:_ICMSTOT:_VICMS:TEXT )
    SF3->F3_BASEIPI := iif( SF2->F2_VALIPI <> 0, Val( oTotal:_ICMSTOT:_VPROD:TEXT ), 0 )
    SF3->F3_VALIPI  := Val( oTotal:_ICMSTOT:_VIPI:TEXT )
    SF3->F3_RECISS  := '2'
    SF3->F3_IDENTFT := '000001'
    SF3->F3_CHVNFE  := cProt
    SF3->F3_CODNFE  := cAut
    SF3->F3_CODRSEF := '100'

Return( NIL )

/*
  []----------------------------------------------------------------------------------------------------------------------------[]
  
                                        Inclusão dos itens nota fiscal de saída
  
  []----------------------------------------------------------------------------------------------------------------------------[]
*/


Static Function GrvItSda(nX)
Private nAux := nX

		RecLock( 'SD2', .T. )
		SD2->D2_FILIAL  := _cFilSD2
		SD2->D2_DOC     := SF2->F2_DOC		
		SD2->D2_SERIE   := SF2->F2_SERIE
		SD2->D2_EMISSAO := SF2->F2_EMISSAO
		SD2->D2_CLIENTE := SF2->F2_CLIENTE
		SD2->D2_LOJA    := SF2->F2_LOJA
		SD2->D2_ESPECIE := SF2->F2_ESPECIE
		SD2->D2_NUMSEQ  := ProxNum()
		SD2->D2_TES     := _cSdaTES
		SD2->D2_CF      := oDet[nX]:_Prod:_CFOP:TEXT
		SD2->D2_TIPO    := SF2->F2_TIPO
		SD2->D2_TP      := 'PA'
		SD2->D2_LOCAL   := '01'
		SD2->D2_EST     :=  SF2->F2_EST
		_cItem := Soma1( _cItem )
		SD2->D2_ITEM    := _cItem
	    SD2->D2_COD     := cProduto
        SD2->D2_DESCR   := oDet[nx]:_Prod:_XPROD:TEXT
        SD2->D2_UM      := oDet[nX]:_Prod:_UTRIB:TEXT
        SD2->D2_QUANT   := Val(oDet[nX]:_Prod:_QTRIB:TEXT)
        SD2->D2_PRUNIT  := Val(oDet[nX]:_Prod:_VUNCOM:TEXT)
        SD2->D2_PRCVEN  := Val(oDet[nX]:_Prod:_VUNCOM:TEXT)
        SD2->D2_TOTAL   := Val(oDet[nX]:_Prod:_VPROD:TEXT)
        SD2->D2_VALBRUT := SD2->D2_TOTAL + SD2->D2_VALIPI + SD2->D2_ICMSRET
        SD2->D2_ICMSRET := _vIcmsRet
        SD2->D2_BRICMS  := _vIcmsBse
        SD2->D2_MARGEM  := _vIcmsMVA
        SD2->D2_ALIQSOL := _vIcmsPer
        SD2->D2_DESCZFR := If( Type( "oDet[nAux]:_Prod:_VDESC")<>"U"                         , val(oDet[nX]:_Prod:_VDESC:TEXT), 0 )
        SD2->D2_FCICOD  := If( Type( "oDet[nAux]:_Prod:_NFCI")<>"U"                          , oDet[nX]:_Prod:_NFCI:TEXT, ' ' )
        SD2->D2_CSTCOF  := if( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSNT:_CST")<>"U"      , oDet[nX]:_IMPOSTO:_COFINS:_COFINSNT:_CST:TEXT           , Space( 2 ) )
        SD2->D2_ALQIMP5 := if( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT ), 0 )
        SD2->D2_BASIMP5 := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC")<>"U"    , val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT  )   , 0 )
        SD2->D2_VALIMP5 := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT) , 0 ) 
        SD2->D2_CSTPIS  := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISNT:_CST")<>"U"            , oDet[nX]:_IMPOSTO:_PIS:_PISNT:_CST:TEXT                , Space( 2 ) )

        If ( SD2->D2_CSTCOF = '  ' )

           SD2->D2_CSTCOF := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSOutr:_CST")<>"U", oDet[nX]:_IMPOSTO:_COFINS:_COFINSOutr:_CST:TEXT, Space( 2 ) )
        
        End

        If ( SD2->D2_CSTCOF = '  ' )

           SD2->D2_CSTCOF := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSAliq:_CST")<>"U", oDet[nX]:_IMPOSTO:_COFINS:_COFINSAliq:_CST:TEXT, Space( 2 ) )
        
        End
        
        If ( SD2->D2_CSTPIS = '  ' )
                         

           SD2->D2_CSTPIS := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISOutr:_CST")<>"U", oDet[nX]:_IMPOSTO:_PIS:_PISOutr:_CST:TEXT, Space( 2 ) )        
        
        End

        If ( SD2->D2_CSTPIS = '  ' )

           SD2->D2_CSTPIS := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISAliq:_CST")<>"U", oDet[nX]:_IMPOSTO:_PIS:_PISAliq:_CST:TEXT, Space( 2 ) )        
        
        End
       
        SD2->D2_ALQIMP6 := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_PPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT)       , 0 )
        SD2->D2_BASIMP6 := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VBC")<>"U"          , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT)        , 0 )
        SD2->D2_VALIMP6 := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT)       , 0 )

        if (SF2->F2_VALCOFI <> 0)
           SD2->D2_BASECOF := SD2->D2_TOTAL
           SD2->D2_VALCOF  := round( SD2->D2_TOTAL * 0.005, 2 )
           SD2->D2_ALQCOF  := 0.5
        End

        if (SF2->F2_VALCOFI <> 0)
           SD2->D2_BASEPIS := SD2->D2_TOTAL
           SD2->D2_VALPIS  := round( SD2->D2_TOTAL * 0.001, 2 )
           SD2->D2_ALQPIS  := 0.1
        End

        If _pICMS > 99
           _pICMS := 0
        End


        SD2->D2_CLASFIS := _cCST
        SD2->D2_CSTIPI  := If( Type( "oDet[nAux]:_IMPOSTO:_IPI:_IPINT:_CST")<>"U", oDet[nX]:_IMPOSTO:_IPI:_IPINT:_CST:TEXT, Space( 2 ) )
        
        If (SD2->D2_CSTIPI = '  ')

           SD2->D2_CSTIPI := If( Type( "oDet[nAux]:_IMPOSTO:_IPI:_IPITrib:_CST")<>"U", oDet[nX]:_IMPOSTO:_IPI:_IPITrib:_CST:TEXT, Space( 2 ) )

        End

        SD2->D2_PICM    := _pICMS
        SD2->D2_BASEICM := _vBC
        SD2->D2_VALICM  := _vIcms
        SD2->D2_BASEIPI := _vBCIPI
        SD2->D2_IPI     := _pIPI
        SD2->D2_VALIPI  := _vIPI
        SD2->( MsUnLock() )

        If (SD2->D2_ICMSRET <> 0)

           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV   := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'SOL'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := Substr( SD2->D2_CLASFIS, 2, 2)
           CD2->CD2_MVA      := SD2->D2_MARGEM
           CD2->CD2_BC       := SD2->D2_BRICMS
           CD2->CD2_ALIQ     := SD2->D2_ALIQSOL
           CD2->CD2_VLTRIB   := SD2->D2_ICMSRET
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->CD2_DESCZF   := SD2->D2_DESCZFR
           CD2->( MsUnLock() )
        End

        If (SD2->D2_DESCZFR <> 0)

           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV    := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'ZFM'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := Substr( SD2->D2_CLASFIS, 2, 2)
           CD2->CD2_MVA      := 0
           CD2->CD2_BC       := 0
           CD2->CD2_ALIQ     := 0
           CD2->CD2_VLTRIB   := 0
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->CD2_DESCZF   := SD2->D2_DESCZFR
           CD2->( MsUnLock() )
        End
    
        If (SD2->D2_VALICM <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV    := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'ICM'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := Substr( SD2->D2_CLASFIS, 2, 2)
           CD2->CD2_BC       := SD2->D2_BASEICM
           CD2->CD2_ALIQ     := SD2->D2_PICM
           CD2->CD2_VLTRIB   := SD2->D2_VALICM
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->( MsUnLock() )
        End

        If (SD2->D2_VALIPI <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV    := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'IPI'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD2->D2_CSTIPI
           CD2->CD2_BC       := SD2->D2_BASEIPI
           CD2->CD2_ALIQ     := SD2->D2_IPI
           CD2->CD2_VLTRIB   := SD2->D2_VALIPI
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->( MsUnLock() )
        End

        If (SD2->D2_VALIMP5 <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV    := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'CF2'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD2->D2_CSTCOF
           CD2->CD2_BC       := SD2->D2_BASIMP5
           CD2->CD2_ALIQ     := SD2->D2_ALQIMP5
           CD2->CD2_VLTRIB   := SD2->D2_VALIMP5
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->( MsUnLock() )
        End

        If (SD2->D2_VALIMP6 <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV    := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'PS2'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD2->D2_CSTPIS
           CD2->CD2_BC       := SD2->D2_BASIMP6
           CD2->CD2_ALIQ     := SD2->D2_ALQIMP6
           CD2->CD2_VLTRIB   := SD2->D2_VALIMP6
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->( MsUnLock() )
        End

        If (SD2->D2_VALPIS <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV    := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'PIS'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD2->D2_CSTPIS
           CD2->CD2_BC       := SD2->D2_BASEPIS
           CD2->CD2_ALIQ     := SD2->D2_ALQPIS
           CD2->CD2_VLTRIB   := SD2->D2_VALPIS
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->( MsUnLock() )
        End


        If (SD2->D2_VALCOF <> 0)
           RecLock( 'CD2', .T. )
           CD2->CD2_FILIAL   := _cFilSD2
           CD2->CD2_TPMOV    := 'S'
           CD2->CD2_ITEM     := SD2->D2_ITEM
           CD2->CD2_CODPRO   := SD2->D2_COD
           CD2->CD2_DOC      := SF2->F2_DOC
           CD2->CD2_SERIE    := SF2->F2_SERIE
           CD2->CD2_CODCLI   := SF2->F2_CLIENTE
           CD2->CD2_LOJCLI   := SF2->F2_LOJA
           CD2->CD2_IMP      := 'COF'
           CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
           CD2->CD2_CST      := SD2->D2_CSTCOF
           CD2->CD2_BC       := SD2->D2_BASECOF
           CD2->CD2_ALIQ     := SD2->D2_ALQCOF
           CD2->CD2_VLTRIB   := SD2->D2_VALCOF
           CD2->CD2_QTRIB    := SD2->D2_QUANT
           CD2->( MsUnLock() )
        End

		RecLock( 'SFT', .T. )
		SFT->FT_FILIAL  := _cFilSD2
		SFT->FT_NFISCAL := SF2->F2_DOC		
		SFT->FT_SERIE   := SF2->F2_SERIE
		SFT->FT_EMISSAO := SF2->F2_EMISSAO
		SFT->FT_ENTRADA := SF2->F2_EMISSAO
		SFT->FT_CLIEFOR := SF2->F2_CLIENTE
		SFT->FT_LOJA    := SF2->F2_LOJA
		SFT->FT_CLIENT  := SF2->F2_CLIENTE
		SFT->FT_LOJENT  := SF2->F2_LOJA
		SFT->FT_ESPECIE := SF2->F2_ESPECIE
		SFT->FT_CFOP    := oDet[nX]:_Prod:_CFOP:TEXT
		SFT->FT_TIPO    := SF2->F2_TIPO
		SFT->FT_ESTADO  := SF2->F2_EST
		SFT->FT_TIPOMOV := 'S'
		SFT->FT_ITEM    := SD2->D2_ITEM
	    SFT->FT_PRODUTO := cProduto
        SFT->FT_DESCZFR := If( Type( "oDet[nAux]:_Prod:_VDESC")<>"U", val(oDet[nX]:_Prod:_VDESC:TEXT), 0 )
        SFT->FT_QUANT   := Val(oDet[nX]:_Prod:_QTRIB:TEXT)

        SFT->FT_TOTAL   := Val(oDet[nX]:_Prod:_VPROD:TEXT) - SFT->FT_DESCZFR

        If SFT->FT_DESCZFR <> 0

           SFT->FT_PRCUNIT := (SFT->FT_TOTAL - SFT->FT_DESCZFR) / SFT->FT_QUANT

        Else

           SFT->FT_PRCUNIT := Val(oDet[nX]:_Prod:_VUNCOM:TEXT)

        End

        SFT->FT_VALCONT := (Val(oDet[nX]:_Prod:_VPROD:TEXT) + _vIPI + _vIcmsRet) - SFT->FT_DESCZFR
        SFT->FT_ICMSRET := _vIcmsRet
        SFT->FT_ICMSCOM := _vIcmsRet
        SFT->FT_CREDST  := iif( _vIcmsRet <> 0, '0', ' ')
        SFT->FT_BASERET := _vIcmsBse
        SFT->FT_MARGEM  := _vIcmsMVA
        SFT->FT_ALIQSOL := _vIcmsPer
//        SFT->FT_FCICOD  := If( Type( "oDet[nX]:_Prod:_NFCI")<>"U"                          , oDet[nX]:_Prod:_NFCI:TEXT, ' ' )
        SFT->FT_CSTCOF  := SD2->D2_CSTCOF
        SFT->FT_ALIQCOF := if( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT ), 0 )
        SFT->FT_BASECOF := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC")<>"U"    , val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT  )   , 0 )
        SFT->FT_VALCOF  := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT) , 0 ) 
        SFT->FT_CSTPIS  := SD2->D2_CSTPIS
        SFT->FT_ALIQPIS := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_PPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT)       , 0 )
        SFT->FT_BASEPIS := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VBC")<>"U"          , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT)        , 0 )
        SFT->FT_VALPIS  := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT)       , 0 )

        if (SF2->F2_VALCOFI <> 0)
           SFT->FT_BRETCOF := SFT->FT_TOTAL
           SFT->FT_VRETCOF  := round( SFT->FT_TOTAL * 0.005, 2 )
           SFT->FT_ARETCOF  := 0.5
        End

        if (SF2->F2_VALCOFI <> 0)
           SFT->FT_BRETPIS := SFT->FT_TOTAL
           SFT->FT_VRETPIS  := round( SFT->FT_TOTAL * 0.001, 2 )
           SFT->FT_ARETPIS  := 0.1
        End

        If _pICMS > 99
           _pICMS := 0
        End

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
        SFT->FT_CTIPI   := SD2->D2_CSTIPI
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
        SFT->( MsUnLock() )

Return( NIL )

/*
  []----------------------------------------------------------------------------------------------------------------------------[]
  
             Inclusão dos cabeçalhos nota fiscal de entrada (transferências, remessa e retorno beneficiamento)
  
  []----------------------------------------------------------------------------------------------------------------------------[]
*/

Static Function GrvCabec()

    SF4->( dbSeek( _cFilSF4 + _cTes, .F. ) )

    If cTipo <> 'N'

       IncClient()

    Else

       IncFornec()

    End

    RecLock( 'SF1', .T. )    
    SF1->F1_FILIAL  := _cFilSF1
    SF1->F1_DOC     := Right( "000000000" + Alltrim( OIdent:_nNF:TEXT ), 9 )
    SF1->F1_SERIE   := OIdent:_serie:TEXT
    SF1->F1_PREFIXO := OIdent:_serie:TEXT
    SF1->F1_FORNECE := if( cTipo <> 'N' , SA1->A1_COD, SA2->A2_COD )
    SF1->F1_LOJA    := if( cTipo <> 'N' , SA1->A1_LOJA, SA2->A2_LOJA )
    SF1->F1_COND    := ''
    SF1->F1_EMISSAO := dData
    SF1->F1_DTDIGIT := dData
    SF1->F1_RECBMTO := dData
    SF1->F1_IDSED   := 'N'
    SF1->F1_EST     := if( cTipo <> 'N' , SA1->A1_EST, SA2->A2_EST )
    SF1->F1_ESTPRES := SF1->F1_EST
    SF1->F1_VALBRUT := Val( oTotal:_ICMSTOT:_VNF:TEXT )
    SF1->F1_VALICM  := Val( oTotal:_ICMSTOT:_VICMS:TEXT )
    SF1->F1_BASEICM := Val( oTotal:_ICMSTOT:_VBC:TEXT )
    SF1->F1_VALIPI  := Val( oTotal:_ICMSTOT:_VIPI:TEXT )
    SF1->F1_BASEIPI := iif( SF2->F2_VALIPI <> 0, Val( oTotal:_ICMSTOT:_VPROD:TEXT ), 0 )
    SF1->F1_VALMERC := Val( oTotal:_ICMSTOT:_VPROD:TEXT )
    SF1->F1_ESPECIE := 'SPED'
    SF1->F1_CHVNFE  := cProt
    SF1->F1_CODNFE  := cAut
    SF1->F1_EMINFE  := dData 
    SF1->F1_STATUS  := 'A'
    SF1->F1_MENNOTA := if( Type("oNFe:_InfNfe:_InfAdic:_InfCpl")<> 'U',oNF:_infNFe:_InfAdic:_InfCpl:TEXT, Space( 600 ) )
    SF1->F1_DESCONT := Val( oTotal:_ICMSTOT:_VDESC:TEXT )
    SF1->F1_TIPO    := cTipo
    SF1->F1_ICMSRET := Val( oTotal:_ICMSTOT:_VST:TEXT )
    SF1->F1_BRICMS  := Val( oTotal:_ICMSTOT:_VBCST:TEXT )
//    SF1->F1_DTLANC  := dData

    SF1->F1_VALIMP5 := Val( oTotal:_ICMSTOT:_VCOFINS:TEXT )
    SF1->F1_BASIMP5 := iif( SF2->F2_VALIMP5 <> 0, SF1->F1_VALMERC, 0)
    
    SF1->F1_VALIMP6 := Val( oTotal:_ICMSTOT:_VPIS:TEXT )
    SF1->F1_BASIMP6 := iif( SF2->F2_VALIMP6 <> 0, SF1->F1_VALMERC, 0)

    SF1->F1_VALCOFI := iif( type( "oTotal:_RETTRIB:_VRETCOFINS:TEXT" ) <> 'U', val( oTotal:_RETTRIB:_VRETCOFINS:TEXT),0)
    SF1->F1_BASCOFI := iif( SF1->F1_VALCOFI <> 0, SF1->F1_VALMERC, 0 )
    SF1->F1_VALPIS  := iif( type( "oTotal:_RETTRIB:_VRETPIS:TEXT" ) <> 'U', val( oTotal:_RETTRIB:_VRETPIS:TEXT),0)
    SF1->F1_BASPIS  := iif( SF1->F1_VALPIS <> 0, SF1->F1_VALMERC, 0 )
    
    SF1->F1_RECISS  := '2'
    SF1->F1_MOEDA   := 1
    SF1->F1_FIMP    := 'S'

    SF1->( MsUnLock() )

    RecLock( 'SF3', .T. )
	SF3->F3_FILIAL  := _cFilSD1
	SF3->F3_NFISCAL := SF1->F1_DOC
	SF3->F3_SERIE   := SF1->F1_SERIE
	SF3->F3_EMISSAO := SF1->F1_EMISSAO
	SF3->F3_ENTRADA := SF1->F1_EMISSAO
	SF3->F3_CLIEFOR := SF1->F1_FORNECE
	SF3->F3_LOJA    := SF1->F1_LOJA
	SF3->F3_ESPECIE := SF1->F1_ESPECIE
	SF3->F3_CLIENT  := SF1->F1_FORNECE
	SF3->F3_LOJENT  := SF1->F1_LOJA
	SF3->F3_TIPO    := SF1->F1_TIPO
	SF3->F3_ESTADO  := SA2->A2_EST
    SF3->F3_VALCONT := Val( oTotal:_ICMSTOT:_VNF:TEXT )

	If SF4->F4_CREDICM <> 'N'

       SF3->F3_BASERET := val( oTotal:_ICMSTOT:_vBCST:TEXT ) 
       SF3->F3_ICMSRET := val( oTotal:_ICMSTOT:_VST:TEXT )
       SF3->F3_ICMSCOM := val( oTotal:_ICMSTOT:_VST:TEXT )
       SF3->F3_DESCZFR := Val( oTotal:_ICMSTOT:_VDESC:TEXT )
       SF3->F3_BASEICM := iif( Val(oTotal:_ICMSTOT:_VICMS:TEXT) <> 0, Val( oTotal:_ICMSTOT:_VBC:TEXT ), 0)
       SF3->F3_VALICM  := val( oTotal:_ICMSTOT:_VICMS:TEXT )

    Else

       SF3->F3_ICMSRET := 0
       SF3->F3_ICMSCOM := 0
       SF3->F3_DESCZFR := 0
       SF3->F3_BASEICM := 0
       SF3->F3_VALICM  := 0
  
    End

	If SF4->F4_CREDIPI <> 'N'

       SF3->F3_BASEIPI := iif( SF1->F1_VALIPI <> 0, Val( oTotal:_ICMSTOT:_VPROD:TEXT ), 0 )
       SF3->F3_VALIPI  := Val( oTotal:_ICMSTOT:_VIPI:TEXT )

    Else

       SF3->F3_BASEIPI := 0
       SF3->F3_VALIPI  := 0

    End

    SF3->F3_RECISS  := '2'
    SF3->F3_IDENTFT := '000001'
    SF3->F3_CHVNFE  := cProt
    SF3->F3_CODNFE  := cAut
    SF3->F3_CODRSEF := '100'

	SF3->F3_CFO     := iif( SA2->A2_EST <> 'SP' .And. Substr( SF4->F4_CF, 1, 1 ) = '1', '2' + Substr( SF4->F4_CF, 2, 3 ), SF4->F4_CF )
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

Return( NIL )


/*
  []----------------------------------------------------------------------------------------------------------------------------[]
  
             Inclusão dos itens nota fiscal de entrada (transferências, remessa e retorno beneficiamento)
  
  []----------------------------------------------------------------------------------------------------------------------------[]
*/

Static Function GrvItEnt(nX)
Private nAux := nX

	RecLock( 'SD1', .T. )
	SD1->D1_FILIAL  := _cFilSD1
	SD1->D1_DOC     := SF1->F1_DOC		
	SD1->D1_SERIE   := SF1->F1_SERIE
	SD1->D1_EMISSAO := SF1->F1_EMISSAO
	SD1->D1_DTDIGIT := SF1->F1_DTDIGIT
	SD1->D1_FORNECE := SF1->F1_FORNECE

	SD1->D1_LOJA    := SF1->F1_LOJA
	SD1->D1_NUMSEQ  := ProxNum()
	SD1->D1_TES     := _cTes
	SD1->D1_CF      := SF4->F4_CF

	SD1->D1_TIPO    := SF1->F1_TIPO

	SD1->D1_TP      := 'PA'
	SD1->D1_LOCAL   := '01'
	SD1->D1_ITEM    := StrZero( nX, 4 )
    SD1->D1_COD     := cProduto
    SD1->D1_DESCR   := oDet[nx]:_Prod:_XPROD:TEXT
    SD1->D1_UM      := oDet[nX]:_Prod:_UTRIB:TEXT
    SD1->D1_QUANT   := Val(oDet[nX]:_Prod:_QTRIB:TEXT)
    SD1->D1_VUNIT   := Val(oDet[nX]:_Prod:_VUNCOM:TEXT)
    SD1->D1_TOTAL   := Val(oDet[nX]:_Prod:_VPROD:TEXT)
    SD1->D1_RATEIO  := '2'
    SD1->D1_STSERV  := '1'
    SD1->D1_CONBAR  := '0'

    SD1->D1_ICMSRET := _vIcmsRet
    SD1->D1_BRICMS  := _vIcmsBse
    SD1->D1_MARGEM  := _vIcmsMVA
    SD1->D1_ALIQSOL := _vIcmsPer
//    SD1->D1_DESCZFR := If( Type( "oDet[nX]:_Prod:_VDESC")<>"U"                         , val(oDet[nX]:_Prod:_VDESC:TEXT), 0 )
    SD1->D1_FCICOD  := If( Type( "oDet[nAux]:_Prod:_NFCI")<>"U"                          , oDet[nX]:_Prod:_NFCI:TEXT, ' ' )
    SD1->D1_CSTCOF  := if( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSNT:_CST")<>"U"      , oDet[nX]:_IMPOSTO:_COFINS:_COFINSNT:_CST:TEXT           , Space( 2 ) )
    SD1->D1_ALQIMP5 := if( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT ), 0 )
    SD1->D1_BASIMP5 := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC")<>"U"    , val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT  )   , 0 )
    SD1->D1_VALIMP5 := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT) , 0 ) 
    SD1->D1_CSTPIS  := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISNT:_CST")<>"U"            , oDet[nX]:_IMPOSTO:_PIS:_PISNT:_CST:TEXT                , Space( 2 ) )

    SD1->D1_CSTCOF := SF4->F4_CSTCOF
    SD1->D1_CSTPIS := SF4->F4_CSTPIS
       
    SD1->D1_ALQIMP6 := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_PPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT)       , 0 )
    SD1->D1_BASIMP6 := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VBC")<>"U"          , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT)        , 0 )
    SD1->D1_VALIMP6 := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT)       , 0 )

    If _pICMS > 99
       _pICMS := 0
    End

    SD1->D1_CLASFIS := if( empty(SB1->B1_ORIGEM), '0', SB1->B1_ORIGEM ) + SF4->F4_SITTRIB
    SD1->D1_CSTIPI  := If( Type( "oDet[nAux]:_IMPOSTO:_IPI:_IPINT:_CST")<>"U", oDet[nX]:_IMPOSTO:_IPI:_IPINT:_CST:TEXT, Space( 2 ) )
        
    If (SD1->D1_CSTIPI = '  ')

       SD1->D1_CSTIPI := If( Type( "oDet[nAux]:_IMPOSTO:_IPI:_IPITrib:_CST")<>"U", oDet[nX]:_IMPOSTO:_IPI:_IPITrib:_CST:TEXT, Space( 2 ) )

    End

    SD1->D1_PICM    := _pICMS
    SD1->D1_BASEICM := _vBC
    SD1->D1_VALICM  := _vIcms
    SD1->D1_BASEIPI := _vBCIPI
    SD1->D1_IPI     := _pIPI
    SD1->D1_VALIPI  := _vIPI

    SD1->D1_CUSTO   := SD1->D1_TOTAL - if( SF4->F4_CREDICM <> 'S' ,(SD1->D1_VALICM + SD1->D1_VALIMP5 + SD1->D1_VALIMP6 ), 0 )

    SD1->( MsUnLock() )

    If (SD1->D1_ICMSRET <> 0)

       RecLock( 'CD2', .T. )
       CD2->CD2_FILIAL   := _cFilSD1
       CD2->CD2_TPMOV   := 'E'
       CD2->CD2_ITEM     := SD1->D1_ITEM
       CD2->CD2_CODPRO   := SD1->D1_COD
       CD2->CD2_DOC      := SF1->F1_DOC
       CD2->CD2_SERIE    := SF1->F1_SERIE
       CD2->CD2_CODCLI   := if( cTipo <> 'N', SF1->F1_FORNECE, ' ' )
       CD2->CD2_CODFOR   := if( cTipo <> 'N', ' ', SF1->F1_FORNECE )
       CD2->CD2_LOJCLI   := SF1->F1_LOJA
       CD2->CD2_IMP      := 'SOL'
       CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
       CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
       CD2->CD2_MVA      := SD1->D1_MARGEM
       CD2->CD2_BC       := SD1->D1_BRICMS
       CD2->CD2_ALIQ     := SD1->D1_ALIQSOL
       CD2->CD2_VLTRIB   := SD1->D1_ICMSRET
       CD2->CD2_QTRIB    := SD1->D1_QUANT
       CD2->CD2_DESCZF   := 0 //SD2->D2_DESCZFR
       CD2->( MsUnLock() )

    End

    If (SD1->D1_VALICM <> 0)

       RecLock( 'CD2', .T. )
       CD2->CD2_FILIAL   := _cFilSD1
       CD2->CD2_TPMOV    := 'E'
       CD2->CD2_ITEM     := SD1->D1_ITEM
       CD2->CD2_CODPRO   := SD1->D1_COD
       CD2->CD2_DOC      := SF1->F1_DOC
       CD2->CD2_SERIE    := SF1->F1_SERIE
       CD2->CD2_CODCLI   := if( cTipo <> 'N', SF1->F1_FORNECE, ' ' )
       CD2->CD2_CODFOR   := if( cTipo <> 'N', ' ', SF1->F1_FORNECE )
       CD2->CD2_LOJCLI   := SF1->F1_LOJA
       CD2->CD2_IMP      := 'ICM'
       CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
       CD2->CD2_CST      := Substr( SD1->D1_CLASFIS, 2, 2)
       CD2->CD2_BC       := SD1->D1_BASEICM                             
       
       CD2->CD2_ALIQ     := SD1->D1_PICM
       CD2->CD2_VLTRIB   := SD1->D1_VALICM
       CD2->CD2_QTRIB    := SD1->D1_QUANT
       CD2->( MsUnLock() )

    End

    If (SD1->D1_VALIPI <> 0)

       RecLock( 'CD2', .T. )
       CD2->CD2_FILIAL   := _cFilSD1
       CD2->CD2_TPMOV    := 'E'
       CD2->CD2_ITEM     := SD1->D1_ITEM
       CD2->CD2_CODPRO   := SD1->D1_COD
       CD2->CD2_DOC      := SF1->F1_DOC
       CD2->CD2_SERIE    := SF1->F1_SERIE
       CD2->CD2_CODCLI   := if( cTipo <> 'N', SF1->F1_FORNECE, ' ' )
       CD2->CD2_CODFOR   := if( cTipo <> 'N', ' ', SF1->F1_FORNECE )
       CD2->CD2_LOJCLI   := SF1->F1_LOJA
       CD2->CD2_IMP      := 'IPI'
       CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
       CD2->CD2_CST      := SD1->D1_CSTIPI
       CD2->CD2_BC       := SD1->D1_BASEIPI
       CD2->CD2_ALIQ     := SD1->D1_IPI
       CD2->CD2_VLTRIB   := SD1->D1_VALIPI
       CD2->CD2_QTRIB    := SD1->D1_QUANT
       CD2->( MsUnLock() )

    End

    If (SD1->D1_VALIMP5 <> 0)

       RecLock( 'CD2', .T. )
       CD2->CD2_FILIAL   := _cFilSD1
       CD2->CD2_TPMOV    := 'E'
       CD2->CD2_ITEM     := SD1->D1_ITEM
       CD2->CD2_CODPRO   := SD1->D1_COD
       CD2->CD2_DOC      := SF1->F1_DOC
       CD2->CD2_SERIE    := SF1->F1_SERIE
       CD2->CD2_CODCLI   := if( cTipo <> 'N', SF1->F1_FORNECE, ' ' )
       CD2->CD2_CODFOR   := if( cTipo <> 'N', ' ', SF1->F1_FORNECE )
       CD2->CD2_LOJCLI   := SF1->F1_LOJA
       CD2->CD2_IMP      := 'CF2'
       CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
       CD2->CD2_CST      := SD1->D1_CSTCOF
       CD2->CD2_BC       := SD1->D1_BASIMP5
       CD2->CD2_ALIQ     := SD1->D1_ALQIMP5
       CD2->CD2_VLTRIB   := SD1->D1_VALIMP5
       CD2->CD2_QTRIB    := SD1->D1_QUANT
       CD2->( MsUnLock() )

    End

    If (SD1->D1_VALIMP6 <> 0)

       RecLock( 'CD2', .T. )
       CD2->CD2_FILIAL   := _cFilSD1
       CD2->CD2_TPMOV    := 'E'
       CD2->CD2_ITEM     := SD1->D1_ITEM
       CD2->CD2_CODPRO   := SD1->D1_COD
       CD2->CD2_DOC      := SF1->F1_DOC
       CD2->CD2_SERIE    := SF1->F1_SERIE
       CD2->CD2_CODCLI   := if( cTipo <> 'N', SF1->F1_FORNECE, ' ' )
       CD2->CD2_CODFOR   := if( cTipo <> 'N', ' ', SF1->F1_FORNECE )
       CD2->CD2_LOJCLI   := SF1->F1_LOJA
       CD2->CD2_IMP      := 'PS2'
       CD2->CD2_ORIGEM   := Substr( SD2->D2_CLASFIS, 1, 1)
       CD2->CD2_CST      := SD1->D1_CSTPIS
       CD2->CD2_BC       := SD1->D1_BASIMP6
       CD2->CD2_ALIQ     := SD1->D1_ALQIMP6
       CD2->CD2_VLTRIB   := SD1->D1_VALIMP6
       CD2->CD2_QTRIB    := SD1->D1_QUANT
       CD2->( MsUnLock() )

    End

    If (SD1->D1_VALPIS <> 0)

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilSD1
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := if( cTipo <> 'N', SF1->F1_FORNECE, ' ' )
        CD2->CD2_CODFOR   := if( cTipo <> 'N', ' ', SF1->F1_FORNECE )
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'PIS'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD1->D1_CSTPIS
        CD2->CD2_BC       := SD1->D1_BASEPIS
        CD2->CD2_ALIQ     := SD1->D1_ALQPIS
        CD2->CD2_VLTRIB   := SD1->D1_VALPIS
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( MsUnLock() )

     End

     If (SD1->D1_VALCOF <> 0)

        RecLock( 'CD2', .T. )
        CD2->CD2_FILIAL   := _cFilSD1
        CD2->CD2_TPMOV    := 'E'
        CD2->CD2_ITEM     := SD1->D1_ITEM
        CD2->CD2_CODPRO   := SD1->D1_COD
        CD2->CD2_DOC      := SF1->F1_DOC
        CD2->CD2_SERIE    := SF1->F1_SERIE
        CD2->CD2_CODCLI   := if( cTipo <> 'N', SF1->F1_FORNECE, ' ' )
        CD2->CD2_CODFOR   := if( cTipo <> 'N', ' ', SF1->F1_FORNECE )
        CD2->CD2_LOJCLI   := SF1->F1_LOJA
        CD2->CD2_IMP      := 'COF'
        CD2->CD2_ORIGEM   := Substr( SD1->D1_CLASFIS, 1, 1)
        CD2->CD2_CST      := SD1->D1_CSTCOF
        CD2->CD2_BC       := SD1->D1_BASECOF
        CD2->CD2_ALIQ     := SD1->D1_ALQCOF
        CD2->CD2_VLTRIB   := SD1->D1_VALCOF
        CD2->CD2_QTRIB    := SD1->D1_QUANT
        CD2->( MsUnLock() )

     End

     RecLock( 'SFT', .T. )
	 SFT->FT_FILIAL  := _cFilSD1
	 SFT->FT_NFISCAL := SF1->F1_DOC
	 SFT->FT_SERIE   := SF1->F1_SERIE
	 SFT->FT_EMISSAO := SF1->F1_EMISSAO
	 SFT->FT_ENTRADA := SF1->F1_EMISSAO
	 SFT->FT_CLIEFOR := SF1->F1_FORNECE
	 SFT->FT_LOJA    := SF1->F1_LOJA
	 SFT->FT_CLIENT  := SF1->F1_FORNECE
	 SFT->FT_LOJENT  := SF1->F1_LOJA
	 SFT->FT_ESPECIE := SF1->F1_ESPECIE
	 SFT->FT_CFOP    := SF4->F4_CF
	 SFT->FT_TIPO    := SF1->F1_TIPO
	 SFT->FT_ESTADO  := SF1->F1_EST
	 SFT->FT_TIPOMOV := 'E'
	 SFT->FT_ITEM    := SD1->D1_ITEM
	 SFT->FT_PRODUTO := cProduto
     SFT->FT_DESCZFR := If( Type( "oDet[nAux]:_Prod:_VDESC")<>"U", val(oDet[nX]:_Prod:_VDESC:TEXT), 0 )
     SFT->FT_QUANT   := Val(oDet[nX]:_Prod:_QTRIB:TEXT)

     SFT->FT_TOTAL   := Val(oDet[nX]:_Prod:_VPROD:TEXT) - SFT->FT_DESCZFR

     If SFT->FT_DESCZFR <> 0

        SFT->FT_PRCUNIT := (SFT->FT_TOTAL - SFT->FT_DESCZFR) / SFT->FT_QUANT

     Else

        SFT->FT_PRCUNIT := Val(oDet[nX]:_Prod:_VUNCOM:TEXT)

     End

     SFT->FT_VALCONT := (Val(oDet[nX]:_Prod:_VPROD:TEXT) + _vIPI + _vIcmsRet) - SFT->FT_DESCZFR

     If SF4->F4_CREDICM <> 'N'
     
        SFT->FT_ICMSRET := _vIcmsRet
        SFT->FT_ICMSCOM := _vIcmsRet
        SFT->FT_CREDST  := iif( _vIcmsRet <> 0, '0', ' ')
        SFT->FT_BASERET := _vIcmsBse
        SFT->FT_MARGEM  := _vIcmsMVA
        SFT->FT_ALIQSOL := _vIcmsPer

     Else

        SFT->FT_ICMSRET := 0
        SFT->FT_ICMSCOM := 0
        SFT->FT_CREDST  := ' '
        SFT->FT_BASERET := 0
        SFT->FT_MARGEM  := 0
        SFT->FT_ALIQSOL := 0
        _pICMS := 0
        _vBC   := 0
        _vIcms := 0

     End

     If SF4->F4_CREDIPI <> 'N'

        SFT->FT_BASEIPI := _vBCIPI
        SFT->FT_ALIQIPI := _pIPI
        SFT->FT_VALIPI  := _vIPI

     Else

        SFT->FT_BASEIPI := 0
        SFT->FT_ALIQIPI := 0
        SFT->FT_VALIPI  := 0
        SFT->FT_IPIOBS  := _vIpi
        _vBCIPI := 0
        _pIPI   := 0
        _vIPI   := 0

     End

     SFT->FT_CSTCOF  := SF4->F4_CSTCOF
     SFT->FT_ALIQCOF := if( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_PCOFINS:TEXT ), 0 )
     SFT->FT_BASECOF := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC")<>"U"    , val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VBC:TEXT  )   , 0 )
     SFT->FT_VALCOF  := If( Type( "oDet[nAux]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS")<>"U", val( oDet[nX]:_IMPOSTO:_COFINS:_COFINSALIQ:_VCOFINS:TEXT) , 0 ) 
     SFT->FT_CSTPIS  := SF4->F4_CSTPIS
     SFT->FT_ALIQPIS := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_PPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_PPIS:TEXT)       , 0 )
     SFT->FT_BASEPIS := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VBC")<>"U"          , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VBC:TEXT)        , 0 )
     SFT->FT_VALPIS  := If( Type( "oDet[nAux]:_IMPOSTO:_PIS:_PISALIQ:_VPIS")<>"U"         , val( oDet[nX]:_IMPOSTO:_PIS:_PISALIQ:_VPIS:TEXT)       , 0 )

     If _pICMS > 99
        _pICMS := 0
     End

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
     SFT->FT_CTIPI   := SF4->F4_CTIPI
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
     SFT->( MsUnLock() )

Return( NIL )

Static Function IncClient()

   If ! SA1->( dbSeek( _cFilSA1 + cCgc, .F. ) )

      _xNOME   := AllTrim(oDestino:_XNOME:TEXT)
	  _IE      := AllTrim(if( Type( "oDestino:_IE" ) <> 'U',oDestino:_IE:TEXT, ' ') )
	  _CEP     := AllTrim(oDestino:_ENDERDEST:_CEP:TEXT)
	  _CMUN    := RIGHT(AllTrim(oDestino:_ENDERDEST:_CMUN:TEXT),5)
	  _CPAIS   := AllTrim( if( Type( "oDestino:_ENDERDEST:_CPAIS" ) <> 'U', oDestino:_ENDERDEST:_CPAIS:TEXT, '1058' ) )
	  _FONE    := AllTrim(if( Type( "oDestino:_ENDERDEST:_FONE:TEXT" ) <> 'U',oDestino:_ENDERDEST:_FONE:TEXT, ' ') )
	  _NRO     := AllTrim(oDestino:_ENDERDEST:_NRO:TEXT)
      _UF      := AllTrim(oDestino:_ENDERDEST:_UF:TEXT)
	  _XBAIRRO := AllTrim(oDestino:_ENDERDEST:_XBAIRRO:TEXT)
	  _XLGR    := AllTrim(oDestino:_ENDERDEST:_XLGR:TEXT)
	  _XMUN    := AllTrim(oDestino:_ENDERDEST:_XMUN:TEXT)

      _cEst    := _UF // UF utilizada na nota fiscal

      _qCli := "SELECT ID_CLIENTE, NOME, FANTASIA, ENDERECO, COMPL_END, REPLACE(REPLACE(CEP,'.',''),'-','') CEP, BAIRRO, ATIV.SUBST_TRIB SUBTRIB, "
      _qCli += "RGINSC, INTERNET eMail, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TELEFONE,'.',''),' ',''),')',''),'(',''),'/',''),'-','') TELEFONE, CONTATO, CONVERT(CHAR(8),CADASTRO,112) CADASTRO, CONVERT( CHAR(8), ULT_COMPRA,112) ULT_COMPRA, CLIENTE.SUFRAMA,"
      _qCli += "REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') CPFCGC, CIDADE.DESCRICAO, UF, COD_UF, MUNICIPIO , PAIS, REPLACE(ISNULL(PLANO.CODIGO,'112010001'),'.','') CONTA"
      _qCli += ' FROM ['+cBDGSTQ+'].[dbo].[CLIENTE] '
      _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[CIDADE] ON CIDADE.ID_CIDADE = CLIENTE.ID_CIDADE '
      _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[OPERACIONAL] OP ON OP.ID_OPERACIONAL = CLIENTE.ID_OPERACIONAL '
      _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[ATIVIDADE] ATIV ON ATIV.ID_ATIVIDADE = CLIENTE.ID_ATIVIDADE '
      _qCli += 'LEFT OUTER JOIN ['+cBDGSTQ+'].[dbo].[PLANO] ON PLANO.ID_PLANO = OP.ID_PLANO_CR '
//      _qCli += "WHERE (CLIENTE.ID_CLIENTE = " + LTRIM(STR(->F2_CLIENTE,6)) + ")"
      _qCli += "WHERE (REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') = '" + cCgc  + "')"
       dbUseArea( .T.,"TOPCONN",TcGenQry(,,_qCli),"CLI",.T.,.T.)
       RecLock( 'SA1', .T. )
       SA1->A1_LOJA    := '01'
       SA1->A1_COD     := StrZero( CLI->ID_CLIENTE, 6 )
       SA1->A1_NOME    := _xNOME
       SA1->A1_NREDUZ  := Substr( _xNome, 1, at( ' ', _xNome) )
       SA1->A1_INSCR   := _IE
       SA1->A1_CGC     := cCGC
       SA1->A1_CEP     := _CEP
       SA1->A1_MUN     := _XMUN
       SA1->A1_COD_MUN := _CMUN
       SA1->A1_PAIS    := SUBSTR( _CPAIS,1,3 )
       SA1->A1_CODPAIS := '0' + _CPAIS
       SA1->A1_TEL     := _FONE
       SA1->A1_END     := _XLGR
       SA1->A1_EMAIL   := CLI->eMail

       If at( ',', _XLGR ) = 0
       
          SA1->A1_END := rTrim( SA1->A1_END ) + ', ' + Alltrim( Str( Val( _NRO ), 5, 0) )
       
       End

       SA1->A1_EST    := _UF
       SA1->A1_BAIRRO := _XBAIRRO
       SA1->A1_PESSOA := if( Len(cCGC) <> 14, 'F', 'J' )
       SA1->A1_TIPO   := 'R'
       SA1->( MsUnLock() )
       CLI->( dbCloseArea() )

    End

Return()

Static Function IncFornec()

   If ! SA2->( dbSeek( _cFilSA2 + cCgc, .F. ) )

	  _xNOME   := AllTrim(oEmitente:_XNOME:TEXT)
	  _IE      := AllTrim(if( Type( "oDestino:_IE" ) <> 'U',oEmitente:_IE:TEXT, ' ') )
	  _CEP     := AllTrim(oEmitente:_ENDEREMIT:_CEP:TEXT)
	  _CMUN    := RIGHT(AllTrim(oEmitente:_ENDEREMIT:_CMUN:TEXT),5)
	  _CPAIS   := AllTrim( if( Type( "oEmitente:_ENDERDEST:_CPAIS" ) <> 'U', oDestino:_ENDEREMIT:_CPAIS:TEXT, '1058' ) )
	  _FONE    := AllTrim(oEmitente:_ENDEREMIT:_FONE:TEXT)
	  _NRO     := AllTrim(oEmitente:_ENDEREMIT:_NRO:TEXT)
      _UF      := AllTrim(oEmitente:_ENDEREMIT:_UF:TEXT)
	  _XBAIRRO := AllTrim(oEmitente:_ENDEREMIT:_XBAIRRO:TEXT)
	  _XLGR    := AllTrim(oEmitente:_ENDEREMIT:_XLGR:TEXT)
	  _XMUN    := AllTrim(oEmitente:_ENDEREMIT:_XMUN:TEXT)

      _cEst    := _UF // UF utilizada na nota fiscal

      _cQry := "SELECT ID_CLIENTE FROM ["+cBDGSTQ+"].[dbo].[CLIENTE] WHERE REPLACE(REPLACE(REPLACE(CPFCGC,'.',''),'/',''),'-','') = '" + cCgc + "'"
      dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQry), 'TMP' )
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
      SA2->( MsUnLock() )
      
   End

Return()
