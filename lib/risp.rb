require './lib/env'

class Risp
  def self.eval(exps, env)
    if exps.instance_of?(String)
      env.search(exps)[exps]
    elsif !exps.instance_of?(Array)
      exps
    elsif exps[0] == "quote"
      exps[1]
    elsif exps[0] == "if"
      _, test, conseq, alt = exps
      eval(eval(test, env) ? conseq : alt, env)
    elsif exps[0] == "define"
      _, var, val = exps
      env.merge!({ var => eval(val, env) })
      var
    elsif exps[0] == "set!"
      _, var, val = exps
      raise "Undefined variable: #{var}" unless env[var]
      env.merge!({ var => val })
      var
    elsif exps[0] == "lambda"
      _, args, exp = exps
      -> (*tmp_args) { eval(exp, Env.new(env).merge!(args.zip(tmp_args).to_h)) }
    elsif exps[0] == "begin"
      _, *exps = exps
      exps.map { |v| eval(v, env) }.last
    else
      exps = exps.map { |exp| eval(exp, env) }
      procedure, *args = exps
      procedure.call(*args)
    end
  end

  def self.tokenize(str)
    str.gsub("(", " ( ").gsub(")", " ) ").split
  end

  def self.parse(tokens)
    raise "Unexpected EOF" if tokens.size.zero?

    token = tokens.shift
    if token == '('
      list = []
      while tokens[0] != ')'
        x = parse(tokens)
        list << x
      end
      tokens.shift
      return list
    elsif token == ')'
      raise RuntimeError("Invalid token")
    else
      atom(token)
    end
  end

  def self.exec(str, env)
    tokens = tokenize(str)
    exps = parse(tokens)
    eval(exps, env)
  end

  def self.atom(token)
    Integer(token) rescue Float(token) rescue token.to_s
  end

  module REPL
    refine Array do
      def to_s
        "(#{map(&:to_s).join(' ')})"
      end
    end

    def self.run
      env = Env.globals
      while true
        print("risp>> ")
        line = gets
        begin
          puts Risp.exec(line, env).to_s
        rescue
          puts $!
        end
      end
    end
  end

end