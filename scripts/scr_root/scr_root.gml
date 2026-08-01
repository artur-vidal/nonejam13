#macro ROOT get_root()

/// @function get_root()
/// @description Retorna a instância do objeto root
/// @returns {Id.Instance<root>} root
function get_root() {
    return singleton(root)
}