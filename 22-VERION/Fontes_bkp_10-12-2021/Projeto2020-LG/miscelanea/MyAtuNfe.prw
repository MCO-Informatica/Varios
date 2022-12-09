#include "totvs.ch"
User Function MyAtuNfe
If !TcCanOpen("SPED050VERION")
	MsgStop("Arquivo SPED050VERION deve ser importado via MpSDU para o BD Oficial","ATENCAO")
Else
	Processa( {|| Atualiza()}, "Atualizando Chave da NFe nas Notas de Entrada..." )
Endif
Return

Static Function Atualiza()
Local _cQryNFe := ""
Local _cIdNFe  := ""
Local _nCount  := 0
Local _aAreaSF1:= SF1->( GetArea() )

_cQryNFe:="SELECT SF1.R_E_C_N_O_ AS NREGSF1,CONVERT(VARCHAR(4000),CONVERT(VARBINARY(4000),XML_ERP))  AS XMLERP "
_cQryNFe+=" FROM SPED050VERION NFE "
_cQryNFe+=" INNER JOIN " + RetSqlName("SF1") + " SF1 "
_cQryNFe+=" ON SF1.F1_SERIE+SF1.F1_DOC = NFE.NFE_ID"
_cQryNFe+=" AND F1_CHVNFE = '' AND F1_FIMP = 'T'"
_cQryNFe+=" WHERE NFE.D_E_L_E_T_ = ''"

If Select("QRY_NFe") > 0
	QRY_NFe->( DbCloseArea() )
Endif

_cQryNFe := ChangeQuery( _cQryNFe )

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQryNFe),"QRY_NFe",.F.,.T.)

QRY_NFe->(DBGoTop())
QRY_NFe->( dbEval( {|| _nCount++ } ) )
QRY_NFe->(DBGoTop())
ProcRegua(_nCount)
_nCount:= 0
Do While QRY_NFe->( !Eof() )
	_cIdNFe := MySpedNfeId(QRY_NFe->XMLERP,"Id")
	_cIdNFe := StrTran(_cIdNFe,"NFe","")
	
	If !Empty( _cIdNFe )
		IncProc("Atualizando Documentos de Entrada..."+Alltrim(Str(QRY_NFe->NREGSF1)))
		_cUpd:= "UPDATE "+RetSqlName("SF1")+" SET F1_CHVNFE ='"+Alltrim(_cIdNFe)+"' WHERE R_E_C_N_O_="+Alltrim(Str(QRY_NFe->NREGSF1))
		TcSqlExec( _cUpd )
		_nCount++
	Endif
	
	QRY_NFe->( DbSkip() )
EndDo

Alert("Fim da Atualizacao - Processadas "+ Alltrim(Str(_nCount))+ " Notas Fiscais de Entrada" )
RestArea( _aAreaSF1 )
Return


Static Function MySpedNfeId(cXML,cAttId)
Local nAt  := 0
Local cURI := ""
Local nSoma:= Len(cAttId)+2

nAt := At(cAttId+'=',cXml)
cURI:= SubStr(cXml,nAt+nSoma)
nAt := At('"',cURI)
If nAt == 0
	nAt := At("'",cURI)
EndIf
cURI:= SubStr(cURI,1,nAt-1)
Return(cUri)
