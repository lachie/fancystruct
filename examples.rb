require 'exemplor'
require File.dirname(__FILE__)+'/lib/fancystruct'

eg.helpers do
  
  def fn; "Myles" end
  def ln; "Byrne" end
  def em; "myles@myles.id.au" end
  
  def set_attribs(fs)
    fs.first_name = fn
    fs.last_name  = ln
  end
  
  def check_fancystruct(fs)
    Check(fs.first_name).is(fn)
    Check(fs.last_name).is(ln)
  end
  
end

eg "the FancyStruct method returns a class" do
  cls = FancyStruct :first_name, :last_name, :email
  fs = cls.new
  set_attribs fs
  check_fancystruct fs
end

eg "takes a block for method definitions and such" do
  cls = FancyStruct :first_name, :last_name, :email do
    def full_name
      first_name + ' ' + last_name
    end
  end
  fs = cls.new
  set_attribs fs
  check_fancystruct fs
end

eg "the .new factory sets attributes via a single hash" do
  cls = FancyStruct :first_name, :last_name, :email
  fs = cls.new :first_name => fn, :last_name => ln, :email => em
  check_fancystruct fs
end

eg "the .new factory sets attributes via an array of values" do
  cls = FancyStruct :first_name, :last_name, :email
  fs = cls.new fn, ln, em
  check_fancystruct fs
end

class Person < FancyStruct :first_name, :last_name, :email
  
  def full_name
    first_name + ' ' + last_name
  end
  
end

eg "can be declared with class-like syntax (plain old inheritance)" do
  p = Person.new
  set_attribs p
  check_fancystruct p
end

eg "calling with a hash returns an instance of an anonymous FancyStruct" do
  fs = FancyStruct :first_name => fn, :last_name => ln
  check_fancystruct fs
end