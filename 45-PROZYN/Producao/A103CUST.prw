#INCLUDE 'Protheus.ch'
#INCLUDE 'TOPCONN.ch'    


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A103CUST  �Autor  Denis Varella        � Data �  12/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada chamado MATA103 por para manipular o      ���
���    .     � custo nas 5 moedas                                         ���
���          � aRet := {{0,0,0,0,0}}                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Comparar o custo medio com o custo standard                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A103CUST()
Local aRet      := PARAMIXB[1] 
Local nCustoUN  := 0  //Custo unitario na moeda 1 
Local cPictCus  := PesqPict("SB1","B1_CUSTD")
Local nI        := 0
Local _cRemet	:= Trim(GetMV("MV_RELACNT"))	
Local cPorcen	:= GetMV("MV_CUSPCNT")
Local _cDest    := SuperGetMv('MV_EMAITRG',, 'ricardo@prozyn.com.br')
Local _cAssunto := 'Custo de entrada divergente da margem estipulada ' + SD1->D1_DOC + " em " + DToC(dDataBase)
Local _aAnexos 	:= ''
Local _cPasta   := ''
Local aArea   	:= getArea()
 
//��������������������������������������������������������������Ŀ
//� Fazer somente quando for uma entrada por devolucao           �
//����������������������������������������������������������������
//If (SD1->D1_TIPO == "D") .AND. SF4->F4_PODER3 <> "D"

//If  Trim(SD1->D1_CF) $ Trim(GetMV("MV_CUSCFOP"))
If  Trim(SD1->D1_CF) $ Trim(GetMV("MV_CUSCFOP")) .or. Trim(SD1->D1_TP) $ Trim(GetMV("MV_CUSTPPR")) .or. SF4->F4_ESTOQUE == "N" //incluso regra do f4_estoque conforme solicita��o da M�rcia Soares

ELSE	
	nCustoUN := aRet[1][1]/SD1->D1_QUANT  
	
	cQuery := "select top 1 (B9_CM1-(B9_CM1/100*"+cPorcen+")) min,(B9_CM1+(B9_CM1/100*"+cPorcen+")) max from "+RetSqlName('SB9')+" where B9_COD = '"+SD1->D1_COD+"' and B9_CM1 != 0 order by B9_DATA DESC"    
	
	If SELECT("TMPSB9") > 0
	TMPSB9->(DbCloseArea()) 
	Endif
				
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPSB9",.T.,.F.)
				
	dbSelectArea("TMPSB9")
	
	If ((nCustoUN < TMPSB9->min .OR. nCustoUN > TMPSB9->max) .and. nCustoUN != 0 .and. TMPSB9->max != 0)
	    Alert("Aten��o! O custo do produto "+POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")+" est� incorreto. Procure o departamento respons�vel. NF: " +SD1->D1_DOC+"/"+SD1->D1_SERIE+" Item: "+SD1->D1_ITEM)
	    
	    _cMsg := "<p>Produto "+POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")+" com custo divergente da margem estipulada:</p><hr/>"
	    _cMsg += "<table>"
	    _cMsg += 	"<tr>"
	    _cMsg += 		"<td style='background-color:#eee;padding:5px 10px;border-bottom:1px dashed #ccc;width:100px;'>NF</td><td style='background-color:#eee;padding:5px 10px;border-bottom:1px dashed #ccc;width:300px;'>Produto<td><td style='background-color:#eee;padding:5px 10px;border-bottom:1px dashed #ccc;width:65px;'>Custo</td><td style='background-color:#eee;padding:5px 10px;border-bottom:1px dashed #ccc;width:65px;'>M�nimo</td><td style='background-color:#eee;padding:5px 10px;border-bottom:1px dashed #ccc;width:65px;'>M�ximo</td>"
	    _cMsg += 	"</tr>"
	    _cMsg += 	"<tr>"
	    _cMsg += 		"<td style='padding:5px 10px;'>"+SD1->D1_DOC+"</td><td style='padding:5px 10px;'>"+POSICIONE("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")+"<td><td style='padding:5px 10px;'><b style='color:#F00;'>"+Transform(nCustoUN,"@E 999,999.99")+"</b></td><td style='padding:5px 10px;'>"+Transform(min,"@E 999,999.99")+"</td><td style='padding:5px 10px;'>"+Transform(max,"@E 999,999.99")+"</td>"
	    _cMsg += 	"</tr>"
	    _cMsg += "</table>"
			
		U_ENVMAIL(_cRemet, _cDest, _cAssunto, _cMsg, _aAnexos, _cPasta)
	EndIf
	TMPSB9->(DbCloseArea()) 
	 
EndIf     

RestArea(aArea)

Return aRet




