require 'spec_helper'

describe V8::C::Function do
  it "can be called" do
    fn = run '(function() {return "foo"})'
    fn.Call(@cxt.Global(), 0, []).Utf8Value().should eql "foo"
  end

  it "can be called as a constructor" do
    fn = run '(function() {this.foo = "foo"})'
    fn.NewInstance().Get(V8::C::String::New('foo')).Utf8Value().should eql "foo"
  end

  it "can be called as a constructor with arguments" do
    fn = run '(function(foo) {this.foo = foo})'
    object = fn.NewInstance(1, [V8::C::String::New("bar")])
    object.Get(V8::C::String::New('foo')).Utf8Value().should eql "bar"
  end

  def run(source)
    source = V8::C::String::New(source.to_s)
    filename = V8::C::String::New("<eval>")
    script = V8::C::Script::New(source, filename)
    result = script.Run()
    result.kind_of?(V8::C::String) ? result.Utf8Value() : result
  end
end