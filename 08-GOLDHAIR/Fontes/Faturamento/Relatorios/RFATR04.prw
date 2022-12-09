#INCLUDE "Protheus.ch"  
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFATR04   � Autor � Anderson Goncalves � Data �  11/12/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Impressao de duplicatas parametrizadas                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GoldHair                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFATR04()

//���������������������������������������������������������������������Ŀ
//� Variaveis da Rotina                                                 �
//����������������������������������������������������������������������� 
Local lContinua	:= .T. 
Local nCont		:= 0  
Local Titulo	:= "Impress�o de Duplicatas"
Private oPrint 	:= Nil
Private aRegs	:= {}
Private cPerg	:= "RFATR04"    

//���������������������������������������������������������������������Ŀ
//� Monta as perguntas para a impressao                                 �
//�����������������������������������������������������������������������  
aAdd(aRegs,{cPerg,"01",	"Prefixo" 			,"","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Titulo Inicial"   	,"","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","Titulo Final"		,"","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })

//���������������������������������������������������������������������Ŀ
//� Cria as perguntas no SX1 se nao existir                             �
//�����������������������������������������������������������������������
ValidPerg(cPerg,aRegs)
If !(pergunte(cPerg,.T.))
	Return Nil
EndIf      

dbSelectArea("SE1")
SE1->(dbSetOrder(1))
 
//���������������������������������������������������������������������Ŀ
//� Imprime as duplicatas                                               �
//�����������������������������������������������������������������������
cQuery := "SELECT R_E_C_N_O_ RECSE1 FROM " + RetSqlName("SE1") + " (NOLOCK) "
cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery += "AND E1_PREFIXO = '" + mv_par01 + "' "
cQuery += "AND E1_NUM BETWEEN '" + mv_par02 + "' AND '" + mv_par03 + "' "
cQuery += "AND D_E_L_E_T_ = ' ' "

If Select("QRYSE1") > 0
	QRYSE1->(dbCloseArea())
EndIf

TcQuery cQuery New Alias "QRYSE1"
dbSelectArea("QRYSE1")
QRYSE1->(dbGoTop()) 
QRYSE1->(dbEval({ || nCont++},,{ ||!EOF()}))  
QRYSE1->(dbGoTop())  

ProcRegua(nCont)

If nCont == 0
	Aviso("RFATR04","N�o existem titulos a serem impressos com a parametriza��o informada!",{"&Ok"},2,"Aten��o")
Else     

	oPrint  := TMSPrinter():New(Titulo)
	//oPrint  :SetLandScape()					//Modo paisagem
	oPrint:SetPortrait()                   //Modo retrato

	If !oPrint:IsPrinterActive()
		oPrint:Setup()
	EndIf

	If !oPrint:IsPrinterActive()
		Aviso("Aten��o","N�o foi Poss�vel Imprimir o Relat�rio, pois n�o h� Nenhuma Impressora Conectada.",{"OK"})
		Return(Nil)
	EndIf    
	
	While QRYSE1->(!EOF())  
	
		SE1->(dbGoTo(QRYSE1->RECSE1))
	
		IncProc("Processando titulos, aguarde!...") 
		
		U_RFATR02("SE1",SE1->(Recno()),4)
		
		QRYSE1->(dbSkip())
	
	Enddo 
	
	oPrint:Preview() 
	//oPrint:SaveAllAsJPEG("TFATR09",1000,700,100)     
	Set Device To Screen
	MS_FLUSH()
	oPrint := Nil
	
EndIf  

If Select("QRYSE1") > 0
	QRYSE1->(dbCloseArea())
EndIf

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg � Autor � Anderson Goncalves � Data �  11/12/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Gerador das perguntas dentro do SX1                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � GoldHair                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg(cPerg,aRegs)

//���������������������������������������������������������������������Ŀ
//� Variaveis da Rotina                                                 �
//�����������������������������������������������������������������������
Local i 	:= 0
Local j 	:= 0
Local aArea := GetArea()

dbSelectArea("SX1")
SX1->(dbSetOrder(1))

For i:= 1 to Len(aRegs)
	If SX1->(!dbSeek(PadR(cPerg,Len(SX1->X1_GRUPO))+aRegs[i,2] ))
		RecLock("SX1", .T.)
		For j := 1 to Len(aRegs[1])
			FieldPut(j,aRegs[i,j])
		Next j
		MsUnlock()
	EndIf
Next i

RestArea(aArea)

Return Nil

