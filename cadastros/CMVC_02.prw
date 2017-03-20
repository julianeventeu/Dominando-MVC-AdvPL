#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function CMVC_02()
Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZB1')
	oBrowse:SetDescription('Cadastro de Turmas')
	oBrowse:Activate()
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CMVC_02' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CMVC_02' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CMVC_02' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CMVC_02' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CMVC_02' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CMVC_02' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel
Local oStruZB1 := FWFormStruct(1,"ZB1")

	oModel := MPFormModel():New("TURMA")
	oModel:SetDescription("Cadastro de Turmas")
	
	oModel:addFields('MASTERZB1',,oStruZB1)
	oModel:getModel('MASTERZB1'):SetDescription('Dados da Turma')
	
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZB2:= FWFormStruct(2, 'ZB1')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_TURMA' , oStrZB2,'MASTERZB1' ) 
	oView:CreateHorizontalBox( 'BOX_FORM_TURMA', 100)
	oView:SetOwnerView('FORM_TURMA','BOX_FORM_TURMA')
	
Return oView