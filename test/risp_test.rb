require 'minitest/autorun'
require 'test_helper'
require 'test_helper'

class RispTest < Minitest::Test
  def test_eval
    assert_equal(1, Risp.eval(1))
    assert_equal(2, Risp.eval(2))
    assert_equal(Risp.eval(1), Risp.eval("hoge", Env.new.merge({ "hoge" => 1 })))
    assert_equal(["+", 1, 2], Risp.eval(["quote", ["+", 1, 2]]))
    assert_equal(true, Risp.eval([">", 2, 1]))
    assert_equal(2, Risp.eval(["if", [">", 2, 1], 2, 1]))
    assert_equal(1, Risp.eval(["if", ["<", 2, 1], 2, 1]))

    env = Env.new
    Risp.eval(["define", "x", 100], env)
    assert_equal({ "x" => 100 }, env)
    Risp.eval(["set!", "x", 300], env)
    assert_equal({ "x" => 300 }, env)
    assert_raises(RuntimeError) { Risp.eval(["set!", "y", 300], env) }

    assert_equal(6, Risp.eval([["lambda", ["x", "y"], ["+", "x", "y"]], 3, 3]))

    assert_equal(100, Risp.eval(["begin",
                                 ["define", "var1", 30], ["define", "var2", 70],
                                 ["+", "var1", "var2"]]))
  end

  def test_tokenize
    assert_equal %w[( * 10 10 )], Risp.tokenize("(* 10 10)")
    assert_equal %w[( * 10 10 )], Risp.tokenize("(             * 10 10            )")
    assert_equal %w[( * 10 ( + 1 1 ) )], Risp.tokenize("(* 10 (+ 1 1))")
  end

  def test_parse
    assert_equal ["*", 10, 10], Risp.parse(%w[( * 10 10 )])
    assert_equal ["*", 10, ["+", 1, 1]], Risp.parse(%w[( * 10 ( + 1 1 ) )])
  end

  using Risp::REPL

  def test_to_s
    assert_equal "(* 100 100)", ["*", 100, 100].to_s
    assert_equal "(* 100 (+ 1 2))", ["*", 100, ["+", 1, 2]].to_s
  end
end
