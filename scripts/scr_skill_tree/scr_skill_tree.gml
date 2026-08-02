function SkillTree() constructor {
    tree = [
        new SkillTreeNode(
            "Upgrade Teste",
            "Este upgrade é um teste.",
            0,
            0,
            undefined,
            [2]
        ),
        
        new SkillTreeNode(
            "Upgrade Teste 2",
            "Este upgrade é um outro teste.",
            0,
            0,
            undefined,
            []
        ),
    ]
    
    get_node = function(id) {
        for (var i = 0; i < array_length(self.tree); i++) {
        	var node = self.tree[i]
            if(node.id == id) {
                return node
            }
        }
        
        return undefined
    }
}

function SkillTreeNode(_name, _description, _x, _y, _icon = undefined, _targets = []) constructor {
    static node_id = 0
    
    id = ++node_id
    
    name = _name
    description = _description
    x = _x
    y = _y
    targets = _targets
    icon = _icon
}