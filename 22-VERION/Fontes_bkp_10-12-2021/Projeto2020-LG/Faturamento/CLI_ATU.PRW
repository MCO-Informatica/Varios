#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function CLI_ATU
// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local _aArea := GetArea()
Local _cMUN := _cMUN2 := _cCod_MUN:= ""

DbSelectArea("SA2")
DbSetOrder(1)
DbGotop()

While !Eof() 
                            
    _cMUN 		:= SA2->A2_MUN
    _cCod_MUN 	:= SA2->A2_COD_MUN
           
	DbSelectArea("CC2")
	DbSetOrder(2)
    DbSeek(xFilial("CC2") + _cMUN,.f.)
    
    _cMUN2 := CC2->CC2_CODMUN          
    
    If empty(_cCod_MUN)
	
	   DbSelectArea("SA2")
       While !RecLock("SA2",.f.)
       Enddo
       SA2->A2_COD_MUN := _cMUN2
       MsUnLock()
	
	Endif
	
    DbSelectArea("SA2")
    DbSkip()
	
Enddo    
                       
Alert(" Termino do Processo !!! ")

// +----------------------------+
// | Restaura Ambiente Original |
// +----------------------------+

RestArea(_aArea)

Return(.t.)
