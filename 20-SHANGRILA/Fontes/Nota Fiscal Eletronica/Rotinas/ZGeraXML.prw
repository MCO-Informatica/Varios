#INCLUDE "Totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO5     � Autor � Jo�o Zabotto       � Data �  23/02/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � 		                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������               
/*/

User Function ZGeraXML()      

Local  aIndArq   := {}
Private cCondicao	:= ""
Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString   := "SF2"
Private cPerg     := "ZGRZML"
Private cCadastro := "Cadastro de . . ."
Private aRotina   := { {"Pesquisar"		,"AxPesqui",0,1} ,;
					   {"Visualizar"	,"AxVisual",0,2} ,;
                       {"Gera XML"		,"U_PegaXML",0,3}}

ValidPerg(cPerg)

Pergunte(cPerg,.T.)
SetKey(123,{|| Pergunte(cPerg,.T.)}) // Seta a tecla F12 para acionamento dos parametros

If mv_par01 == 1
	cString:= "SF2"
	cCondicao := "F2_SERIE = '"+Mv_Par02 +"'"
	dbSelectArea(cString)
	dbSetOrder(1)
	
Else
	cString:= "SF1"
    cCondicao := "F1_SERIE = '"+Mv_Par02+"'"
	dbSelectArea(cString)
	dbSetOrder(1)
EndIf                                               

//����������������������������������������������������Ŀ
//�Realiza a Filtragem: Pela Serie MV_PAR02   �
//������������������������������������������������������
                         
bFiltraBrw := {|| FilBrowse(cString,@aIndArq,@cCondicao) }
Eval(bFiltraBrw)           

mBrowse( 6,1,22,75,cString)

EndFilBrw( cString , @aIndArq ) //Finaliza el Filtro
 
//mBrowse( 6,1,22,75,cString)

Set Key 123 To // Desativa a tecla F12 do acionamento dos parametros

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     �Autor  �Microsiga           � Data �  09/13/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PegaXML()
Local aDados := {}
Local aTmp   := {}
Local aRet   := {}

If mv_par01 == 1
	cTipo    := "1"
	cSerie   := SF2->F2_SERIE
	cNota    := SF2->F2_DOC
	cClieFor := SF2->F2_CLIENTE
	cLoja    := SF2->F2_LOJA
Else
	cTipo    := "2"
	cSerie   := SF1->F1_SERIE
	cNota    := SF1->F1_DOC
	cClieFor := SF1->F1_FORNECE
	cLoja    := SF1->F1_LOJA
EndIf

aDados := {cTipo,"",cSerie,cNota,cClieFor,cLoja,"","",{}}


MsAguarde({|| U_GetXml(aDados)},"Aguarde...","Gerando XML",.T.)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TESTE1    �Autor  �Microsiga           � Data �  10/06/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GetXml(aDados)

If ExistBlock("XmlNfeSef")
	aRet := ExecBlock("XmlNfeSef",.F.,.F.,{aDados,"3.10",{""},{"",""}})
EndIf

Memowrite("c:\TEMP\Xml_Nota_"+Alltrim(aDados[4])+"-"+Alltrim(aDados[3])+".xml",aRet[2])

Aviso("Arquivo Gerado","Xml Gerado no caminho C:\ com o nome de " + " Xml_Nota_"+Alltrim(aDados[4])+"-"+Alltrim(aDados[3])+".xml", {"OK"})

Return

Static Function ValidPerg(cPerg)

Local sAlias 	:= Alias()
Local aRegs 	:= {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Tipo NFe:","Tipo NFe:","Tipo NFe:","MV_CH1","C",1,0,2,"C","","MV_PAR01","Saida","Saida","Saida","","","Entrada","Entrada","Entrada","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Serie NFe:","Serie NFe:","Serie NFe:","MV_CH2","C",03,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek (cPerg + aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(sAlias)
Return()
