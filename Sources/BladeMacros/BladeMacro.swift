import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct BladePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BladeMacro.self
    ]
}

struct BladeMacro: PeerMacro {
    
    static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let classDeclaration = declaration.as(ClassDeclSyntax.self) else { return [] }
        
        let className = classDeclaration.name.text
        let protocolName = "I" + className
        var members: [DeclSyntax] = []
        
        for member in classDeclaration.memberBlock.members {
            
            if let funcDeclaration = member.decl.as(FunctionDeclSyntax.self),
               funcDeclaration.modifiers.contains(where: { $0.name.text == "public" }) {
                
                members.append("""
                func \(funcDeclaration.name)\(funcDeclaration.signature)
                """)
            }
            if let variableDeclaration = member.decl.as(VariableDeclSyntax.self),
               variableDeclaration.modifiers.contains(where: { $0.name.text == "public" }) {
                
                for bindingValiables in variableDeclaration.bindings {
                    guard
                        let id = bindingValiables.pattern.as(IdentifierPatternSyntax.self),
                        let type = bindingValiables.typeAnnotation?.type
                    else { continue }
                    
                    members.append(
                    """
                    var \(raw: id.identifier.text): \(type) { get set }
                    """
                    )
                }
            }
        }
        
        let protocolDeclaration: DeclSyntax = """
        public protocol \(raw: protocolName) {
            \(raw: members.map(\.description).joined(separator: "\n"))
        }
        """
        let extensionDecl: DeclSyntax = """
        extension \(raw: className): \(raw: protocolName) {}
        """
        
        return [protocolDeclaration, extensionDecl]
    }
}
