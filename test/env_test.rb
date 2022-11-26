require 'minitest/autorun'
require 'test_helper'

class GlobalEnvTest < Minitest::Test
  def test_env
    assert Env.superclass == Hash
    env = Env.new
    env.merge!({ "+" => Env::Operator.method(:+), "==" => Env::Operator.method(:==) })
    assert_equal({ "+" => Env::Operator.method(:+), "==" => Env::Operator.method(:==) }, env)
    assert_nil env.outer
    assert_equal env, env.search("+")
    assert_nil env.search("hoge")

    inner_env1 = Env.new(env)
    inner_env1.merge!({ "hoge" => "variable" })
    assert_equal({ "hoge" => "variable" }, inner_env1)
    assert_equal env, inner_env1.outer
    assert_equal env, inner_env1.search("+")
    assert_equal inner_env1, inner_env1.search("hoge")
    assert_nil inner_env1.search("hugahuga")
  end

  def test_globals
    builtin_operators = {
      "+" => Env::Operator.method(:+), "-" => Env::Operator.method(:-),
      "/" => Env::Operator.method(:/), "*" => Env::Operator.method(:*),
      "==" => Env::Operator.method(:==), "!=" => Env::Operator.method(:!=),
      ">" => Env::Operator.method(:>), "<" => Env::Operator.method(:<),
      ">=" => Env::Operator.method(:>=), "<=" => Env::Operator.method(:<=),
    }
    assert_equal(builtin_operators, Env.globals)
  end

end