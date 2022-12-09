#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������ı�
���Rdmake	 � EtiqProd �Autor  � Magh Moura            � Data � 16.05.06  ��
���			 �          �Modif  � Magh Moura            � Data � 25/09/06  ��
���			 �          �Modif  � SUPORTE               � Data � 21/02/07  ��
��������������������������������������������������������������������������ı�
���Descri��o � Rotina de impressao de etiquetas codigo de Barras	       ��
���          � do cadastro de produtos x Lote.                 			   ��
��������������������������������������������������������������������������ͱ�
���Uso       � Minexco Com. Imp. Exp. Ltda.                                ��
��������������������������������������������������������������������������ı�
���Conf.Impr.� ELTRON LP2142. (Configurar esse drive de impressao sempre)  ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION Etiq()

Local cCmd, bExecok	:= .F.
Local lRet			:= .T.

cPerg      := "EST06R"  // Nome da Pergunte
//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������

If !Pergunte(cPerg,.T.)
	lRet	:=	.f.
EndIF

BuscaEtiq()

If lRet
	dbSelectArea("TEMP")
	dbGoTop()
	ProcRegua(RecCount())
	
	If Eof()
		MsgBox("N�o h� etiquetas a imprimir.","Etiquetas","Stop")
		dbSelectArea("TEMP")
		dbCloseArea("TEMP")
		Return
	EndIf
	
	MSCBPRINTER("ELTRON","LPT1",,63,.f.,) //Setei Impressora Eltron pois OS 214 ou ARGOX ou ALLEGRO nao imprime nada.
	MSCBLOADGRF("ETIQ.PCX")
	MSCBCHKSTATUS(.F.) //status da impressora, se .F. imprime mesmo com problema de impressora, se .T. nao imprime
	MSCBINFOETI("Etiqueta Produto","")
	MSCBWRITE("H10"+CHR(13)+CHR(10))  //aumenta a temperatura da impressora
	
	ProcRegua(TEMP->(RecCount()))
	
	While  ! TEMP->(eof())
		
		If !Empty(TEMP->Z3_CNPJ)
			_cCNPJ := Subs(TEMP->Z3_CNPJ,1,2)+"."+Subs(TEMP->Z3_CNPJ,3,3)+"."+Subs(TEMP->Z3_CNPJ,6,3)+"/"+Subs(TEMP->Z3_CNPJ,9,4)+"-"+Subs(TEMP->Z3_CNPJ,13,2)
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
		MSCBSAY(05,05,Iif(!Empty(TEMP->Z3_NOME),TEMP->Z3_NOME,Iif(mv_par04==1,"KENIA","ONITEX")),"N","4","2,2")
		//MSCBSAY(20,14,TEMP->Z3_NOME,"N","2","1,1")
		MSCBSAY(05,21,"Lote:","N","2","1,1")
		MSCBSAY(15,21,TEMP->Z3_LOTE,"N","2","1,1")
		MSCBSAY(34,21,"OP:","N","2","1,1")
		MSCBSAY(39,21,TEMP->Z3_PARTIDA,"N","2","1,1")
		MSCBSAY(50,21,"Rev:","N","2","1,1")
		MSCBSAY(55,21,TEMP->Z3_REVISOR,"N","2","1,1")
		MSCBSAY(05,28,"Artigo:","N","2","1,1")
		MSCBSAY(15,28,TEMP->Z3_ARTIGO,"N","2","1,1")
		MSCBSAY(30,28,"Cor:","N","2","1,1")
		MSCBSAY(40,28,TEMP->Z3_COR,"N","2","1,1")
		MSCBSAY(50,28,"Qtde:","N","2","1,1")
		MSCBSAY(60,28,Transform(TEMP->Z3_QUANTID,"@E 999,999,999.99"),"N","2","1,1")
		MSCBSAYBAR(73,33,ALLTRIM(TEMP->Z3_LOTE),'N','MB07',08,.F.,.T.,.F.,,2,2,,,,.T.)
		MSCBSAY(05,35,"Compos:","N","2","1,1")
		MSCBSAY(15,35,TEMP->Z3_COMP,"N","2","1,1")
		MSCBSAY(05,42,"CNPJ:","N","2","1,1")
		MSCBSAY(15,42,_cCNPJ,"N","2","1,1")
		MSCBSAY(20,47,"**** RECLAMACOES SOMENTE COM ESTA ETIQUETA ****","N","2","1,1")
		MSCBSAY(05,63,"","N","2","1,1")
		MSCBEND()
		
		
		dbSelectArea("SZ3")
		dbSetOrder(1)
		dbSeek(TEMP->(Z3_FILIAL+Z3_LOTE+Z3_ARTIGO+Z3_COR),.f.)
	
		RecLock("SZ3",.F.)
		SZ3->Z3_IMP	:=	"S"
		MsUnLock()

		dbSelectArea("TEMP")
		dbSkip()
	EndDo
	
	dbSelectArea("TEMP")
	dbCloseArea("TEMP")
	
Else
	msgalert("Voce Cancelou a Opera��o.")
EndIf


Return


Static Function BuscaEtiq()

cQuery := "SELECT * FROM SZ3010 "
cQuery += "WHERE D_E_L_E_T_ = '' "
If !Empty(mv_par01)
	cQuery += "AND Z3_LOTE BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
Else
	cQuery += "AND Z3_IMP <> 'S' "
EndIf
If !Empty(mv_par03)
	cQuery += "AND Z3_CLIENTE <> '"+MV_PAR03+"' "
EndIf

cQuery += "ORDER BY Z3_LOTE"


cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TEMP", .F., .T.)

Return

