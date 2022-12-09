#INCLUDE "rwmake.ch"



User Function LS_Z08()

cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z08"

dbSelectArea("Z08")
dbSetOrder(1)

AxCadastro(cString,"Mapeamento de endereços do CD",cVldExc,cVldAlt)

Return


User Function LS_Z09()

cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z09"

dbSelectArea("Z09")
dbSetOrder(1)

AxCadastro(cString,"Produtos por endereços",cVldExc,cVldAlt)

Return
