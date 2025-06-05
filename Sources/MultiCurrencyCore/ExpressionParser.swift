import Foundation

public struct ExpressionParser {
    public static func evaluate(_ expression: String) -> Double? {
        let trimmed = expression.replacingOccurrences(of: " ", with: "")
        let allowed = CharacterSet(charactersIn: "0123456789+-*/().")
        guard trimmed.unicodeScalars.allSatisfy({ allowed.contains($0) }) else { return nil }
        guard let tokens = tokenize(trimmed) else { return nil }
        guard let rpn = toRPN(tokens) else { return nil }
        return evaluateRPN(rpn)
    }

    private enum Token {
        case number(Double)
        case oper(Character)
        case lparen
        case rparen
    }

    private static func tokenize(_ str: String) -> [Token]? {
        var tokens: [Token] = []
        var number = ""
        for c in str {
            if c.isNumber || c == "." {
                number.append(c)
            } else {
                if !number.isEmpty {
                    if let d = Double(number) { tokens.append(.number(d)) } else { return nil }
                    number = ""
                }
                switch c {
                case "+", "-", "*", "/": tokens.append(.oper(c))
                case "(": tokens.append(.lparen)
                case ")": tokens.append(.rparen)
                default: return nil
                }
            }
        }
        if !number.isEmpty { if let d = Double(number) { tokens.append(.number(d)) } else { return nil } }
        return tokens
    }

    private static func precedence(_ op: Character) -> Int {
        switch op {
        case "+", "-": return 1
        case "*", "/": return 2
        default: return 0
        }
    }

    private static func toRPN(_ tokens: [Token]) -> [Token]? {
        var output: [Token] = []
        var stack: [Character] = []
        for token in tokens {
            switch token {
            case .number:
                output.append(token)
            case .oper(let op):
                while let last = stack.last, precedence(last) >= precedence(op) {
                    output.append(.oper(stack.removeLast()))
                }
                stack.append(op)
            case .lparen:
                stack.append("(")
            case .rparen:
                while let last = stack.last, last != "(" {
                    output.append(.oper(stack.removeLast()))
                }
                if stack.last == "(" { stack.removeLast() } else { return nil }
            }
        }
        while let last = stack.popLast() {
            if last == "(" { return nil }
            output.append(.oper(last))
        }
        return output
    }

    private static func evaluateRPN(_ tokens: [Token]) -> Double? {
        var stack: [Double] = []
        for token in tokens {
            switch token {
            case .number(let v):
                stack.append(v)
            case .oper(let op):
                guard stack.count >= 2 else { return nil }
                let rhs = stack.removeLast()
                let lhs = stack.removeLast()
                switch op {
                case "+": stack.append(lhs + rhs)
                case "-": stack.append(lhs - rhs)
                case "*": stack.append(lhs * rhs)
                case "/": stack.append(lhs / rhs)
                default: return nil
                }
            default:
                return nil
            }
        }
        return stack.count == 1 ? stack[0] : nil
    }
}
