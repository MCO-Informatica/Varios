#include "TBICONN.CH"
#include "RWMAKE.CH"
#include "COLORS.CH"
#include "FONT.CH"
#include "TOPCONN.CH"
#include "PROTHEUS.CH"

#DEFINE CRLF Chr(13)+Chr(10)

User Function  RCTRA001()

Local nX		:= 0
Local lMark   	:= .F.
Local oChk    	:= Nil

Private oDlgCA
Private aItens  := {}
Private lChk  	:= .F.
Private oLbx	:= Nil
Private cBusca  := space(15)
Private cDe     := Space(15)
Private cAte    := Space(15)
Private cCopy  	:= Space(4)
Private nCopy   := 0  
Private _cSeqCNF := ''
_cAlias   := Alias()
_nRecno   := Recno()
_nIndex   := IndexOrd()
lRefresh    := .T.
aButtons    := {}
aAdd(aItens,{.F.,"","","","","",""})

//Fontes utilizados na rotina
oArial12:= TFont():New("Arial",,-12,.T.,.T.)
//Objeto de marcação utilizados na rotina
oOk   := LoaDbitmap(GetResources(),"LBTIK")	//Marca
oNo   := LoaDbitmap(GetResources(),"LBNO")	//Desmarca

DEFINE MSDIALOG oDlgCA TITLE "Replica de Contrato" FROM 0,0  TO 450,800 PIXEL

oSay2   := tSay():New(172,140,{|| "Contrato De 	:" },oDlgCA,,oArial12,,,,.T.,CLR_BLACK,,45,06)
oSay3   := tSay():New(189,140,{|| "Contrato Ate	:" },oDlgCA,,oArial12,,,,.T.,CLR_BLACK,,45,06)
oSay4   := tSay():New(208,140,{|| "No. de Copias :"},oDlgCA,,oArial12,,,,.T.,CLR_BLACK,,45,08)

oDe     := tGet():New(172,190,{|u| if(PCount()>0,cDe  :=u,cDe)}		,oDlgCA,50,008,"@!"		,{|| zCarrega()},,,,,,.T.,,,{|| .T.},,,,,,"SXBCN9","cDe",,,,.T.,.F.)
oAte    := tGet():New(191,190,{|u| if(PCount()>0,cAte :=u,cAte)} 	,oDlgCA,50,008,"@!"		,{|| zCarrega()},,,,,,.T.,,,{|| .T.},,,,,,"SXBCN9","cAte",,,,.T.,.F.)
oCopy   := tGet():New(208,190,{|u| if(PCount()>0,nCopy:=u,nCopy)}	,oDlgCA,10,008,"@E 9999",,,,,,,.T.,,,{|| .T.},,,,,,,"nCopy",,,,.T.,.F.)


oBtn1 := TButton():New(172,015,'Replicar',oDlgCA,{|| _ExProces()  },40,10,,,,.T.)
oBtn2 := TButton():New(191,015,'Fechar'	 ,oDlgCA,{|| oDlgCA:end() },40,10,,,,.T.)


@ 10,14 LISTBOX oLbx FIELDS HEADER " ","Numero do Contrato","Tipo","Descricao" SIZE 380, 153 NOSCROLL OF oDlgCA PIXEL ON dblClick(aItens[oLbx:nAt,1] := !aItens[oLbx:nAt,1],oLbx:Refresh())

oLbx:SetArray(aItens)
oLbx:bLine:={|| {If(aItens[oLbx:nAt,1],oOk,oNo),aItens[oLbx:nAt,2],aItens[oLbx:nAt,3],aItens[oLbx:nAt,4],aItens[oLbx:nAt,5]}}

@ 210,15 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlgCA;
ON CLICK(Iif(lChk,Marca(lChk),Marca(lChk)))


ACTIVATE MSDIALOG oDlgCA CENTERED

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nRecno)

Return(.F.)


Static Function zCarrega()
Local lErro	:= .F.
aItens:={}
_cDe := cDe
_cAte:= If(Empty(cAte),If(Empty(cDe),"ZZZZZZZZZZZZZZZ",cDe),cAte)

qCN9    := GetNextAlias()
lQuery := .T.
BeginSql Alias qCN9
	SELECT CN9.CN9_NUMERO,CN9.CN9_REVISA,CN9_XTIPO,SZ2.Z2_DESC,SZ2.Z2_NEXTNUM
	FROM %Table:CN9% CN9
	INNER JOIN %Table:SZ2% SZ2 ON SZ2.Z2_COD = CN9.CN9_XTIPO AND SZ2.%NotDel% AND SZ2.Z2_FILIAL = %xFilial:SZ2%
	WHERE CN9.CN9_FILIAL = %xFilial:CN9%
	AND (CN9.CN9_NUMERO BETWEEN %Exp:_cDe% AND %Exp:_cAte%)
	AND CN9.CN9_REVISA = ' '
	AND CN9.CN9_SITUAC = '02'
	AND CN9.%NotDel%
	ORDER BY CN9.CN9_NUMERO
EndSql

DbSelectArea(qCN9)
If (qCN9 )->(!EOF())
	While (qCN9)->(!EOF())
		aAdd( aItens, {.F.,(qCN9)->CN9_NUMERO , (qCN9)->CN9_REVISA,(qCN9)->CN9_XTIPO, (qCN9)->Z2_DESC,(qCN9)->Z2_NEXTNUM})
		(qCN9)->(DbSkip())
	EndDo
	
	If Len(aItens)==0
		Aviso("Atencao", "Não existe Contratos no sistema com os parâmetro informados.", {"Ok"})
		lErro := .T.
	Endif
Else
	lErro := .T.
EndIf

DbSelectArea(qCN9)
DbCloseArea()

If Len(aItens)==0
	aAdd(aItens,{.F.,"","","","",""})
EndIf

oLbx:SetArray(aItens)
oLbx:bLine:={|| {If(aItens[oLbx:nAt,1],oOk,oNo),aItens[oLbx:nAt,2],aItens[oLbx:nAt,3],aItens[oLbx:nAt,4],aItens[oLbx:nAt,5]}}
oLbx:Refresh()
Return !lErro


Static Function Marca(lMarca)
Local i := 0
For i := 1 To Len(aItens)
	aItens[i][1] := lMarca
Next i
oLbx:Refresh()
Return

Static Function _ProcNewCNF
_cSeqCNF := ''

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Verifica se o contrato existe na tabela de contratos (CN9).  //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
cQryCNF := " SELECT MAX(CNF_NUMERO) as SEQZZF "
cQryCNF += " FROM "+RetSqlName("CNF")+" CNF "
cQryCNF += " WHERE CNF.D_E_L_E_T_ = ' ' "
cQryCNF += " AND CNF.CNF_FILIAL = '" + xFilial("CNF") + "' "

If Select("QRYCNF")<>0
	DbSelectArea("QRYCNF")
	QRYCNF->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQryCNF)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryCNF),"QRYCNF",.F.,.T.)


QRYCNF->(DbGoTop())
If QRYCNF->(!Eof())
	_cSeqCNF := Soma1(QRYCNF->SEQZZF)
Else
	cLog := "Não foi possivel definir a sequencia de contrato."
	Aadd(aDetExcel, {"NÃO PROCESSADO", 'xxx', "ARQUIVO CSV", cLog})
EndIf
Return(_cSeqCNF)
/*
Funcao		: _ExProces
Descricao	: Funcao que trata a execucao da Procedure PROC_COPIA_CONTRATO
Consultoria	: B2Finance
Consultor	: Marcelo Santana
Alteracao    : 13/05/2016

*/
Static function  _ExProces()
Processa({|| _ExRepl()()},'Aguarde...  Replicando contratos!')
MsgInfo("Processo de replica realizado com sucesso!")
oDlgCA:end()
Return
/*
Funcao		: _ExRepl
Descricao	: Executa a funcao de gravacao da procedure conforme parametros na selecao dos dados
Consultoria	: B2Finance
Consultor	: Marcelo Santana
Data Criacao : 13/05/2016

*/
Static Function _ExRepl()

Local nX := 0
Private _cSeqCNF := ''
ProcRegua(Len(aitens))


For nX := 1 To Len(aitens)
	IncProc()
	If aitens[nX,1]
		dbSelectArea("SZ2")
		dbSetOrder(3)
		_NumContr:= aitens[nX,2] //Numero do contrato
		_cRevisa := aitens[nX,3] //Numero da Revisao
		_cTipCont:= SubStr(_NumContr,1,4)
		If MsSeek(xFilial("SZ2")+_cTipCont) //Z2_FILIAL+Z2_COD
			For nI := 1 To nCopy
				_NovoCont:= Posicione("SZ2",1,xFilial("SZ2")+_cTipCont,"Z2_NEXTNUM")  
				_cCronog:= Posicione("CNA",3,xFilial("CNA")+_NumContr+_cRevisa,"CNA_CRONOG")
				_cNovoNum:= SubStr(_NumContr,1,9)+_NovoCont  
				// Define o próximo numero de cronograma apenas se o contrato original possuir
				_cSeqCNF := IIF(Alltrim(_cCronog) = '',space(6),_ProcNewCNF())
				_ProcNow(_NumContr, _NumContr, _cNovoNum,_cSeqCNF ) //Procedure para insert da replica
				RecLock("SZ2",.F.)
				SZ2->Z2_NEXTNUM := Soma1(SZ2->Z2_NEXTNUM,,.T.)
				MsUnLock()
			Next nI
		EndIf
	Endif
Next
dbclosearea("SZ2")
Return
/*
Funcao		: _ProcNow
Descricao	: Funcao que trata a execucao da Procedure PROC_COPIA_CONTRATO
Consultoria	: B2Finance
Consultor	: Marcelo Santana
Alteracao    : 13/05/2016

*/
Static Function _ProcNow( _cContrI, _cContrF, _cContrN, _nSeqCNFN )
Local aResult	:= {}
Local aArea 	:= {}
Local cQuery :=" 	CREATE OR REPLACE PROCEDURE PROC_COPIA_CONTRATO(pCONTRADE in varchar2, pCONTRAATE in varchar2,  pCONTNOVO in varchar2, pSEQCNF in varchar2  	" + CRLF
cQuery +="  )	" + CRLF
cQuery +=" 	as	" + CRLF
cQuery +=" 	vRECNO integer;	" + CRLF
cQuery +=" 	vNUMSEQ varchar2(4000);	" + CRLF
cQuery +=" 	vCAMPOSCN9 varchar2(4000);	" + CRLF
cQuery +=" 	vCAMPOSCN9B varchar2(4000);	" + CRLF
cQuery +=" 	ultimo_campoCN9 varchar2(4000);	" + CRLF
cQuery +=" 	nVALIDADUPL integer := 0;	" + CRLF
cQuery +=" 	nVALIDADUPL2 integer := 0;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	-----------------------------------------------CONTRATOS ---------------------------------------------------	" + CRLF
cQuery +=" 	cursor cCONTRATO  is SELECT * FROM  CN9000   " + CRLF
cQuery +=" 	            where trim(CN9_NUMERO) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE) 	" + CRLF
cQuery +=" 	            and CN9_REVISA ='   '	" + CRLF
cQuery +=" 	            and D_E_L_E_T_<>'*';	" + CRLF
cQuery +=" 	rCONTRATO cCONTRATO%rowtype;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	-----------------------------------------------------------------------------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	-----------------------------------------------CRONOGRAMA FINANCEIRO --------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	cursor cCRONOGRAMA  is SELECT * FROM  CNF000    	" + CRLF
cQuery +=" 	            JOIN (SELECT  CN9_NUMERO, CN9_REVISA FROM CN9000  	" + CRLF
cQuery +=" 	                     where trim(CN9_NUMERO) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE)	" + CRLF
cQuery +=" 	                    and CN9_REVISA='   '	" + CRLF
cQuery +=" 	                    and D_E_L_E_T_<>'*' ) 	" + CRLF
cQuery +=" 	            ON ( CNF_REVISA=CN9_REVISA)	" + CRLF
cQuery +=" 	            where trim(CNF_CONTRA) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE)	" + CRLF
cQuery +=" 	            and D_E_L_E_T_<>'*';	" + CRLF
cQuery +=" 	rCRONOGRAMA cCRONOGRAMA%rowtype;	" + CRLF
cQuery +=" 	------------------------------------------------------------------------------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	-----------------------------------------------AMARRACACAO USUARIO --------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	cursor cUSUARIO  is SELECT * FROM  CNN000   	" + CRLF
cQuery +=" 	            JOIN (SELECT CN9_NUMERO, CN9_REVISA FROM CN9000  	" + CRLF
cQuery +=" 	                    where  trim(CN9_NUMERO) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE) 	" + CRLF
cQuery +=" 	                    and CN9_REVISA='   '	" + CRLF
cQuery +=" 	                    and D_E_L_E_T_<>'*' ) 	" + CRLF
cQuery +=" 	                ON (  CNN_REVISA=CN9_REVISA )" + CRLF
cQuery +=" 	             where  trim(CNN_CONTRA) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE)	" + CRLF
cQuery +=" 	            and D_E_L_E_T_<>'*';	" + CRLF
cQuery +=" 	rUSUARIO cUSUARIO%rowtype;	" + CRLF
cQuery +=" 	------------------------------------------------------------------------------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	----------------------------------------------- CABECALHO DE PLANILHA  -------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	cursor cPLANILHA  is SELECT * FROM  CNA000    	" + CRLF
cQuery +=" 	            JOIN (SELECT  CN9_NUMERO, CN9_REVISA FROM CN9000  	" + CRLF
cQuery +=" 	                    where trim(CN9_NUMERO) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE) 	" + CRLF
cQuery +=" 	                    and CN9_REVISA='   '	" + CRLF
cQuery +=" 	                    and D_E_L_E_T_<>'*' ) 	" + CRLF
cQuery +=" 	             ON (   CNA_REVISA=CN9_REVISA)            	" + CRLF
cQuery +=" 	            where  trim(CNA_CONTRA) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE)	" + CRLF
cQuery +=" 	             and D_E_L_E_T_<>'*';	" + CRLF
cQuery +=" 	rPLANILHA cPLANILHA%rowtype;	" + CRLF
cQuery +=" 	--------------------------------------------------------------------------------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	----------------------------------------------- Itens das Planilhas Contratos  -------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	cursor cITEMPLANILHA  is SELECT * FROM  CNB000    	" + CRLF
cQuery +=" 	            JOIN (SELECT CN9_NUMERO, CN9_REVISA FROM CN9000  	" + CRLF
cQuery +=" 	                        where  trim(CN9_NUMERO) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE) 	" + CRLF
cQuery +=" 	                    and CN9_REVISA='   '	" + CRLF
cQuery +=" 	                    and D_E_L_E_T_<>'*' )	" + CRLF
cQuery +=" 	               ON ( CNB_REVISA=CN9_REVISA)    	" + CRLF
cQuery +=" 	           where  trim(CNB_CONTRA) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE)	" + CRLF
cQuery +=" 	            and D_E_L_E_T_<>'*';	" + CRLF
cQuery +=" 	rITEMPLANILHA cITEMPLANILHA%rowtype;	" + CRLF
cQuery +=" 	--------------------------------------------------------------------------------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	----------------------------------------------- Amarracao Fornec x Contratos    ------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	cursor cAMARRACAO  is SELECT * FROM  CNC000    	" + CRLF
cQuery +=" 	            JOIN (SELECT CN9_NUMERO, CN9_REVISA FROM CN9000  	" + CRLF
cQuery +=" 	                    where trim(CN9_NUMERO) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE)	" + CRLF
cQuery +=" 	                    and CN9_REVISA='   ' " + CRLF
cQuery +=" 	                    and D_E_L_E_T_<>'*' ) 	" + CRLF
cQuery +=" 	            ON ( CNC_REVISA=CN9_REVISA)    	" + CRLF
cQuery +=" 	           where trim(CNC_NUMERO) BETWEEN TRIM(pCONTRADE) and TRIM(pCONTRAATE)	" + CRLF
cQuery +=" 	            and D_E_L_E_T_<>'*';	" + CRLF
cQuery +=" 	rAMARRACAO cAMARRACAO%rowtype;	" + CRLF
cQuery +=" 	--------------------------------------------------------------------------------------------------------------	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	begin	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    open cCONTRATO;	" + CRLF
cQuery +=" 	      loop	" + CRLF
cQuery +=" 	      fetch cCONTRATO into  rCONTRATO;	" + CRLF
cQuery +=" 	      exit when cCONTRATO%notfound;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	        select MAX(R_E_C_N_O_) into vRECNO from CN9000;	" + CRLF
cQuery +=" 	        vRECNO := vRECNO + 1;	" + CRLF
cQuery +=" 	    	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	                 	" + CRLF
cQuery +=" 	        INSERT INTO CN9000(CN9_NUMERO, CN9_XTIPO, CN9_DTINIC, CN9_DTASSI, CN9_VIGE, CN9_UNVIGE, CN9_DTFIM,CN9_XUNIDR, CN9_XCODUS,	" + CRLF
cQuery +=" 	                    CN9_CLIENT, CN9_LOJACL, CN9_MOEDA, CN9_CONDPG, CN9_CODOBJ, CN9_TPCTO, CN9_VLINI, CN9_VLATU,	" + CRLF
cQuery +=" 	                    CN9_INDICE, CN9_FLGREJ, CN9_REVISA, CN9_FLGCAU, CN9_TPCAUC, CN9_MINCAU, CN9_DTENCE, CN9_TIPREV,	" + CRLF
cQuery +=" 	                    CN9_REVATU, CN9_SALDO, CN9_MOTPAR, CN9_DTFIMP, CN9_DTREIN, CN9_CODJUS,  CN9_CODCLA, CN9_DTREV,	" + CRLF
cQuery +=" 	                    CN9_DTREAJ, CN9_VLREAJ, CN9_VLADIT, CN9_NUMTIT, CN9_VLMEAC, CN9_TXADM, CN9_FORMA,  CN9_DTENTR,	" + CRLF
cQuery +=" 	                    CN9_LOCENT, CN9_CODENT, CN9_DESFIN, CN9_CONTFI, CN9_DTINPR, CN9_PERPRO,   CN9_UNIPRO, 	" + CRLF
cQuery +=" 	                    CN9_VLRPRO, CN9_DTPROP, CN9_DTULST, CN9_DTINCP, CN9_SITUAC, CN9_DESCRI, CN9_END, CN9_MUN,    CN9_BAIRRO,	" + CRLF
cQuery +=" 	                    CN9_EST, CN9_ALCISS, CN9_INSSMO, CN9_DIACTB,  CN9_NODIA, CN9_INSSME, CN9_XFOR, CN9_XDTASS,	" + CRLF
cQuery +=" 	                    CN9_XDTPAG, CN9_XMESRE,CN9_XCLIEN, CN9_VLDCTR, CN9_APROV, CN9_PROXAV, CN9_CODED, CN9_USUAVA, CN9_PROGRA,	" + CRLF
cQuery +=" 	                    CN9_NUMPR, CN9_ULTAVA, CN9_DTVIGE, D_E_L_E_T_,  R_E_C_N_O_, CN9_TPCONT, CN9_XGESTO,CN9_XCODGE , R_E_C_D_E_L_,	" + CRLF
cQuery +=" 	                    CN9_RESREM /*, CN9_XPROJE ,CN9_XTAREF*/) 	" + CRLF
cQuery +=" 	            values (pCONTNOVO, rcontrato.CN9_XTIPO, rcontrato.CN9_DTINIC, rcontrato.CN9_DTASSI, 	" + CRLF
cQuery +=" 	                    rcontrato.CN9_VIGE, rcontrato.CN9_UNVIGE, rcontrato.CN9_DTFIM, rcontrato.CN9_XUNIDR, rcontrato.CN9_XCODUS, rcontrato.CN9_CLIENT, rcontrato.CN9_LOJACL, rcontrato.CN9_MOEDA, 	" + CRLF
cQuery +=" 	                    rcontrato.CN9_CONDPG, rcontrato.CN9_CODOBJ, rcontrato.CN9_TPCTO, rcontrato.CN9_VLINI, rcontrato.CN9_VLATU, rcontrato.CN9_INDICE,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_FLGREJ, rcontrato.CN9_REVISA, rcontrato.CN9_FLGCAU,rcontrato.CN9_TPCAUC, rcontrato.CN9_MINCAU, rcontrato.CN9_DTENCE,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_TIPREV, rcontrato.CN9_REVATU, rcontrato.CN9_SALDO, rcontrato.CN9_MOTPAR, rcontrato.CN9_DTFIMP, rcontrato.CN9_DTREIN, 	" + CRLF
cQuery +=" 	                    rcontrato.CN9_CODJUS, rcontrato.CN9_CODCLA, rcontrato.CN9_DTREV, rcontrato.CN9_DTREAJ, rcontrato.CN9_VLREAJ, rcontrato.CN9_VLADIT,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_NUMTIT, rcontrato.CN9_VLMEAC, rcontrato.CN9_TXADM, rcontrato.CN9_FORMA, rcontrato.CN9_DTENTR, rcontrato.CN9_LOCENT,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_CODENT, rcontrato.CN9_DESFIN, rcontrato.CN9_CONTFI, rcontrato.CN9_DTINPR, rcontrato.CN9_PERPRO, rcontrato.CN9_UNIPRO,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_VLRPRO, rcontrato.CN9_DTPROP, rcontrato.CN9_DTULST, rcontrato.CN9_DTINCP, '02', rcontrato.CN9_DESCRI,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_END, rcontrato.CN9_MUN, rcontrato.CN9_BAIRRO, rcontrato.CN9_EST, rcontrato.CN9_ALCISS, rcontrato.CN9_INSSMO, 	" + CRLF
cQuery +=" 	                    rcontrato.CN9_DIACTB, rcontrato.CN9_NODIA, rcontrato.CN9_INSSME, rcontrato.CN9_XFOR, rcontrato.CN9_XDTASS, rcontrato.CN9_XDTPAG,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_XMESRE, rcontrato.CN9_XCLIEN, '2', rcontrato.CN9_APROV, rcontrato.CN9_PROXAV, rcontrato.CN9_CODED,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_USUAVA, rcontrato.CN9_PROGRA, rcontrato.CN9_NUMPR,	" + CRLF
cQuery +=" 	                    rcontrato.CN9_ULTAVA, rcontrato.CN9_DTVIGE, ' ',  vRECNO, rcontrato.CN9_TPCONT, rcontrato.CN9_XGESTO,rcontrato.CN9_XCODGE ,	" + CRLF
cQuery +=" 	                    0, rcontrato.CN9_RESREM /*,  rcontrato.CN9_XPROJE , rcontrato.CN9_XTAREF*/);	" + CRLF
cQuery +=" 	          commit;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	      end loop;	" + CRLF
cQuery +=" 	 close cCONTRATO;	" + CRLF
cQuery +=" 	 	" + CRLF
cQuery +=" 	  open cCRONOGRAMA;	" + CRLF
cQuery +=" 	  loop	" + CRLF
cQuery +=" 	  fetch cCRONOGRAMA into  rCRONOGRAMA;	" + CRLF
cQuery +=" 	    exit when cCRONOGRAMA%notfound;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    select MAX(R_E_C_N_O_) into vRECNO from CNF000;	" + CRLF
cQuery +=" 	    vRECNO := vRECNO + 1 ;	" + CRLF
//cQuery +=" 	    cSeqCNF := _cSeqCNF ;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    insert into CNF000(CNF_NUMERO,CNF_CONTRA,CNF_PARCEL,CNF_COMPET,CNF_VLPREV,CNF_VLREAL,CNF_SALDO,	" + CRLF
cQuery +=" 	                        CNF_DTVENC,CNF_PRUMED,CNF_MAXPAR,CNF_REVISA,CNF_PERANT,CNF_DTREAL,CNF_TXMOED,CNF_PERIOD,CNF_DIAPAR,	" + CRLF
cQuery +=" 	                        CNF_CONDPG,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_)	" + CRLF
//cQuery +="   values(rCRONOGRAMA.CNF_NUMERO,pCONTNOVO,rCRONOGRAMA.CNF_PARCEL,rCRONOGRAMA.CNF_COMPET,	" + CRLF
cQuery +=" 	    values(pSEQCNF,pCONTNOVO,rCRONOGRAMA.CNF_PARCEL,rCRONOGRAMA.CNF_COMPET,	" + CRLF
cQuery +=" 	    rCRONOGRAMA.CNF_VLPREV,rCRONOGRAMA.CNF_VLREAL,rCRONOGRAMA.CNF_SALDO,rCRONOGRAMA.CNF_DTVENC,rCRONOGRAMA.CNF_PRUMED,	" + CRLF
cQuery +=" 	    rCRONOGRAMA.CNF_MAXPAR,rCRONOGRAMA.CNF_REVISA,rCRONOGRAMA.CNF_PERANT,rCRONOGRAMA.CNF_DTREAL,rCRONOGRAMA.CNF_TXMOED,	" + CRLF
cQuery +=" 	    rCRONOGRAMA.CNF_PERIOD,rCRONOGRAMA.CNF_DIAPAR,rCRONOGRAMA.CNF_CONDPG,' ',vRECNO,0);	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	commit;	" + CRLF
cQuery +=" 	END LOOP;	" + CRLF
cQuery +=" 	CLOSE cCRONOGRAMA;	" + CRLF
cQuery +=" 	  open cUSUARIO;	" + CRLF
cQuery +=" 	  loop	" + CRLF
cQuery +=" 	  fetch cUSUARIO into  rUSUARIO;	" + CRLF
cQuery +=" 	    exit when cUSUARIO%notfound;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    select MAX(R_E_C_N_O_) into vRECNO from CNN000;	" + CRLF
cQuery +=" 	    vRECNO := vRECNO + 1 ;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    insert into CNN000(CNN_CONTRA,CNN_USRCOD,CNN_GRPCOD,CNN_TRACOD,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_)	" + CRLF
cQuery +=" 	    values(pCONTNOVO,rUSUARIO.CNN_USRCOD,rUSUARIO.CNN_GRPCOD,rUSUARIO.CNN_TRACOD,' ',vRECNO,0);	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	commit;	" + CRLF
cQuery +=" 	END LOOP;	" + CRLF
cQuery +=" 	CLOSE cUSUARIO;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	  open cPLANILHA;	" + CRLF
cQuery +=" 	  loop	" + CRLF
cQuery +=" 	  fetch cPLANILHA into  rPLANILHA;	" + CRLF
cQuery +=" 	    exit when cPLANILHA%notfound;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    select MAX(R_E_C_N_O_) into vRECNO from CNA000;	" + CRLF
cQuery +=" 	    vRECNO := vRECNO + 1;    	" + CRLF
cQuery +=" 	    	" + CRLF
cQuery +=" 	    insert into CNA000 (CNA_CONTRA,CNA_NUMERO,CNA_REVISA,CNA_FORNEC,CNA_LJFORN,CNA_CLIENT,CNA_LOJACL,CNA_DTINI,	" + CRLF
cQuery +=" 	                        CNA_VLTOT,CNA_SALDO,CNA_TIPPLA,CNA_DTFIM,CNA_CRONOG,CNA_ESPEL,CNA_FLREAJ,	" + CRLF
cQuery +=" 	                        CNA_DTMXMD,CNA_CRONCT,CNA_VLCOMS,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_)	" + CRLF
cQuery +=" 	          values        (pCONTNOVO,rPLANILHA.CNA_NUMERO,rPLANILHA.CNA_REVISA,rPLANILHA.CNA_FORNEC,	" + CRLF
cQuery +=" 	                         rPLANILHA.CNA_LJFORN,rPLANILHA.CNA_CLIENT,rPLANILHA.CNA_LOJACL,rPLANILHA.CNA_DTINI,	" + CRLF
cQuery +=" 	                        rPLANILHA.CNA_VLTOT,rPLANILHA.CNA_SALDO,rPLANILHA.CNA_TIPPLA,rPLANILHA.CNA_DTFIM,	" + CRLF    
cQuery +=" 	                       pSEQCNF,rPLANILHA.CNA_ESPEL,rPLANILHA.CNA_FLREAJ,rPLANILHA.CNA_DTMXMD,	" + CRLF
//cQuery +=" 	                        rPLANILHA.CNA_CRONOG,rPLANILHA.CNA_ESPEL,rPLANILHA.CNA_FLREAJ,rPLANILHA.CNA_DTMXMD,	" + CRLF
cQuery +=" 	                        rPLANILHA.CNA_CRONCT,rPLANILHA.CNA_VLCOMS,' ',vRECNO,0) ;	" + CRLF
									
cQuery +=" 	    	" + CRLF                                                                                             
cQuery +=" 	    commit;	" + CRLF
cQuery +=" 	    end loop;	" + CRLF
cQuery +=" 	CLOSE cPLANILHA;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	  open cITEMPLANILHA;	" + CRLF
cQuery +=" 	  loop	" + CRLF
cQuery +=" 	  fetch cITEMPLANILHA into  rITEMPLANILHA;	" + CRLF
cQuery +=" 	    exit when cITEMPLANILHA%notfound;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    select MAX(R_E_C_N_O_) into vRECNO from CNB000;	" + CRLF
cQuery +=" 	    vRECNO := vRECNO + 1;  	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	INSERT INTO CNB000 (CNB_NUMERO,CNB_REVISA,CNB_ITEM,CNB_PRODUT,CNB_DESCRI,CNB_UM,CNB_QUANT,CNB_REALI,CNB_DTREAL,CNB_VLTOTR,	" + CRLF
cQuery +=" 	CNB_VLUNIT,CNB_VLTOT,CNB_NATURE,CNB_CC,CNB_CONTA,CNB_DESC,CNB_VLDESC,CNB_CODMEN,CNB_DTANIV,CNB_CONORC,CNB_CONTRA,	" + CRLF
cQuery +=" 	CNB_DTCAD,CNB_DTPREV,CNB_QTDMED,CNB_CONTA,CNB_PERC,CNB_RATEIO,CNB_TIPO,CNB_ITSOMA,CNB_PRCORI,CNB_QTDORI,CNB_QTRDAC,	" + CRLF
cQuery +=" 	CNB_QTRDRZ,CNB_QTREAD,CNB_VLREAD,CNB_VLRDGL,CNB_PERCAL,CNB_FILHO,CNB_SLDMED,CNB_NUMSC,CNB_ITEMSC,CNB_QTDSOL,CNB_SLDREC,	" + CRLF
cQuery +=" 	CNB_FLGCMS,CNB_TE,CNB_TS,CNB_COPMED,CNB_ULTAVA,CNB_PROXAV,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,CNB_ITMDST,CNB_ITEMCT,	" + CRLF
cQuery +=" 	CNB_TABPRC,CNB_GERBIN,CNB_BASINS,CNB_ITEMCT,CNB_CLVL,CNB_EC05DB,CNB_EC05CR)	" + CRLF
cQuery +=" 	values(rITEMPLANILHA.CNB_NUMERO,rITEMPLANILHA.CNB_REVISA,rITEMPLANILHA.CNB_ITEM,rITEMPLANILHA.CNB_PRODUT,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_DESCRI,rITEMPLANILHA.CNB_UM,rITEMPLANILHA.CNB_QUANT,rITEMPLANILHA.CNB_REALI,rITEMPLANILHA.CNB_DTREAL,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_VLTOTR,rITEMPLANILHA.CNB_VLUNIT,rITEMPLANILHA.CNB_VLTOT,rITEMPLANILHA.CNB_NATURE,rITEMPLANILHA.CNB_CC,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_CONTA,rITEMPLANILHA.CNB_DESC,rITEMPLANILHA.CNB_VLDESC,rITEMPLANILHA.CNB_CODMEN,rITEMPLANILHA.CNB_DTANIV,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_CONORC,pCONTNOVO,rITEMPLANILHA.CNB_DTCAD,rITEMPLANILHA.CNB_DTPREV,rITEMPLANILHA.CNB_QTDMED,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_CONTA,rITEMPLANILHA.CNB_PERC,rITEMPLANILHA.CNB_RATEIO,rITEMPLANILHA.CNB_TIPO,rITEMPLANILHA.CNB_ITSOMA,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_PRCORI,rITEMPLANILHA.CNB_QTDORI,rITEMPLANILHA.CNB_QTRDAC,rITEMPLANILHA.CNB_QTRDRZ,rITEMPLANILHA.CNB_QTREAD,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_VLREAD,rITEMPLANILHA.CNB_VLRDGL,rITEMPLANILHA.CNB_PERCAL,rITEMPLANILHA.CNB_FILHO,rITEMPLANILHA.CNB_SLDMED,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_NUMSC,rITEMPLANILHA.CNB_ITEMSC,rITEMPLANILHA.CNB_QTDSOL,rITEMPLANILHA.CNB_SLDREC,rITEMPLANILHA.CNB_FLGCMS,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_TE,rITEMPLANILHA.CNB_TS,rITEMPLANILHA.CNB_COPMED,rITEMPLANILHA.CNB_ULTAVA,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_PROXAV,' ' ,vRECNO, 0,rITEMPLANILHA.CNB_ITMDST,rITEMPLANILHA.CNB_ITEMCT,	" + CRLF
cQuery +=" 	rITEMPLANILHA.CNB_TABPRC,rITEMPLANILHA.CNB_GERBIN,rITEMPLANILHA.CNB_BASINS,rITEMPLANILHA.CNB_ITEMCT,rITEMPLANILHA.CNB_CLVL,rITEMPLANILHA.CNB_EC05DB,rITEMPLANILHA.CNB_EC05CR);	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	commit;	" + CRLF
cQuery +=" 	END LOOP;	" + CRLF
cQuery +=" 	CLOSE cITEMPLANILHA;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	  open cAMARRACAO;	" + CRLF
cQuery +=" 	  loop	" + CRLF
cQuery +=" 	  fetch cAMARRACAO into  rAMARRACAO;	" + CRLF
cQuery +=" 	    exit when cAMARRACAO%notfound;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	    select MAX(R_E_C_N_O_) into vRECNO from CNC000;	" + CRLF
cQuery +=" 	    vRECNO := vRECNO + 1;  	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	INSERT INTO CNC000(CNC_NUMERO,CNC_CODIGO,CNC_LOJA,CNC_CODED,CNC_NUMPR,D_E_L_E_T_,R_E_C_N_O_,R_E_C_D_E_L_,CNC_REVISA)	" + CRLF
cQuery +=" 	values (pCONTNOVO,rAMARRACAO.CNC_CODIGO,rAMARRACAO.CNC_LOJA,rAMARRACAO.CNC_CODED,	" + CRLF
cQuery +=" 	rAMARRACAO.CNC_NUMPR,' ',vRECNO,0,rAMARRACAO.CNC_REVISA);	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	commit;	" + CRLF
cQuery +=" 	end loop;	" + CRLF
cQuery +=" 	CLOSE cAMARRACAO;	" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 		" + CRLF
cQuery +=" 	end;	"

If TCGetDB()=="ORACLE"
	If TCSQLEXEC(cQuery) < 0
		Alert("Houve falha na Criação da Procedure")
	Else
		_nSeqCNFN := _cSeqCNF
		alresult := TCSPEXEC("PROC_COPIA_CONTRATO",  _cContrI, _cContrF, _cContrN,_nSeqCNFN )
	endif
Else
	MsgInfo("Procedimento preparado apenas para ORACLE. Nenhum Processo será realizado")
EndIf
Return            
