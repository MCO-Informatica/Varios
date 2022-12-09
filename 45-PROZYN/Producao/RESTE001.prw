#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'


#DEFINE CRLF CHR(13)+CHR(10)
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RESTE001 ³ Autor ³ Adriano Leonardo    ³ Data ³ 11/07/2016 ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Tela para definição da atividade do lote, chamada em diver-º±±
±±º          ³ sos pontos do sistema.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico para a empresa Prozyn               			  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RESTE001(_cProduto, _cLocal ,_cLote, _cSubLote)

Local _cRotina		:= "RESTE001"
Local _aSavArea		:= GetArea()
Local _aSavSB8		:= SB8->(GetArea())
Local _aSavSZ1		:= SZ1->(GetArea())
Local _aSavSD5		:= SD5->(GetArea())
Local _nCont		:= 1
Local cQuery		:= ""
Default _cProduto 	:= SD5->D5_PRODUTO
Default _cLocal		:= SD5->D5_LOCAL
Default _cLote		:= SD5->D5_LOTECTL
Default	_cSubLote	:= SD5->D5_NUMLOTE


/*
aC
•aC[n,1] = Nome da Variável Ex.:"_nAtivid"
•aC[n,2] = Array com coordenadas do Get [x,y], em Windows estão em PIXEL
•aC[n,3] = Titulo do Campo
•aC[n,4] = Picture
•aC[n,5] = Validação
•aC[n,6] = F3
•aC[n,7] = Se campo é editavel .T. se não .F.

aR
•aR[n,1] = Nome da Variável Ex.:"_nAtivid"
•aR[n,2] = Array com coordenadas do Get [x,y], em Windows estão em PIXEL
•aR[n,3] = Titulo do Campo
•aR[n,4] = Picture
•aR[n,5] = Validação
•aR[n,6] = F3
•aR[n,7] = Se campo é editavel .T. se não .F.
*/

nOpcx:=3
//+-----------------------------------------------+
//¦ Montando aHeader para a Getdados              ¦
//+-----------------------------------------------+

_aFields:= {"B8_PRODUTO", "B8_LOCAL", "B8_LOTEFOR", "B8_LOTECTL", "B8_NUMLOTE", "B8_DATA", "B8_DFABRIC", "B8_QTDORI", "B8_SALDO", "B8_DTVALID", "B8_DOC", "B8_SERIE", "B8_CLIfOR"}
nUsado	:=0
aHeader	:={}

For _nCont := 1 To Len(_aFields)
	dbSelectArea("SX3")
	dbSetOrder(2) //Campo
	If dbSeek(_aFields[_nCont])
		If X3USO(x3_usado) .AND. cNivel >= x3_nivel
			nUsado:=nUsado+1
			AADD(aHeader,{ TRIM(x3_titulo),x3_campo,;
			x3_picture,x3_tamanho,x3_decimal,;
			".F.",x3_usado,;
			x3_tipo, x3_arquivo, x3_context } )
		EndIf
	EndIf
Next
//+-----------------------------------------------+
//¦ Montando aCols para a GetDados                ¦
//+-----------------------------------------------+

aCols:=Array(1,nUsado+1)
nUsado:=0

//Caso a chamada seja pela rotina de manutenção do lote, o registro já se encontra posicionado
If FunName() == "MATA390"
	_cProduto 	:= SD5->D5_PRODUTO
	_cLocal		:= SD5->D5_LOCAL
	_cLote		:= SD5->D5_LOTECTL
	_cSubLote	:= SD5->D5_NUMLOTE
EndIf	

dbSelectArea("SB8")
dbSetOrder(3)
If dbSeek(xFilial("SB8")+_cProduto+_cLocal+_cLote+_cSubLote)
	For _nCont := 1 To Len(_aFields)
		dbSelectArea("SX3")
		dbSetOrder(2) //Campos
		If dbSeek(_aFields[_nCont])
			If X3USO(x3_usado) .AND. cNivel >= x3_nivel
				nUsado:=nUsado+1
				If nOpcx == 3
					aCOLS[1][nUsado] := SB8->&(_aFields[_nCont])
				EndIf
			EndIf
		EndIf
	Next	
EndIf

aCOLS[1][nUsado+1] := .F.

//+----------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2           ¦
//+----------------------------------------------+
dbSelectArea("SZ1")
dbSetOrder(1)
If SZ1->(dbSeek(xFilial("SZ1")+_cProduto+_cLocal+_cLote+_cSubLote))
	_nAtivid	:= SZ1->Z1_ATIVIDA
	_cUnid		:= SZ1->Z1_UNIDADE
Else
	_nAtivid	:= CriaVar("Z1_ATIVIDA")
	_cUnid		:= CriaVar("Z1_UNIDADE")
EndIf

//+----------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2
//+----------------------------------------------+
nLinGetD:=0

//+----------------------------------------------+
//¦ Titulo da Janela                             ¦
//+----------------------------------------------+
cTitulo:="Controle de Atividade"

//+----------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho  ¦
//+----------------------------------------------+
aC:={}

#IFDEF WINDOWS
	AADD(aC,{"_nAtivid" ,{015,010} ,"Atividade",PesqPict("SZ1","Z1_ATIVIDA"),"Positivo() .And. NaoVazio()","",})
	AADD(aC,{"_cUnid"   ,{015,200} ,"Unidade","@!","NaoVazio()",,})
#ELSE
	AADD(aC,{"_nAtivid" ,{006,005} ,"Atividade",PesqPict("SZ1","Z1_ATIVIDA"),"Positivo() .And. NaoVazio()","",})
	AADD(aC,{"_cUnid"   ,{006,040} ,"Unidade","@!","NaoVazio()",,})
#ENDIf

//+-------------------------------------------------+
//¦ Array com descricao dos campos do Rodape        ¦
//+-------------------------------------------------+
aR:={}

#IfDEF WINDOWS 
	AADD(aR,{"nLinGetD" ,{120,10},"Linha na GetDados", "@E 999",,,.F.})
#ELSE 
	AADD(aR,{"nLinGetD" ,{19,05},"Linha na GetDados","@E 999",,,.F.})
#ENDIf

//+------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2   ¦
//+------------------------------------------------+
#IFDEF WINDOWS
	aCGD:={44,5,118,315}
#ELSE
	aCGD:={10,04,15,73}
#ENDIF

//+----------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2           ¦
//+----------------------------------------------+
cLinhaOk := ".T."
cTudoOk  := ".T."

//+----------------------------------------------+
//¦ Chamada da Modelo2                           ¦
//+----------------------------------------------+
// lRet = .t. se confirmou
// lRet = .f. se cancelou

If Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,{},,,,,.F.,.T.)

	cQuery	:= " SELECT *  
	cQuery 	+= " FROM "+RetSqlName("SD5")+" SD5 " + CRLF
	cQuery 	+= " WHERE D5_LOTECTL = '"+ SD5->D5_LOTECTL + "'" + CRLF
	cQuery 	+= " AND D5_PRODUTO  = '"+ SD5->D5_PRODUTO + "'" + CRLF
	
	If Select("TMP") > 0
	       TMP->( dbCloseArea() )
	EndIf  
	
	dbUseArea( .T., "TopConn", TCGenQry(,,cQuery), "TMP", .F., .F. )
 

	dbSelectArea("SZ1") //Controle de atividade
	dbSetOrder(1) //Filial + Produto + Armazém + Lote + Sub-lote
	
	If Select("TMP") > 0
	
		TMP->( dbGoTop() )
		While TMP->( !Eof() )
	
			If dbSeek(xFilial("SZ1")+ TMP->D5_PRODUTO + TMP->D5_LOCAL + TMP->D5_LOTECTL + TMP->D5_NUMLOTE)
				RecLock("SZ1",.F.)
					SZ1->Z1_ORIGEM	:= "SD5"
					SZ1->Z1_ATIVIDA	:= _nAtivid
					SZ1->Z1_UNIDADE	:= _cUnid
					SZ1->Z1_USER	:= UsrRetName(__cUserID)
					SZ1->Z1_DATA	:= dDataBase
					SZ1->Z1_HORA	:= Time()
				SZ1->(MsUnlock())
			Else
				RecLock("SZ1",.T.)
					SZ1->Z1_FILIAL := xFilial("SZ1")
					SZ1->Z1_PRODUTO := TMP->D5_PRODUTO 	//SD5->D5_PRODUTO
					SZ1->Z1_LOCAL	:= TMP->D5_LOCAL 	//SD5->D5_LOCAL
					SZ1->Z1_LOTECTL	:= TMP->D5_LOTECTL	//SD5->D5_LOTECTL
					SZ1->Z1_NUMLOTE	:= TMP->D5_NUMLOTE	//SD5->D5_NUMLOTE
					SZ1->Z1_ORIGEM	:= "SD5"
					SZ1->Z1_ATIVORI := _nAtivid
					SZ1->Z1_ATIVIDA	:= _nAtivid
					SZ1->Z1_UNIDADE	:= _cUnid
					SZ1->Z1_USER	:= UsrRetName(__cUserID)
					SZ1->Z1_DATA	:= dDataBase
					SZ1->Z1_HORA	:= Time()
				SZ1->(MsUnlock())
			EndIf
			
			//Atualiza a atividade 
			U_PZCVA003(TMP->D5_PRODUTO, TMP->D5_LOCAL, TMP->D5_LOTECTL, TMP->D5_NUMLOTE, _nAtivid )
		
		TMP->( dbSkip() )
		Enddo
		
	Endif

EndIf

RestArea(_aSavSB8)
RestArea(_aSavSZ1)
RestArea(_aSavSD5)
RestArea(_aSavArea)

Return()