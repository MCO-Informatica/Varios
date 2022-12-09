#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LP530    º Autor ³                    º Data ³  21/10/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ LP 530 -                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico MAKENI                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LP530(_cseq)

	Local _aArea  := GetArea()
	Local _nValor := 0                  


	If _cseq == '001'
		IF ALLTRIM(SE5->E5_TIPO)=="PA" .OR. SE5->E5_MOTBX$'DAC/VEN/PCC/FAT' .OR. ALLTRIM(SE5->E5_NATUREZ)$'218009/218005/218010/218012/218015/218016/218019/PCC/PIS/COFINS/CSLL/INSS/IRF/ISS'
			_nValor := 0                      
		Else  
			IF ALLTRIM(SE5->E5_NATUREZ)$'222013/222014'
				_nValor := SE5->E5_VALOR       
			Else
				_nValor := (SE5->E5_VALOR+SE5->E5_VLDESCO)-(SE5->E5_VLMULTA+SE5->E5_VLJUROS)       
			Endif	
		Endif
	Endif

	If _cseq == '002'  
		IF ALLTRIM(SE5->E5_TIPO)=="PA" .OR. SE5->E5_MOTBX$'DAC/VEN/PCC/FAT' .OR. ALLTRIM(SE5->E5_NATUREZ)$'218005/PCC/PIS/COFINS/CSLL/INSS/IRF/ISS'
			_nValor := 0
		Else
			_nValor := SE5->E5_VLJUROS
		Endif
	Endif    

	If _cseq == '003'  
		IF ALLTRIM(SE5->E5_TIPO)=="PA" .OR. SE5->E5_MOTBX=='DAC/VEN/PCC/FAT' .OR. ALLTRIM(SE5->E5_NATUREZ)$'218009/218005/218010/218012/218015/218016/218019/PCC/PIS/COFINS/CSLL/INSS/IRF/ISS'
			_nValor := 0
		Else  
			_nValor := SE5->E5_VLDESCO
		Endif
	Endif

	If _cseq == '004'  
		IF ALLTRIM(SE2->E2_TIPO)=="PA" .OR. SE5->E5_MOTBX=='DAC/VEN/PCC/FAT' .OR. ALLTRIM(SE2->E2_NATUREZ)$'218009/218005/218010/218012/218015/218016/218019/PCC/PIS/COFINS/CSLL/INSS/IRF/ISS'
			_nValor := 0
		ELSE
			_nValor := SE5->E5_VALOR 
		Endif
	Endif      


        If _cseq == '005'  
		IF ALLTRIM(SE5->E5_TIPO)=="PA" .OR. SE5->E5_MOTBX$'DAC/VEN/PCC/FAT' .OR. ALLTRIM(SE5->E5_NATUREZ)$'218005/PCC/PIS/COFINS/CSLL/INSS/IRF/ISS'
			_nValor := 0
		Else
			_nValor := SE5->E5_VLMULTA
		Endif
	Endif                                                                                                       


	RestArea(_aArea)      

Return(_nValor)
