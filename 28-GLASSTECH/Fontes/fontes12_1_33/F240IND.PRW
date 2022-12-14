/*/{Protheus.doc} F240IND
//TODO O retorno do ponto de entrada passa a ser do tipo num?rico, tornando necess?rio indicar o n?mero do ?ndice padr?o (SIX) a ser considerado. Obs: Caso o ?ndice seja alfanum?rico (exemplo: A, B, C), o retorno do ponto de entrada deve seguir a mesma regra da fun??o "DBSetOrder", ou seja, o retorno deve ser num?rico.
@author Pirolo
@since 29/07/2019
@version undefined
@return return, return_description
@see http://tdn.totvs.com/pages/releaseview.action?pageId=6071532
/*/
User Function F240IND()
Local aAreaSE2 := SE2->(GetArea())
LOCAL xIndTemp := { CriaTrab( , .F. ) }

If AllTrim(GetRPORelease()) < "12.1.017"
	SE2->( dbOrderNickName('VALOR') )
	
	IndRegua( cAliasSE2, xIndTemp[1], SE2->( IndexKey() ), , , 'Indexando arquivo....' )
else
	SE2->( dbOrderNickName('VALOR') )
	xIndTemp := SE2->(GetArea())[2]
	RestArea(aAreaSE2) 
EndIf

Return xIndTemp
