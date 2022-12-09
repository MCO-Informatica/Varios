/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtaAdGstq º Autor ³ Sérgio Santana       º Data ³29/10/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importacao Base de Dados                                   º±±
±±º          ³ Tratamento dos lançamentos referente ao recebimento anteci º±±
±±º          ³ pado e pagamento antecipado                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºALTERACAO ³                                                            º±± 
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ThermoGlass                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±admiun	±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//U_CtaAdGstq( '20140901', '20141031' )
#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"

User Function TitAdGstq( _cDtIni, _cDtFim )

DEFAULT _cDtIni := DtoS( dDataBase - 1 )
DEFAULT _cDtFim := DtoS( dDataBase - 1 )

PRIVATE _cFilSA2 := xFilial( 'SA2' )
PRIVATE _qAdt

_cFilSE5 := "@ (D_E_L_E_T_ = '') AND (E5_TIPO IN ('RA','PA'))"
SE5->( dbSetFilter( { || _cFilSE5 }, _cFilSE5 ) )
SE5->( dbGoTop() )

GrvAdtFin()

Return( NIL )                       


Static Function GrvAdtFin()

While ! SE5->( Eof() )

   If SE5->E5_RECPAG <> 'P'

      If ! ( SE1->( dbSeek( SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO, .F. ) ) )

         GeraRec()

      End

   Else

      If ! (SE2->( dbSeek( SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA, .F.  ) ) )

         GeraPag()

      End

   End

   SE5->( dbSkip() )

End

SE5->( dbCloseArea() )

Return( NIL )

Static Function GeraRec()

  RecLock( 'SE1', .T. )

  SE1->E1_FILIAL  := SE5->E5_FILIAL
  SE1->E1_FILORIG := SE5->E5_FILORIG
  SE1->E1_MSFIL   := SE5->E5_FILIAL
  SE1->E1_TIPO    := SE5->E5_TIPO
  SE1->E1_MSEMP  := '01'
  SE1->E1_STATUS  := 'A'
  SE1->E1_CLIENTE := SE5->E5_CLIFOR
  SE1->E1_LOJA    := '01'
  SE1->E1_NOMCLI  := SE5->E5_BENEF
  SE1->E1_NUM     := SE5->E5_NUMERO
  SE1->E1_PARCELA := SE5->E5_PARCELA
  SE1->E1_SERIE   := SE5->E5_PREFIXO
  SE1->E1_PREFIXO := SE5->E5_PREFIXO
  SE1->E1_VALOR   := SE5->E5_VALOR
  SE1->E1_VLCRUZ  := SE5->E5_VALOR
  SE1->E1_SALDO   := 0
  SE1->E1_EMISSAO := SE5->E5_DATA
  SE1->E1_EMIS1   := SE5->E5_DATA
  SE1->E1_VENCTO  := SE5->E5_DATA
  SE1->E1_VENCREA := SE5->E5_DATA
  SE1->E1_VENCORI := SE5->E5_DATA
  SE1->E1_CONTA   := SE5->E5_CONTA
  SE1->E1_MULTNAT := '2'
  SE1->E1_NATUREZ := SE5->E5_NATUREZ
  SE1->E1_PORTADO := SE5->E5_BANCO
  SE1->E1_SITUACA := '0'
  SE1->E1_FLUXO   := 'S'
  SE1->E1_APLVLMN := '1'
  SE1->E1_PROJPMS := '2'
  SE1->E1_DESDOBR := '2'
  SE1->E1_MOEDA   := 1
  SE1->E1_FRETISS := '1'
  SE1->E1_ORIGEM  := 'CTMVADSTQ'
  SE1->( dbUnLock() )

Return( NIL )


Static Function GeraPag()

   RecLock( 'SE2', .T. )

   SE2->E2_FILIAL  := SE5->E5_FILIAL
   SE2->E2_FILORIG := SE5->E5_FILIAL
   SE2->E2_TIPO    := SE5->E5_TIPO
   SE2->E2_STATUS  := ' '
   SE2->E2_FORNECE := SE5->E5_CLIFOR
   SE2->E2_LOJA    := '01'
   SE2->E2_NOMFOR  := SE5->E5_BENEF
   SE2->E2_NUM     := SE5->E5_NUMERO
   SE2->E2_PARCELA := SE5->E5_PARCELA
   SE2->E2_PREFIXO := SE5->E5_PREFIXO
   SE2->E2_VALOR   := SE5->E5_VALOR
   SE2->E2_VLCRUZ  := SE5->E5_VALOR
   SE2->E2_SALDO   := 0
   SE2->E2_ACRESC  := 0
   SE2->E2_JUROS   := 0
   SE2->E2_DESCONT := 0
   SE2->E2_EMISSAO := SE5->E5_DATA
   SE2->E2_EMIS1   := SE5->E5_DATA
   SE2->E2_VENCTO  := SE5->E5_DATA
   SE2->E2_VENCREA := SE5->E5_DATA
   SE2->E2_VENCORI := SE5->E5_DATA
   SE2->E2_CONTAD  := SE5->E5_CONTA
   SE2->E2_FLUXO   := 'S'
   SE2->E2_PROJPMS := '2'
   SE2->E2_DESDOBR := 'N'
   SE2->E2_MOEDA   := 1
   SE2->E2_FRETISS := '1'
   SE2->E2_PRETINS := '1'
   SE2->E2_MDRTISS := '1'
   SE2->E2_OCORREN := '01'
   SE2->E2_RATEIO  := 'N'
   SE2->E2_RATFIN  := '2'
   SE2->E2_APLVLMN := '1'
   SE2->E2_DIRF    := '2'
   SE2->E2_MODSPB  := '1'
   SE2->E2_HIST    := SE5->E5_HISTOR
   SE2->E2_MULTNAT := '2'
   SE2->E2_NATUREZ := SE5->E5_NATUREZ
   SE2->E2_ORIGEM  := 'CTMVADSTQ'
   SE2->E2_LA      := ' '
   SE2->( dbUnLock() )

Return( NIL )