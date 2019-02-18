#Include 'Protheus.ch'
#Include 'fwmvcdef.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} MVC07
Exemplo de setActivate e setVldActivate

@since 01/06/2018
/*/
//-------------------------------------------------------------------
User Function MVC07()
Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB5') 
	oBrowse:SetDescription('Cadastro de Turma x Aluno')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC07' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC07' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC07' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC07' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.MVC07' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.MVC07' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef() 
Local oModel := FWLoadModel("MVC04")			

    oModel:SetActivate({ |oModel| Activate(oModel)})
    oModel:SetVldActivate({|oModel| VldActivate(oModel)})
 
Return oModel 

Static Function ViewDef() 
Local oView := FWLoadView("MVC04") 
    oView:SetModel(ModelDef())
Return oView
 
Static Function VldActivate(oModel)
Local cStatusTurma
Local cTurma
Local lValid := .T.

    If oModel:GetOperation() == MODEL_OPERATION_UPDATE
        cTurma := ZB5->ZB5_CODTUR
        cStatusTurma := Posicione("ZB1",1,xFilial("ZB1")+cTurma,"ZB1_SITUAC")

        If cStatusTurma <> "1"
            Help( ,, 'HELP',, 'Somente turmas ativas podem ser modificadas.', 1, 0)   
            lValid := .F.
        EndIf 
    EndIf
    
Return lValid

Static Function Activate(oModel)
    //Modelo já está ativo, pode ser manipulado!
Return

