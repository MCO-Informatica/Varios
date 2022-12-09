User Function GP410DES()
/*           
Local lRet	:= .F.           

If SUBSTR(SRA->RA_BCDEPSA,1,3)=='001' .AND. MV_PAR34==2
		lRet := .T.              
ElseIf SUBSTR(SRA->RA_BCDEPSA,1,3)<>'001'.AND. MV_PAR34==1
		lRet := .T.                                                   
Else               
		lRet := .F.
Endif
*/
lRet := .T.
Return lRet         