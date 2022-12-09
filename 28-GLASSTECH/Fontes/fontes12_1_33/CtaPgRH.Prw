#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.ch"
#include "Colors.ch"
#include "Font.ch"
#Include "HBUTTON.CH"
#include "Topconn.ch"
Static cBDGSTQ	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "TESTE"			, "TPCP"		)
Static cBDPROT	:= GetMv("MV_TWINENV")
Static cBVGstq	:= Iif(At("_12133", Upper(GetEnvServer())) > 0, "BVTESTE"			, "BV"			)

/*/{Protheus.doc} CtaPgRh
//TODO Descrição auto-gerada.
@author Desconhecido
@since 26/08/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CtaPgRh()
LOCAL _cTipo
LOCAL _cPensao

PRIVATE _aVerbas
PRIVATE _cFilSRC
PRIVATE _cMat

// SRQ DADOS PARA DEPOSITO pensao

_aDescr := {;
             'Liquido Férias'     ,;
             'Liquido Rescisão'   ,;
             'Pensão'             ,;
             'Liquido Salário'    ,;
             'Liquido 13º Salário',;
            }

_aVerbas := {;
             {'Liquido Férias'     ,'0102',5378},;
             {'Liquido Rescisão'   ,'0126',5351},;
             {'Pensão'             ,'    ',5387,536,539,540,533,534,548,542,545,546,543},;
             {'Liquido Salário'    ,'0047',5715},;
             {'Liquido 13º Salário','0021',5379};
            }

_aPensao := {;
             ' ',;
             '533 (Pensão Alimentícia)',;
             '534 (Pensão Alimentícia)',;
             '536 (Pensão Alimentícia Adto)',;
             '539 (Pensão Alimentícia Férias)',;
             '540 (Pensão Alimentícia Férias)',;
             '542 (Pensão Alimentícia 13º 1ª Parc.)',;
             '543 (Pensão Alimentícia 13º 1ª Parc.)',;
             '545 (Pensão Alimentícia 13º 2ª Parc.)',;
             '546 (Pensão Alimentícia 13º 2ª Parc.)',;
             '548 (Pensão Alimentícia 13º 1ª Parc.)';
            }

_cMat    := '      '
_cNome   := Space( 40 )
_cBcoAge := Space( 10 )
_cCtaCte := Space( 10 )
_dDtPgt  := dDataBase
_nTipo   := 1
_nPensao := 1
_nVlr    := 0


DEFINE MSDIALOG _oDlgRH FROM  50, 050 TO 350,450 TITLE OemToAnsi('Autorização Pagamento') PIXEL
	
	@ 005,005 Say 'Matricula' Size 040,030
	@ 020,005 Say 'Funcionário' Size 070,030
	@ 035,005 Say 'Bco/Agência' Size 070,030
	@ 050,005 Say 'Conta Corrente' Size 070,030
	@ 065,005 Say 'Tipo' Size 070,030
	@ 080,005 Say 'Verba' Size 070,030
	@ 095,005 Say 'Data Pagto' Size 070,030
	@ 110,005 Say 'Valor' Size 070,030
	
	@ 005,060 Get _cMat  Picture '999999' /*Valid ExistCpo('SRA')*/ F3 'SRA'
	@ 020,060 Get _cNome WHEN .F. Object _oNome SIZE 110,10
	@ 035,060 Get _cBcoAge Picture '@R 999/99999' WHEN .F. Object _oBcoAge
	@ 050,060 Get _cBcoAge Picture '@R !!!!!!!!!!' Object _oBcoAge WHEN .F.
	@ 065,060 COMBOBOX oTipo   VAR _cTipo ITEMS _aDescr  Valid PesqVerba() SIZE 100,10 Of _oDlgRH Pixel
	@ 080,060 COMBOBOX oPensao VAR _cPensao ITEMS _aPensao SIZE 100,10  Valid PesqVerba() When ( _cTipo = 'Pensão' ) Of _oDlgRH Pixel
	@ 095,060 Get _dDtPgt Picture '@ED 99/99/9999' SIZE 50,10
	@ 110,060 Get _nVlr Picture '@RE 999,999.99' SIZE 50,10 When .F.
		
	@ 125,100 Button OemToAnsi("Autorizar")  Size 036,016 Action (_oDlgRH:End())
	@ 125,160 Button OemToAnsi("Cancelar")   Size 036,016 Action Fecha()
	
ACTIVATE Dialog _oDlgRH CENTERED
	
Return( NIL )


Static Function PesqVerba()

_cFilSRC := xFilial( 'SRC' )
_cMatricula := ' '
_cVerba     := ' '

If ( SRC->( dbSeek( _cFilSRC + _cMatricula + _cVerba + SRA->RA_CC + Space( Len( SRC->RC_SEMANA + SRC->RC_SEQ ) ), .F. ) ) )

    If     _cFilSRC = '0101'
       _nIdEmpresa := 1
    ElseIf _cFilSRC =  '0102'
       _nIdEmpresa := 2
    ElseIf _cFilSRC = '0201'
       _nIdEmpresa := 3
    ElseIf _cFilSRC = '0601'
       _nIdEmpresa := 4
    ElseIf _cFilSRC = '0103'
       _nIdEmpresa := 5
    ElseIf _cFilSRC = '0202'
       _nIdEmpresa := 6
    ElseIf _cFilSRC = '0301'
       _nIdEmpresa := 7
    ElseIf _cFilSRC = '0401'
       _nIdEmpresa := 8
    ElseIf _cFilSRC = '0501'
       _nIdEmpresa := 9
    ElseIf _cFilSRC = '0701'
       _nIdEmpresa := 12
    Else 
       _nIdEmpresa := 0
    End

End

_nOpc        := 1
_nIdEmpresa  := 0
_cReferencia := SRA->RA_NOME
_dData       := _dDtPgt
_nCliente    := _aVerbas[ _nOpc ][ 3 ]
_dEmissao    := dDataBase
_nCondPag    := 132
_cLogin      := cUserName
_cDoc        := SRA->RA_MAT
_cLF         := Chr(13)

_cSP := 'DECLARE @idTitulo Int;'+_cLF
_cSP += 'DECLARE @nRec Int;'+_cLF

_cSP += 'SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;'+_cLF
_cSP += 'BEGIN TRANSACTION;'+_cLF

_cSP += "select @nRec = count(*) from ["+cBDGSTQ+"].[dbo].[TITULO] WHERE DOC = ('" + Substr( Str(Year( _dDtPgt ),4 ), 4, 1 ) + Substr( Str(Month( _dDtPgt ),4 ), 3, 2 ) + _cReferencia + "')"+_cLF
   
_cSP += 'If @nRec <> 0'+_cLF

_cSP +=  'begin'+_cLF

_cSP +=    'select @idTitulo = MAX(ID_TITULO) + 1 from ['+cBDGSTQ+'].[dbo].[TITULO]'+_cLF
_cSP +=    'insert into ['+cBDGSTQ+'].[dbo].[TITULO]'+_cLF
_cSP +=       '(ID_TITULO,DOC  ,ID_CLIENTE,TIPOTITULO,ID_DEPTO, REFERENCIA, DATA, ID_EMPRESA, TP_LANC, ID_CONDPAG )'+_cLF
_cSP +=    'values'+_cLF
_cSP +=       '( @idTitulo,'+ Substr( Str(Year( _dDtPgt ),4 ), 4, 1 ) + Substr( Str(Month( _dDtPgt ),4 ), 3, 2 ) + ',' + Str( _nCliente, 6, 0 ) +',0         ,0       ,'+ _cReferencia +"',cast('" + DtoC( _dData ) + "' as datetime)," + Str( _nIdEmpresa, 2, 0 ) + ',0,132)'+_cLF

_cSP += "select @nRec = max(ID_VENCTITULO) + 1 from ["+cBDGSTQ+"].[dbo].[VENCTITULO]"+_cLF

_cSP +=    'insert into ['+cBDGSTQ+'].[dbo].[VENCTITULO]'+_cLF
_cSP +=       '(ID_TITULO,ID_TABCC,ID_COBRANCA,ID_PLANO,ID_CONTA,DOC,VALOR,VENCIMENTO,TIPOPAGAM,OBS,DATA_PAG,PAGO,VALOR_PAGO,DESCONTO,OUTRAS,JUROS,BANCO,AGENCIA,CONTA,EMISSAO,NOSSONUMERO,CONTACOBRANCA,ID_EMPRESA,Perc,QParc,ID_NOTA)'+_cLF
_cSP +=    'values'+_cLF
_cSP +=    '( @nRec, @idTitulo,1,1,NULL,-1,'+ Substr( Str(Year( _dDtPgt ),4 ), 4, 1 ) + Substr( Str(Month( _dDtPgt ),4 ), 3, 2 ) + _cReferencia +','+ Str( _nVlr, 12, 2 ) +",cast('"+ DtoC( _dDtPgt ) +"' as datetime),NULL,NUL,NULL,NULL,0,0,0,0,NULL,NULL,NULL,cast('"+DtoC( dDataBase ) + "' as datetime),null,null,0,63,0, 0,0, 0, 0)"+_cLF

_cSP += 'end'+_cLF

_cSP += 'COMMIT'+_cLF

Return( NIL )
