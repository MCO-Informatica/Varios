#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function ZEBRAX()


Local aCampos    := {{"Z3_OK"     ,,"",},;
					{"Z3_LOTE"   ,,"LOTE", "@!"},;
					{"Z3_QUANTID",,"QTDE","@E 999,999,999.99"},;
					{"Z3_ARTIGO" ,,"ARTIGO", "@!"},;
					{"Z3_COR"    ,,"COR", "@!"},;
					{"Z3_PARTIDA",,"OP", "@!"},;
					{"Z3_NOME"   ,,"CLIENTE", "@!"}}

Private cQuery
Private cMarca   := GetMark()
Private bMark    := {|| Mark()}
Private cFiltro	 := ""
Private cCadastro:= "Etiquetas Lote"
Private aRotina := {{"Pesquisar", "AxPesqui",0,1},;
					{"Imprimir", "Execblock('ZEBRAX',.F.,.F.)",0,3}}
Private bMark    := {|| Mark()}

Private cPerg      := "EST06R"

If !Pergunte(cPerg,.T.)
	Return()
Else
	_cQuery :=	""
	_cQuery +=	"SELECT * FROM SZ3010 "
	If !EMPTY(MV_PAR01)
		_cQuery +=	"WHERE Z3_LOTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	Else
		_cQuery +=	"WHERE Z3_IMP <> 'S' "
	EndIf
	_cQuery +=	"ORDER BY Z3_LOTECTL "
	
	MEMOWRIT("C:\SQLREL.txt",_cQuery)
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"SQL", .F., .T.)
EndIF


dbSelectArea("SQL")
dbSetOrder(1)

MarkBrow("SQL","Z3_OK",,aCampos,,cMarca,,,,,)

Return

User Function ZEBRAX()
       
Local cCmd, bExecok	:= .F.

dbSelectArea("SQL")
dbGoTop()
ProcRegua(RecCount())

If Eof()
	MsgBox("Não há etiquetas a imprimir.","Etiquetas","Stop")
	dbSelectArea("SQL")
	dbCloseArea("SQL")
	Return
EndIf

MSCBPRINTER("ELTRON","LPT1",,63,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
MSCBLOADGRF("ETIQ.PCX")
MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
MSCBINFOETI("Etiqueta Produto","")
MSCBWRITE("H10"+CHR(13)+CHR(10))  //aumenta a SZ3eratura da impressora

ProcRegua(SQL->(RecCount()))

While  ! SQL->(eof())
	
    If !Marked("Z3_OK")
        DbSkip()
        Loop
    EndIf

	If !Empty(SQL->Z3_CNPJ)
		_cCNPJ := Subs(SQL->Z3_CNPJ,1,2)+"."+Subs(SQL->Z3_CNPJ,3,3)+"."+Subs(SQL->Z3_CNPJ,6,3)+"/"+Subs(SQL->Z3_CNPJ,9,4)+"-"+Subs(SQL->Z3_CNPJ,13,2)
	ElseIf mv_par04==1
		_cCNPJ := "50.747.674/0001-22"
	Else
		_cCNPJ := "05.567.611/0001-30"
	EndIf
	
	bExecOk:= .T.
	IncProc("Imprimindo Etiqueta...")
	MSCBBEGIN(1,6,63) //Inicio da Imagem da Etiqueta
	MSCBGRAFIC(55,05,"ETIQ")
	//					MSCBGRAFIC(2,3,"ETIQ")
	//					MSCBBOX(05,02,99,48)
	//					MSCBLINEH(10,10,45)
	//					MSCBLINEH(15,15,45)
	//					MSCBLINEV(20,20,05)
	//					MSCBLINEH(20,20,45)
	//					MSCBLINEH(25,25,45)
	//					MSCBLINEV(55,55,48)
	MSCBSAY(05,05,Iif(!Empty(SQL->Z3_NOME),SQL->Z3_NOME,Iif(mv_par04==1,"KENIA","ONITEX")),"N","4","2,2")
	//MSCBSAY(20,14,SQL->Z3_NOME,"N","2","1,1")
	MSCBSAY(05,21,"Lote:","N","2","1,1")
	MSCBSAY(15,21,SQL->Z3_LOTE,"N","2","1,1")
	MSCBSAY(34,21,"OP:","N","2","1,1")
	MSCBSAY(39,21,SQL->Z3_PARTIDA,"N","2","1,1")
	MSCBSAY(50,21,"Rev:","N","2","1,1")
	MSCBSAY(55,21,SQL->Z3_REVISOR,"N","2","1,1")
	MSCBSAY(05,28,"Artigo:","N","2","1,1")
	MSCBSAY(15,28,SQL->Z3_ARTIGO,"N","2","1,1")
	MSCBSAY(30,28,"Cor:","N","2","1,1")
	MSCBSAY(40,28,SQL->Z3_COR,"N","2","1,1")
	MSCBSAY(50,28,"Qtde:","N","2","1,1")
	MSCBSAY(60,28,Transform(SQL->Z3_QUANTID,"@E 999,999,999.99"),"N","2","1,1")
	MSCBSAYBAR(73,33,ALLTRIM(SQL->Z3_LOTE),'N','MB07',08,.F.,.T.,.F.,,2,2,,,,.T.)
	MSCBSAY(05,35,"Compos:","N","2","1,1")
	MSCBSAY(15,35,SQL->Z3_COMP,"N","2","1,1")
	MSCBSAY(05,42,"CNPJ:","N","2","1,1")
	MSCBSAY(15,42,_cCNPJ,"N","2","1,1")
	MSCBSAY(20,47,"**** RECLAMACOES SOMENTE COM ESTA ETIQUETA ****","N","2","1,1")
	MSCBSAY(05,63,"","N","2","1,1")
	MSCBEND()
	
	
	dbSelectArea("SZ3")
	dbSetOrder(1)
	If dbSeek(xFilial("SZ3")+SQL->(Z3_LOTE+Z3_ARTIGO+Z3_COR),.F.)
		RecLock("SZ3",.F.)
		SZ3->Z3_IMP	:=	"S"
		SZ3->Z3_OK	:=	""
		MsUnLock()
	EndIf
	
	dbSelectArea("SQL")
	dbSkip()
EndDo

dbSelectArea("SQL")
dbCloseArea("SQL")

Return
