#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFAT001    บAutor  ณMicrosiga           บ Data ณ  06/14/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Faturamento Sintetico.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ                  3
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function VSUS001()
Private aOrd         := {}
Private CbTxt        := ""
Private cDesc1       := "Este programa gera um relat๓rio de cadastros clientes."
Private cDesc2       := ""
Private cDesc3       := ""
Private cPict        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "VSUS01"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "VSUS01    "
Private titulo       := "CADASTRO DE CLIENTES E PROSPECT"
Private nLin         := 80
Private Cabec1       := "Nome                                     End                                      Tel             Contato      Ul.P.Vda  Dt.Ul.Orca"
//                         1234567890123456789012345678901234567890 1234567890123456789012345678901234567890 123456789012345 1234567890 99/99/99  99/99/99
//                         12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                                  1         2         3         4         5         6         7         8         9         0         1         2         3
Private Cabec2       := ""
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private imprime      := .T.
Private wnrel        := "VSUS01"
Private cString      := "SA1"

_cOmInsc := ""

//Pesquisa as perguntas selecionadas.
ValidPerg()
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
Titulo := "Cadastros - " + DTOC(DDATABASE)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
nTipo := If(aReturn[4]==1,15,18)
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
PROCESSA O RELATORIO
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem 
_ADADOS := {}
_aStru  := {}

// CAMPOS DA TABELA TEMPORARIA
AADD(_aStru,{"T_NOM"     ,"C",40,0})
AADD(_aStru,{"T_END"     ,"C",40,0})
AADD(_aStru,{"T_MUN"     ,"C",15,5})
AADD(_aStru,{"T_BAI"     ,"C",30,0})
AADD(_aStru,{"T_CEP"     ,"C",08,0})
AADD(_aStru,{"T_EST"     ,"C",02,0})
AADD(_aStru,{"T_DDI"     ,"C",06,0})
AADD(_aStru,{"T_DDD"     ,"C",06,0})
AADD(_aStru,{"T_TEL"     ,"C",15,0})
AADD(_aStru,{"T_FAX"     ,"C",15,0})
AADD(_aStru,{"T_CONTATO" ,"C",30,0})
AADD(_aStru,{"T_TELCON"  ,"C",15,0})
AADD(_aStru,{"T_CELCON"  ,"C",15,0})
AADD(_aStru,{"T_FAXCON"  ,"C",15,0})
AADD(_aStru,{"T_ORIG"    ,"C",03,0})
AADD(_aStru,{"T_VEND1"   ,"C",06,0})
AADD(_aStru,{"T_NOM1"  	 ,"C",30,0})
AADD(_aStru,{"T_VEND2"   ,"C",06,0})
AADD(_aStru,{"T_NOM2"  	 ,"C",30,0})
AADD(_aStru,{"T_DTVDA"   ,"D",08,0})
AADD(_aStru,{"T_DTORC"   ,"D",08,0})

_cPath   := "\SPOOL\"
_cNomArq := "CADAST.xls"

// CRIA A TABELA TEMPORARIA...                                                                                          
dbcreate(_cPath+_cNomArq,_aStru)
dbusearea(.T.,,_cPath+_cNomArq,"NFS",.T.,.F.)

// CADASTRO DE CLIENTE
DbSelectArea("SA1")
cQuery := "SELECT * "
cQuery += "FROM "
cQuery += RetSqlName("SA1") + " SA1 "
cQuery += "WHERE "
cQuery += "SA1.A1_EST >= '"+mv_par01+"' AND "
cQuery += "SA1.A1_EST <= '"+mv_par02+"' AND "
cQuery += "SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
cQuery += "SA1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY SA1.A1_EST"

cQuery := ChangeQuery(cQuery)

TCQUERY cQuery NEW ALIAS "CQUERY"

DbSelectArea("CQUERY")
DbGoTop()
SetRegua(RecCount())

While !Eof()
	IncRegua() // Termometro de Impressao
	
	If lAbortPrint
		@nLin,00 PSAY '*** CANCELADO PELO OPERADOR ***'
		Exit
	Endif
	
	_COD     := cQuery->A1_COD+cQuery->A1_LOJA
	_NOM     := cQuery->A1_NOME
	_END     := cQuery->A1_END
	_MUN     := cQuery->A1_MUN
	_BAI     := cQuery->A1_BAIRRO
	_CEP     := cQuery->A1_CEP
	_EST     := cQuery->A1_EST
	_DDI     := cQuery->A1_DDI
	_DDD     := cQuery->A1_DDD
	_TEL     := cQuery->A1_TEL
	_FAX     := cQuery->A1_FAX
	_VEND1   := cQuery->A1_VEND
	_NOM1    := POsicione("SA3",1,xFilial("SA3")+cQuery->A1_VEND,"A3_NOME")
	_VEND2   := cQuery->A1_VEND2
	_NOM2    := POsicione("SA3",1,xFilial("SA3")+cQuery->A1_VEND2,"A3_NOME")
	_CONTATO := ""
	_TELCON  := ""
	_CELCON  := ""
	_FAXCON  := ""
	_ORIG    := "CLI"
	_CXX     := ""
	_DPRICOM := _ACPVDCV(cQuery->A1_COD,cQuery->A1_LOJA)
	_DDTORC  := _ACORCCV(cQuery->A1_COD,cQuery->A1_LOJA)
	

    // TABELA DE Relacao de Contatos x Entidade
	dbSelectArea("AC8")
	dbSetOrder(2)
	dbSeek(Xfilial("AC8")+"SA1  "+_COD)
	_CXX := AC8->AC8_CODCON
	

    // TABELA DE CONTATO - SU5
	dbSelectArea("SU5")
	dbSetORder(1)
	dbSeek(xFilial("SU5")+_CXX)
	_contato := SU5->U5_CONTAT
	_telcon  := SU5->U5_FONE
	_CELCON  := SU5->U5_CELULAR
	_FAXCON  := SU5->U5_FAX
	
	DbSelectArea("NFS")
	RecLock("NFS",.T.)
	T_NOM     := _NOM
	T_END     := _END
	T_MUN     := _MUN
	T_BAI     := _BAI
	T_CEP     := _CEP
	T_EST     := _EST
	T_DDI     := _DDI
	T_DDD     := _DDD
	T_TEL     := _TEL
	T_FAX     := _FAX
	T_CONTATO := _CONTATO
	T_TELCON  := _TELCON
	T_CELCON  := _CELCON
	T_FAXCON  := _FAXCON
	T_ORIG    := _ORIG
	T_VEND1	  := _VEND1
	T_NOM1	  := _NOM1
	T_VEND2	  := _VEND2
	T_NOM2	  := _NOM2
	T_DTVDA   := _DPRICOM
	T_DTORC   := _DDTORC
	MsUnLock("NFS")

    // ARRAY PARA GERAR O EXCELL DIRETO
	AADD(_aDados,{_NOM,_END,_MUN,_BAI,_CEP,_EST,_DDI,_DDD,_TEL,_FAX,_CONTATO,_TELCON,_CELCON,_FAXCON,_ORIG,_VEND1,_NOM1,_VEND2,_NOM2,_DPRICOM,_DDTORC})
	
	DbSelectArea("cQuery")
	DbSkip()
End

// TABELA DE Prospects                     
DbSelectArea("SUS")
cQuery1 := "SELECT * "
cQuery1 += "FROM "
cQuery1 += RetSqlName("SUS") + " SUS "
cQuery1 += "WHERE "
cQuery1 += "SUS.US_EST >= '"+mv_par01+"' AND "
cQuery1 += "SUS.US_EST <= '"+mv_par02+"' AND "
cQuery1 += "SUS.US_STATUS <> '6' AND "
cQuery1 += "SUS.US_CODCLI = ' ' AND "
cQuery1 += "SUS.US_MSBLQL <> '1' AND "
cQuery1 += "SUS.US_FILIAL = '"+xFilial("SUS")+"' AND "
cQuery1 += "SUS.D_E_L_E_T_ = ' ' "
cQuery1 += "ORDER BY SUS.US_EST"

cQuery1 := ChangeQuery(cQuery1)

TCQUERY cQuery1 NEW ALIAS "CQUERY1"

DbSelectArea("CQUERY1")
DbGoTop()
SetRegua(RecCount())

While !Eof()
	IncRegua() // Termometro de Impressao
	
	If lAbortPrint
		@nLin,00 PSAY '*** CANCELADO PELO OPERADOR ***'
		Exit
	Endif
	
	_COD     := cQuery1->US_COD+cQuery1->US_LOJA
	_NOM     := cQuery1->US_NOME
	_END     := cQuery1->US_END
	_MUN     := cQuery1->US_MUN
	_BAI     := cQuery1->US_BAIRRO
	_CEP     := cQuery1->US_CEP
	_EST     := cQuery1->US_EST
	_DDI     := cQuery1->US_DDI
	_DDD     := cQuery1->US_DDD
	_TEL     := cQuery1->US_TEL
	_FAX     := cQuery1->US_FAX
	_VEND1   := cQuery1->US_VEND
	_NOM1    := POsicione("SA3",1,xFilial("SA3")+cQuery1->US_VEND,"A3_NOME")
	_VEND2   :=Space(6)
	_NOM2    :=Space(30)
	_CONTATO := ""
	_TELCON  := ""
	_CELCON  := ""
	_FAXCON  := ""
	_ORIG    := "PRO"
	_CXX     := ""
	_DPRICOM := CTOD("  /  /  ")
	_DDTORC  := CTOD("  /  /  ")
	
	dbSelectArea("AC8")
	dbSetOrder(2)
	dbSeek(Xfilial("AC8")+"SUS  "+_COD)
	_CXX := AC8->AC8_CODCON
	
	dbSelectArea("SU5")
	dbSetORder(1)
	dbSeek(xFilial("SU5")+_CXX)
	_contato := SU5->U5_CONTAT
	_telcon  := SU5->U5_FONE
	_CELCON  := SU5->U5_CELULAR
	_FAXCON  := SU5->U5_FAX
	
	DbSelectArea("NFS")
	RecLock("NFS",.T.)
	T_NOM     := _NOM
	T_END     := _END
	T_MUN     := _MUN
	T_BAI     := _BAI
	T_CEP     := _CEP
	T_EST     := _EST
	T_DDI     := _DDI
	T_DDD     := _DDD
	T_TEL     := _TEL
	T_FAX     := _FAX
	T_CONTATO := _CONTATO
	T_TELCON  := _TELCON
	T_CELCON  := _CELCON
	T_FAXCON  := _FAXCON
	T_ORIG    := _ORIG
	T_VEND1   := _VEND1
	T_NOM1    := _NOM1
	T_VEND2   := _VEND2
	T_NOM2    := _NOM2
	T_DTVDA   := _DPRICOM
	T_DTORC   := _DDTORC
	MsUnLock("NFS")

    // ARRAY PARA GERAR O EXCELL DIRETO
	AADD(_aDados,{_NOM,_END,_MUN,_BAI,_CEP,_EST,_DDI,_DDD,_TEL,_FAX,_CONTATO,_TELCON,_CELCON,_FAXCON,_ORIG,_VEND1,_NOM1,_VEND2,_NOM2,_DPRICOM,_DDTORC})
	
	DbSelectArea("cQuery1")
	DbSkip()
End


/*
LISTA O ARQUIVO GERADO !!!
*/
DbSelectArea("NFS")
DbGotop()
While !Eof()
	
	If nLin > 55
		nLin   := cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	//         1         2         3         4         5         6         7         8         9         0         1         2         3
	//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//xxxxxxxxxxxxxxx 123456789012345678901234567890123456789012345678901234567890 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99
	
	@ nlin,001 PSAY NFS->T_NOM
	@ nlin,042 PSAY NFS->T_END
	@ nlin,083 PSAY NFS->T_TEL
	@ nlin,099 PSAY Substr(NFS->T_CONTATO,1,10)
	@ nlin,112 psay NFS->T_DTVDA
	@ nlin,121 psay NFS->T_DTORC
	nLin := nLin + 1
	DbSelectArea('NFS')
	DbSkip()
End


DbSelectArea('NFS')
_cArqDest := "\SPOOL\CADASTRO\CADAST.XLS"
Copy to &_cArqDest VIA "DBFCDXADS"

DbSelectArea('NFS')
DbCloseArea('NFS')

DbSelectArea("CQUERY")
DbCloseArea("CQUERY")

DbSelectArea("CQUERY1")
DbCloseArea("CQUERY1")

// FUNCAO QUE GERA A PLANILHA
U_gerxlxr(_aDados)

Set Device To Screen

// Se impressao em disco, chama o gerenciador de impressao...
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFAT001    บAutor  ณMicrosiga           บ Data ณ  06/15/05  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao Validperg para validacao das perguntas do arquivo   บฑฑ
ฑฑบ          ณ SX1                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP7                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs :={}

AADD(aRegs,{cPerg,"01","Do Estado                 ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Estado                ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Else
				exit
			Endif
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(_sAlias)
Return

//============================================//
// ACHA A DATA DO ULTIMO ORCAMENTO COLOCADO   //
//============================================//
STATIC FUNCTION _ACORCCV(_CLIENTE,_LOJA)
_DTACH  := CTOD("  /  /  ")
CQUERY2 := ""

DbSelectArea("SUA")
cQuery2 := "SELECT MAX(UA_EMISSAO) EMIS"
cQuery2 += " FROM "
cQuery2 += RetSqlName("SUA") + " SUA "
cQuery2 += " WHERE "
cQuery2 += " SUA.UA_CLIENTE = '"+_CLIENTE+"' AND "
cQuery2 += " SUA.UA_LOJA = '"+_LOJA+"' AND "
cQuery2 += " SUA.UA_FILIAL = '"+xFilial("SUA")+"' AND "
cQuery2 += " SUA.UA_PROSPEC = 'F' AND SUA.UA_OPER = '2' AND "
cQuery2 += " SUA.D_E_L_E_T_ = ' ' "

cQuery2 := ChangeQuery(cQuery2)

TCQUERY cQuery2 NEW ALIAS "CQUERY2"

DbSelectArea("CQUERY2")
DbGoTop()

_DTACH := STOD(CQUERY2->EMIS)

DbSelectArea("CQUERY2")
DbCloseArea("CQUERY2")
RETURN(_DTACH)


//============================================//
// ACHA A DATA DO ULTIMO PEDIDO DE VENDAS     //
//============================================//
STATIC FUNCTION _ACPVDCV(_CLIENTE,_LOJA)
_DTACH  := CTOD("  /  /  ")
CQUERY3 := ""

DbSelectArea("SC5")
cQuery3 := "SELECT MAX(C5_EMISSAO) EMIS"
cQuery3 += " FROM "
cQuery3 += RetSqlName("SC5") + " SC5 "
cQuery3 += " WHERE "
cQuery3 += " SC5.C5_CLIENTE = '"+_CLIENTE+"' AND "
cQuery3 += " SC5.C5_LOJACLI = '"+_LOJA+"' AND "
cQuery3 += " SC5.C5_FILIAL = '"+xFilial("SUA")+"' AND "
cQuery3 += " SC5.C5_NOTA <> 'XXXXXX' AND "
cQuery3 += " SC5.D_E_L_E_T_ = ' ' "

cQuery3 := ChangeQuery(cQuery3)

TCQUERY cQuery3 NEW ALIAS "CQUERY3"

DbSelectArea("CQUERY3")
DbGoTop()

_DTACH := STOD(CQUERY3->EMIS)

DbSelectArea("CQUERY3")
DbCloseArea("CQUERY3")
RETURN(_DTACH)
                           
//**********************************
USER FUNCTION gerxlxr(aDados)
//**********************************
Local aCabec := {"NOME","ENDERECO","MUNICIPIO","BAIRRO","CEP","ESTADO","DDI","DDD","TELEFONE","FAX","CONTATO","TELEFONE","CELULAR","FAX","ORIGEM","VENDEDOR1","NOME","VENDEDOR2","NOME","DT.UL.P.VDA","DT.UL.ORCAM"}
Local aDados := aDados

If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel esta instalado nessa maquina!")
else
	DlgToExcel({ {"ARRAY", "Relatorio Cadastro Cliente", aCabec, aDados} })
EndIf
Return