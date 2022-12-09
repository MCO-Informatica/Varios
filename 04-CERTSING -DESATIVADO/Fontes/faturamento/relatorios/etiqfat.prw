#Include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 05/07/00
#include "TOPCONN.CH"       
//#INCLUDE "ETIQMD.CH"

User Function Etiqfat()        // incluido pelo assistente de conversao do AP5 IDE em 05/07/00

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CBTXT,CSTRING,AORD,CDESC1,CDESC2,CDESC3")
SetPrvt("LEND,ARETURN,NOMEPROG,AMALADIR,NLASTKEY,CPERG")
SetPrvt("AINFO,AT_PRG,WCABEC0,WCABEC1,WCABEC2,CONTFL")
SetPrvt("LI,NTAMANHO,TITULO,WNREL,NORDEM,CFILDE")
SetPrvt("CFILATE,CCCDE,CCCATE,CMATDE,CMATATE,CNOMEDE")
SetPrvt("CNOMEATE,CCHAPADE,CCHAPAATE,CSITUACAO,CCATEGORIA,DDATAREF")
SetPrvt("NCOLUNAS,CINICIO,CFIM,CINDCOND,CFOR,CARQNTX")
SetPrvt("CHAVE,NCOL,NALIN,CFILIALANT,CCCANT")
SetPrvt("CTIPO")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ETIQFAT   � Autor � Eugenio Arcanjo      � Data � 30/11/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Etiqueta para Mala Diretao                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RdMake                                                     ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Basicas)                            �
//����������������������������������������������������������������
CbTxt   := ""     //Ambiente
cString := "SF2"  // alias do arquivo principal (Base)
//aOrd    := {STR0001,STR0002,STR0003,STR0004} //"Matricula"###"Centro de Custo"###"Nome"###"Chapa"
cDesc1  := "Emiss�o de Etiquetas P/ Mala Direta"
cDesc2  := "Ser� impresso de acordo com os parametros solicitados pelo"
cDesc3  := "usu�rio."
   
//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
lEnd     := .F.
aReturn  := {"Zebrado",1,"Administ",2,2,1,"",1 }     //"Zebrado"###"Administra��o"
NomeProg := "ETIQFAT"
aVetor   := {}
nLastKey := 0
cPerg    := "ETIQFT"
   
//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
aInfo := {}
   
//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
AT_PRG   := "ETIQFT"
wCabec0  := 2
wCabec1  := ""
wCabec2  := ""
Contfl   := 1
Li       := 0
nTamanho := "M"

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/
cAcessaSF2	:= &( " { || " + ChkRH( "ETIQMD" , "SF2" , "2" ) + " } " )
 
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
validperg()

pergunte("ETIQFT",.T.)
   
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  N. Fiscal DE                             �
//� mv_par02        //  N. Fiscal Ate                            �
//������������
����������������������������������������������������
Titulo := "EMISS�O DE ETIQUETAS P/ MALA DIRETA"
   
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="ETIQFAT"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.)
   
If nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif
Li := 3
RptStatus({|| ETIQImp(wCabec1,wCabec2,Titulo,Li) },Titulo)      

//RptStatus({||ETIQImp()})// Substituido pelo assistente de conversao do AP5 IDE em 05/07/00 ==>    RptStatus({||Execute(GR360Imp)})
Return Nil
// Substituido pelo assistente de conversao do AP5 IDE em 05/07/00 ==>    function GR360Imp
//EITQUETA EUGENIO
Static function ETIQimp(wCabec1,wCabec2,Titulo,Li) //ETIQImp()

Local T
   
//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem     := aReturn[8]
cNFDe      := mv_par01
cNFAte     := mv_par02

   
Chave      := 0
Li         := PROW()
nCol       := 1
nAlin      := 0
i          := 0
aAdd(aVetor,{" "," "," "," "," "," "," "," "," "," "," "," "})
cFilialAnt := "  "
cCcAnt     := Space(9)

lOk := CalcParc()
If !lOk
	Alert('N�o foi encontrado nenhum registro para o relat�rio')
	Return
EndIf

SetRegua(TRBVIEW->(RecCount()))

TRBVIEW->(dbGoTop())
While !TRBVIEW->(EOF())
  	//���������������������������������������������������������������������Ŀ
   	//� Verifica o cancelamento pelo usuario...                             �
   	//�����������������������������������������������������������������������
	If lAbortPrint
      	@Li,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      	Exit
   	Endif
    
	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
   	//����������������������������������������������������������������
   	IncRegua()

	nAlin++           
	IF !EMPTY(MV_PAR07)
        aVetor[nAlin,1]:= Padc(AllTrim(MV_PAR07),42,Space(1))
	ENDIF
	aVetor[nAlin,2]:= " "
	aVetor[nAlin,3]:= Padc(RTrim(TRBVIEW->A1_NOME),42,Space(1))
	aVetor[nAlin,4]:= Padc(RTrim(TRBVIEW->A1_END),42,Space(1))
	aVetor[nAlin,5]:= Padc("CEP: " + TRBVIEW->A1_CEP + " - BAIRRO: " + TRBVIEW->A1_BAIRRO,42,Space(1))
	aVetor[nAlin,6]:= Padc(ALLTRIM(TRBVIEW->A1_MUN) + "/" + ALLTRIM(TRBVIEW->A1_EST),42,Space(1))
	cTipo:= "I"
	FChkETFAT()
	TRBVIEW->(dbSkip())
Enddo      
TRBVIEW->(DbCloseArea())

cTipo:="F"

Set Device To Screen
   
If aReturn[5] == 1
	Set Printer To
	dbCommit()
	OurSpool(WnRel)
EndIf
   
MS_FLUSH()
/*
�����������������������������������������������������������������������������
VERIFICA AS PERGUNTAS INCLUINDO-AS CASO NAO EXISTAM		
�����������������������������������������������������������������������������*/
Static Function ValidPerg()

Local aArea := GetArea()

aRegs:={}  

aAdd(aRegs,{cPerg,"01","N.Fiscal De"		,"N.Fiscal De"		,"N.Fiscal De"	    ,"mv_ch1"	,"C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","N.Fiscal Ate"	    ,"N.Fiscal Ate"		,"N.Fiscal Ate"	 	,"mv_ch2"	,"C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"03","Serie  De"	        ,"Serie  De"		,"Serie  De"	 	,"mv_ch3"	,"C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Serie  Ate"	        ,"Serie  Ate"		,"Serie  Ate"	 	,"mv_ch4"	,"C",03,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Cliente  De"	    ,"Cliente De"		,"Cliente De"	 	,"mv_ch5"	,"C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Cliente Ate"	    ,"Cliente Ate"		,"Cliente Ate"	 	,"mv_ch6"	,"C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","A/C "	            ,"A/C      "		,"A/C        "	 	,"mv_ch7"	,"C",20,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})


dbSelectArea("SX1")
dbSetOrder(1)
For i:=1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[i,2]))
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		SX1->(MsUnlock())
	Endif
Next  

RestArea(aArea)

Return
/*
�����������������������������������������������������������������������������
ARQUIVO TEMPORARIO
�����������������������������������������������������������������������������*/
Static Function CalcParc()
Local aArea := GetArea()
Local _lRet := .T.

cQry := "SELECT A1.A1_NOME, A1.A1_END, A1.A1_COD, A1.A1_BAIRRO, A1.A1_CEP, A1.A1_EST, A1.A1_MUN, "
cQry += " F2.F2_DOC, F2.F2_SERIE,F2.F2_CLIENTE,F2.F2_LOJA "
cQry += " FROM "+RetSqlName("SA1")+" A1, "+RetSqlName("SF2")+" F2"
cQry += " WHERE F2.F2_DOC BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'" 
cQry += " AND F2.F2_SERIE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" 
cQry += " AND F2.F2_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
cQry += " AND F2.D_E_L_E_T_ = ' ' AND F2.F2_FILIAL = '"+xFilial("SF2")+"'"
cQry += " AND F2.F2_CLIENTE = A1.A1_COD"
cQry += " AND F2.F2_LOJA    = A1.A1_LOJA"
cQry += " AND A1.D_E_L_E_T_ = ' ' " // AND A1.A1_FILIAL = '"+xFilial("SA1")+"'"  
//cQry += " AND A2.D_E_L_E_T_ = ' '  AND A2.A2_FILIAL = '"+xFilial("SA2")+"'"
cQry += " ORDER BY F2.F2_SERIE, F2.F2_DOC, F2.F2_CLIENTE"
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQry), "TRBVIEW", .F., .T.)
            
TRBVIEW->(dbGoTop())
if TRBVIEW->(EOF())
	_lRet := .F.    
	TRBVIEW->(DbCloseArea())
endif

RestArea(aArea)

Return _lRet   
//////////////////////////
Static Function FChkETFAT()
Local C
Local I
nColunas:= 1
If (cTipo == "I" .And. nAlin == nColunas) .Or. (cTipo == "F" .And. nAlin > 0)
	For C:= 1 To 12  // numero de Linha por etiqueta
		nCol:=0
		For I:= 1 To nColunas       
			 @ Li,nCol PSAY aVetor[I,C]
			 nCol := nCol + 56
			 aVetor[I,C]:= " "
		Next
		Li := Li + 1
	Next

	nAlin:=0              

Endif

If cTipo == "F"
	@ Li, 0 PSAY " "
Endif	

Return(nil)